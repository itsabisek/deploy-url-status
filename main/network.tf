# Create a vpc
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name

}

# Create firewall rules to allow http and ssh traffic
resource "google_compute_firewall" "firewall_allow_ssh" {
  name    = format("%s-allow-ssh", google_compute_network.vpc_network.name)
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["backend-ssh-server"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "firewall_allow_http" {
  name    = format("%s-allow-http", google_compute_network.vpc_network.name)
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = ["backend-http-server"]
  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_firewall" "firewall_allow_icmp" {
  name    = format("%s-allow-icmp", google_compute_network.vpc_network.name)
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "icmp"
  }
  target_tags   = ["icmp-server"]
  source_ranges = ["0.0.0.0/0"]

}
