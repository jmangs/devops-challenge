output "bastion_compartment_id" {
  value = oci_identity_compartment.bastion.id
}

output "application_compartment_id" {
  value = oci_identity_compartment.application.id
}
