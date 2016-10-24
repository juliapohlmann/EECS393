package edu.cwru.eecs393.montecarlo;

import static spark.Spark.get;
import static spark.Spark.post;

import edu.cwru.eecs393.montecarlo.handlers.RequestHandler;

/**
 * Entry point for the web server. Configures all Spark end points.
 *
 * @author David
 *
 */
public class Server {

	private static final RequestHandler simulationHandler = null;

	public static void main(String[] args) {
		get("/hello", (req, res) -> "Hello World");
		post("/simulation", (req, res) -> simulationHandler.handleRequest(req, res));

	}

}
