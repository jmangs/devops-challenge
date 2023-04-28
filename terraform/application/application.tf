
# Any operation which destroys an application compute will fail if it's associated
# to an existing instance pool. So what we have to do here is maintain two copies
# of the instance configuration and update one, then swap it in and out on the
# instance pool itself. This allows you to destroy it easily but requires two
# applies in order to make changes; right now there's no easy way around this.
#
# It's not pretty but at least it's very deliberate when changing auto-scaling.
resource "oci_core_instance_configuration" "application_compute_config" {
  compartment_id = var.compartment_id
  display_name   = "application-compute-autoscale"

  instance_details {
    instance_type = "compute"

    launch_details {
      availability_domain = var.availability_domain_name
      compartment_id      = var.compartment_id

      metadata = {
        ssh_authorized_keys = var.ssh_public_key
        user_data           = "${base64encode(file("application/files/bootstrap.sh"))}"
      }

      shape = var.shape

      create_vnic_details {
        assign_public_ip = false
        subnet_id        = var.subnet_id
      }

      source_details {
        image_id    = var.image_id
        source_type = "image"
      }
    }
  }
}

resource "oci_core_instance_configuration" "application_compute_config_alt" {
  compartment_id = var.compartment_id
  display_name   = "application-compute-autoscale-alt"

  instance_details {
    instance_type = "compute"

    launch_details {
      availability_domain = var.availability_domain_name
      compartment_id      = var.compartment_id

      metadata = {
        ssh_authorized_keys = var.ssh_public_key
        user_data           = "${base64encode(file("application/files/bootstrap-alternate.sh"))}"
      }

      shape = var.shape

      create_vnic_details {
        assign_public_ip = false
        subnet_id        = var.subnet_id
      }

      source_details {
        image_id    = var.image_id
        source_type = "image"
      }
    }
  }
}

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
    url_path = "/status"
    port     = 8080
  }
  load_balancer_id = oci_load_balancer_load_balancer.application_loadbalancer.id
  name             = "application-backend-set"
  policy           = "ROUND_ROBIN"
}

resource "oci_load_balancer_listener" "application_listener" {
  default_backend_set_name = oci_load_balancer_backend_set.application_backend_set.name
  load_balancer_id         = oci_load_balancer_load_balancer.application_loadbalancer.id
  name                     = "application_listener"
  port                     = 80
  protocol                 = "HTTP"
}

resource "oci_core_instance_pool" "application_instance_pool" {
  compartment_id            = var.compartment_id
  display_name              = "application-compute"
  instance_configuration_id = oci_core_instance_configuration.application_compute_config_alt.id

  placement_configurations {
    availability_domain = var.availability_domain_name
    primary_subnet_id   = var.subnet_id
  }

  size = "1"

  lifecycle {
    ignore_changes = [
      size,
    ]
  }

  load_balancers {
    backend_set_name = oci_load_balancer_backend_set.application_backend_set.name
    load_balancer_id = oci_load_balancer_load_balancer.application_loadbalancer.id
    port             = "8080"
    vnic_selection   = "PrimaryVnic"
  }
}

resource "oci_autoscaling_auto_scaling_configuration" "application_auto_scaling_config" {
  auto_scaling_resources {
    id   = oci_core_instance_pool.application_instance_pool.id
    type = "instancePool"
  }

  compartment_id       = var.compartment_id
  cool_down_in_seconds = "300"
  display_name         = "application-autoscaling-config"

  is_enabled = "true"
  policies {
    capacity {
      initial = "1"
      max     = "2"
      min     = "1"
    }

    display_name = "application-autoscaling-policy"
    is_enabled   = "true"
    policy_type  = "threshold"

    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "1"
      }
      display_name = "scale-out-rule"
      metric {
        metric_type = "CPU_UTILIZATION"
        threshold {
          operator = "GT"
          value    = "70"
        }
      }
    }

    rules {
      action {
        type  = "CHANGE_COUNT_BY"
        value = "-1"
      }
      display_name = "scale-in-rule"
      metric {
        metric_type = "CPU_UTILIZATION"
        threshold {
          operator = "LT"
          value    = "40"
        }
      }
    }
  }
}
