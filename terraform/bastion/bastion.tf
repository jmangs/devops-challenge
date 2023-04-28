resource "oci_core_instance" "bastion_compute" {
  availability_domain = var.availability_domain_name
  compartment_id      = var.compartment_id
  shape               = var.shape
  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  display_name = "bastion-compute"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.subnet_id
  }

  # We can also enable access via the Bastion Service if desired. It's a bit of
  # a pain to use in Terraform due how state is handled, so I've stuck to just
  # building my own bastion access using a real compute node as was defined in
  # the problem statement here.
  agent_config {
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }

  shape_config {
    memory_in_gbs = 1
    ocpus         = 1
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
  preserve_boot_volume = false
}
