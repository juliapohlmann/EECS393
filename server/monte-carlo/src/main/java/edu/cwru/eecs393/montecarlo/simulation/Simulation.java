package edu.cwru.eecs393.montecarlo.simulation;

import edu.cwru.eecs393.montecarlo.data.SimulationResult;

/**
 * Interface for various simulations.
 *
 * @author David
 *
 */
public interface Simulation {

	/**
	 * Runs the current simulation and returns the results.
	 *
	 * @return the results of running this simulation
	 */
	SimulationResult runSimulation();

}
