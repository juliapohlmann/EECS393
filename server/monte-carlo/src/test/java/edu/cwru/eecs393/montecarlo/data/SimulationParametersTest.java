package edu.cwru.eecs393.montecarlo.data;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import junit.framework.TestCase;

public class SimulationParametersTest extends TestCase {

	@Test
	public void testIsValidTrue() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("T", 100.0);
		params.setTickerToAllocation(tickerToAllocation);
		assertTrue(params.isValid());
	}

	@Test
	public void testIsValidEmptyMap() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		params.setTickerToAllocation(tickerToAllocation);
		assertFalse(params.isValid());

		params.setTickerToAllocation(null);
		assertFalse(params.isValid());
	}

	@Test
	public void testIsValidZeros() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(0);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("T", 100.0);
		params.setTickerToAllocation(tickerToAllocation);

		assertFalse(params.isValid());

		params.setGoalMoney(200);
		params.setStartingMoney(0);

		assertFalse(params.isValid());

		params.setStartingMoney(100);
		params.setYears(0);

		assertFalse(params.isValid());
	}

}
