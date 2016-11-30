/**
 *
 */
package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareOnlyThisForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import junit.framework.TestCase;
import lombok.Data;

/**
 * @author David
 *
 */
@RunWith(PowerMockRunner.class)
public class AbstractRequestHandlerTest extends TestCase {

	@Test
	public void testDataToJson() throws JsonParseException, JsonMappingException, IOException {
		List<String> list = new ArrayList<>();
		list.add("a");
		list.add("b");
		TestData data = new TestData();
		data.setName("name");
		data.setNum(1);
		data.setList(list);
		String json = AbstractRequestHandler.dataToJson(data);
		ObjectMapper mapper = new ObjectMapper();
		TestData readVersion = mapper.readValue(json, TestData.class);
		assertEquals(data, readVersion);
	}

	@PrepareOnlyThisForTest(AbstractRequestHandler.class)
	@Test(expected = IllegalStateException.class)
	public void testDataToJsonException() throws Exception {
		// Since StringWriter should never throw an IOException, mock the
		// constructor and force it to
		PowerMockito.whenNew(StringWriter.class).withNoArguments().thenThrow(new IOException());
		List<String> list = new ArrayList<>();
		list.add("a");
		list.add("b");
		TestData data = new TestData();
		data.setName("name");
		data.setNum(1);
		data.setList(list);
		AbstractRequestHandler.dataToJson(data);
	}

	@Test
	public void testIsValidTrue() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("A", 6.66);
		tickerToAllocation.put("B", 6.66);
		tickerToAllocation.put("C", 6.66);
		tickerToAllocation.put("D", 6.66);
		tickerToAllocation.put("E", 6.66);
		tickerToAllocation.put("F", 6.66);
		tickerToAllocation.put("G", 6.66);
		tickerToAllocation.put("H", 6.66);
		tickerToAllocation.put("I", 6.66);
		tickerToAllocation.put("K", 6.66);
		tickerToAllocation.put("L", 6.66);
		tickerToAllocation.put("M", 6.66);
		tickerToAllocation.put("N", 6.66);
		tickerToAllocation.put("O", 6.66);
		tickerToAllocation.put("T", 6.66);
		params.setTickerToAllocation(tickerToAllocation);
		assertTrue(AbstractRequestHandler.isValidParams(params));
	}

	@Test
	public void testIsValidOver100() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("A", 50.0);
		tickerToAllocation.put("B", 6.66);
		tickerToAllocation.put("C", 6.66);
		tickerToAllocation.put("D", 6.66);
		tickerToAllocation.put("E", 6.66);
		tickerToAllocation.put("F", 6.66);
		tickerToAllocation.put("G", 6.66);
		tickerToAllocation.put("H", 6.66);
		tickerToAllocation.put("I", 6.66);
		tickerToAllocation.put("K", 6.66);
		tickerToAllocation.put("L", 6.66);
		tickerToAllocation.put("M", 6.66);
		tickerToAllocation.put("N", 6.66);
		tickerToAllocation.put("O", 6.66);
		tickerToAllocation.put("T", 6.66);
		params.setTickerToAllocation(tickerToAllocation);
		assertFalse(AbstractRequestHandler.isValidParams(params));
	}

	@Test
	public void testIsValidUnder99() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("A", 1.0);
		tickerToAllocation.put("B", 6.66);
		tickerToAllocation.put("C", 6.66);
		tickerToAllocation.put("D", 6.66);
		tickerToAllocation.put("E", 6.66);
		tickerToAllocation.put("F", 6.66);
		tickerToAllocation.put("G", 6.66);
		tickerToAllocation.put("H", 6.66);
		tickerToAllocation.put("I", 6.66);
		tickerToAllocation.put("K", 6.66);
		tickerToAllocation.put("L", 6.66);
		tickerToAllocation.put("M", 6.66);
		tickerToAllocation.put("N", 6.66);
		tickerToAllocation.put("O", 6.66);
		tickerToAllocation.put("T", 6.66);
		params.setTickerToAllocation(tickerToAllocation);
		assertFalse(AbstractRequestHandler.isValidParams(params));
	}

	@Test
	public void testIsValidEmptyMap() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		params.setTickerToAllocation(tickerToAllocation);
		assertFalse(AbstractRequestHandler.isValidParams(params));

		params.setTickerToAllocation(null);
		assertFalse(AbstractRequestHandler.isValidParams(params));
	}

	@Test
	public void testIsValidLessThan15() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("A", 25.0);
		tickerToAllocation.put("B", 25.0);
		tickerToAllocation.put("C", 25.0);
		tickerToAllocation.put("D", 25.0);
		params.setTickerToAllocation(tickerToAllocation);
		assertFalse(AbstractRequestHandler.isValidParams(params));
	}

	@Test
	public void testIsValidZeros() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(0);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("A", 6.66);
		tickerToAllocation.put("B", 6.66);
		tickerToAllocation.put("C", 6.66);
		tickerToAllocation.put("D", 6.66);
		tickerToAllocation.put("E", 6.66);
		tickerToAllocation.put("F", 6.66);
		tickerToAllocation.put("G", 6.66);
		tickerToAllocation.put("H", 6.66);
		tickerToAllocation.put("I", 6.66);
		tickerToAllocation.put("K", 6.66);
		tickerToAllocation.put("L", 6.66);
		tickerToAllocation.put("M", 6.66);
		tickerToAllocation.put("N", 6.66);
		tickerToAllocation.put("O", 6.66);
		tickerToAllocation.put("T", 6.66);
		params.setTickerToAllocation(tickerToAllocation);

		assertFalse(AbstractRequestHandler.isValidParams(params));

		params.setGoalMoney(200);
		params.setStartingMoney(0);

		assertFalse(AbstractRequestHandler.isValidParams(params));

		params.setStartingMoney(100);
		params.setYears(0);

		assertFalse(AbstractRequestHandler.isValidParams(params));
	}

	@Data
	public static class TestData {
		private String name;
		private int num;
		private List<String> list;
	}

}
