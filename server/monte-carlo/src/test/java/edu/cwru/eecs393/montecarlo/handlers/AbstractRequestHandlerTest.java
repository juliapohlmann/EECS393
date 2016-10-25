/**
 *
 */
package edu.cwru.eecs393.montecarlo.handlers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import junit.framework.TestCase;
import lombok.Data;

/**
 * @author David
 *
 */
public class AbstractRequestHandlerTest extends TestCase {

	@Test
	public void testDataToJson() throws JsonParseException, JsonMappingException, IOException {
		List<String> list = new ArrayList<>();
		list.add("a");
		list.add("b");
		TestData data = new TestData();
		data.setName("name");
		data.setNum(1);
		data.setList(list);
		String json = AbstractRequestHandler.dataToJson(data);
		ObjectMapper mapper = new ObjectMapper();
		TestData readVersion = mapper.readValue(json, TestData.class);
		assertEquals(data, readVersion);
	}

	@Data
	public static class TestData {
		private String name;
		private int num;
		private List<String> list;
	}

}
