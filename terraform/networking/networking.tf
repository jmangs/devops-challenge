module "vcn" {
  source = "oracle-terraform-modules/vcn/oci"

  # Should the VCN stay in the root compartment? Since I'm spanning
  # two CIDR ranges with distinct subnets it made more sense here,
  # it's just annoying to look at in the UI sometimes....
  compartment_id = var.root_compartment_id
  region         = var.region

  internet_gateway_route_rules = null
  local_peering_gateways       = null
  nat_gateway_route_rules      = null

  vcn_name      = "demo-vcn"
  vcn_dns_label = "demo"

  # Both CIDR ranges are in the same VCN, but we could also build
  # two VCNs and then peer them together using a DRG, but for the
  # sake of simplicity I'm just using a single VCN for this.
  vcn_cidrs = ["10.0.0.0/16", "172.168.0.0/29"]

  # These are new to me and are really nice to have, I used to have
  # to create these all by hand on the older version of this module!
  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}

resource "oci_core_security_list" "application-security-list" {
  compartment_id = var.application_compartment_id
  vcn_id         = module.vcn.vcn_id

  display_name = "application-security-list"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "172.168.0.0/29"
    source_type = "CIDR_BLOCK"

    protocol = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.1.0/24"
    source_type = "CIDR_BLOCK"

    protocol = "6"
    tcp_options {
      min = 8080
      max = 8080
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.1.0/24"
    source_type = "CIDR_BLOCK"

    protocol = "6"
    tcp_options {
      min = 3000
      max = 3000
    }
  }
}

resource "oci_core_security_list" "public-access-security-list" {
  compartment_id = var.application_compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "public-access-security-list"

  egress_security_rules {
    stateless        = false
    destination      = "10.0.0.0/24"
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    tcp_options {
      min = 8080
      max = 8080
    }
  }

  egress_security_rules {
    stateless        = false
    destination      = "10.0.0.0/24"
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    tcp_options {
      min = 3000
      max = 3000
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    protocol = "6"
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    protocol = "6"
    tcp_options {
      min = 3000
      max = 3000
    }
  }
}

resource "oci_core_security_list" "bastion-security-list" {
  compartment_id = var.bastion_compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "bastion-security-list"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    protocol = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_subnet" "application-subnet" {
  compartment_id = var.application_compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.0.0/24"

  route_table_id    = module.vcn.nat_route_id
  security_list_ids = [oci_core_security_list.application-security-list.id]
  display_name      = "application-subnet"

  prohibit_public_ip_on_vnic = true
  prohibit_internet_ingress  = true
}

resource "oci_core_subnet" "public-access-subnet" {
  compartment_id = var.application_compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.1.0/24"

  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.public-access-security-list.id]
  display_name      = "public-access-subnet"
}

resource "oci_core_subnet" "bastion-subnet" {
  compartment_id = var.application_compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "172.168.0.0/29"

  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.bastion-security-list.id]
  display_name      = "bastion-subnet"
}
