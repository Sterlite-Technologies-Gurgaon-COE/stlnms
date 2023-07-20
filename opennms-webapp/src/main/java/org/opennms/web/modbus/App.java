package org.opennms.web.modbus;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.opennms.web.modbus.ModbusClient ;

public class App 
{
    // private static final String SERVER_ADDRESS = "10.100.101.245"; // Modbus device address
    // private static final int START_ADDRESS = 4000; // Starting address of the registers
    // private static final int NUM_REGISTERS = 6; // Number of registers to read
    // private static final int PORT = 8899;
    // private final static String url = "jdbc:postgresql://localhost/opennms";
    // private static final String QUERY = "select id,serve,email,country,password from Users where id =?";
    private static Logger LOG = LoggerFactory.getLogger(App.class);
    private static final String SELECT_ALL_QUERY = "select * from modbus_nodes";
    static ModbusClient mbc = new ModbusClient();

    // public void modbus_func() {
    //     mbc.pollModbusDevice(SERVER_ADDRESS,START_ADDRESS,NUM_REGISTERS,PORT);
    //     System.out.println("Modbus Client class executed successfully");
       
        
    // }

    public void modbus_ip(){
        // using try-with-resources to avoid closing resources (boiler plate
        // code)

        // Step 1: Establishing a Connection
         LOG.debug("\nEntered modbus_ip");
        try (Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost/stlnms", "postgres", "postgres");
            // Step 2:Create a statement using connection object
            PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_QUERY);) {
            // System.out.println(preparedStatement);
            // Step 3: Execute the query or update query
            LOG.debug("\nConected to DB");
            ResultSet rs = preparedStatement.executeQuery();
            // Step 4: Process the ResultSet object.    
            while (rs.next()) {
                String ip_address = rs.getString("ip_address");
                int start_address = rs.getInt("start_address");
                int num_registers = rs.getInt("num_registers");
                int port=rs.getInt("port");
                mbc.pollModbusDevice(ip_address,start_address,num_registers,port);
                System.out.println("Modbus Client class executed successfully");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}