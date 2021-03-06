package edu.cwru.eecs393.montecarlo.simulation;

import java.util.HashMap;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.reflect.Whitebox;

import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import junit.framework.TestCase;

@RunWith(PowerMockRunner.class)
public class SimulationBuilderTest extends TestCase {

	@Test(expected = IllegalStateException.class)
	public void testNoSimulationType() {
		SimulationBuilder bldr = new SimulationBuilder();
		bldr.buildSimulation();
	}

	// This test has some black magic...
	@Test(expected = IllegalStateException.class)
	@PrepareForTest(SimulationType.class)
	public void testBadSimulationType() {
		// Create a fake enum
		SimulationType BOGUS = PowerMockito.mock(SimulationType.class);
		// Set the fake enum's private fields
		Whitebox.setInternalState(BOGUS, "name", "BOGUS");
		Whitebox.setInternalState(BOGUS, "ordinal", 1);

		// Mock the entire enum class
		PowerMockito.mockStatic(SimulationType.class);
		// set the SimulationType class to return our new fake enum
		PowerMockito.when(SimulationType.values())
				.thenReturn(new SimulationType[] { SimulationType.MONTE_CARLO, BOGUS });

		SimulationBuilder bldr = new SimulationBuilder();
		// Use the fake enum so that it falls to the default case in the switch
		bldr.simulationType(BOGUS).buildSimulation();
	}

	@Test
	public void testMonteCarloSimulation() {
		// TODO test after implememnting builder
		SimulationBuilder bldr = new SimulationBuilder();
		Simulation sim = bldr.simulationType(SimulationType.MONTE_CARLO)
				.simulationParameters(new SimulationParameters()).financialDataMap(new HashMap<>()).buildSimulation();
		assertEquals(sim.getSimulationType(), SimulationType.MONTE_CARLO);
		assertEquals(sim.getClass(), MonteCarloSimulation.class);
	}

	@Test(expected = IllegalStateException.class)
	public void testMonteCarloSimulationNullParams() {
		SimulationBuilder bldr = new SimulationBuilder();
		bldr.simulationType(SimulationType.MONTE_CARLO).simulationParameters(null).financialDataMap(new HashMap<>())
				.buildSimulation();
	}

	@Test(expected = IllegalStateException.class)
	public void testMonteCarloSimulationNullFinancialData() {
		SimulationBuilder bldr = new SimulationBuilder();
		bldr.simulationType(SimulationType.MONTE_CARLO).simulationParameters(new SimulationParameters())
				.financialDataMap(null).buildSimulation();
	}

}
