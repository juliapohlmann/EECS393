package edu.cwru.eecs393.montecarlo.finance;

import static junit.framework.TestCase.assertEquals;
import static junit.framework.TestCase.assertNull;
import static junit.framework.TestCase.assertTrue;
import static org.mockito.Matchers.anyInt;
import static org.mockito.Matchers.anyString;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.powermock.api.support.membermodification.MemberMatcher.method;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import java.util.TreeSet;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.reflect.Whitebox;

import edu.cwru.eecs393.montecarlo.data.FinancialData;
import edu.cwru.eecs393.montecarlo.data.HistoricalFinancialData;
import edu.cwru.eecs393.montecarlo.data.HistoricalFinancialData.HistoricalFinancialDataBuilder;

@RunWith(PowerMockRunner.class)
public class YahooFinanceHandlerTest {

	@Test
	@PrepareForTest(YahooFinanceHandler.class)
	public void testGetFinancialDataNoDataFromURL() throws Exception {
		YahooFinanceHandler handlerSpy = PowerMockito.spy(new YahooFinanceHandler());

		// return an empty string from url call
		when(handlerSpy, method(YahooFinanceHandler.class, "getDataFromURL", String.class)).withArguments(anyString())
				.thenReturn("");
		List<String> tickers = new ArrayList<>();
		tickers.add("a");
		Map<String, FinancialData> result = handlerSpy.getFinancialData(tickers);
		assertTrue(result.isEmpty());
	}

	@Test
	@PrepareForTest(YahooFinanceHandler.class)
	public void testGetFinancialDataNoDataForTicker() throws Exception {
		YahooFinanceHandler handlerSpy = PowerMockito.spy(new YahooFinanceHandler());

		// return an empty string from url call
		when(handlerSpy, method(YahooFinanceHandler.class, "getDataFromURL", String.class)).withArguments(anyString())
				.thenReturn("\"GOOG\",N/A,N/A");
		List<String> tickers = new ArrayList<>();
		tickers.add("a");
		Map<String, FinancialData> result = handlerSpy.getFinancialData(tickers);
		assertTrue(result.isEmpty());
	}

	@Test
	@PrepareForTest(YahooFinanceHandler.class)
	public void testGetFinancialData() throws Exception {
		YahooFinanceHandler handlerSpy = PowerMockito.spy(new YahooFinanceHandler());

		// return an empty string from url call
		when(handlerSpy, method(YahooFinanceHandler.class, "getDataFromURL", String.class)).withArguments(anyString())
				.thenReturn("\"GOOG\",4.5,4.5,4.5");
		when(handlerSpy, method(YahooFinanceHandler.class, "getAllHistoricalData", String.class))
				.withArguments(anyString()).thenReturn(new TreeSet<HistoricalFinancialData>());
		List<String> tickers = new ArrayList<>();
		tickers.add("GOOG");
		Map<String, FinancialData> result = handlerSpy.getFinancialData(tickers);
		assertEquals(1, result.size());
		FinancialData expected = FinancialData.builder().ask((float) 4.5).bid((float) 4.5)
				.historicalData(new TreeSet<>()).lastSale((float) 4.5).ticker("GOOG").build();
		assertEquals(expected, result.get("GOOG"));
	}

	@Test(expected = IllegalArgumentException.class)
	public void testGetFinancialDataNull() {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		handler.getFinancialData(null);
	}

	@Test(expected = IllegalArgumentException.class)
	public void testGetFinancialDataEmpty() {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		handler.getFinancialData(new ArrayList<>());
	}

	@Test
	public void testTrimString() throws Exception {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		String trimmed = Whitebox.invokeMethod(handler, "trim", "\"A\"");
		assertEquals("A", trimmed);
	}

	@Test
	@PrepareForTest(YahooFinanceHandler.class)
	public void testGetAllHistoricalDataNoNulls() throws Exception {
		YahooFinanceHandler handlerSpy = PowerMockito.spy(new YahooFinanceHandler());
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		HistoricalFinancialDataBuilder bldr = HistoricalFinancialData.builder();
		HistoricalFinancialData hfd1 = bldr.adjClose(1).date(cal.getTime()).close(1).open(1).volume(1).build();
		cal.add(Calendar.YEAR, -1);
		HistoricalFinancialData hfd2 = bldr.adjClose(2).date(cal.getTime()).close(2).open(2).volume(2).build();
		cal.add(Calendar.YEAR, -1);
		HistoricalFinancialData hfd3 = bldr.adjClose(3).date(cal.getTime()).close(3).open(3).volume(3).build();
		cal.add(Calendar.YEAR, -1);
		HistoricalFinancialData hfd4 = bldr.adjClose(4).date(cal.getTime()).close(4).open(4).volume(4).build();
		cal.add(Calendar.YEAR, -1);
		HistoricalFinancialData hfd5 = bldr.adjClose(5).date(cal.getTime()).close(5).open(5).volume(5).build();

		when(handlerSpy, method(YahooFinanceHandler.class, "createHistoricalFinancialData", String.class, int.class))
				.withArguments(anyString(), anyInt()).thenReturn(hfd1, hfd2, hfd3, hfd4, hfd5);

		NavigableSet<HistoricalFinancialData> hfdSet = Whitebox.invokeMethod(handlerSpy, "getAllHistoricalData",
				"GOOG");
		assertEquals(hfd1, hfdSet.first());
		assertEquals(hfd5, hfdSet.last());
		assertEquals(5, hfdSet.size());
	}

