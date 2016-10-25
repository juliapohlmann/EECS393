package edu.cwru.eecs393.montecarlo.data;

import java.util.Map;

import lombok.Data;

/**
 * A simple object for simulation parameters.
 *
 * @author David
 *
 */
@Data
public class SimulationParameters {

	private Map<String, Double> tickerToAllocation;
	private int startingMoney;
	private int years;
	private int goalMoney;

	public boolean isValid() {
		return null != tickerToAllocation && !tickerToAllocation.isEmpty() && 0 < years && startingMoney != 0
				&& goalMoney != 0;
	}

}
