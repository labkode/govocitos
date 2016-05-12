<%-- 
    Document   : saveFile
    Created on : Jun 3, 2011, 1:03:10 AM
    Author     : fede
--%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"%>
<%@page import="java.util.Properties"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <%
                Properties prop = WebProperties.getProperties(new File(this.getClass().getResource("/web.properties").getFile()));
                String path = prop.getProperty("web_path")+prop.getProperty("conf_file");
                FileInputStream archivo = new FileInputStream(path);
                int longitud = archivo.available();
                byte[] datos = new byte[longitud];
                archivo.read(datos);
                archivo.close();
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition","attachment,filename="+prop.getProperty("conf_file"));
                ServletOutputStream ouputStream = response.getOutputStream();
                ouputStream.write(datos);
                ouputStream.flush();
                ouputStream.close();
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <body>
    </body>
</html>