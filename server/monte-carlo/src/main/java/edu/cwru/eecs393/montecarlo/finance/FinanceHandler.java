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
	 * Retrieves the ticker prices for a list of stocks.
	 * 
	 * @param tickers
	 *            a list containing the tickers for every desired stock
	 * @return a Map, mapping a ticker to it's price.
	 */
	Map<String, Double> getTickerPrices(List<String> tickers);

}
