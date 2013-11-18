<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
String test = request.getParameter("content");
response.getWriter().println(test);
%>

<html>
	<body>
		<p><%= test %></p>
	</body>
</html>

<%%>