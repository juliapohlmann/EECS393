package edu.cwru.eecs393.montecarlo.finance;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.junit.Test;

import junit.framework.TestCase;

public class YahooURLCreatorTest {

	@Test(expected = NullPointerException.class)
	public void testFormatHistoricalURLNullTicker() {
		YahooURLCreator.formatHistoricalURL(null, new Date());
	}

	@Test(expected = NullPointerException.class)
	public void testFormatHistoricalURLNullDate() {
		YahooURLCreator.formatHistoricalURL("GOOG", null);
	}

	@Test
	public void testFormatHistoricalURL() {
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.DAY_OF_MONTH, 28);
		cal.set(Calendar.MONTH, 11);
		cal.set(Calendar.YEAR, 2000);
		String url = YahooURLCreator.formatHistoricalURL("GOOG", cal.getTime());
		String expected = "http://ichart.finance.yahoo.com/table.csv?s=GOOG&a=11&b=28&c=2000&d=0&e=2&f=2001&g=d&ignore=.csv";
		TestCase.assertEquals(expected, url);
	}

	@Test(expected = NullPointerException.class)
	public void testFormatRealTimeURLNull() {
		YahooURLCreator.formatRealTimeURL(null);
	}

	@Test(expected = IllegalArgumentException.class)
	public void testFormatRealTimeURLEmpty() {
		YahooURLCreator.formatRealTimeURL(new ArrayList<>());
	}

	@Test
	public void testFormatRealTimeURLSingle() {
		List<String> ticker = new ArrayList<>();
		ticker.add("GOOG");
		String result = YahooURLCreator.formatRealTimeURL(ticker);
		String expected = "http://download.finance.yahoo.com/d/quotes.csv?s=GOOG&f=sabl1";
		TestCase.assertEquals(expected, result);
	}

	@Test
	public void testFormatRealTimeURLMultiple() {
		List<String> tickers = new ArrayList<>();
		tickers.add("GOOG");
		tickers.add("AAPL");
		String result = YahooURLCreator.formatRealTimeURL(tickers);
		String expected = "http://download.finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL&f=sabl1";
		TestCase.assertEquals(expected, result);
	}

}
