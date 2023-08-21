package org.opennms.web.postgetservice;

import org.apache.http.HttpEntity;
import org.apache.http.HttpHeaders;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONObject;
import javax.servlet.RequestDispatcher;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.*;

public class PostTemplateServlet extends HttpServlet {
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String parameter1 = request.getParameter("textareaContent");
        String parameter2 = request.getParameter("selectedOption");
        String parameter3 = request.getParameter("nodeId");


        System.out.println("Commands Are:" + parameter1);
        System.out.println("SSH/NETCONF:" + parameter2);
        System.out.println("For Node Id:" + parameter3);

  
        response.setContentType("text/html");

        String apiUrl = "http://localhost:8080/api/runCommand";

        try {
            JSONObject jsonObject = new JSONObject();
            if(parameter2.equals("SSH")){
                String[] items = parameter1.split(",");
                List<String> itemList = Arrays.asList(items);
                System.out.println(itemList);

                jsonObject.put("nodeId", parameter3);
                jsonObject.put("preference", "ssh");
                jsonObject.put("sshCommands", itemList);

            }
            else{
                jsonObject.put("nodeId", parameter3);
                jsonObject.put("preference", "netconf");
                jsonObject.put("ncfCommands", parameter1);

            }
            System.out.println(jsonObject);

            System.out.println("Dhimanti");

            String jsonData = jsonObject.toJSONString();
            System.out.println(jsonData);
            HttpClient httpClient = HttpClients.createDefault();

            HttpPost httpPost = new HttpPost(apiUrl);
            httpPost.setHeader(HttpHeaders.CONTENT_TYPE, ContentType.APPLICATION_JSON.getMimeType());

            StringEntity requestEntity = new StringEntity(jsonData, ContentType.APPLICATION_JSON);
            httpPost.setEntity(requestEntity);

            HttpResponse myResponse = httpClient.execute(httpPost);

            int statusCode = myResponse.getStatusLine().getStatusCode();
            HttpEntity responseEntity = myResponse.getEntity();
            String responseBody = EntityUtils.toString(responseEntity);

            EntityUtils.consume(responseEntity);

            System.out.println("dhimanti 5");
                System.out.println("<h1>Response Status Code: " + statusCode + "</h1>");
                System.out.println("dhimanti 6");

                System.out.println("<p>Response Body: " + responseBody + "</p>");
                System.out.println("dhimanti 7");


            response.getWriter().write("Status Code: " + statusCode + "</br>");
            response.getWriter().write("Response Body: " + responseBody);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR is : "+ e.toString());
            response.getWriter().write("An error occurred.");
        } 
        finally {
            System.out.println("Reached finally block in PostTemplateServlet.java");
        }
    }
}