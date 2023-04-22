output "application_subnet_id" {
  value = oci_core_subnet.application-subnet.id
}

output "public_access_subnet_id" {
  value = oci_core_subnet.public-access-subnet.id
}

output "bastion_subnet_id" {
  value = oci_core_subnet.bastion-subnet.id
}
