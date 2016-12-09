package edu.cwru.eecs393.montecarlo.simulation;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import edu.cwru.eecs393.montecarlo.data.FinancialData;
import edu.cwru.eecs393.montecarlo.data.HistoricalFinancialData;
import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import edu.cwru.eecs393.montecarlo.data.SimulationResult;
import edu.cwru.eecs393.montecarlo.math.Statistics;

/**
 * Implementation of {@link Simulation} for running monte carlo simulations.
 *
 */
public class MonteCarloSimulation implements Simulation {

	// number of years money is invested
	private final int duration;
	// beginning portfolio balance
	private final double initialValue;
	// goal, or target, amount of money at the end of the duration
	private final double goalValue;
	// list of type Stock that makes up the portfolio
	private final List<FinancialData> portfolio;
	// number of stocks in the portfolio
	private final int numStocks;
	// the annual price forcast for each stock in the portfolio
	private double forecast[][];
	// number of trials the simulation runs
	private final int numTrials = 10000;
	// list of ending values from each trial
	private final List<Double> results = new ArrayList<>();
	private final SimulationParameters simParameters;

	/**
	 * Constructor for the simulation
	 * @param simParameters 
	 * 				the parameters of the simulation passed in from the front end
	 * @param financialData
	 * 				historic financial data of each stock from the Yahoo! Finance API
	 */
	public MonteCarloSimulation(SimulationParameters simParameters, Map<String, FinancialData> financialData) {
		this.simParameters = simParameters;
		initialValue = simParameters.getStartingMoney();
		goalValue = simParameters.getGoalMoney();
		duration = simParameters.getYears();
		portfolio = new ArrayList<>(financialData.size());
		for (FinancialData fd : financialData.values()) {
			portfolio.add(fd);
		}
		numStocks = portfolio.size();
	}

	@Override
	/**
	 * Runs the simulation.  Forecasts a portfolio of stocks over 10,000 trials.
	 * 
	 * @return Simulation Result
	 * 				output of the simulation
	 */
	public SimulationResult runSimulation() {
		SimulationResult simResult = new SimulationResult();
		double bestTrial = 0;
		double worstTrial = 0;
		int successfulTrials = 0;
		for (int i = 0; i < numTrials; i++) {
			forecastAllStocks();
			double result = calculateReturns(simParameters);
			results.add(result);

			if (result >= goalValue) {
				successfulTrials++;
			}
		}

		Collections.sort(results);
		bestTrial = results.get((int) (results.size() * 0.85));
		worstTrial = results.get((int) (results.size() * 0.15));
		simResult.setMaxValue(results.get(results.size() - 1));
		simResult.setMinValue(results.get(0));
		simResult.setPercentGoalReached(successfulTrials * (1.0) / numTrials);
		simResult.setValueToPercent(getMap(worstTrial, bestTrial));
		return simResult;
	}

	/**
	 * @return SimulationType
	 * 			Returns the type of simulation to run.
	 */
	@Override
	public SimulationType getSimulationType() {
		return SimulationType.MONTE_CARLO;
	}

	/**
	 * Creates the map of doubles used to create the graph shown at the end of the results page.
	 * @param min
	 * 			The minimum result shown on the graph
	 * @param max
	 * 			The maximum result shown on the graph
	 * @return Map of the the ranges for the graph and the number of observation in each range
	 */
	public Map<Double, Double> getMap(double min, double max) {
		double increment = (max - min) / 10;
		Map<Double, Double> m = new HashMap<>();
		for (int i = 1; i <= 10; i++) {
			double x = min + (i * increment);
			double y = find(x);
			m.put(x, y);
		}
		return m;
	}
/**
 * 
 * @param x
 * 			The lowest simulation result in the next graph increment
 * @return The index of the input x, if it were in the results array
 */
	public double find(double x) {
		int count = Math.abs(Collections.binarySearch(results, x));
		count = results.size() - count;
		return (count * 1.0) / results.size();
	}

