# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_image
data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template
resource "google_compute_instance_template" "vpn" {
  name         = "${var.name}-vpn-template"
  project      = var.project
  region       = var.region
  machine_type = var.machine_type

  disk {
    source_image = data.google_compute_image.debian.id
    boot         = true
    auto_delete  = true
    disk_type    = "pd-standard"
    disk_size_gb = 10
  }

  network_interface {
    subnetwork = google_compute_subnetwork.vpn.id
    access_config {}
  }

  service_account {
    email  = google_service_account.vpn.email
    scopes = [ "cloud-platform" ]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  scheduling {
    automatic_restart = true
    preemptible       = false
  }

  metadata = {
    # https://cloud.google.com/compute/docs/instances/access-overview
    # https://cloud.google.com/compute/docs/oslogin/set-up-oslogin
    # https://cloud.google.com/compute/docs/connect/add-ssh-keys
    # enable-oslogin = "TRUE"
    ssh-keys = format("admin:%s", file(var.ssh_public_key_file))

    # https://cloud.google.com/compute/docs/instances/startup-scripts/linux
    startup-script = data.template_file.startup_script.rendered
  }

  tags = [ "vpn" ]

  labels = {
    name = "${var.name}-vpn"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ labels ]
  }
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "startup_script" {
  template = file("${path.module}/bootstrap.sh")
  vars = {
    username = local.panel_username
    password = local.panel_password
    port     = local.panel_port
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template
resource "google_compute_instance_from_template" "vpn" {
  name                     = "${var.name}-vpn"
  zone                     = data.google_compute_zones.available.names[0]
  source_instance_template = google_compute_instance_template.vpn.id

  # https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/connection
  # https://developer.hashicorp.com/terraform/language/resources/provisioners/file

  connection {
    type        = "ssh"
    user        = "admin"
    host        = self.network_interface.0.access_config.0.nat_ip
    private_key = file(var.ssh_private_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /cert",
      "sudo chown :admin /cert",
      "sudo usermod -a -G admin admin",
      "sudo chmod g+w /cert",
    ]
  }

  provisioner "file" {
    content     = acme_certificate.vpn.private_key_pem
    destination = "/cert/private_key.pem"
  }

  provisioner "file" {
    content     = acme_certificate.vpn.certificate_pem
    destination = "/cert/certificate.pem"
  }

  provisioner "file" {
    content     = acme_certificate.vpn.issuer_pem
    destination = "/cert/issuer_cert.pem"
  }
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "ssh_config" {
  template = file("${path.module}/sshconfig.tpl")
  vars = {
    subdomain   = var.subdomain
    address     = google_compute_instance_from_template.vpn.network_interface.0.access_config.0.nat_ip
    private_key = basename(var.ssh_private_key_file)
  }
}

# https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "ssh_config" {
  filename = pathexpand(format("%s/config-%s",
    dirname(var.ssh_private_key_file),
    var.name,
  ))

  content              = data.template_file.ssh_config.rendered
  file_permission      = "0644"
  directory_permission = "0700"
}
