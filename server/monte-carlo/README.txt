Dev Dependencies:
	Maven version 3.3.9 (may work with others, only tested on this):
		$ sudo apt-get install maven
	Java1.8:
		$ sudo add-apt-repository ppa:webupd8team/java
		$ sudo apt-get update
		$ sudo apt-get install oracle-java8-installer
	Lombok:
		You will need to configure your IDE to work with Lombok, see https://projectlombok.org/index.html
		
Production Dependencies:
	1. Java1.8
	2. Open port: 4567
	3. Compiled .jar file must be run in same directory as folder titles logs/ containing a `logging.properties` file.


Running The Server:

	To run the pre-compiled server program, navigate to the folder containing `monte-carlo-1.0-jar-with-dependencies.jar`
	and execute the following command:
	
		$ java -cp monte-carlo-1.0-jar-with-dependencies.jar edu.cwru.eecs393.montecarlo.Server
		
	Note: this does not run a server that the app will be able to communicate with. That server is running at 
	acm-people.case.edu:4567 which can only be reached when on the Case Wireless network.

Development Commands

	To run the server in development mode, execute the command:
		$ mvn compile && mvn exec:java
	Note: this does not run a server that the app will be able to communicate with. That server
	is running at acm-people.case.edu:4567 which can only be reached when on the Case Wireless network.
	
	To run tests and code coverage, execute the command:
		$ mvn clean package
	This will place code coverage results in the directory ${basedir}/target/site/jacoco, just open the file
	`index.html` in a web browser.

	To generate Javadoc comments as navigable HTML files, use the command:
		$ mvn javadoc:javadoc
	This will place the resulting docs in the director ${basedir}/target/site/apidocs, just
	open the file index.html in a web browser.

	To create a runnable jar for the server, execute the command:
		$ mvn clean compile assembly:single
	This will place a jar in the target/ directory. The jar will be called `monte-carlo-1.0-jar-with-dependencies.jar`
	To run the jar can be run from the command line, it must be in the same directory as the logs/ folder. Then execute
	the command listed above.
	
Server Information:

	The default port is 4567. When running locally, visiting localhost:4567/hello will display a hello world message. 
	Executing a POST to /simulation with valid JSON body will result in	a simulation being run and its results returned.
	
	The request schema is:
	{
		"title": "Request Schema",
		"type": "object",
		"properties": {
			"tickerToAllocation": {
				"type": "object",
				"additionalProperties": {
					"type": "double"
				}
			},
			"years": {
				"type": "integer",
				"minimum": 1,
				"maximum": 100
			},
			"startingMoney": {
				"type": "integer",
				"minimum": 1
			},
			"goalMoney": {
				"type": "integer",
				"minimum": 3
			}
		},
		"required": ["tickerToAllocation", "years", "startingMoney", "goalMoney"]
	}
	Note: The "goalMoney" field must be greater than "startingMoney". The number of additional properties on "tickerToAllocation"
	must be between between 15 and 100, with the double values summing to 100.

	The response schema is:
	{
		"title": "Response Schema",
		"type": "object",
		"properties": {
			"maxValue": {
				"type": "double",
				"minimum": 0
			},
			"minValue": {
				"type": "double",
				"minimum": 0
			},
			"percentGoalReached": {
				"type" "double",
				"minimum": 0,
				"maximum": 100
			},
			"valueToPercent": {
				"type": "object",
				"additionalProperties": {
					"type": "double",
					"minimum": 0,
					"maximum": 100
				}
			}
		},
		"required": ["maxValue", "minValue", "percentGoalReached", "valueToPercent"]
	}
	Note: The "valueToPercent" object will consist of 10 additional properties that have a name consisting of a stringified double. These
	will be the 10 splits between "minValue" and "maxValue".

The major libraries that our code uses are:
	Spark (Web framework): 
		http://sparkjava.com/
	Lombok (Quality of life annotations): 
		https://projectlombok.org/
	Jackson (JSON parsing): 
		http://wiki.fasterxml.com/JacksonHome
	Yahoo! Finance API: 
		All calls made by code written by us, but the base URLs are 
		http://ichart.finance.yahoo.com/table.csv and 
		http://download.finance.yahoo.com/d/quotes.csv
	Mockito (Mocking library for testing):
		http://site.mockito.org/
	PowerMock (Extension of Mockito for working with private and static members):
		https://github.com/jayway/powermock
		
	The remainder of the code in this repository uses built in Java1.8 libraries.