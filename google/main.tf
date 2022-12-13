# ====================================================================================================
#  NETWORKING
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_versions
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones
data "google_compute_zones" "available" {
  status = "UP"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpn" {
  name                    = "${var.name}-vpn-network"
  project                 = var.project
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "vpn" {
  name                     = "${var.name}-vpn-subnet"
  project                  = var.project
  region                   = var.region
  network                  = google_compute_network.vpn.id
  ip_cidr_range            = local.vpn_subnetwork_cidr
  private_ip_google_access = false
}

# https://cloud.google.com/vpc/docs/routes
# https://cloud.google.com/network-connectivity/docs/router/concepts/overview
# https://cloud.google.com/nat/docs/overview

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "vpn" {
  name    = "${var.name}-vpn-router"
  project = var.project
  region  = var.region
  network = google_compute_network.vpn.id
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "main" {
  name                               = "${var.name}-vpn-router-nat"
  project                            = var.project
  region                             = var.region
  router                             = google_compute_router.vpn.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat#nested_subnetwork
  subnetwork {
    name                    = google_compute_subnetwork.vpn.id
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "egress_all" {
  name    = "${var.name}-vpn-allow-outgoing"
  project = var.project
  network = google_compute_network.vpn.id

  description        = "Allow all outgoing traffic from the vpn subnetwork to the Internet."
  priority           = 1000
  direction          = "EGRESS"
  destination_ranges = [ "0.0.0.0/0" ]
  target_tags        = [ local.vpn_subnetwork_tag ]

  allow {
    protocol = "all"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "ingress_self" {
  name    = "${var.name}-vpn-allow-internal"
  project = var.project
  network = google_compute_network.vpn.id

  description   = "Allow all internal traffic within the vpn subnetwork."
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = [ local.vpn_subnetwork_cidr ]
  target_tags   = [ local.vpn_subnetwork_tag ]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = [ "0-65535" ]
  }

  allow {
    protocol = "tcp"
    ports    = [ "0-65535" ]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "ingress_icmp" {
  name    = "${var.name}-vpn-allow-icmp"
  project = var.project
  network = google_compute_network.vpn.id

  description   = "Allow ICMP traffic from trusted addresses to the vpn subnetwork."
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = var.icmp_incoming_cidrs
  target_tags   = [ local.vpn_subnetwork_tag ]

  allow {
    protocol = "icmp"
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "ingress_ssh" {
  name    = "${var.name}-vpn-allow-ssh"
  project = var.project
  network = google_compute_network.vpn.id

  description   = "Allow SSH traffic from trusted addresses to the vpn subnetwork."
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = var.ssh_incoming_cidrs
  target_tags   = [ local.vpn_subnetwork_tag ]

  allow {
    protocol = "tcp"
    ports    = [ "22" ]
  }
}

# ====================================================================================================
#  Identity and Access Management (IAM)
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "vpn" {
  account_id   = "${var.name}-vpn"
  project      = var.project
  display_name = "VPN Service Account"
}

# ====================================================================================================
#  VM INSTANCES
# ====================================================================================================

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_image
data "google_compute_image" "vpn" {
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
    source_image = data.google_compute_image.vpn.id
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
    startup-script = file("${path.module}/bootstrap.sh")
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

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template
resource "google_compute_instance_from_template" "vpn" {
  name                     = "${var.name}-vpn"
  zone                     = data.google_compute_zones.available.names[0]
  source_instance_template = google_compute_instance_template.vpn.id
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "ssh_config" {
  template = file("${path.module}/sshconfig.tpl")
  vars = {
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
