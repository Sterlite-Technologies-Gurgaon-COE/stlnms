package org.opennms.web.rfms;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.io.InputStreamReader;

import org.json.JSONException;
import org.json.JSONObject;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.BufferedReader;

public class GetAccessToken {
    private static final Logger log = LoggerFactory.getLogger(GetAccessToken.class);

    String fetchToken()
    {
        String url = "https://auth.demo.novafiber-fms.com/auth/realms/Fiber/protocol/openid-connect/token";
        String parameters = "client_id=fg-topologyui&username=rohit&password=ROHIT%40123&grant_type=password";
		
        URL obj;
        try {
            obj = new URL(url);
        } catch (MalformedURLException e) {
            e.printStackTrace();
            return "MalformedURLException error";
        }

        try {
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();
            con.setRequestMethod("POST");
            con.setDoOutput(true);    
            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(parameters);
            wr.flush();
            wr.close();

            System.out.println("URL : " + url);
            System.out.println("Request Method: " + con.getRequestMethod());
            System.out.println("Response Code: " + con.getResponseCode());
            System.out.println("Response Message: " + con.getResponseMessage());

            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) 
            {
                response.append(inputLine);
            }
            in.close();
            
            JSONObject jsonResponse = new JSONObject(response.toString());
        
            return jsonResponse.getString("access_token");
        } 
        catch (IOException e) {
            e.printStackTrace();
            return "IOException Error";
        } 
	}
}