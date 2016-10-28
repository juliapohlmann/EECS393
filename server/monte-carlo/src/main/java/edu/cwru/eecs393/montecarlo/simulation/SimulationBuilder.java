package edu.cwru.eecs393.montecarlo.simulation;

import java.util.logging.Level;

import lombok.extern.java.Log;

/**
 * Utility class for building simulations.
 *
 * @author David
 *
 */
@Log
public class SimulationBuilder {

	// TODO add the actual building methods
	private SimulationType simulationType;

	public SimulationBuilder() {
		this.simulationType = null;
	}

	public SimulationBuilder simulationType(SimulationType type) {
		simulationType = type;
		return this;
	}

	/**
	 * Creates a new Simulation with the current values.
	 *
	 * @return an implementation of Simulation
	 * @throws IllegalStateException
	 *             if the builder can not successfully build a new Simulation
	 *             based on the inputs
	 */
	public Simulation buildSimulation() throws IllegalStateException {
		if (null == simulationType) {
			throw new IllegalStateException("No SimulationType specified.");
		}
		switch (simulationType) {
		case MONTE_CARLO:
			return buildMonteCarloSimulation();
		default:
			log.log(Level.SEVERE, "Unhandled SimulationType.");
			throw new IllegalStateException("Unhandled SimulationType.");
		}
	}

	private Simulation buildMonteCarloSimulation() throws IllegalStateException {
		// TODO check fields, throw exception if needed
		// return new MonteCarloSimulation();
		return null;
	}

}
