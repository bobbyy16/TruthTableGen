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
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class EvalServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
    
    String express = req.getParameter("content");
    resp.getWriter().println(express);
    
    int varCount = 0;
    String vars = "";
    for (int i = 0; i < express.length(); i++)
    {
    	if (Character.isLetter(express.charAt(i)))
    	{
    		varCount++;
    		vars += express.charAt(i);
    	}
    }
    resp.getWriter().println(vars);
    resp.getWriter().println(varCount);
    
    }
}
