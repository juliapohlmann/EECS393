package edu.cwru.eecs393.montecarlo.finance;

import java.util.List;
import java.util.Map;

/**
 * Interface for retrieving current financial market data based.
 *
 * @author David
 *
 */
public interface FinanceHandler {

	/**
	 * Retrieves the ticker prices, and historical prices for a list of stocks.
	 *
	 * @param tickers
	 *            a list containing the tickers for every desired stock
	 * @return a Map, mapping a ticker to a list of prices, the first being most
	 *         recent with each subsuquent price moving one year back in time
	 */
	Map<String, List<Double>> getTickerPrices(List<String> tickers);

}
