package edu.cwru.eecs393.montecarlo.finance;

import static junit.framework.TestCase.assertTrue;
import static org.mockito.Matchers.anyString;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.powermock.api.support.membermodification.MemberMatcher.method;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PowerMockIgnore;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import edu.cwru.eecs393.montecarlo.data.FinancialData;

@RunWith(PowerMockRunner.class)
@PowerMockIgnore("org.jacoco.agent.rt.*")
public class YahooFinanceHandlerTest {

	// TODO Tests

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

}
