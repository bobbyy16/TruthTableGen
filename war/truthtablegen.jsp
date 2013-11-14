<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
	<body>
	Please enter an expression
	 <form action="/eval" method="post">
    <div><textarea name="content" rows="3" cols="60"></textarea></div>
    <div><input type="submit" value="Post Greeting" /></div>
  	</form>
	</body>
</html>