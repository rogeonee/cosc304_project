<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<%
//Force load SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " + e);
}
//Connection
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw";
			
	try ( Connection con = DriverManager.getConnection(url, uid, pw); ) 
	{
		// Get all customer info
		Statement s = con.createStatement();	
		ResultSet rs = s.executeQuery("SELECT * FROM customer");

		// Display all customer
		String sql = "SELECT customerId,firstName,lastName,email,phonenum,address,city,state,postalCode,country,userid FROM customer WHERE customerId = ?";
		PreparedStatement ps = con.prepareStatement(sql);

		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		
			out.println("<tr align=\"right\"><td colspan=\"4\"><table border=\"1\">" + 
						"<tr>><th>ID</th><th>First Name</th>" +
							"<th>Last Name</th><th>Email</th></tr>Phone</th><th>Address</th>"+
							"<th>City</th><th>State</th><th>Postal Code</th><th>Country</th><th>User ID</th></tr>");

							//Data loop
							while (rs.next()) {
								String custId = rs.getString("customerId");
					
								ps.setString(1, custId);
								ResultSet custInfo = ps.executeQuery();

							// Customer info loop
							while(custInfo.next()) {
								String first = custInfo.getString("firstName");
								String last = custInfo.getString("lastName");
								String mail = custInfo.getString("email");
								String phone = custInfo.getString("phonenum");
								String ad = custInfo.getString("address");
								String cit = custInfo.getString("city");
								String stat = custInfo.getString("state");
								String postal = custInfo.getString("postalCode");
								String cou = custInfo.getString("country");
								String id = custInfo.getString("userId");
								
							out.println("<tr><td>" + custId + "</td><td>" + first + "</td><td>" + last + "</td><td>" + mail +
												"</td><td>" + phone + "</td><td>" + ad + "</td><td>" + cit + "</td><td>" + stat + 
													"</td><td>" + postal + "</td><td>" + cou + "</td><td>" + id + "</td></tr>");
							}

			out.println("</table></td></tr>");
		}
		out.println("</table>");
	}
	catch (SQLException ex)
	{
		out.println("SQLException: " + ex);
	}

// Close connection
// =>  Automatic close in try
%>

</body>
</html>

