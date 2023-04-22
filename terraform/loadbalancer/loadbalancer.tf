resource "oci_load_balancer_load_balancer" "application_loadbalancer" {
  compartment_id = var.compartment_id
  display_name   = "application-loadbalancer"
  shape          = "flexible"
  is_private     = false
  subnet_ids     = [var.public_subnet_id]

  shape_details {
    maximum_bandwidth_in_mbps = 10
    minimum_bandwidth_in_mbps = 10
  }
}

resource "oci_load_balancer_backend_set" "application_backend_set" {
  health_checker {
    protocol = "HTTP"
    url_path = "/healthcheck"
    port     = 8081
  }
  load_balancer_id = oci_load_balancer_load_balancer.application_loadbalancer.id
  name             = "application-backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "application_backend" {
  backendset_name  = oci_load_balancer_backend_set.application_backend_set.name
  ip_address       = var.application_compute_ip
  load_balancer_id = oci_load_balancer_load_balancer.application_loadbalancer.id
  port             = 8080
}

resource "oci_load_balancer_listener" "application_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.application_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.application_loadbalancer.id
  name                     = "application_listener"
  port                     = 80
  protocol                 = "HTTP"
}