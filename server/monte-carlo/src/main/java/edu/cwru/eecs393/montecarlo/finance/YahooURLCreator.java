package edu.cwru.eecs393.montecarlo.finance;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import lombok.NonNull;

public final class YahooURLCreator {

	/**
	 * Private constructor since this is a utility class.
	 */
	private YahooURLCreator() {
	}

	/**
	 * Base URL for retrieving historical stock data from Yahoo! Finance.
	 */
	private static final String baseHistoricalURL = "http://ichart.finance.yahoo.com/table.csv?s={TICKER}&a={SM}&b={SD}&c={SY}&d={EM}&e={ED}&f={EY}&g=d&ignore=.csv";

	/**
	 * Base URL for retrieving most up to date data about a stock or stocks from
	 * Yahoo! Finance.
	 */
	private static final String baseCurrentURL = "http://download.finance.yahoo.com/d/quotes.csv?s={TICKERS}&f=snabl1";

	/**
	 * Creates a URL that can be used to retrieve historical data about a
	 * specific ticker, at a specific date. <br>
	 * <br>
	 * <b>Note:</b> This does not guarantee that the results from the call will
	 * be from that specific date, rather they will be from that day or within 5
	 * days after. The results may also contain data for multiple dates.
	 *
	 * @param ticker
	 *            the stock ticker to use in the URL
	 * @param historicalDate
	 *            the date that will be used to create the URL
	 * @return a string containing a fully formed url for Yahoo! Finance
	 *         historical data
	 */
	public static String formatHistoricalURL(@NonNull String ticker, @NonNull Date historicalDate) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(historicalDate);
		String sm = "" + calendar.get(Calendar.MONTH);
		String sd = "" + calendar.get(Calendar.DATE);
		String sy = "" + calendar.get(Calendar.YEAR);
		calendar.add(Calendar.DAY_OF_MONTH, 5);
		String em = "" + calendar.get(Calendar.MONTH);
		String ed = "" + calendar.get(Calendar.DATE);
		String ey = "" + calendar.get(Calendar.YEAR);
		String result = baseHistoricalURL.replace("{TICKER}", ticker).replace("{SM}", sm).replace("{SD}", sd)
				.replace("{SY}", sy).replace("{EM}", em).replace("{ED}", ed).replace("{EY}", ey);
		return result;
	}

	public static String formatRealTimeURL(@NonNull List<String> tickerList) {
		if (tickerList.isEmpty()) {
			throw new IllegalArgumentException("List of desired tickers was empty.");
		}
		String tickers = String.join("+", tickerList);
		String result = baseCurrentURL.replace("{TICKERS}", tickers);
		return result;
	}

}
