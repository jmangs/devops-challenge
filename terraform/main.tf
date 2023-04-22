module "compartments" {
  source     = "./compartments"
  tenancy_id = var.tenancy_id
}

module "networking" {
  source                     = "./networking"
  root_compartment_id        = var.root_compartment_id
  application_compartment_id = module.compartments.application_compartment_id
  bastion_compartment_id     = module.compartments.bastion_compartment_id
  region                     = var.region
}

module "application" {
  source                   = "./application"
  compartment_id           = module.compartments.application_compartment_id
  availability_domain_name = data.oci_identity_availability_domains.ads.availability_domains.1.name # AD1 is out of "free" compute....
  subnet_id                = module.networking.application_subnet_id
  image_id                 = data.oci_core_images.oraclelinux-8.images.0.id
  ssh_public_key           = var.ssh_public_key
}

module "bastion" {
  source                   = "./bastion"
  compartment_id           = module.compartments.bastion_compartment_id
  availability_domain_name = data.oci_identity_availability_domains.ads.availability_domains.1.name # AD1 is out of "free" compute....
  subnet_id                = module.networking.bastion_subnet_id
  image_id                 = data.oci_core_images.oraclelinux-8.images.0.id
  ssh_public_key           = var.ssh_public_key
}

module "loadbalancer" {
  source                 = "./loadbalancer"
  compartment_id         = module.compartments.application_compartment_id
  application_compute_ip = module.application.application_compute_ip
  public_subnet_id       = module.networking.public_access_subnet_id
}
