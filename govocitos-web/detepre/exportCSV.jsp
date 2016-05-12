<%-- 
    Document   : exportCSV
    Created on : Jun 27, 2011, 8:12:37 PM
    Author     : fede
--%>

<%@page import="java.io.FileInputStream"%>
<%@page import="org.apache.struts2.ServletActionContext"%>
<%@page import="es.uvigo.ei.lia.ddms.dms.db.Database"%>
<%@page import="es.uvigo.ei.lia.ddms.DatabaseModel"%>
<%@page import="java.io.File"%>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"%>
<%@page import="java.util.Properties"%>
<%@page import="es.uvigo.ei.lia.ddms.dms.db.Model"%>
<%@page import="es.uvigo.ei.lia.ddms.dms.db.Registry"%>
<%@page import="es.uvigo.ei.lia.ddms.dms.db.Field"%>
<%@page import="es.uvigo.ei.lia.ddms.dms.db.Relationship"%>
<%@page import="java.util.Vector"%>
<%@page import="es.uvigo.ei.lia.ddms.dms.db.PrimaryKey"%>
<%@page import="es.uvigo.ei.lia.ddms.dms.db.Table"%>
<%@page import="com.csvreader.CsvWriter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <%
        Properties prop = WebProperties.getProperties(new File(this.getClass().getResource("/web.properties").getFile()));
        String path = prop.getProperty("absolute_final_path")+"informe.csv";
        FileInputStream archivo = new FileInputStream(path);
        int longitud = archivo.available();
        byte[] datos = new byte[longitud];
        archivo.read(datos);
        archivo.close();
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition","attachment,filename="+"informe.csv");
        ServletOutputStream ouputStream = response.getOutputStream();
        ouputStream.write(datos);
        ouputStream.flush();
        ouputStream.close();
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Export to CSV</title>
        <link href="./css/main.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <table class="bordeGris" align="center" border="0" cellspacing="50" bgcolor="#FFFFFF">
        <td>
         <form ACTION="./listTables.jsp" METHOD="POST">
         <INPUT class="button" style='width:130px' TYPE="submit" name ="confirm" value="Back" >
             </center>
         </form>
    </body>
</html>