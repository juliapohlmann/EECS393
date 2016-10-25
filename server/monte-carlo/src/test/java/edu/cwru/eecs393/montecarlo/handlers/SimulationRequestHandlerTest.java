package edu.cwru.eecs393.montecarlo.handlers;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.junit.Test;

import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
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

}
