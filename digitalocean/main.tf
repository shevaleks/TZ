resource "digitalocean_vpc" "k8s_vpc" {
  name   = "k8s-vpc"
  region = var.region
}

resource "digitalocean_vpc" "db_vpc" {
  name   = "db-vpc"
  region = var.region
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name    = "k8sber"
  region  = var.region
  version = "1.30.1-do.0"
  vpc_uuid = digitalocean_vpc.k8s_vpc.id
  node_pool {
    name       = "worker-pool"
    size       = "s-4vcpu-8gb"
    node_count = 1
  }
}

# resource "digitalocean_database_db" "database-sber" {
#   cluster_id = digitalocean_database_cluster.postgres.id
#   name       = "sber"
# }

resource "digitalocean_database_cluster" "postgres" {
  name       = "postgresber"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-2gb"
  region     = var.region
  node_count = 2
}

// один из вариантов отказоустойчивости
resource "digitalocean_database_replica" "replica" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "posgresbereplica"
  size       = "db-s-1vcpu-1gb"
  region     = "ams3" //поскольку по умолчанию стоит франкфурт, то можно выбрать нидерланды, для отказоустойчивости на уровне региона
}

# output "k8s_cluster_id" {
#   value = digitalocean_kubernetes_cluster.k8s_cluster.id
# }

# output "db_cluster_uri" {
#   value = digitalocean_database_cluster.postgres.uri
# }
