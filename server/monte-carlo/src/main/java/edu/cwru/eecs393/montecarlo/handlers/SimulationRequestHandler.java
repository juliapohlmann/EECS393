package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;

import com.fasterxml.jackson.databind.ObjectMapper;

import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import spark.Request;
import spark.Response;

/**
 * Request handler for the simulation endpoint.
 *
 * @author David
 *
 */
public class SimulationRequestHandler extends AbstractRequestHandler {

	@Override
	public String handleRequest(Request req, Response res) {
		try {
			ObjectMapper mapper = new ObjectMapper();
			SimulationParameters params = mapper.readValue(req.body(), SimulationParameters.class);
			if (!params.isValid()) {
				res.status(HTTP_BAD_REQUEST);
				return "";
			}
			res.status(HTTP_OK);
			res.type("application/json");
			// TODO call simulation here
			return dataToJson(params);
		} catch (IOException jpe) {
			res.status(HTTP_BAD_REQUEST);
			return "";
		}
	}

}