	/**
	 * Calculates the number of shares purchased by dividing # dollars allocated
	 * by current price. Then, multiplies share count by the price in the final
	 * year of forecast to get a final value for that stock
	 * @param simParameters
	 * 			The initial parameters of the simulation passed in from the front end
	 * @return  The final value of one trial of the simulation.
	 */
	public double calculateReturns(SimulationParameters simParameters) {
		double endValue = 0;
		for (int i = 0; i < numStocks; i++) {
			double alloc = simParameters.getTickerToAllocation().get(portfolio.get(i).getTicker());
			double price = portfolio.get(i).getAsk();
			double shareCount = ((alloc / 100) * initialValue) / price;
			endValue += shareCount * forecast[i][duration];
		}
		return endValue;
	}

	/**
	 * Forecasts the entire portfolio for entire duration Creates a matrix of
	 * number of stocks by duration, with the forecasted price of each stock for
	 * each year of the simulation
	 */
	public void forecastAllStocks() {
		forecast = new double[numStocks][duration + 1];
		for (int i = 0; i < portfolio.size(); i++) {
			FinancialData s = portfolio.get(i);
			forecast[i] = forecast(s);
		}
	}


	/**
	 * Forecast an individual stock over the duration of the investment.
	 * @param stock
	 * 			The stock to be forecasted over the duration of the investment.
	 * @return A double array that contains the current price at index 0, and forecasted prices from
	 * index 1 through n, the duration of the simulation.
	 */
	public double[] forecast(FinancialData stock) {
		double currentPrice = stock.getAsk();
		double periodicReturns[] = new double[stock.getHistoricalData().size() - 1];
		double annualPrices[] = new double[stock.getHistoricalData().size()];

		Iterator<HistoricalFinancialData> iter = stock.getHistoricalData().iterator();
		int i = 0;
		while (iter.hasNext()) {
			annualPrices[i] = iter.next().getClose();
			i++;
		}

		for (int j = 0; j < stock.getHistoricalData().size() - 1; j++) {
			periodicReturns[j] = periodicAnnualReturn(annualPrices[j], annualPrices[j + 1]);
		}

		Statistics stat = new Statistics(periodicReturns);

		double aveAnnualReturn = stat.getMean();
		double variance = stat.getVariance();
		double drift = drift(aveAnnualReturn, variance);
		double stdDev = stat.getStdDev();

		// duration + 1 to include price at time 0
		double forecastedPrice[] = new double[duration + 1];
		// year 0 price is current price
		forecastedPrice[0] = currentPrice;

		/*
		 * for each year of duration, calculate the price. Model is based on the
		 * drift of annual returns and a random variable Assumes stocks follow a
		 * "Random Walk" and employs random, Brownian Motion
		 */
		for (int j = 1; j <= duration; j++) {
			double randomValue = randomValue(stdDev, stat);
			forecastedPrice[j] = nextYearPrice(currentPrice, drift, randomValue);
			currentPrice = forecastedPrice[j];
		}

		return forecastedPrice;
	}

	/**
	 * periodic return is the natural log of the change in price over 1 year
	 * @param today
	 * 			The current price of the stock when the method is called.  
	 * @param previousYear
	 * 			The price of the stock one year prior in the simulation
	 * @return The log of the percent change of the inputs.  
	 */
	public double periodicAnnualReturn(double today, double previousYear) {
		return Math.log(today / previousYear);
	}


	/**
	 * 	drift defined as the average annual periodic return less half the variance
	 * @param aveAnnualReturn
	 * 			The average annual periodic return of the stock.
	 * @param variance
	 * 			The variance of the periodic returns.
	 * @return Drift, a measure of historic stock price movement.  
	 */
	public double drift(double aveAnnualReturn, double variance) {
		double drift = aveAnnualReturn - (variance / 2);
		return drift;
	}

	/**
	 * inverse probability a random value occurs on a normal distribution scaled
	 * by the standard deviation
	 * @param stdDev
	 * 			The standard deviation of periodic returns.
	 * @param stat
	 * 			An instance of a helper stat class
	 * @return A random value
	 */
	public double randomValue(double stdDev, Statistics stat) {
		return stdDev * stat.normInv(Math.random(), 0, 1);
	}


	/**
	 * Forecast the next price as current price * e ^ (drift + random Value)
	 * @param today
	 * 			The current price in the simulation
	 * @param drift
	 * 			The drift calculated from the drift method
	 * @param randomValue
	 * 			The random value calculated from the random value method
	 * @return  The next forecasted price.  
	 */
	public double nextYearPrice(double today, double drift, double randomValue) {
		return today * Math.exp(drift + randomValue);
	}

}
