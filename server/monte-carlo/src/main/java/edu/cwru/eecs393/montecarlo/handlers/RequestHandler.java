package edu.cwru.eecs393.montecarlo.handlers;

import spark.Request;
import spark.Response;

/**
 * Interface for handling incoming HTTP requests.
 * 
 * @author David
 *
 */
public interface RequestHandler {

	/**
	 * A method for handling HTTP requests.
	 * 
	 * @param res
	 *            The response object
	 * @param req
	 *            The request object
	 * @return A string that is the JSON response
	 */
	String handleRequest(Request req, Response res);

}
