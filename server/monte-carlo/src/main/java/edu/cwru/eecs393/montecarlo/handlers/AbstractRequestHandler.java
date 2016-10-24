package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;
import java.io.StringWriter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

/**
 * Abstract base class for all implementations of {@link RequestHandler}.
 *
 * @author David
 *
 */
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
			throw new RuntimeException("IOException from a StringWriter?");
		}
	}

}
