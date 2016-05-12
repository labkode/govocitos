<%-- 
    Document   : deleteConf
    Created on : Mar 5, 2011, 7:29:21 PM
    Author     : fede
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*" import="java.io.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />

<html>
    <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
   %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>File Deleted</title>
        <link href="./css/main.css" rel="stylesheet" type="text/css"/>

        <link rel="shortcut icon" href="./images/gavidIcon.ico"/>
    </head>
    <body>


        <table style="margin-top:1%;" border="0" align="center">
    <thead>
        <tr>
            <th colspan="3"></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td colspan="3"></td>
        </tr>
        <tr>
            <td></td>
            <td><img border="0" src="./images/gavidLogo.png" width="300" height="105"/></td>
            <td></td>
        </tr>
        <tr>
            <td colspan="3"></td>
        </tr>
    </tbody>
</table>




    <table class="bordeGris" align="center" border="0" cellspacing="50" bgcolor="#FFFFFF">
 <td>
       <center><font class="styleTitle">File Deleted!</font></center>


         <br><br><center>
             <form ACTION="../index.html" METHOD="POST">
             <INPUT class="button" style='width:130px' TYPE="submit" name ="confirm" value="Back" >
                 </center>
             </form>
    </body>
</html>