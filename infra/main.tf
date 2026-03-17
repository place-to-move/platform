terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "app_net" {
  name = "place_to_move_net"
}

# Redpanda — легка заміна Kafka
resource "docker_container" "redpanda" {
  name  = "redpanda"
  image = "docker.redpanda.com/redpandadata/redpanda:v23.2.1"
  networks_advanced { name = docker_network.app_net.name }
  # Обмежуємо ресурси для Celeron
  command = [
    "redpanda", "start", "--overprovisioned",
    "--smp 1", "--memory 512M", "--check=false",
    "--node-id 0", "--kafka-addr internal://0.0.0.0:9092,external://0.0.0.0:19092",
    "--advertise-kafka-addr internal://redpanda:9092,external://localhost:19092"
  ]
  ports {
    internal = 19092
    external = 19092 # Для доступу з твого ПК (через тунель або IP)
  }
}

# База даних для Matcher
resource "docker_container" "postgres" {
  name  = "postgres"
  image = "postgres:15-alpine"
  networks_advanced { name = docker_network.app_net.name }
  env = [
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=secret",
    "POSTGRES_DB=realestate"
  ]
  ports {
    internal = 5432
    external = 5432
  }
}