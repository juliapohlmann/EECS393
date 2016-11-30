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
	private int duration; // number of years money is invested
	private double initialValue; // beginning portfolio balance
	private double goalValue; // goal, or target, amount of money at the end of the duration
	private List<FinancialData> portfolio; // list of type Stock that makes up the portfolio
	private int numStocks; // number of stocks in the portfolio
	private double forecast[][];  //the annual price forcast for each stock in the portfolio
	private int numTrials = 10000;  //number of trials the simulation runs
	private List<Double> results = new ArrayList();  //list of ending values from each trial
	private SimulationParameters simParameters;


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
		bestTrial = results.get(results.size() - 1);
		worstTrial = results.get(0);
		simResult.setMaxValue(bestTrial);
		simResult.setMinValue(worstTrial);
		simResult.setPercentGoalReached(successfulTrials * (1.0) / numTrials);
		simResult.setValueToPercent(getMap(worstTrial, bestTrial));
		return simResult;
	}

	@Override
	public SimulationType getSimulationType() {
		return SimulationType.MONTE_CARLO;
	}

	public Map<Double, Double> getMap(double min, double max) {
		double increment = (results.get(results.size() / 2) - min) / 10;
		Map<Double, Double> m = new HashMap<>();
		for (int i = 1; i <= 10; i++) {
			double x = min + (i * increment);
			double y = find(x);
			m.put(x, y);
		}
		return m;
	}

	public double find(double x) {
		int count = Math.abs(Collections.binarySearch(results, x));
		count = results.size() - count;
		return (count * 1.0) / results.size();
	}

	/*
	 * Calculates the number of shares purchased by dividing # dollars allocated
	 * by current price. Then, multiplies share count by the price in the final
	 * year of forecast to get a final value for that stock
	 */
	public double calculateReturns(SimulationParameters simParameters) {
		double endValue = 0;
		for (int i = 0; i < numStocks; i++) {
			double alloc = simParameters.getTickerToAllocation().get(portfolio.get(i).getTicker());
			double price = portfolio.get(i).getAsk();
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
			FinancialData s = portfolio.get(i);
			forecast[i] = forecast(s);
		}
	}

	/*
	 * Forecast a stock price each year for the number of years of the duration
	 */
	public double[] forecast(FinancialData stock) {
		double currentPrice = stock.getAsk();
		double prevYearPrice = stock.getHistoricalData().first().getClose();
		double periodicReturns[] = new double[stock.getHistoricalData().size()-1];
		double annualPrices[] = new double[stock.getHistoricalData().size()];

		Iterator<HistoricalFinancialData> iter = stock.getHistoricalData().iterator();
		int i = 0;
		while(iter.hasNext()){
			annualPrices[i] = iter.next().getClose();
			i++;
		}
		
		for(int j = 0; j < stock.getHistoricalData().size()-1; j++){
			periodicReturns[j] = periodicAnnualReturn(annualPrices[j],annualPrices[j+1]);
		}


		Statistics stat = new Statistics(periodicReturns);

		double aveAnnualReturn = stat.getMean();
		double variance = stat.getVariance();
		double drift = drift(aveAnnualReturn, variance);
		double stdDev = stat.getStdDev();

		double forecastedPrice[] = new double[duration + 1]; // duration + 1 to
																// include price
																// at time 0
		forecastedPrice[0] = currentPrice; // year 0 price is current price

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
		//return today * Math.exp(randomValue);
	}

}
