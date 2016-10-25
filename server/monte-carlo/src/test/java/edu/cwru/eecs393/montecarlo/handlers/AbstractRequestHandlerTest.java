/**
 *
 */
package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

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

	@Test
	public void testIsValidTrue() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(1000);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("T", 100.0);
		params.setTickerToAllocation(tickerToAllocation);
		assertTrue(AbstractRequestHandler.isValidParams(params));
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
	public void testIsValidZeros() {
		SimulationParameters params = new SimulationParameters();
		params.setGoalMoney(0);
		params.setStartingMoney(10);
		params.setYears(5);
		Map<String, Double> tickerToAllocation = new HashMap<>();
		tickerToAllocation.put("T", 100.0);
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
