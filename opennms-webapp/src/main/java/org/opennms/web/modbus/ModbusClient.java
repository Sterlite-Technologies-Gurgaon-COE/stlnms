package org.opennms.web.modbus;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.wimpi.modbus.io.ModbusTCPTransaction;
import net.wimpi.modbus.msg.ReadMultipleRegistersRequest;
import net.wimpi.modbus.msg.ReadMultipleRegistersResponse;
import net.wimpi.modbus.net.TCPMasterConnection;
import org.json.simple.JSONObject;
public class ModbusClient {
    private static Logger LOG = LoggerFactory.getLogger(ModbusClient.class);

    public void pollModbusDevice (String ipAddr, Integer registerStartAddr, Integer numOfRegisters, Integer devicePort) {
        try {
            // Set the device IP address and port
            InetAddress deviceAddress = InetAddress.getByName(ipAddr);
            if (devicePort == null) {
                devicePort = 502; // set to default
            }

            // Create a TCP master connection
            TCPMasterConnection connection = new TCPMasterConnection(deviceAddress);
            connection.setPort(devicePort);
            
            // Establish the connection
            connection.connect();
            LOG.debug("Connection is established to device running at {}.", ipAddr);

            // Create a Modbus TCP transaction
            ModbusTCPTransaction transaction = new ModbusTCPTransaction(connection);
            
            // Create a request to read multiple holding registers
            ReadMultipleRegistersRequest request = new ReadMultipleRegistersRequest(registerStartAddr, numOfRegisters);
            request.setUnitID(1); // Set the Modbus slave unit ID (default is 1)
            
            // Set the transaction request
            transaction.setRequest(request);
            
            // Execute the transaction
            transaction.execute();
            
            // Get the transaction response
            ReadMultipleRegistersResponse response = (ReadMultipleRegistersResponse) transaction.getResponse();
            
            // Print the register values
            if (response != null) {
                System.out.println("Register values:");
                try {
                    saveToDB(response,ipAddr);
                }
                catch (Exception e) {
                    LOG.error("error",e);
                }
            } else {
                System.out.println("No response received.");
            }

            // Close the connection
            connection.close();
        } 
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void saveToDB(ReadMultipleRegistersResponse response , String ipAddr) throws SQLException {
		// insert statement
        
        Date date = new Date();
        JSONObject jobj = new JSONObject();
		String sqlInsertIntoModbusTable = "INSERT INTO modbus values (?,?,?);";
        LOG.debug("\nEntered saveToDB");          
		try (
			Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/stlnms", "postgres", "postgres");
            
		) {
    
			if (conn != null) {
               
				PreparedStatement insertStatement = conn.prepareStatement(sqlInsertIntoModbusTable);
                // insertStatement.setInt(1, 24);
                System.out.println(new Timestamp(date.getTime()));

                insertStatement.setTimestamp(1, new Timestamp(date.getTime()));
                // for (int i = 0; i < response.getWordCount(); i++) {
                //     int registerValue = response.getRegisterValue(i);
                    // LOG.debug("->{} : {}",i,registerValue);
                    // insertStatement.setInt(i+2, registerValue);
                // }
                jobj.put("current_node",response.getRegisterValue(0));
                jobj.put("sweeptime",response.getRegisterValue(1));
                jobj.put("sweepdelay",response.getRegisterValue(2));
                jobj.put("startfreq",response.getRegisterValue(3));
                jobj.put("endfreq",response.getRegisterValue(4));
                jobj.put("currentfreq",response.getRegisterValue(5));
                LOG.debug("1--->{}",jobj.toString());
                insertStatement.setString(2,jobj.toString());
            
                insertStatement.setString(3,ipAddr);
			
				int result = insertStatement.executeUpdate();
				LOG.debug("Got result as {}", result);
				LOG.debug("Successfully entered data inside of DB.");
			}
            else{
                LOG.debug("error ,the  connection is NULL");
            }
		}
        catch (Exception e) {
                    LOG.error("error",e);
                }
	}
}