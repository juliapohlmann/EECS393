package edu.cwru.eecs393.montecarlo.handlers;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import edu.cwru.eecs393.montecarlo.data.SimulationResult;
import junit.framework.TestCase;
import spark.Request;
import spark.Response;

public class SimulationRequestHandlerTest extends TestCase {

	@Test
	public void testHandleRequestWrongInputType() {
		Request req = mock(Request.class);
		Response res = mock(Response.class);
		when(req.body()).thenReturn(AbstractRequestHandler.dataToJson(new Integer(0)));
		SimulationRequestHandler handler = new SimulationRequestHandler();
		String result = handler.handleRequest(req, res);
		assertTrue(result.isEmpty());
		verify(res).status(400);
	}

	@Test
	public void testHandleRequestInvalidParams() {
		SimulationParameters params = new SimulationParameters();
		params.setTickerToAllocation(null);
		Request req = mock(Request.class);
		Response res = mock(Response.class);
		when(req.body()).thenReturn(AbstractRequestHandler.dataToJson(params));
		SimulationRequestHandler handler = new SimulationRequestHandler();
		String result = handler.handleRequest(req, res);
		assertTrue(result.isEmpty());
		verify(res).status(400);
	}

	@Test
	public void testHandleRequestValidParams() throws JsonParseException, JsonMappingException, IOException {
		SimulationParameters params = new SimulationParameters();
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
		params.setGoalMoney(10000);
		params.setStartingMoney(100);
		params.setYears(5);
		Request req = mock(Request.class);
		Response res = mock(Response.class);
		when(req.body()).thenReturn(AbstractRequestHandler.dataToJson(params));
		SimulationRequestHandler handler = new SimulationRequestHandler();
		String result = handler.handleRequest(req, res);

		assertFalse(result.isEmpty());
		verify(res).status(200);
		// verify that a SimulationResult in JSON form was returned
		SimulationResult simResult = new ObjectMapper().readValue(result, SimulationResult.class);
		// assertNotNull(simResult);
	}

}
