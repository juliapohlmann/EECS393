package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;
import java.util.Map;
import java.util.logging.Level;

import com.fasterxml.jackson.databind.ObjectMapper;

import edu.cwru.eecs393.montecarlo.data.FinancialData;
import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import edu.cwru.eecs393.montecarlo.data.SimulationResult;
import edu.cwru.eecs393.montecarlo.finance.FinanceHandler;
import edu.cwru.eecs393.montecarlo.finance.YahooFinanceHandler;
import edu.cwru.eecs393.montecarlo.simulation.Simulation;
import edu.cwru.eecs393.montecarlo.simulation.SimulationBuilder;
import edu.cwru.eecs393.montecarlo.simulation.SimulationType;
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
			if (!isValidParams(params)) {
				res.status(HTTP_BAD_REQUEST);
				return "";
			}
			res.status(HTTP_OK);
			res.type("application/json");
			FinanceHandler financeHandler = new YahooFinanceHandler();
			Map<String, FinancialData> financialData = financeHandler
					.getFinancialData(params.getTickerToAllocation().keySet());
			SimulationBuilder bldr = new SimulationBuilder();
			Simulation simulation = bldr.simulationType(SimulationType.MONTE_CARLO).financialDataMap(financialData)
					.simulationParameters(params).buildSimulation();
			SimulationResult simulationResult = simulation.runSimulation();
			return dataToJson(simulationResult);
		} catch (IOException jpe) {
			log.log(Level.WARNING, "Exception occurred while handing simulation request.", jpe);
			res.status(HTTP_BAD_REQUEST);
			return "";
		}
	}

}