	@Test
	@PrepareForTest(YahooFinanceHandler.class)
	public void testGetAllHistoricalDataNulls() throws Exception {
		YahooFinanceHandler handlerSpy = PowerMockito.spy(new YahooFinanceHandler());
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		HistoricalFinancialDataBuilder bldr = HistoricalFinancialData.builder();
		HistoricalFinancialData hfd1 = bldr.adjClose(1).date(cal.getTime()).close(1).open(1).volume(1).build();
		cal.add(Calendar.YEAR, -1);
		HistoricalFinancialData hfd2 = bldr.adjClose(2).date(cal.getTime()).close(2).open(2).volume(2).build();
		cal.add(Calendar.YEAR, -1);
		HistoricalFinancialData hfd3 = bldr.adjClose(3).date(cal.getTime()).close(3).open(3).volume(3).build();
		cal.add(Calendar.YEAR, -1);
		HistoricalFinancialData hfd5 = bldr.adjClose(5).date(cal.getTime()).close(5).open(5).volume(5).build();

		when(handlerSpy, method(YahooFinanceHandler.class, "createHistoricalFinancialData", String.class, int.class))
				.withArguments(anyString(), anyInt()).thenReturn(hfd1, hfd2, hfd3, null, hfd5);

		NavigableSet<HistoricalFinancialData> hfdSet = Whitebox.invokeMethod(handlerSpy, "getAllHistoricalData",
				"GOOG");
		assertEquals(hfd1, hfdSet.first());
		assertEquals(hfd5, hfdSet.last());
		assertEquals(4, hfdSet.size());
	}

	@Test
	public void testBuildHFDNullEmptyData() throws Exception {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		assertNull(Whitebox.invokeMethod(handler, "buildHFD", new Date(), null));
		assertNull(Whitebox.invokeMethod(handler, "buildHFD", new Date(), ""));
	}

	@Test
	public void testBuildHFDNoData() throws Exception {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		assertNull(Whitebox.invokeMethod(handler, "buildHFD", new Date(), "Date,Open,High,Low,Close,Volume,Adj Close"));
	}

	@Test
	public void testBuildHFDData() throws Exception {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		Date d = new Date();
		HistoricalFinancialData data = Whitebox.invokeMethod(handler, "buildHFD", d,
				"Date,Open,High,Low,Close,Volume,Adj Close\n"
						+ "2016-10-27,801.00,803.48999,791.50,795.349976,2568500,795.349976");
		HistoricalFinancialData expected = HistoricalFinancialData.builder().adjClose((float) 795.349976)
				.open((float) 801.00).close((float) 795.349976).date(d).volume(2568500).build();
		assertEquals(expected, data);
	}

	@Test
	public void testGetDataFromURLValid() throws Exception {
		YahooFinanceHandler handler = new YahooFinanceHandler();

		String expected = "Date,Open,High,Low,Close,Volume,Adj Close\n2016-10-25,816.679993,816.679993,805.140015,807.669983,1576400,807.669983\n";
		String url = "http://ichart.finance.yahoo.com/table.csv?s=GOOG&a=9&b=25&c=2016&d=9&e=25&f=2016&g=d&ignore=.csv";
		String data = Whitebox.invokeMethod(handler, "getDataFromURL", url);
		assertEquals(expected, data);
	}

	@Test
	public void testGetDataFromURL404() throws Exception {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		// TSLA not available for 2004
		String url = "http://ichart.finance.yahoo.com/table.csv?s=TSLA&a=01&b=19&c=2004&d=01&e=19&f=2004&g=d&ignore=.csv";
		String data = Whitebox.invokeMethod(handler, "getDataFromURL", url);
		assertEquals("", data);
	}

	@Test
	public void testGetDataFromURLException() throws Exception {
		YahooFinanceHandler handler = new YahooFinanceHandler();
		String url = "Bad url asdff";
		String data = Whitebox.invokeMethod(handler, "getDataFromURL", url);
		assertEquals("", data);
	}

}
