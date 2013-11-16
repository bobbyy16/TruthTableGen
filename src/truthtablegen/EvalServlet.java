package truthtablegen;

import java.lang.*;
import java.util.*;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
//import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class EvalServlet extends HttpServlet {
	public boolean isValid(char c)
	{
		if (Character.isLetter(c) || c == ')')
			return true;
		return false;
	}
	
	public int precedence(char c)
	{
		String operators = "(|&!";
		int[] rank = { 0, 1, 2, 3 };
		int pos = -1;
		for (int i = 0; i < operators.length(); i++)
		{
			if (c == operators.charAt(i))
			{
				pos = i;
				break;
			}
		}
		assert(pos != -1);
		return rank[pos];
	}
	
	public String toPostFix(String infix)
	{
		String postfix = "";
		String error = "Improperly Formatted";
		Stack operatorStack = new Stack();
		
		char x = '@';
		int left = 0;
		int right = 0;
		
		// Check if expression has matched parantheses
		for (int i = 0; i < infix.length(); i++)
		{
			char current = infix.charAt(i);
			if (current == '(')
				left++;
			if (current == ')')
				right++;
		}
		if (left != right)
			return error;
		
		String temp = "";
		for (int i = 0; i < infix.length(); i++)
		{
			if (infix.charAt(i) != ' ')
				temp += infix.charAt(i);
		}
		
		// Todo: Error checking for other characters?
		for (int i = 0; i < temp.length(); i++)
		{
			char current = temp.charAt(i);
			switch (current)
			{
			case '!':
			case '(':
				if (isValid(x))
					return error;
				operatorStack.push(current);
				break;
			case ')':
				if (!isValid(x))
					return error;
				while (true)
				{
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
				while (!operatorStack.empty() && precedence(current) <= precedence((char) operatorStack.peek()))
				{
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
		
		while (!operatorStack.empty())
		{
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
		
		
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
    
    String express = req.getParameter("content");
    resp.getWriter().println("Input: " + express);
    
    Hashtable<Character, Boolean> unique = new Hashtable<Character, Boolean>();
    
    // For HTML purposes
    int varCount = 0;
    String vars = "";
    for (int i = 0; i < express.length(); i++)
    {
    	if (Character.isLetter(express.charAt(i)))
    	{
    		// if it's a new variable we haven't encountered before
    		if(unique.get(express.charAt(i)) == null)
    		{
    			unique.put(express.charAt(i), true);
    			varCount++;
        		vars += express.charAt(i);
    		}
    	}
    }
    resp.getWriter().println("Variables: " + vars);
    resp.getWriter().println("Number of variables: " +varCount);
    
    int numOfRows = (int)Math.pow(2,varCount);
    int boolVector = 0x0;
    List<String> rows = new ArrayList<String>(numOfRows);

    //construct input strings with T/F instead of variables
    for (int i = 0; i < numOfRows; i++) {
        String rowString = "";
        for(int j = 0; j< express.length(); j++) {
            int index = vars.indexOf(express.charAt(j));
            if (index != -1) {
                //extract 0 or 1 from boolVector for variable #j
                int temp = ((boolVector >> (varCount-index-1)) & 1);
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
    
    
    String postfix = toPostFix(express);
    resp.getWriter().println("Postfix: " + postfix);
    
    }
    
}
