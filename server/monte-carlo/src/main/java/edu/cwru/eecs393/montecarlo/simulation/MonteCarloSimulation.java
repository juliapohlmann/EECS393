package edu.cwru.eecs393.montecarlo.simulation;

import java.util.List;
import java.util.Map;

import edu.cwru.eecs393.montecarlo.data.FinancialData;
import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import edu.cwru.eecs393.montecarlo.data.SimulationResult;
import edu.cwru.eecs393.montecarlo.data.Stock;
import edu.cwru.eecs393.montecarlo.math.Statistics;
import lombok.extern.java.Log;

/**
 * Implementation of {@link Simulation} for running monte carlo simulations.
 *
 */
@Log
public class MonteCarloSimulation implements Simulation {

	// TODO fields and constructor with everything that is needed for this
	// simulation
	int duration;
	double initialValue;
	double goalValue;
	List<Stock> portfolio;
	int numStocks;

	public MonteCarloSimulation(SimulationParameters simParameters, Map<String, FinancialData> financialData) {
		initialValue = simParameters.getStartingMoney();
		goalValue = simParameters.getGoalMoney();
		duration = simParameters.getYears();
		for (FinancialData fd : financialData.values()) {
			portfolio.add(new Stock(fd.getTicker(), fd.getBid(), fd.getHistoricalData().first().getClose(),
					simParameters.getTickerToAllocation().get(fd.getTicker())));
		}
		numStocks = portfolio.size();
	}

	@Override
	public SimulationResult runSimulation() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SimulationType getSimulationType() {
		return SimulationType.MONTE_CARLO;
	}

	public void forecastAllStocks() {
		double forecast[][] = new double[numStocks][duration];
		for (int i = 0; i < portfolio.size(); i++) {
			Stock s = portfolio.get(i);
			forecast[i] = forecast(s);
		}
	}

	public double[] forecast(Stock stock) {
		double currentPrice = stock.getCurrentPrice();
		double prevYearPrice = stock.getPrevPrice();
		double periodicReturns[] = new double[1];

		periodicReturns[0] = periodicAnnualReturn(currentPrice, prevYearPrice);

		Statistics stat = new Statistics(periodicReturns);

		double aveAnnualReturn = stat.getMean();
		double variance = stat.getVariance();
		double drift = drift(aveAnnualReturn, variance);
		double stdDev = 1;

		double forecastedPrice[] = new double[duration + 1];
		forecastedPrice[0] = currentPrice;

		for (int i = 1; i <= duration; i++) {
			double randomValue = randomValue(stdDev, stat);
			forecastedPrice[i] = nextYearPrice(currentPrice, drift, randomValue);
			currentPrice = forecastedPrice[i];
		}

		return forecastedPrice;
	}

	public double periodicAnnualReturn(double today, double previousYear) {
		return Math.log(today / previousYear);
	}

	public double drift(double aveAnnualReturn, double variance) {
		double drift = aveAnnualReturn - (variance / 2);
		return drift;
	}

	public double randomValue(double stdDev, Statistics stat) {
		return stdDev * stat.normInv(Math.random(), 0, 1);
	}

	public double nextYearPrice(double today, double drift, double randomValue) {
		return today * Math.exp(drift + randomValue);
	}

}
