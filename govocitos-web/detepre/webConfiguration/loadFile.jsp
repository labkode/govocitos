<%--
    Document   : deleteConf
    Created on : Mar 5, 2011, 7:29:21 PM
    Author     : fede
--%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="com.opensymphony.xwork2.ActionSupport"
import="es.uvigo.ei.lia.ddms.xml.*" import="java.io.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />
   <script type='text/javascript'>
       function compruebaExtension() {
          //recupero la extensión de este nombre de archivo
          file = document.getElementById("carga").cargar.value;
          while (file.indexOf("\\") != -1) file = file.slice(file.indexOf("\\") + 1);
          extension = file.slice(file.indexOf(".")).toLowerCase();
          //compruebo si la extensión está entre las permitidas
          if (".xml" == extension) {
          }else{
              document.getElementById("carga").cargar.value="";
          }
        }
   </script>
<html>
    <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
   %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Load Configuration File</title>
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
     <br><font color=red size=2><s:actionerror /></font><br>
       <form id="carga" ACTION="goLoadConf.action" enctype="multipart/form-data" METHOD="POST">
             <br><INPUT TYPE="file" name ="cargar" id="cargar"></INPUT><br>
             <br><center><INPUT class="button" TYPE="submit" name ="button" value="Load" onClick="compruebaExtension()"></INPUT></center><br>
             <br><br><center><INPUT class="button" style='width:130px' TYPE="submit" name ="button" value="Back" ></center>
       </form>
    </body>
</html>