variable "gcp_credentials" {}

// Configure the Google Cloud provider
provider "google" {
 credentials = "${var.gcp_credentials}"
 project     = "clickhouse-dev"
 region      = "us-west1"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
  name         = "clickhouse-1"
  machine_type = "n1-standard-8"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata {
    sshKeys = "akomar:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E0C56BD4; echo 'deb http://repo.yandex.ru/clickhouse/deb/stable/ main/' | sudo tee /etc/apt/sources.list.d/clickhouse.list; sudo apt-get update; sudo apt-get install -y  --allow-unauthenticated clickhouse-server clickhouse-client; sudo service clickhouse-server start"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  tags = [
    "clickhouseserver"
  ]

  labels = {
    "role" = "clickhouserole"
  }
}

// A variable for extracting the external ip of the instance
output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

