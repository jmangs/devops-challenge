package com.example.devops;

import com.example.devops.health.TemplateHealthCheck;
import com.example.devops.resources.FibonacciResource;
import com.example.devops.resources.HelloWorldResource;

import io.dropwizard.Application;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;

public class DevOpsApplication extends Application<DevOpsConfiguration> {

    public static void main(final String[] args) throws Exception {
        new DevOpsApplication().run(args);
    }

    @Override
    public String getName() {
        return "DevOps";
    }

    @Override
    public void initialize(final Bootstrap<DevOpsConfiguration> bootstrap) {
        // Nothing to do here for this application.
    }

    @Override
    public void run(final DevOpsConfiguration configuration,
                    final Environment environment) {
        final HelloWorldResource helloWorldResource = new HelloWorldResource(
            configuration.getTemplate(),
            configuration.getDefaultName()
        );
        environment.jersey().register(helloWorldResource);

        final FibonacciResource fibonacciResource = new FibonacciResource();
        environment.jersey().register(fibonacciResource);

        final TemplateHealthCheck healthCheck =
            new TemplateHealthCheck(configuration.getTemplate());
        environment.healthChecks().register("template", healthCheck);
    }

}
