package com.example.devops.api;

import com.codahale.metrics.Counter;
import com.codahale.metrics.MetricRegistry;
import com.codahale.metrics.Timer;
import com.fasterxml.jackson.annotation.JsonProperty;

public class Status {
    private boolean isHealthy;
    private long totalRequests;
    private double meanRequestRate;
    private long currentActiveRequests;

    @SuppressWarnings("unused")
    public Status() {
        // Jackson deserialization
    }

    public Status(boolean isHealthy, MetricRegistry metrics) {
        this.isHealthy = isHealthy;

        Timer requestsTimer = metrics.timer("io.dropwizard.jetty.MutableServletContextHandler.requests");
        Counter activeRequestsCounter = metrics.counter("io.dropwizard.jetty.MutableServletContextHandler.active-requests");
    
        this.totalRequests = requestsTimer.getCount();
        this.meanRequestRate = requestsTimer.getMeanRate();
        this.currentActiveRequests = activeRequestsCounter.getCount();
    }

    @JsonProperty
    public boolean getIsHealthy() {
        return isHealthy;
    }

    @JsonProperty
    public long getTotalRequests() {
        return totalRequests;
    }

    @JsonProperty
    public double getMeanRequestRate() {
        return meanRequestRate;
    }

    @JsonProperty
    public long getCurrentActiveRequests() {
        return currentActiveRequests;
    }

    @Override
    public String toString() {
        return "Saying{" + "isHealthy=" + isHealthy + '}';
    }
}
