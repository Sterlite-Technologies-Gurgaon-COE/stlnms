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

public class GetTemplateServlet extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

            String nodeIdStr = request.getParameter("node");

            int nodeId = Integer.parseInt(nodeIdStr);
            System.out.println("dhimanti chauhan");
            System.out.println(nodeId);
            
            // Set response content type
            response.setContentType("text/html");

            // Actual logic goes here.
            // PrintWriter out = response.getWriter();

            // Replace with the actual API URL
            String apiUrl = "http://localhost:8080/api/fetchTemplatesByNodeId/" + nodeId; 
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


                List<Map<String, String>> templateList = new ArrayList<>();
                System.out.println("dhimanti 3");

                for (JsonNode node : jsonNode) {
                    Map<String, String> templateMap = new HashMap<>();
                    templateMap.put("templateDescription", node.get("templateDescription").asText());
                    templateMap.put("template", node.get("template").asText());
                    templateList.add(templateMap);
                }

                for (Map<String, String> template : templateList) {
                    System.out.println("Template Description: " + template.get("templateDescription"));
                    System.out.println("dhimanti 4");
                    System.out.println("Template: " + template.get("template"));
                }



                // Display the response in the servlet's output
                System.out.println("dhimanti 5");
                System.out.println("<h1>Response Status Code: " + statusCode + "</h1>");
                System.out.println("dhimanti 6");

                System.out.println("<p>Response Body: " + responseBody + "</p>");
                System.out.println("dhimanti 7");

                request.setAttribute("templateList", templateList);
                request.getRequestDispatcher("/element/templateList.jsp").forward(request, response);

                
            } catch (Exception e) {
                e.printStackTrace();
            }          
            finally {
                System.out.println("Reached finally block in GetTemplateServlet.java");
                System.out.println("dhimanti8");

            }
        System.out.println("dhimanti9");

        }

    }
