output "vm_instances_info" {
  value = {
    for vm in [
      {
        name = yandex_compute_instance.platform.name
        external_ip = yandex_compute_instance.platform.network_interface.0.nat_ip_address
        fqdn = yandex_compute_instance.platform.fqdn
      },
      {
        name = yandex_compute_instance.platform-db.name
        external_ip = yandex_compute_instance.platform-db.network_interface.0.nat_ip_address
        fqdn = yandex_compute_instance.platform-db.fqdn
      }
    ] :
    vm.name => vm
  }
  description = "Информация о всех ВМ: имя, внешний IP и полное доменное имя"
}