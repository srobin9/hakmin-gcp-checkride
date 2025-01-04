<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Database Connection Check</title>
</head>
<body>
    <h1>Database Connection Test</h1>
    <%
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            Class.forName("org.postgresql.Driver");
            String dbUrl = "jdbc:postgresql://" + System.getenv("DB_PRIVATE_IP") + "/" + System.getenv("DB_NAME");
            connection = DriverManager.getConnection(dbUrl, System.getenv("DB_USER"), System.getenv("DB_PASSWORD"));
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT 1;");
            if (resultSet.next()) {
                out.println("<p style='color:green;'>Connection Successful: " + resultSet.getInt(1) + "</p>");
            } else {
                out.println("<p style='color:red;'>Connection Error: No Data</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Connection Failed: " + e.getMessage() + "</p>");
        } finally {
            try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (statement != null) statement.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>