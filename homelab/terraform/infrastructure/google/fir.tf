resource "google_compute_network" "vpc_network" {
    name = "forest"
}

resource "google_service_account" "terraform" {
    account_id = "terraform-service-account"
    display_name = "terraform"
}

resource "google_compute_instance" "fir" {
  name         = "fir"
  machine_type = "e2-micro"
  zone         = "us-west1-c"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "forest"
  }

  service_account {
    email  = google_service_account.terraform.email
    scopes = ["cloud-platform"]
  }
}