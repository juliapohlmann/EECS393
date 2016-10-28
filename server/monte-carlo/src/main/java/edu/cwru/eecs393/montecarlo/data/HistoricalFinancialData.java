package edu.cwru.eecs393.montecarlo.data;

import java.util.Date;

import lombok.Builder;
import lombok.Value;

/**
 * A class for holding historical data for a stock.
 *
 * @author David
 *
 */
@Value
@Builder
public class HistoricalFinancialData {

	private Date date;
	private float open;
	private float close;
	private int volume;
	private float adjClose;

}
