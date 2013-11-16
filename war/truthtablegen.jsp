<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
	<body>
	Please enter an expression
	<br> Use ! to represent NOT </br>
	     Use | to represent OR 
	<br> Use & to represent AND </br>
	 <form action="/eval" method="post">
    <div><textarea name="content" rows="3" cols="60"></textarea></div>
    <div><input type="submit" value="Submit expression" /></div>
  	</form>
	</body>
</html>