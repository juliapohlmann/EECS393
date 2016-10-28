package edu.cwru.eecs393.montecarlo.data;

import lombok.AllArgsConstructor;
import lombok.Value;

@Value
@AllArgsConstructor
public class Stock {

	private String ticker;
	private double currentPrice;
	private double prevPrice;
	private double allocation;
}