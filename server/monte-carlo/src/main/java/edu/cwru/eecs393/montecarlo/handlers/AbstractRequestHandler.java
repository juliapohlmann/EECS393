package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;
import java.io.StringWriter;
import java.util.logging.Level;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import edu.cwru.eecs393.montecarlo.data.SimulationParameters;
import lombok.extern.java.Log;

/**
 * Abstract base class for all implementations of {@link RequestHandler}.
 *
 * @author David
 *
 */
@Log
public abstract class AbstractRequestHandler implements RequestHandler {

	/**
	 * Default HTTP code for bad requests.
	 */
	protected static final int HTTP_BAD_REQUEST = 400;

	/**
	 * Default HTTP code for good requests.
	 */
	protected static final int HTTP_OK = 200;

	/**
	 * A utility method for converting an object to JSON
	 *
	 * @param data
	 *            the object to be used as input
	 * @return the String in JSON format
	 */
	public static String dataToJson(Object data) {
		try {
			ObjectMapper mapper = new ObjectMapper();
			mapper.enable(SerializationFeature.INDENT_OUTPUT);
			StringWriter sw = new StringWriter();
			mapper.writeValue(sw, data);
			return sw.toString();
		} catch (IOException e) {
			// Should not be possible
			log.log(Level.SEVERE, "An IOException was thrown by a StringWriter, something is fishy.", e);
			throw new IllegalStateException("IOException from a StringWriter?");
		}
	}

	/**
	 * Checks if these params are valid for starting a simulation.
	 *
	 * @return true if the params are valid, false otherwise.
	 */
	public static boolean isValidParams(SimulationParameters params) {
		double sum = sumAllocations(params);
		return null != params.getTickerToAllocation() && params.getTickerToAllocation().size() > 14 && sum > 99
				&& sum < 101 && 0 < params.getYears() && params.getStartingMoney() != 0 && params.getGoalMoney() != 0;
	}

	private static double sumAllocations(SimulationParameters params) {
		if (null == params.getTickerToAllocation()) {
			return 0;
		} else {
			return params.getTickerToAllocation().values().stream().mapToDouble(value -> value).sum();
		}
	}

}
