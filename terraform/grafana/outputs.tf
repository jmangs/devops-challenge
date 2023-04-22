output "grafana_compute_ip" {
  value = oci_core_instance.grafana_compute.private_ip
}
