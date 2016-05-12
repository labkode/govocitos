<%-- 
    Document   : dbData
    Created on : Jul 28, 2009, 4:40:39 PM
    Author     : anrodriguez2
--%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"
import="java.util.Properties"
import="com.opensymphony.xwork2.ActionSupport"
import="java.io.File"
contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*" import="java.io.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">


<jsp:include page="checkisAdmin.jsp" />


<html
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Data Base Info</title>
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
       <center><font class="styleTitle">Data Base Info:</font></center>

        <br><font color=red size=2><s:actionerror /></font><br>


     <form ACTION="setDBData.action" METHOD="POST">
        <%
            Properties prop = null;
            try {
                //compruebo que los datos coincidan con los del fichero
                prop = WebProperties.getProperties(new File(this.getClass().getResource("/web.properties").getFile()));
            } catch (Exception e)  {
                Exception exc2=new Exception("Error reading web.properties file");
       //         addActionError(exc2.getMessage());
            }
            //leemos los datos por defecto del fichero de propiedades
           out.println("<input type=text name=dbname  ");
           out.println(" value=" + prop.getProperty("database_name"));
           out.println(" >DataBase name</input><br>  ");

           out.println("<input type=text name=server ");
           out.println(" value=" + prop.getProperty("database_server"));
           out.println(" >Server</input><br>  ");

           out.println("<input type=text name=port ");
           out.println(" value=" + prop.getProperty("database_port"));
           out.println(" >Port</input><br>  ");

           out.println("<input type=text name=user ");
           out.println(" value=" + prop.getProperty("database_user"));
           out.println(" >User</input><br>  ");

           out.println("<input type=password name=password ");
           out.println(" value=" + prop.getProperty("database_password"));
           out.println(" >Pass</input><br>  ");
       //    out.println("<input type=text name=file value=/home/anrodriguez2/Desktop/ejemplo_detepre.xml >Configuration File</input><br>  ");
        //en el campo de bases de datos disponibles, metemos el valor por defecto
      %>
            <select class="style33" name="listDBaval">
                        <option value="-1" default selected>-- Please Select --</option>
                        <%
                         String db_aval = prop.getProperty("available_databases");
                         int z = 0;
                         String auxChar="";
                        while (z< db_aval.length())
                        {
                           while ((z< db_aval.length()) && (db_aval.charAt(z) != ';'))
                            {//while1111
                                auxChar=auxChar + db_aval.charAt(z);
                                z++;
                            }//while1111
                           out.print("<option value=" + auxChar);
                           if (prop.getProperty("dbms").equals(auxChar))
                                out.print(" default selected ");
                           out.println(">" + auxChar + "</option>");
                            auxChar ="";
                            z++;
                        }
                        out.println("</select>");
        %>
        <br><br><br><center><INPUT class="button" TYPE="submit" name ="button" value="Connect" ></center>
      </form>
       </td>
    </table>
    </body>
</html>
