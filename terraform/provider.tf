provider "oci" {
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_id
  private_key_path = var.key_file_path
  fingerprint      = var.fingerprint
  region           = var.region
}
