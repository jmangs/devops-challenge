resource "oci_identity_compartment" "bastion" {
  compartment_id = var.tenancy_id
  description    = "Compartment for bastion resources."
  name           = "bastion"
}

resource "oci_identity_compartment" "application" {
  compartment_id = var.tenancy_id
  description    = "Compartment for application resources."
  name           = "application"
}
