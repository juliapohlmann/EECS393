package edu.cwru.eecs393.montecarlo.simulation;

import java.util.ArrayList;
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
	int duration; // number of years money is invested
	double initialValue; // beginning portfolio balance
	double goalValue; // goal, or target, amount of money at the end of the
						// duration
	List<Stock> portfolio; // list of type Stock that makes up the portfolio
	int numStocks; // number of stocks in the portfolio
	double forecast[][];
	int numTrials = 10000;

	public MonteCarloSimulation(SimulationParameters simParameters, Map<String, FinancialData> financialData) {
		initialValue = simParameters.getStartingMoney();
		goalValue = simParameters.getGoalMoney();
		duration = simParameters.getYears();
		portfolio = new ArrayList<>(financialData.size());
		for (FinancialData fd : financialData.values()) {
			portfolio.add(new Stock(fd.getTicker(), fd.getBid(), fd.getHistoricalData().first().getClose(),
					simParameters.getTickerToAllocation().get(fd.getTicker())));
		}
		numStocks = portfolio.size();
	}

	@Override
	public SimulationResult runSimulation() {
		SimulationResult simResult = new SimulationResult();
		double bestTrial = 0;
		double worstTrial = 0;
		int successfulTrials = 0;
		for (int i = 0; i < numTrials; i++) {
			forecastAllStocks();
			double result = calculateReturns();

			if (i == 0) {
				bestTrial = result;
				worstTrial = result;
			}

			if (result > bestTrial) {
				bestTrial = result;
			}

			if (result < worstTrial) {
				worstTrial = result;
			}

			if (result >= goalValue) {
				successfulTrials++;
			}
		}
		simResult.setMaxValue(bestTrial);
		simResult.setMinValue(worstTrial);
		simResult.setPercentGoalReached(successfulTrials*(1.0) / numTrials);
		simResult.setValueToPercent(null);
		// TODO Auto-generated method stub
		return simResult;
	}

	@Override
	public SimulationType getSimulationType() {
		return SimulationType.MONTE_CARLO;
	}

	public double calculateReturns() {
		double endValue = 0;
		for (int i = 0; i < numStocks; i++) {
			double alloc = portfolio.get(i).getAllocation();
			double price = portfolio.get(i).getCurrentPrice();
			double shareCount = (alloc * initialValue) / price;
			endValue += shareCount * forecast[i][duration];
		}
		return endValue;
	}

	/*
	 * Forecasts the entire portfolio for entire duration Creates a matrix of
	 * number of stocks by duration, with the forecasted price of each stock for
	 * each year of the simulation
	 */
	public void forecastAllStocks() {
		forecast = new double[numStocks][duration + 1];
		for (int i = 0; i < portfolio.size(); i++) {
			Stock s = portfolio.get(i);
			forecast[i] = forecast(s);
		}
	}

	/*
	 * Forecast a stock price each year for the number of years of the duration
	 */
	public double[] forecast(Stock stock) {
		double currentPrice = stock.getCurrentPrice();
		double prevYearPrice = stock.getPrevPrice();
		// will be expanded in later versions to include up to 5 years of
		// historic prices
		double periodicReturns[] = new double[1];

		periodicReturns[0] = periodicAnnualReturn(currentPrice, prevYearPrice);

		Statistics stat = new Statistics(periodicReturns);

		double aveAnnualReturn = stat.getMean();
		double variance = stat.getVariance();
		double drift = drift(aveAnnualReturn, variance);
		double stdDev = 1;

		double forecastedPrice[] = new double[duration + 1]; // duration + 1 to
																// include price
																// at time 0
		forecastedPrice[0] = currentPrice; // year 0 price is current price

		/*
		 * for each year of duration, calculate the price. Model is based on the
		 * drift of annual returns and a random variable Assumes stocks follow a
		 * "Random Walk" and employs random, Brownian Motion
		 */
		for (int i = 1; i <= duration; i++) {
			double randomValue = randomValue(stdDev, stat);
			forecastedPrice[i] = nextYearPrice(currentPrice, drift, randomValue);
			currentPrice = forecastedPrice[i];
		}

		return forecastedPrice;
	}

	// periodic return is the log (base e) of the change in price over 1 year
	public double periodicAnnualReturn(double today, double previousYear) {
		return Math.log(today / previousYear);
	}

	// drift defined as the average annual periodic return less half the
	// variance
	public double drift(double aveAnnualReturn, double variance) {
		double drift = aveAnnualReturn - (variance / 2);
		return drift;
	}

	// inverse probability a random value occurs on a normal distribution scaled
	// by the standard deviation
	public double randomValue(double stdDev, Statistics stat) {
		return stdDev * stat.normInv(Math.random(), 0, 1);
	}

	// the current price * e ^ (drift + random Value)
	public double nextYearPrice(double today, double drift, double randomValue) {
		return today * Math.exp(drift + randomValue);
	}

}
