package truthtablegen;

import java.lang.*;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.*;


import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class EvalServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
    
    String exp = req.getParameter("content");
    resp.getWriter().println(exp);
    
    int varCount = 0;
    String vars = "";
    for (int i = 0; i < exp.length(); i++)
    {
        //find variables and ignore multiple instances of same variable
        char currChar = exp.charAt(i)
    	if (Character.isLetter(currChar) && vars.indexOf(currChar) == -1)
    	{
    		varCount++;
    		vars += currChar;
    	}
    }
    resp.getWriter().println(vars);
    resp.getWriter().println(varCount);

    int numOfRows = Math.pow(2,varCount);
    int boolVector = 0x0;
    List<String> rows = new ArrayList<String>(numOfRows);

    //construct input strings with T/F instead of variables
    for (int i = 0; i < numOfRows; i++) {
        int rowString = "";
        for(int j = 0; j< exp.length(); j++) {
            int index = vars.indexOf(exp.charAt(j));
            if (index != -1) {
                //extract 0 or 1 from boolVector for variable #j
                int temp = ((boolVector >> (varCount-index-1)) & 1);
                if (temp == 1) {
                    rowString += 'T';
                } else if (temp == 0) {
                    rowString += 'F';                    
                }
            } else {
                rowString += exp.charAt(j);
            }
        }
        boolVector++;
        rows.add(rowString);
    }
}
