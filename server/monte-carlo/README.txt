Dependencies:
	To run the server the following must be installed:
	Maven:
		$ sudo apt-get install maven
	Java1.8:
		$ sudo add-apt-repository ppa:webupd8team/java
		$ sudo apt-get update
		$ sudo apt-get install oracle-java8-installer

To run the server, execute the command:
	$ mvn compile && mvn exec:java

The default port is 4567, visiting localhost:4567/hello will display a hello 
world message. Visiting /simulation is currently not supported.