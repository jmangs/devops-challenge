package com.example.devops.api;

import java.math.BigInteger;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Fibonacci {
  private BigInteger[] fibonacci;
  private BigInteger total;

  @SuppressWarnings("unused")
  public Fibonacci() {
      // Jackson deserialization
  }

  public Fibonacci(int target) {
      // We need to use BigInteger for larger values of N or we get overflow.
      this.fibonacci = new BigInteger[target + 1];
      this.fibonacci[0] = BigInteger.ZERO;
      this.total = BigInteger.ZERO;

      // calculate the Fibonacci sequence and track the total as we go
      for (int i = 1; i <= target; i++) {
          this.total = total.add(calculate(i));
      }
  }

  @JsonProperty
  public long getMemberCount() {
      return fibonacci.length;
  }

  @JsonProperty
  public BigInteger[] getSequence() {
      return fibonacci;
  }

  @JsonProperty BigInteger getTotal() {
      return total;
  }

  @Override
  public String toString() {
      return "";
  }
  
  private BigInteger calculate(int n) {
    if (fibonacci[n] != null) {
        return fibonacci[n];
    }
    
    if (n == 1 || n == 2) {
        this.fibonacci[n] = BigInteger.ONE; // I could seed this into the memoization, but cleaner this way
        return BigInteger.ONE;
    }
    else {
        this.fibonacci[n] = calculate(n - 1).add(calculate(n - 2));
        return fibonacci[n];
    }
  }
}
