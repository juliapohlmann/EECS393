package edu.cwru.eecs393.montecarlo.finance;

import java.util.Collection;
import java.util.Map;

import edu.cwru.eecs393.montecarlo.data.FinancialData;

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
	 * @return a map, mapping each ticker to its financial data.
	 */
	Map<String, FinancialData> getFinancialData(Collection<String> tickers);

}
