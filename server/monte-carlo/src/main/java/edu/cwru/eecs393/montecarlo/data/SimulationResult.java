package edu.cwru.eecs393.montecarlo.data;

import java.util.Map;

import edu.cwru.eecs393.montecarlo.simulation.Simulation;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * A class for holding the results of a {@link Simulation}.
 *
 * @author David
 *
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SimulationResult {

	private double maxValue;
	private double minValue;
	private double percentGoalReached;
	private Map<Double, Double> valueToPercent;

}
