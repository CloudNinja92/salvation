resource "google_compute_network" "america-vpc-tf" {
  name = "america-vpc-tf"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "sub-sg"{
  name = "sub-sg"
  network = google_compute_network.america-vpc-tf.id 
  ip_cidr_range = "172.16.0.0/24"
  region = "us-west4"
  private_ip_google_access = false
}

output "america" {
  value = google_compute_network.america-vpc-tf.id
}