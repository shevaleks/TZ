resource "digitalocean_vpc" "k8s_vpc" {
  name   = "k8s-vpc"
  region = var.region
}

resource "digitalocean_vpc" "db_vpc" {
  name   = "db-vpc"
  region = var.region
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name    = "k8s-cluster"
  region  = var.region
  version = "1.30.1-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}

resource "digitalocean_database_db" "database-sber" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "sber"
}

resource "digitalocean_database_cluster" "postgres" {
  name       = "postgres-cluster"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-1gb"
  region     = var.region
  node_count = 1
}


# output "k8s_cluster_id" {
#   value = digitalocean_kubernetes_cluster.k8s_cluster.id
# }

# output "db_cluster_uri" {
#   value = digitalocean_database_cluster.postgres.uri
# }
