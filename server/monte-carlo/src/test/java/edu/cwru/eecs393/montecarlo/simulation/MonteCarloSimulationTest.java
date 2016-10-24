package edu.cwru.eecs393.montecarlo.simulation;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class MonteCarloSimulationTest {

	@Test
	public void testGetSimulationType() {
		MonteCarloSimulation simulation = new MonteCarloSimulation();
		assertEquals(simulation.getSimulationType(), SimulationType.MONTE_CARLO);
	}

}
