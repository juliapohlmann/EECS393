package edu.cwru.eecs393.montecarlo.handlers;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import edu.cwru.eecs393.montecarlo.finance.YahooFinanceHandler;

public class YahooFinanceHandlerTest {

	@Test
	public void test() {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		List<String> tickers = new ArrayList<>();
		tickers.add("GOOG");
		tickers.add("AAPL");
		tickers.add("YHOO");
		tickers.add("DAX");
		tickers.add("T");
		tickers.add("NKE");
		tickers.add("DIS");
		tickers.add("SBUX");
		tickers.add("VZ");
		tickers.add("IBM");
		tickers.add("DELL");
		tickers.add("DE");
		long start = System.nanoTime();
		handler.getFinancialData(tickers);
		long end = System.nanoTime();
		System.out.println("Nanos: " + (end - start));
	}

}
