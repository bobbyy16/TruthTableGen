<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
  <head>
	<meta name="viewport" content="width=device-width">
	<link type="text/css" rel="stylesheet" href="/stylesheets/bootstrap.min.css" />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js" type="text/javascript"></script>
	<script src="https://netdna.bootstrapcdn.com/bootstrap/3.0.1/js/bootstrap.min.js" type="text/javascript"></script>

	<script type = "text/javascript">
	function get_values(input_id)
	{
		var input = document.getElementById(input_id).value;
		document.write(input);
	}
	</script>
  </head>
	<body>
	<div class="container">
	  <div class="navbar navbar-default">
		<h1>&nbsp;The Amazing Truth Table Generator.<br></h1>
		<div class="container">
		  <div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
			  <span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
			</button>
		  </div>
		</div>
	  </div>
	<b>Please enter an expression</b>
	<form action="/eval" method="post">
	<input class="form-control" type="text" name ="content" style="color:#888;" 
	value="A | B" onfocus="inputFocus(this)" onblur="inputBlur(this); required"><br>
	<div><input class="btn btn-block btn-success" type="submit" value="Submit expression" /></div>
	<br> Use ! to represent NOT </br>
		 Use | to represent OR 
	<br> Use & to represent AND </br> <br>
  	</form>
	</body>
</html>
