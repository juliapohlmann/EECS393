package edu.cwru.eecs393.montecarlo.simulation;

import org.junit.Test;

public class MonteCarloSimulationTest {

	@Test
	public void testGetSimulationType() {
		// MonteCarloSimulation simulation = new MonteCarloSimulation();
		// assertEquals(simulation.getSimulationType(),
		// SimulationType.MONTE_CARLO);
	}

	// public void testDrift() {
	// Stock s = new Stock("AAPL", 23.40, 20.05, 0.5);
	// Stock portfolio[] = { s };
	// MonteCarlo m = new MonteCarlo(5, 10, 50, portfolio);
	// double aveAnnualReturn = 10;
	// double variance = 5;
	// assert (m.drift(aveAnnualReturn, variance) == (aveAnnualReturn - variance
	// / 2));
	// }
	//
	// public void testNextYearPrice() {
	// Stock s = new Stock("AAPL", 23.40, 20.05, 0.5);
	// Stock portfolio[] = { s };
	// MonteCarlo m = new MonteCarlo(5, 10, 50, portfolio);
	// double currentPrice = 23.66;
	// double drift = 3.2;
	// double randomValue = 0.9;
	// assert (m.nextYearPrice(currentPrice, drift, randomValue) ==
	// (currentPrice * (Math.exp(drift + randomValue))));
	// }
	//
	// public void testPeriodicAnnualReturn() {
	// Stock s = new Stock("AAPL", 23.40, 20.05, 0.5);
	// Stock portfolio[] = { s };
	// MonteCarlo m = new MonteCarlo(5, 10, 50, portfolio);
	// double currentPrice = 23.66;
	// double previousPrice = 20.05;
	// assert (m.periodicAnnualReturn(currentPrice, previousPrice) ==
	// Math.log(currentPrice / previousPrice));
	// }
	//
	// public void testForecast() {
	// Stock s = new Stock("AAPL", 23.40, 20.05, 0.5);
	// Stock portfolio[] = { s };
	// MonteCarlo m = new MonteCarlo(5, 1000, 5000, portfolio);
	// MonteCarlo n = new MonteCarlo(5, 1000, 5000, portfolio);
	// assertNotSame(m.forecast(s), n.forecast(s));
	// }

}
