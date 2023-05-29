package org.opennms.web.rfms;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class rfmsApiScheduler {
    public void myTask () {
        System.out.println("Executing task...");
        String url = "jdbc:postgresql://localhost:5444/postgres";
        String username = "postgres";
        String password = "root";
        Connection conn = null;

        try {
            conn = DriverManager.getConnection(url, username, password);
            Statement crtStmt = conn.createStatement();
            String getName = getAlphaNumericString(11);
            String sqlStatement = "INSERT INTO public.sample values (" + getName + ");";
            crtStmt.executeUpdate(sqlStatement);
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    static String getAlphaNumericString(int n)
    {
        // choose a Character random from this String
        String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789" + "abcdefghijklmnopqrstuvxyz";
        
        // create StringBuffer size of AlphaNumericString
        StringBuilder sb = new StringBuilder(n);
        
        for (int i = 0; i < n; i++) 
        {
            // generate a random number between
            // 0 to AlphaNumericString variable length
            int index
                = (int)(AlphaNumericString.length()
                * Math.random());
            
            // add Character one by one in end of sb
            sb.append(AlphaNumericString
                .charAt(index));
        }

    return sb.toString();
    }   
}