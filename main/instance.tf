# Create the compute engine instance
resource "google_compute_instance" "backend" {
  name         = format("%s-001", var.instance_prefix)
  machine_type = "e2-small"
  zone         = var.gcp_zone
  tags         = ["icmp-server", "backend-http-server", "backend-ssh-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20210325"
      size  = 10
    }
    device_name = format("%s-001", var.instance_prefix)
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
        // Ephemeral IP
    }
  }

  shielded_instance_config {
    enable_vtpm                 = false
    enable_integrity_monitoring = false
  }

  metadata_startup_script = file("../scripts/bootstrap_env.sh")
}
