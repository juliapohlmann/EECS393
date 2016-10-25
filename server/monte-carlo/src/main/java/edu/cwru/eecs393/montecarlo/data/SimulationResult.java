package edu.cwru.eecs393.montecarlo.data;

import java.util.Map;

import edu.cwru.eecs393.montecarlo.simulation.Simulation;
import lombok.Value;

/**
 * A class for holding the results of a {@link Simulation}.
 *
 * @author David
 *
 */
@Value
public class SimulationResult {

	private final double maxValue;
	private final double minValue;
	private final double percentGoalReached;
	private final Map<Double, Double> valueToPercent;

}
