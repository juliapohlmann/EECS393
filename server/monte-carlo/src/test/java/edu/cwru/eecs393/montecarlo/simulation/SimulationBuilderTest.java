package edu.cwru.eecs393.montecarlo.simulation;

import org.junit.Test;

import junit.framework.TestCase;

public class SimulationBuilderTest extends TestCase {

	@Test()
	public void testNoSimulationType() {
		SimulationBuilder bldr = new SimulationBuilder();
		try {
			bldr.buildSimulation();
			fail();
		} catch (IllegalStateException e) {
			assertTrue(true);
		}
	}

	@Test
	public void testMonteCarloSimulation() {
		SimulationBuilder bldr = new SimulationBuilder();
		Simulation sim = bldr.simulationType(SimulationType.MONTE_CARLO).buildSimulation();
		assertEquals(sim.getSimulationType(), SimulationType.MONTE_CARLO);
		assertEquals(sim.getClass(), MonteCarloSimulation.class);
	}

}
