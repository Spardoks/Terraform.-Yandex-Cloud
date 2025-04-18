# netwroks

resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}
resource "yandex_vpc_subnet" "develop-db" {
  name           = "develop-db"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"]
}


# data

data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_image_family
}


# vms

## vm1

resource "yandex_compute_instance" "platform" {
  name        = local.vm_names.web
  platform_id = var.vm_web_platform_id

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  # metadata = {
  #   serial-port-enable = var.vm_web_serial_port_enable
  #   ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  # }
  metadata = var.vm_metadata
}

## vm2

resource "yandex_compute_instance" "platform-db" {
  name        = local.vm_names.db
  platform_id = var.vm_db_platform_id
  zone = "ru-central1-b"

  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop-db.id
    nat       = var.vm_db_nat
  }

  # metadata = {
  #   serial-port-enable = var.vm_db_serial_port_enable
  #   ssh-keys           = "ubuntu:${var.vms_ssh_public_root_key}"
  # }
  metadata = var.vm_metadata
}