/**
 *
 */
package edu.cwru.eecs393.montecarlo.handlers;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import junit.framework.TestCase;
import lombok.Data;

/**
 * @author David
 *
 */
public class AbstractRequestHandlerTest extends TestCase {

	@Test
	public void testDataToJson() {
		List<String> list = new ArrayList<>();
		list.add("a");
		list.add("b");
		TestData data = new TestData("name", 1, list);
		String json = AbstractRequestHandler.dataToJson(data);
		String expected = "{\r\n  \"name\" : \"name\",\r\n  \"num\" : 1,\r\n  \"list\" : [ \"a\", \"b\" ]\r\n}";
		assertEquals(expected, json);
	}

	@Data
	private class TestData {
		private final String name;
		private final int num;
		private final List<String> list;
	}

}
