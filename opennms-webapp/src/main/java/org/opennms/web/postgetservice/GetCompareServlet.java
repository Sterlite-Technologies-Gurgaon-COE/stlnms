package org.opennms.web.postgetservice;

import org.apache.http.HttpEntity;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;


import java.text.SimpleDateFormat;
import java.util.Date;


public class GetCompareServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String nodeIdStr = request.getParameter("node");

        int nodeId = Integer.parseInt(nodeIdStr);
        System.out.println("dhimanti chauhan");
        System.out.println(nodeId);

        // Set response content type
        response.setContentType("text/html");

        
        String apiUrl = "http://localhost:8080/api/fetchAvailableBackupDates";
        System.out.println(apiUrl);

        try {
            // Create the HTTP Client
            HttpClient httpClient = HttpClients.createDefault();

            // Create the HTTP GET request
            HttpGet httpGet = new HttpGet(apiUrl);

            // Execute the request and get the response
            HttpResponse myResponse = httpClient.execute(httpGet);

            // Handle the response
            int statusCode = myResponse.getStatusLine().getStatusCode();
            HttpEntity responseEntity = myResponse.getEntity();
            String responseBody = EntityUtils.toString(responseEntity);

            // Don't forget to close the response entity to release resources
            EntityUtils.consume(responseEntity);

            ObjectMapper objectMapper = new ObjectMapper();
            System.out.println("dhimanti 1");

            JsonNode jsonNode = objectMapper.readTree(responseBody);
            System.out.println("dhimanti 2");
            System.out.println(responseBody);
            System.out.println(statusCode);


            List<Map<String, String>> rowDataList = new ArrayList<>();

            for (JsonNode node : jsonNode) {
                Map<String, String> rowDataMap = new HashMap<>();
                System.out.println("dhimanti 3");


                String timestampString = node.get("timestamp").asText();
                SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                System.out.println("dhimanti 41");
                
                Date date = inputFormat.parse(timestampString);
                String formattedDate = outputFormat.format(date);
                System.out.println("dhimanti 40");

                // // Parse the timestamp and format the date
                // String timestampString = node.get("timestamp").asText();
                // Instant timestamp = Instant.parse(timestampString);
                // LocalDate date = timestamp.atZone(ZoneId.systemDefault()).toLocalDate();
                // String formattedDate = date.format(DateTimeFormatter.ISO_DATE);
                // System.out.println("dhimanti 4");

                rowDataMap.put("formattedDate", formattedDate);
                rowDataMap.put("rowId", node.get("rowId").asText());
                rowDataList.add(rowDataMap);
            }

            System.out.println("dhimanti 89");

            // Print the parsed data
            for (Map<String, String> rowData : rowDataList) {
                System.out.println("Row ID: " + rowData.get("rowId"));
                System.out.println("Formatted Date: " + rowData.get("formattedDate"));
                // System.out.println();
            }

            // Display the response in the servlet's output
            System.out.println("dhimanti 5");
            System.out.println("<h1>Response Status Code: " + statusCode + "</h1>");
            System.out.println("dhimanti 6");

            System.out.println("<p>Response Body: " + responseBody + "</p>");
            System.out.println("dhimanti 7");

            request.setAttribute("rowDataList1", rowDataList);
            List<Map<String, String>> retrievedRowDataList = (List<Map<String, String>>) request.getAttribute("rowDataList1");
            for (Map<String, String> rowData : retrievedRowDataList) {

                String rowId = rowData.get("rowId"); // Replace "rowId" with the actual key in the map
                String date = rowData.get("formattedDate"); // Replace "date" with the actual key in the map
                
                System.out.println("Row ID: " + rowId);
                System.out.println("Date: " + date);

                
                // Print other attributes as needed
            }

            request.getRequestDispatcher("/element/configuration_manage.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            System.out.println("Reached finally block in GetTemplateServlet.java");
            System.out.println("dhimanti 8");

        }
        System.out.println("dhimanti 9");

    }

}
