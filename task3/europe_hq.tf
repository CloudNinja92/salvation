provider "google" {
  # Configuration options
project = "stellar-aurora-413600"
region = "us-west4"
zone = "us-west4-a"
credentials = "stellar-aurora-413600-81017f2c74c3.json"
}

resource "google_compute_network" "custom-vpc-tf" {
  name = "custom-vpc-tf"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub-sg"{
  name = "sub-sg"
  network = google_compute_network.custom-vpc-tf.id 
  ip_cidr_range = "10.17.0.0/24"
  region = "eu-west4"
  private_ip_google_access = false
}

resource "google_compute_firewall" "vpc-firewall" {
  name = "vpc-firewall"
  network = google_compute_network.custom-vpc-tf.id
  allow {
    protocol = "icmp"
  } 
  source_ranges = ["0.0.0.0/0"]
  priority = 455

allow {
  protocol = "tcp"
  ports = ["80", "22" , "443"]
}
}

resource "google_compute_instance" "ninjawarrior-vm" {
    name = "ninjawarrior-vm"
    machine_type = "e2-medium"
    zone = "eu-west4-a"
    allow_stopping_for_update = true
    depends_on   = [google_compute_firewall.vpc-firewall]


boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

    metadata = {
    startup-script = file("${path.module}/script2.txt")
  }
  
  network_interface {
    network = google_compute_network.custom-vpc-tf.id
    subnetwork = google_compute_subnetwork.sub-sg.id


access_config {
      // Ephemeral IP
    }
  }

  service_account {
    email  = "terraform2@stellar-aurora-413600.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}

output "custom" {
  value = google_compute_network.custom-vpc-tf.id
}
