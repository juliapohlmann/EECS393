Dependencies:
	To run the server the following must be installed:
	Maven:
		$ sudo apt-get install maven
	Java1.8:
		$ sudo add-apt-repository ppa:webupd8team/java
		$ sudo apt-get update
		$ sudo apt-get install oracle-java8-installer
	Lombok:
		You will need to configure your IDE to work with Lombok, see https://projectlombok.org/index.html

To run the server, execute the command:
	$ mvn compile && mvn exec:java
	
To run tests and code coverage, execute the command:
	$ mvn clean package
This will place code coverage results in the directory ${basedir}/target/site/jacoco, just
open the file index.html in a web browser.

To gererate Javadoc comments as navigable HTML files, use the command:
	$ mvn javadoc:javadoc
This will place the resulting docs in the director ${basedir}/target/site/apidocs, just
open the file index.html in a web browser.

To create a runnable jar for the server, execute the command:
	$ mvn clean compile assembly:single
This will place a jar in the target/ directory.

The default port is 4567, visiting localhost:4567/hello will display a hello 
world message. Executing a POST to /simulation with valid JSON body will result in
a result of all zeros being returned. The correct JSON format is:
{
	"tickerToAllocation" : {
		"tickerString" : double,
		...
	},
	"years" : int,
	"startingMoney" : int,
	"goalMoney" : int
}.

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