package com.example.devops.resources;

import com.example.devops.api.Fibonacci;
import com.codahale.metrics.annotation.Timed;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

@Path("/fibonacci")
@Produces(MediaType.APPLICATION_JSON)
public class FibonacciResource {
    public FibonacciResource() {
        // left intentionally empty
    }

    @GET
    @Timed
    @Produces(MediaType.APPLICATION_JSON)
    public Fibonacci getFibonacci(@QueryParam("value") @NotNull @Min(1) @Max(100) Integer value) {
        return new Fibonacci(value);
    }
}
