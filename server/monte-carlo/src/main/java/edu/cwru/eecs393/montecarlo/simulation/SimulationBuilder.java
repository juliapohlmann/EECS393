package edu.cwru.eecs393.montecarlo.simulation;

import java.util.Map;
import java.util.logging.Level;

import edu.cwru.eecs393.montecarlo.data.FinancialData;
import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import lombok.extern.java.Log;

/**
 * Utility class for building simulations.
 *
 * @author David
 *
 */
@Log
public class SimulationBuilder {

	// TODO once there is more than one simulation type, this should not be
	// initialized by default
	private SimulationType simulationType = SimulationType.MONTE_CARLO;
	private SimulationParameters simulationParameters;
	private Map<String, FinancialData> financialDataMap;

	/**
	 * Initializes a new {@link SimulationBuilder}
	 */
	public SimulationBuilder() {
		this.simulationType = null;
	}

	/**
	 * Sets this builder's {@link SimulationType}.
	 *
	 * @param simulationType
	 *            the type of simulation to build
	 * @return this builder
	 */
	public SimulationBuilder simulationType(SimulationType simulationType) {
		this.simulationType = simulationType;
		return this;
	}

	/**
	 * Set this builder's {@link SimulationParameters}. It is assumed that the
	 * simulation parameters are valid.
	 *
	 * @param simulationParameters
	 *            the parameters for the simulation to build
	 * @return this builder
	 */
	public SimulationBuilder simulationParameters(SimulationParameters simulationParameters) {
		this.simulationParameters = simulationParameters;
		return this;
	}

	/**
	 * Sets this builder's Map of {@link FinancialData}. It is assumed that the
	 * map and financial data are both valid.
	 *
	 * @param data
	 *            the financial data for the simulation to build
	 * @return this builder
	 */
	public SimulationBuilder financialDataMap(Map<String, FinancialData> financialDataMap) {
		this.financialDataMap = financialDataMap;
		return this;
	}

	/**
	 * Creates a new Simulation with the current values.
	 *
	 * @return an implementation of {@link Simulation}
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

	// Utility method for creating a MonteCarloSimulation
	private Simulation buildMonteCarloSimulation() throws IllegalStateException {
		if (null == simulationParameters || null == financialDataMap) {
			throw new IllegalStateException("No simulation parameters or financial data specified.");
		}
		return new MonteCarloSimulation(simulationParameters, financialDataMap);
	}

}
