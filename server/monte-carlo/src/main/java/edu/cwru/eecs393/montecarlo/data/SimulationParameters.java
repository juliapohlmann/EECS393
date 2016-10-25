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

	/**
	 * Checks if these params are valid for starting a simulation. <br>
	 * <b>Note:</b> can not be called <code>isValid</code> due to how Jackson
	 * will serialize the object, resulting an an extra JSON field named "valid"
	 *
	 * @return true if the params are valid, false otherwise.
	 */
	public boolean checkValid() {
		return null != tickerToAllocation && !tickerToAllocation.isEmpty() && 0 < years && startingMoney != 0
				&& goalMoney != 0;
	}

}
