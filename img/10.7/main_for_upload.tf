terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token = "xxxx"
  cloud_id = "xxxxx"
  folder_id = "xxxxx"
  zone = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  count = 2
  name = "vm${count.index}"

  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8emvfmfoaordspe1jr"
      size = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }
  
  metadata = {
    user-data = "${file("./meta.yml")}"
  }

}
resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.network-1.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_lb_target_group" "target-1" {
  name      = "target1"
  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm-1[0].network_interface.0.ip_address
  }
  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm-1[1].network_interface.0.ip_address
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "lb1"
  listener {
    name = "listener1"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = "${yandex_lb_target_group.target-1.id}"
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}


resource "yandex_compute_snapshot" "snap-1" {
  name = "sanp1"
  source_disk_id = "${yandex_compute_instance.vm-1[0].boot_disk[0].disk_id}"
}

output "internal_ip_address_vm_1" {
  value = "${yandex_compute_instance.vm-1[0].network_interface.0.ip_address}"
}
output "external_ip_address_vm_1" {
  value = "${yandex_compute_instance.vm-1[0].network_interface.0.nat_ip_address}"
}
output "internal_ip_address_vm_2" {
  value = "${yandex_compute_instance.vm-1[1].network_interface.0.ip_address}"
}
output "external_ip_address_vm_2" {
  value = "${yandex_compute_instance.vm-1[1].network_interface.0.nat_ip_address}"
}  