package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;
import java.util.HashMap;
import java.util.logging.Level;

import com.fasterxml.jackson.databind.ObjectMapper;

import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import edu.cwru.eecs393.montecarlo.data.SimulationResult;
import lombok.extern.java.Log;
import spark.Request;
import spark.Response;

/**
 * Request handler for the simulation endpoint.
 *
 * @author David
 *
 */
@Log
public class SimulationRequestHandler extends AbstractRequestHandler {

	@Override
	public String handleRequest(Request req, Response res) {
		log.log(Level.INFO, "Received simulation request.");
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
			return dataToJson(new SimulationResult(0, 0, 0, new HashMap<>()));
		} catch (IOException jpe) {
			log.log(Level.WARNING, "Exception occurred while handing simulation request.", jpe);
			res.status(HTTP_BAD_REQUEST);
			return "";
		}
	}

}
