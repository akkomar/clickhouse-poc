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

resource "google_compute_disk" "clickhouse-data-disk" {
  name = "clickhouse-data-disk"
  type = "pd-ssd"
  zone = "us-west1-a"
  size = "500"
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

  attached_disk {
    source = "${google_compute_disk.clickhouse-data-disk.name}"
    device_name = "clickhouse-data"
  }

  connection {
    type = "ssh"
    user = "admin"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "script/mount-data-disk.sh"
    destination = "/tmp/mount-data-disk.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/mount-data-disk.sh",
      "sudo /tmp/mount-data-disk.sh",
    ]
  }

  metadata {
    sshKeys = "admin:${file("~/.ssh/id_rsa.pub")}"
  }

  # metadata_startup_script = "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E0C56BD4; echo 'deb http://repo.yandex.ru/clickhouse/deb/stable/ main/' | sudo tee /etc/apt/sources.list.d/clickhouse.list; sudo apt-get update; sudo apt-get install -y  --allow-unauthenticated clickhouse-server clickhouse-client; sudo service clickhouse-server start"

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

