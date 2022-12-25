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

# https://cloud.google.com/vpc/docs/firewalls

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

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "ingress_http" {
  name    = "${var.name}-vpn-allow-http"
  project = var.project
  network = google_compute_network.vpn.id

  description   = "Allow HTTP traffic from trusted addresses to the vpn subnetwork."
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = var.http_incoming_cidrs
  target_tags   = [ local.vpn_subnetwork_tag ]

  allow {
    protocol = "tcp"
    ports    = [ "80" ]
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall
resource "google_compute_firewall" "ingress_https" {
  name    = "${var.name}-vpn-allow-https"
  project = var.project
  network = google_compute_network.vpn.id

  description   = "Allow HTTPS traffic from trusted addresses to the vpn subnetwork."
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = var.https_incoming_cidrs
  target_tags   = [ local.vpn_subnetwork_tag ]

  allow {
    protocol = "tcp"
    ports    = [ "443" ]
  }
}
