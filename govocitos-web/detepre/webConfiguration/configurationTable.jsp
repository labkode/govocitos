<%-- 
    Document   : configurationRestrictions
    Created on : Jul 8, 2009, 1:28:45 PM
    Author     : anrodriguez2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />

<html>
         <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
        DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
        Connection connection = Base.getCon();
        //se inicializan en goConfUsers.action
        String status = (String)request.getSession().getAttribute("status");
        String auxRol = (String)request.getSession().getAttribute("auxRol");
       %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Data Base Tables Configuration</title>
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
     <center><font class="styleTitle">Data Base Tables Configuration:</font></center>

        <FORM name="formulario" ACTION="" METHOD="POST">
        <%
            int i = 0;           
            out.println("<br>Select visible tables: <br>");
            for (i= 0; i<Base.getNumTables();i++){
                out.println("<INPUT TYPE=CHECKBOX");
                if (Base.getTable(i).getVisible().equals("YES") || Base.getTable(i).getVisible().equals(""))
                     out.print(" checked ");
                out.println ("NAME=checkbox" + i + " >" + Base.getTable(i).getNameT() + "<br>");
            }
            //PASAMOS LA tabla por defecto POR SESION
            request.getSession().setAttribute("tabSelec", "-1");
            request.getSession().setAttribute("fktableSelec", "-1");
        %>
        <br>
        
               <center>
                   <br><br><br><INPUT class="button" TYPE="submit" onClick="document.formulario.action='goMenu.action';document.formulario.submit();" name ="confirm" value="Back" >
            <INPUT class="button" style='width:130px' TYPE="submit" name ="buttonVis" onClick="document.formulario.action='setVisibles.action';document.formulario.submit();" value="Configure Table" ></center><br>
        </FORM>        
        </td>
    </table>
    </body>
</html>
