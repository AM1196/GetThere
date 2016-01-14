/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.web;

import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.naming.*;
import javax.naming.directory.*;
import java.util.Hashtable;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class login extends HttpServlet {

    

   
   

    ///DATABASE DETAILS
    static String DB = "jdbc:mysql://localhost:3306/mark";
    private static String DBUSER = "root";
    private static String DBPSW = "";

    private static boolean auth;
    private Attributes atr;
    private PreparedStatement pstmt;

    public static HttpSession session;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    @Override
    public void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException, ServletException {

        String user="";
        String pass="";
        //connect to database
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(DB, DBUSER, DBPSW);

            user = request.getParameter("username");
            pass = request.getParameter("password");

            // Set up ldap environment
            Hashtable<String,String> env = new Hashtable<String,String>();
            env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
            env.put(Context.PROVIDER_URL, "ldap://ldap.uth.gr:389/");
            // Authenticate as User and password "mysecret"
            env.put(Context.SECURITY_PRINCIPAL, "uid=" + user + ", ou=People, dc=uth,dc=gr");
            env.put(Context.SECURITY_AUTHENTICATION, "simple");
            env.put(Context.SECURITY_CREDENTIALS, pass);
            
             // Create initial context
            DirContext ctx = new InitialDirContext(env);

            atr = ctx.getAttributes("uid=" + user + ", ou=People, dc=uth, dc=gr");

            auth = true;

            ctx.close();
            System.out.println(atr.toString());
        } catch (ClassNotFoundException | SQLException |AuthenticationException ex ) {
            //Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
            auth = false;
        } catch (NamingException ex) {
            auth = false;
            //Logger.getLogger(Loginservlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        PrintWriter out = response.getWriter();
        

        if (auth) {

            try {
                stmt = conn.createStatement();

                //db query for current user
                rs = stmt.executeQuery("SELECT * FROM user WHERE username='" + user + "'");

                if (rs.next()) { //O xrhsths uparxei

                    

                    session = request.getSession();
                    session.setAttribute("user", user);

                    session.setMaxInactiveInterval(3 * 60);

                    Cookie loginCookie = new Cookie("user", user);
                    //setting cookie to expiry in 30 mins
                    loginCookie.setMaxAge(3 * 60);
                    response.addCookie(loginCookie);
                    response.sendRedirect("map.jsp");
                    //RequestDispatcher view = request.getRequestDispatcher("index.jsp");


                   // view.forward(request, response);
                } else { //den uparxei o xrhsths, kane eisagwgh                   
                   
                    
                    session = request.getSession();
                    session.setAttribute("user", user);

                    session.setMaxInactiveInterval(3 * 60);

                    Cookie loginCookie = new Cookie("user", user);
                    //setting cookie to expiry in 30 mins
                    loginCookie.setMaxAge(3 * 60);
                    response.addCookie(loginCookie);

                    
                    //out.println("<html><body>MAIL: " + mail + "\n</body></html>");
                    pstmt = conn.prepareStatement("INSERT INTO user(username) VALUES (?)");
                    pstmt.setString(1, user);
                   
                    pstmt.executeUpdate();

                    response.sendRedirect("map.jsp");
                    //RequestDispatcher view = request.getRequestDispatcher("/index.jsp");
                   // view.forward(request, response);
                    

                }
            } catch (SQLException ex) {
               
            }
        } else {
            
            RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.jsp");

            rd.forward(request, response);
        }

    }
}
