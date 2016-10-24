package edu.cwru.eecs393.montecarlo;

import static spark.Spark.*;

public class Server {

	public static void main(String[] args) {
		get("/hello", (req, res) -> "Hello World");
	}

}
