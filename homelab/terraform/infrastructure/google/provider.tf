terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.71.0"
    }
  }
}

provider "google" {
  credentials = file("./google/service-key.json")
  project     = "jafner-net-319520"
  region      = "us-west1"
  zone        = "us-west1-c"
}

