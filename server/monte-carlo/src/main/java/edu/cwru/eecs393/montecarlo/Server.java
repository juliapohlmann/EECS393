package edu.cwru.eecs393.montecarlo;

import static spark.Spark.get;
import static spark.Spark.post;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.LogManager;

import edu.cwru.eecs393.montecarlo.handlers.RequestHandler;
import edu.cwru.eecs393.montecarlo.handlers.SimulationRequestHandler;
import lombok.extern.java.Log;

/**
 * Entry point for the web server. Configures all Spark end points.
 *
 * @author David
 *
 */
@Log
public class Server {

	private static final RequestHandler simulationHandler = new SimulationRequestHandler();

	public static void main(String[] args) throws SecurityException, FileNotFoundException, IOException {
		LogManager.getLogManager().readConfiguration(new FileInputStream("logs/logging.properties"));
		log.log(Level.INFO, "Initializing routes.");
		get("/hello", (req, res) -> "Hello World");
		post("/simulation", (req, res) -> simulationHandler.handleRequest(req, res));

	}

}
