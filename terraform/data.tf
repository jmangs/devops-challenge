data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_id
}

data "oci_core_images" "oraclelinux-8" {
  compartment_id           = var.root_compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  filter {
    name   = "display_name"
    values = ["Oracle-Linux-8.7-2023.03.28-0"] # Have to pick this specific image for it to work with free compute
    regex  = true
  }
}
