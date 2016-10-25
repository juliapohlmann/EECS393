package edu.cwru.eecs393.montecarlo.data;

import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * A simple object for simulation parameters.
 *
 * @author David
 *
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SimulationParameters {

	private Map<String, Double> tickerToAllocation;
	private int startingMoney;
	private int years;
	private int goalMoney;

}
