package org.opennms.web.rfms.alarms;

import java.util.Date;
import java.sql.*;

public class ResponseAlarms {
    String _id;
	// Date initialEventTime;
	String initialEventTime;
	String alarmSummary;
	// float maxFaultPosition;
	// float minFaultPosition;
    // float position;
	String maxFaultPosition;
	String minFaultPosition;
    String position;
	String severity;
	String probableCause;
	String rtuId;
	String rtuName;
	String rtuSiteName;
    String measurementId;

	public void setId(String id) {
		this._id = id;
	}

	String getId() { 
		return this._id;
	}

	public void setInitialEventTime(String initialEventTime) {
		this.initialEventTime = initialEventTime;
	}

	String getInitialEventTime() {
		return initialEventTime;
	}

	public void setAlarmSummary(String alarmSummary) {
		this.alarmSummary = alarmSummary;
	}

	String getAlarmSummary() {
		return this.alarmSummary;
	}

	public void setMaxFaultPosition(String position) {
		this.maxFaultPosition = position;
	}

	String getMaxFaultPosition() {
		return this.maxFaultPosition;
	}

	public void setMinFaultPosition(String position) {
		this.minFaultPosition = position;
	}

	String getMinFaultPosition() {
		return this.minFaultPosition;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	String getPosition() {
		return this.position;
	}

	public void setSeverity(String severity) {
		this.severity = severity;
	}

	String getSeverity() {
		return this.severity;
	}

	public void setProbableCause(String message) {
		this.probableCause = message;
	}

	String getProbableCause() {
		return this.probableCause;
	}

	public void setRtuId(String rtuId) {
		this.rtuId = rtuId;
	}

	String getRtuId() {
		return this.rtuId;
	}

	public void setRtuName(String rtuName) {
		this.rtuName = rtuName;
	}

	String getRtuName() {
		return this.rtuName;
	}

	public void setRtuSiteName(String rtuSite) {
		this.rtuSiteName = rtuSite;
	}

	String getRtuSiteName() {
		return this.rtuSiteName;
	}

	public void setMeasurementId(String measureId) {
		this.measurementId = measureId;
	}

	String getMeasurementId() {
		return this.measurementId;
	}

	public void saveToDB() throws SQLException {
		// insert statement
		String sqlInsertIntoRfmsTable = "INSERT INTO rfms values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";

		try (
			Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/opennms", "postgres", "postgres");
		) {
			if (conn != null) {
				PreparedStatement insertStatement = conn.prepareStatement(sqlInsertIntoRfmsTable);
				insertStatement.setString(1, getId());
				insertStatement.setString(2, getInitialEventTime());
				insertStatement.setString(3, getAlarmSummary());
				insertStatement.setString(4, getMaxFaultPosition());
				insertStatement.setString(5, getMinFaultPosition());
				insertStatement.setString(6, getPosition());
				insertStatement.setString(7, getSeverity());
				insertStatement.setString(8, getProbableCause());
				insertStatement.setString(9, getRtuId());
				insertStatement.setString(10, getRtuName());
				insertStatement.setString(11, getRtuSiteName());
				insertStatement.setString(12, getMeasurementId());

				int result = insertStatement.executeUpdate();
				// System.out.println("Got result as " + result);
				System.out.println("Successfully entered data inside of DB.");
				
			}

		}
	}

	public boolean checkAlarmExistsDB(String alarmID) throws SQLException {
		// check if ID exists
		String SqlCheckAlarmExists = "Select \"rtuId\" from rfms where exists(select \"rfms\" from rfms where fmsid='" + alarmID + "');";
		// System.out.println("Check statement formed as : " + SqlCheckAlarmExists);

		try (
			Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/opennms", "postgres", "postgres");
			PreparedStatement checkStatement = conn.prepareStatement(SqlCheckAlarmExists)
			){
				ResultSet result = checkStatement.executeQuery();
				
				if (result.next() == false) 
				{
					return true;
				}
				else {
					return false;
				}
			}
	}

	public boolean checkMeasurementId(String measurementId) throws SQLException {
		// check if measurementID exists
		String sqlCheckMeasurementId = "Select \"rtuId\" from rfms where exists(Select \"rtuId\" from rfms where \"measurementId\" = '" + measurementId + "');";
		// System.out.println("Check statement formed as : " + sqlCheckMeasurementId);

		try (
			Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/opennms", "postgres", "postgres");
			PreparedStatement checkStatement = conn.prepareStatement(sqlCheckMeasurementId)
			) 
			{
				ResultSet result = checkStatement.executeQuery();
				// boolean success = result.next();
				// System.out.println("Output of exist for " + measurementId + ": " + success);
				
				if (result.next() == false) 
				{
					return true;
				}
				else {
				 	return false;
				}
			}
	}
}