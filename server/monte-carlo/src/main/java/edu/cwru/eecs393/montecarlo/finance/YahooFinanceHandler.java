package edu.cwru.eecs393.montecarlo.finance;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.NavigableSet;
import java.util.Scanner;
import java.util.TreeSet;
import java.util.logging.Level;

import edu.cwru.eecs393.montecarlo.data.FinancialData;
import edu.cwru.eecs393.montecarlo.data.FinancialData.FinancialDataBuilder;
import edu.cwru.eecs393.montecarlo.data.HistoricalFinancialData;
import edu.cwru.eecs393.montecarlo.data.HistoricalFinancialData.HistoricalFinancialDataBuilder;
import lombok.extern.java.Log;

/**
 * An implementation of {@link FinanceHandler} specifically for the Yahoo!
 * Finance API.
 *
 * @author David
 *
 */
@Log
public class YahooFinanceHandler implements FinanceHandler {

	@Override
	public Map<String, FinancialData> getFinancialData(List<String> tickers) {
		if (tickers.isEmpty()) {
			log.log(Level.SEVERE, "Received an empty list of tickers.");
			throw new IllegalArgumentException("List of tickers must not be empty.");
		}
		Map<String, FinancialData> results = new HashMap<>();
		String url = YahooURLCreator.formatRealTimeURL(tickers);
		String data = getDataFromURL(url);
		Scanner scanner = new Scanner(data);
		FinancialDataBuilder bldr = FinancialData.builder();
		while (scanner.hasNextLine()) {
			String line = scanner.nextLine();
			if (line.contains("N/A")) {
				continue;
			}
			String[] values = line.split(",");
			String ticker = trim(values[0]);
			log.log(Level.INFO, "Working on: " + ticker);
			bldr.ticker(ticker);
			bldr.ask(Float.parseFloat(values[1]));
			bldr.bid(Float.parseFloat(values[2]));
			bldr.lastSale(Float.parseFloat(values[3]));
			bldr.historicalData(getHistoricalData(ticker));
			FinancialData financialData = bldr.build();
			results.put(ticker, financialData);
		}
		scanner.close();
		return results;
	}

	private String trim(String string) {
		return string.substring(1, string.length() - 1);
	}

	private NavigableSet<HistoricalFinancialData> getHistoricalData(String ticker) {
		NavigableSet<HistoricalFinancialData> results = new TreeSet<>((o1, o2) -> o1.getDate().compareTo(o2.getDate()));
		for (int i = 1; i <= 5; i++) {
			HistoricalFinancialData hist = createHistoricalFinancialData(ticker, i);
			if (null != hist) {
				results.add(hist);
			}
		}
		return results;
	}

	private HistoricalFinancialData createHistoricalFinancialData(String ticker, int yearsAgo) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.YEAR, -1 * yearsAgo);
		String url = YahooURLCreator.formatHistoricalURL(ticker, cal.getTime());
		String data = getDataFromURL(url);
		return buildHFD(cal.getTime(), data);
	}

	private HistoricalFinancialData buildHFD(Date time, String data) {
		if (null == data || data.isEmpty()) {
			return null;
		}
		Scanner scanner = new Scanner(data);
		String[] headers = scanner.nextLine().split(",");
		if (scanner.hasNextLine()) {
			String[] values = scanner.nextLine().split(",");
			scanner.close();
			return buildFromCSV(values, headers, time);
		} else {
			scanner.close();
			return null;
		}
	}

	private HistoricalFinancialData buildFromCSV(String[] values, String[] headers, Date time) {
		HistoricalFinancialDataBuilder bldr = HistoricalFinancialData.builder();
		bldr.date(time);
		for (int i = 0; i < headers.length; i++) {
			switch (headers[i]) {
			case "Open":
				bldr.open(Float.parseFloat(values[i]));
				break;

			case "Close":
				bldr.close(Float.parseFloat(values[i]));
				break;

			case "Volume":
				bldr.volume(Integer.parseInt(values[i]));
				break;

			case "Adj Close":
				bldr.adjClose(Float.parseFloat(values[i]));
				break;

			default:
				log.log(Level.INFO, "Received un used historical header: " + headers[i]);
				break;
			}
		}
		return bldr.build();
	}

	private String getDataFromURL(String urlToRead) {
		try {
			StringBuilder result = new StringBuilder();
			URL url = new URL(urlToRead);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			String line;
			while ((line = rd.readLine()) != null) {
				result.append(line + "\n");
			}
			rd.close();
			String data = result.toString();
			if (data.contains("404 Not Found")) {
				return "";
			} else {
				return data;
			}
		} catch (Exception e) {
			log.log(Level.SEVERE, "Exception occurred while getting historical data.", e);
			return "";
		}
	}

}
