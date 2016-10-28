package edu.cwru.eecs393.montecarlo.data;

import java.util.NavigableSet;

import lombok.Builder;
import lombok.Value;

/**
 * A class for holding all the relevant financial data about a specific stock.
 *
 * @author David
 *
 */
@Value
@Builder
public class FinancialData {

	private String ticker;
	private float ask;
	private float bid;
	private float lastSale;
	private NavigableSet<HistoricalFinancialData> historicalData;

}
