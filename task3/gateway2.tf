#Gateway
resource "google_compute_vpn_gateway" "gateway-2" {
    name = "cloudninja-gateway2"
    network = google_compute_network.network_2.id
    region = var.net2_sub1_region
    depends_on = [ google_compute_subnetwork.network2_sub1]
}
#>>>

#IP Birth
resource "google_compute_address" "st2" {
  name = "cloudgenjutsu2"
  region = var.net2_sub1_region
}
#IP Output
output "gateway2-ip" {
  value = google_compute_address.st2.address
}
#>>>

#Tunnel
resource "google_compute_vpn_tunnel" "tunnel-2" {
  name = "highliner2"
  target_vpn_gateway = google_compute_vpn_gateway.gateway-2.id
  peer_ip = google_compute_address.st1.address
  shared_secret = sensitive("faquettetuseifraise")
  ike_version = 2
  local_traffic_selector = [var.net2_sub1_iprange] 
  remote_traffic_selector = [var.net1_sub2_iprange]
  depends_on = [ 
    google_compute_forwarding_rule.rule4,
    google_compute_forwarding_rule.rule5-500,
   ]
}
#>>>

#Next Hop to Final Destination
resource "google_compute_route" "route2" {
  name = "route2"
  network = google_compute_network.network_2.id
  dest_range = var.net1_sub2_iprange
  priority = 1000
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel-2.id
  depends_on = [ google_compute_vpn_tunnel.tunnel-2 ]
}
#>>>

#Internal Traffic Firewall rule
resource "google_compute_firewall" "allow_internal-2" {
  name    = "allow-internal-2"
  network = var.net2

  allow {
    protocol = "all"
  }

  source_ranges = [var.net1_sub2_iprange]
  description   = "Allow all internal traffic from peer network"
}