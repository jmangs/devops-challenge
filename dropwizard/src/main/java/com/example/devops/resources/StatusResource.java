package com.example.devops.resources;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.codahale.metrics.health.HealthCheckRegistry;

@Path("/status")
@Produces(MediaType.APPLICATION_JSON)
public class StatusResource {
    private final HealthCheckRegistry registry;

    public StatusResource(HealthCheckRegistry registry) {
        this.registry = registry;
    }

    @GET
    public boolean checkStatus() {
        return registry.runHealthCheck("template").isHealthy();
    }
}
