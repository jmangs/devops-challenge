package com.example.devops.resources;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.codahale.metrics.MetricRegistry;
import com.codahale.metrics.health.HealthCheckRegistry;
import com.example.devops.api.Status;

@Path("/status")
@Produces(MediaType.APPLICATION_JSON)
public class StatusResource {
    private final HealthCheckRegistry registry;
    private final MetricRegistry metrics;

    public StatusResource(HealthCheckRegistry registry, MetricRegistry metrics) {
        this.registry = registry;
        this.metrics = metrics;
    }

    @GET
    public Status checkStatus() {
        final boolean isHealthy = registry.runHealthCheck("template").isHealthy();
        return new Status(isHealthy, metrics);
    }
}
