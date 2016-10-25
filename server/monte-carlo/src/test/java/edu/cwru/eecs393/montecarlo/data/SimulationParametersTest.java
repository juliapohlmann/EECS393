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
		assertTrue(params.checkValid());
	}

	@Test
	public void testIsValidEmptyMap() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		params.setTickerToAllocation(tickerToAllocation);
		assertFalse(params.checkValid());

		params.setTickerToAllocation(null);
		assertFalse(params.checkValid());
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

		assertFalse(params.checkValid());

		params.setGoalMoney(200);
		params.setStartingMoney(0);

		assertFalse(params.checkValid());

		params.setStartingMoney(100);
		params.setYears(0);

		assertFalse(params.checkValid());
	}

}
