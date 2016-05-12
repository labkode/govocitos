<%-- 
    Document   : configurationView
    Created on : Jul 1, 2009, 5:40:16 PM
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
       %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Data Base View Configuration</title>

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
     <center><font class="styleTitle">Data Base View Configuration:</font></center>
  
        <br><br><center>Select Table:</center><br>

        <FORM name="formulario" ACTION="" METHOD="POST">

        <%
            out.println("<center><select name="+"cmb_table"+">");
            for (int j=0; j<Base.getNumTables(); j++) {
                if (Base.getTable(j).getVisible().equals("YES")){//if
                    out.print("<option value=" + j);
                    out.println(">" + Base.getTable(j).getNameT() + "</option>");
                }//if
            }
            out.println("</select></center>");
        %>
            
        <br><center><INPUT class="button" style='width:150px' TYPE="submit" name ="button" onClick="document.formulario.action='goConfView2.action'" value="Configure View" ></center><br>
        <center><br><br><INPUT class="button" style='width:130px' TYPE="submit" onClick="document.formulario.action='configurationTable3.jsp';" name ="confirm" value="Back" >
       <INPUT class="button"  style='width:150px' TYPE="submit" name ="button" onClick="document.formulario.action='goConfView2.action';" value="Save all in file" ></center><br>
        </FORM>
         </td>
    </table>




    </body>
</html>
