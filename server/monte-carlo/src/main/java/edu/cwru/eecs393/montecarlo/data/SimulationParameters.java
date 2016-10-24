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
	private int startingCash;
	private int years;

	public boolean isValid() {
		// TODO what makes these valid?
		return true;
	}

}
