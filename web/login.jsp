<%-- 
    Document   : login
    Created on : Jan 11, 2016, 10:21:01 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>


<<!DOCTYPE html>
<html >
<head>
  
  <title>Fail</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <style>
  .jumbotron {
      background-color: #a3a3c2;
      color: #fff;
  }
  </style>
</head>
<body>
<<div class="container">
<div class="jumbotron text-center" >
  <h1>Login Failed!</h1> 
<p>The user does not exist!</p>
                </br>
  <p>Make sure you entered your password correctly</p> 
  <a href="index.jsp">Back</a>

</div>
</div>
</body>
</html>
