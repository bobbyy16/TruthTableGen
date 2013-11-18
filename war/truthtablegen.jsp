<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.lang.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
	<meta name="viewport" content="width=device-width">
	<title>The Amazing Truth Table Generator</title>
	<link type="text/css" rel="stylesheet" href="/stylesheets/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css" href="stylesheets/eval.css" />
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
	<form action="/truthtablegen.jsp" method="post">
	<input class="form-control" type="text" name ="content" style="color:#888;" value=
<%
	String express = request.getParameter("content");
	if (express != null) {
%>
	"<%=express%>"
<%
	} else {
%>
	"A | B"
<%
	}
%> 
	onfocus="inputFocus(this)" onblur="inputBlur(this); required"><br>
	<div><input class="btn btn-block btn-success" type="submit" value="Submit expression" /></div>
	<br> Use ! to represent NOT </br>
		 Use | to represent OR 
	<br> Use & to represent AND </br> <br>
  	</form>
  	
  	<%!
	//helper functions
	public boolean isValid(char c) {
		if (Character.isLetter(c) || c == ')')
			return true;
		return false;
	}

	public int precedence(char c) {
		String operators = "(|&!";
		int[] rank = { 0, 1, 2, 3 };
		int pos = -1;
		for (int i = 0; i < operators.length(); i++) {
			if (c == operators.charAt(i)) {
				pos = i;
				break;
			}
		}
		assert (pos != -1);
		return rank[pos];
	}

	public int evaluate(String postfix) {
		
		Stack<Boolean> operandStack = new Stack<Boolean>();

		for (int i = 0; i < postfix.length(); i++) {
			char current = postfix.charAt(i);

			if (current == 'T')
				operandStack.push(true);
			else if (current == 'F')
				operandStack.push(false);
			else {
				boolean var1 = (boolean) operandStack.peek();
				operandStack.pop();
				if (current == '!')
					operandStack.push(!var1);
				else {
					boolean var2 = (boolean) operandStack.peek();
					operandStack.pop();
					if (current == '&')
						operandStack.push(var1 && var2);
					else if (current == '|')
						operandStack.push(var1 || var2);
					else
						return -1;
				}
			}
		}
		boolean result = (boolean) operandStack.peek();
		
		if (result)
			return 1;
		else
			return 0;

	}
	public String toPostFix(String infix) {
		String postfix = "";
		String error = "Improperly Formatted";
		Stack<Character> operatorStack = new Stack<Character>();

		char x = '@';
		int left = 0;
		int right = 0;

		// Check if expression has matched parantheses
		for (int i = 0; i < infix.length(); i++) {
			char current = infix.charAt(i);
			if (current == '(')
				left++;
			if (current == ')')
				right++;
		}
		if (left != right)
			return error;

		String temp = "";
		for (int i = 0; i < infix.length(); i++) {
			if (infix.charAt(i) != ' ')
				temp += infix.charAt(i);
		}

		// Todo: Error checking for other characters?
		for (int i = 0; i < temp.length(); i++) {
			char current = temp.charAt(i);
			switch (current) {
			case '!':
			case '(':
				if (isValid(x))
					return error;
				operatorStack.push(current);
				break;
			case ')':
				if (!isValid(x))
					return error;
				while (true) {
					if (operatorStack.empty())
						return error;
					char top = (char) operatorStack.peek();
					operatorStack.pop();
					if (top == '(')
						break;
					postfix += top;
				}
				break;
			case '&':
			case '|':
				if (!isValid(x))
					return error;
				while (!operatorStack.empty()
						&& precedence(current) <= precedence((char) operatorStack
								.peek())) {
					postfix += (char) operatorStack.peek();
					operatorStack.pop();
				}
				operatorStack.push(current);
				break;
			default:
				if (isValid(x))
					return error;
				postfix += current;
				break;
			}
			x = current;
		}

		if (!isValid(x))
			return error;

		while (!operatorStack.empty()) {
			char top = (char) operatorStack.peek();
			operatorStack.pop();
			if (top == '(')
				break;
			postfix += top;
		}

		if (postfix.isEmpty())
			return error;

		return postfix;
	}
%>

<%
if (express != null) {
%>
	<p>Input expression: <%=express %></p>
<%
	int varCount = 0;
	String vars = "";
	for (int i = 0; i < express.length(); i++) {
		// find variables and ignore multiple instances of same variable
		char currChar = express.charAt(i);
		if (Character.isLetter(currChar) && vars.indexOf(currChar) == -1) {
			varCount++;
			vars += currChar;
		}
	}
// 	resp.getWriter().println("Variables: " + vars);
// 	resp.getWriter().println("Number of variables: " + varCount);
	
	int numOfRows = (int) Math.pow(2, varCount);
	int boolVector = 0x0;
	List<String> rows = new ArrayList<String>(numOfRows);
	
	// construct input strings with T/F instead of variables
	for (int i = 0; i < numOfRows; i++) {
		String rowString = "";
		for (int j = 0; j < express.length(); j++) {
			int index = vars.indexOf(express.charAt(j));
			if (index != -1) {
				// extract 0 or 1 from boolVector for variable #j
				int temp = ((boolVector >> (varCount - index - 1)) & 1);
				if (temp == 1) {
					rowString += 'T';
				} else if (temp == 0) {
					rowString += 'F';
				}
			} else {
				rowString += express.charAt(j);
			}
		}
		boolVector++;
		rows.add(rowString);
	}
	
	List<String> postfixRows = new ArrayList<String>(numOfRows);
	
	for (int i = 0; i < numOfRows; i++) {
		String postfix = toPostFix(rows.get(i));
// 		resp.getWriter().println("Postfix: " + postfix);
		postfixRows.add(postfix);
	}
	
	// //add row for header
	// numOfRows++;
	
	// reset boolVector
	boolVector = 0x0;
			
	//header row
	if (varCount > 0) {
%>
		<table border=1>
			<tr>
<%
		for (int i = 0; i < varCount; i++) {
%>
				<td><%=vars.charAt(i)%></td>
<%
		}
%>
				<td><%=express%></td>
<%
	}
	
	for (int i = 0; i < numOfRows; i++) {
%>
			<tr>
<%
		for (int j = 0; j < vars.length(); j++) {
			int boolVal = (boolVector >> (varCount - j - 1) & 1);
%>
				<td><%=boolVal%></td>
<%
		}
%>
				<td><%=evaluate(postfixRows.get(i))%></td>
			</tr>
<%
		boolVector++;
	}
}
%>
		</table>
	</body>
</html>
