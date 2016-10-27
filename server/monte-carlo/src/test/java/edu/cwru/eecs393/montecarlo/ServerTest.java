package edu.cwru.eecs393.montecarlo;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;

import java.io.FileNotFoundException;
import java.io.IOException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import spark.Spark;

@RunWith(PowerMockRunner.class)
@PrepareForTest(spark.Spark.class)
public class ServerTest {

	@Test
	public void testServerSetup() throws SecurityException, FileNotFoundException, IOException {
		PowerMockito.mockStatic(Spark.class);

		Server.main(new String[] {});

		PowerMockito.verifyStatic();
		Spark.post(eq("/simulation"), any());
	}

}
