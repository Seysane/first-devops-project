terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "app_network" {
  name = "app-network"
}

resource "docker_volume" "postgres_data" {
  name = "postgres-data"
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = "postgres:16"

  network_mode = docker_network.app_network.name

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  lifecycle {
    ignore_changes = [
      env,
      volumes,
    ]
  }
}

resource "docker_container" "app" {
  name  = "app"
  image = "lesson33-app:latest"

  network_mode = docker_network.app_network.name

  ports {
    internal = 5000
    external = 5000
  }

  lifecycle {
    ignore_changes = [
      env,
      ports,
    ]
  }
}

resource "docker_container" "nginx" {
  name  = "nginx"
  image = "nginx:latest"

  network_mode = docker_network.app_network.name

  ports {
    internal = 80
    external = 8080
  }

  lifecycle {
    ignore_changes = [
      env,
      ports,
    ]
  }
}