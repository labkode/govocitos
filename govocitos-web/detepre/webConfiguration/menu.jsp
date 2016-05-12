<%-- 
    Document   : index
    Created on : Jun 24, 2009, 12:48:33 PM
    Author     : anrodriguez2
--%>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"%>
<%@page import="java.util.Properties"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*" import="java.io.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />

   <script type='text/javascript'>

function Confirmar(nombre) {
    if(confirm("Are you sure that you want to remove the configuration file for database: "+ nombre  +"?")){
        document.formulario.submit();
    }
}
function guardarFichero(){
    window.open('saveFile.jsp');
}

</script>

<html>
    <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
                Properties prop = WebProperties.getProperties(new File(this.getClass().getResource("/web.properties").getFile()));
                String path = prop.getProperty("web_path")+prop.getProperty("conf_file");
                String nameDB = prop.getProperty("database_name");
       %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Configuration Menu:</title>
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

<table align="center" border="0" cellspacing="25" bgcolor="#FFFFFF">
 <td>
     <center><font class="styleTitle">Menu:</font></center>
     <br><font color=red size=2><s:actionerror /></font><br></td>

<table class="bordeGris" align="center" border="0" cellspacing="25" bgcolor="#FFFFFF">
    <td>
     <center><font class="styleTitle">Configuration Menu:</font></center>
            <form name="formulario" id="formulario" ACTION="menuSelected.action" METHOD="POST">
            <br><center><INPUT class="button" style='width:220px' TYPE="submit" name ="button" value="Field Properties Configuration" ></center><br>
            <br><center><INPUT class="button" style='width:140px' TYPE="submit" name ="button" value="User Management" ></center><br>
            <br><center><INPUT class="button" style='width:140px' TYPE="submit" name ="button" value="Image Management" ></center><br>
            <br><center><INPUT class="button" style='width:220px' TYPE="submit" name ="button" value="Synchronize Configuration File" ></center>
    </td>
    <td>
            <center><font class="styleTitle">XML Management:</font></center>
            <br><center><INPUT class="button" style='width:190px' TYPE="button" onClick="Confirmar('<%=nameDB%>')" name ="button" value="Delete Configuration File" ></center><br>
            <br><center><INPUT class="button" style='width:180px' TYPE="button" onClick="guardarFichero()" name ="button" value="Save Configuration File" ></INPUT></center><br>
            <br><center><INPUT class="button" style='width:180px' TYPE="submit" name ="button" value="Load Configuration File" ></center>
    </td>
</table>
</form>
      <FORM ACTION="../index.html" METHOD="POST">
     <br><br><center><INPUT class="button" TYPE="submit" name ="button" value="Back" ></center>

</FORM>
    </table>
    </body>
</html>
