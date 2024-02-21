resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = var.zone
  deletion_protection = false
  remove_default_node_pool = true
  initial_node_count = 1
  network_policy {
    enabled = true
  }
}	
