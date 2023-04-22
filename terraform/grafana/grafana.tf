resource "oci_core_instance" "grafana_compute" {
  availability_domain = var.availability_domain_name
  compartment_id      = var.compartment_id
  shape               = var.shape
  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  display_name = "grafana-compute"
  create_vnic_details {
    assign_public_ip = false
    subnet_id        = var.subnet_id
  }

  shape_config {
    ocpus = 1
    memory_in_gbs = 1
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = "${base64encode(file("grafana/files/bootstrap.sh"))}"
  }
  preserve_boot_volume = false
}
