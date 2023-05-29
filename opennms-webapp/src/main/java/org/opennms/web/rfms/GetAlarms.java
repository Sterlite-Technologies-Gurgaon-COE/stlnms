package org.opennms.web.rfms;

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import org.opennms.web.rfms.alarms.ResponseAlarms;

import java.sql.SQLException;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class GetAlarms {
    private static final Logger log = LoggerFactory.getLogger(GetAlarms.class);    
    
	private static final GetAccessToken getToken = new GetAccessToken();
    String bearerToken = getToken.fetchToken();

    public void fetchAlarms() throws SQLException, JSONException {
        String alarmURI = "https://alarm.demo.novafiber-fms.com/v1/alarms?$top=10&$filter=alarmState/state eq 'new' and severity eq 'critical'";

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set("Content-Type", "application/json");
        
        // verify why this is required
        headers.add("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X)");
        headers.add("Authorization", "Bearer " + bearerToken);

        ResponseEntity<List> response = restTemplate.exchange(
                    alarmURI,
                    HttpMethod.GET,
                    new HttpEntity<>("parameters", headers),
                    List.class
                    // ResponseAlarms.class
                    );

        JSONObject alarmResponse = new JSONObject(response);
        JSONArray body = alarmResponse.getJSONArray("body");
        // System.out.println("Body is " + body);

        for (int i = 0; i < body.length(); i++) {
            JSONObject alarm = body.getJSONObject(i);
            saveAlarm(alarm);
        }
    }

    void saveAlarm(JSONObject alarm) throws SQLException, JSONException {
        ResponseAlarms placeHolder = new ResponseAlarms();
    
        String alarmId = alarm.getString("_id");
        // System.out.println("Got alarmID as "+ alarmId);
    
        if (placeHolder.checkAlarmExistsDB(alarmId)) {
            // set the _id parameter 
            placeHolder.setId(alarm.getString("_id"));
            // set initialEventTime
            placeHolder.setInitialEventTime(alarm.getString("initialEventTime"));
            // set maxFaultPosition
            placeHolder.setMaxFaultPosition(alarm.getString("maxFaultPosition"));
            // set minFaultPosition
            placeHolder.setMinFaultPosition(alarm.getString("minFaultPosition"));
            // set Position
            placeHolder.setPosition(alarm.getString("position"));
            // set alarmSummary
            placeHolder.setAlarmSummary(alarm.getString("alarmSummary"));
            // set ProbableCause
            placeHolder.setProbableCause(alarm.getString("probableCause"));
            // set Severity
            placeHolder.setSeverity(alarm.getString("severity"));

            JSONArray sources = alarm.getJSONArray("sources");
            // iterate across all fibers in sources JSON Array
            for (int i=0; i < sources.length(); i++) 
            {
                JSONObject singleFiber = sources.getJSONObject(i);
                JSONObject sourceDetailData = singleFiber.getJSONObject("sourceDetailData");
                JSONObject contextData = singleFiber.getJSONObject("contextData");

                // System.out.println("hasFault value obtained as " + sourceDetailData.getBoolean("hasFault"));
                // System.out.println("measurementId value obtained as " + sourceDetailData.getString("measurementId"));
                
                if ((sourceDetailData.getBoolean("hasFault")) && placeHolder.checkMeasurementId(sourceDetailData.getString("measurementId")))
                {
                    log.info("There is an alarm with notfication id {} and rtuId {}", alarm.getString("_id"), contextData.getString("rtuId"));
                    placeHolder.setRtuId(contextData.getString("rtuId"));
                    placeHolder.setRtuName(contextData.getString("rtuName"));
                    placeHolder.setRtuSiteName(contextData.getString("rtuSiteName"));
                    placeHolder.setMeasurementId(sourceDetailData.getString("measurementId"));
                    
                    // save to DB
                    placeHolder.saveToDB();
                }
                else {
                    log.info("Alarm measurementID already exists!!");
                }
            }
        }
        else {
            log.info("AlarmID already exists in Database");
            return;
        }
    }
}