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
    ocpus         = 1
    memory_in_gbs = 1
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = "${base64encode(file("grafana/files/bootstrap.sh"))}"
  }
  preserve_boot_volume = false
}

resource "oci_load_balancer_backend_set" "grafana_backend_set" {
  health_checker {
    protocol = "HTTP"
    url_path = "/api/health"
    port     = 3000
  }
  load_balancer_id = var.loadbalancer_id
  name             = "grafana-backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "grafana_backend" {
  backendset_name  = oci_load_balancer_backend_set.grafana_backend_set.name
  ip_address       = oci_core_instance.grafana_compute.private_ip
  load_balancer_id = var.loadbalancer_id
  port             = 3000
}

resource "oci_load_balancer_listener" "grafana_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.grafana_backend_set.name
  load_balancer_id         = var.loadbalancer_id
  name                     = "grafana_listener"
  port                     = 3000
  protocol                 = "HTTP"
}
