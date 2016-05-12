<%-- 
    Document   : imagesConf
    Created on : Jul 5, 2011, 5:36:39 PM
    Author     : fede
--%>

<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*" import="java.io.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />

   <script type='text/javascript'>

function Confirmar() {
    if(confirm("Are you sure that you want to remove this user?")){
        document.getElementById('formulario').submit();
    }
}

</script>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Users Management</title>
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
       <center><font class="styleTitle">Images Management:</font></center>

        <br><font color=red size=2><s:actionerror /></font><br>
         <FORM id="formulario" name="formulario" enctype="multipart/form-data" ACTION="manageImages.action" METHOD="POST">
          <table border =1 >
              <tr><td>
                Image:       <input type=file name=NombreImg ></input><br>
                Description: <input type=text name=descripcionImg></input><br>
                Link:        <input type=text name=link></input><br>
                <input type=radio name=tipo_img value="0" >Logo</input><br>
                <input type=radio name=tipo_img value="1" >Icon</input><br>
                <input type=radio name=tipo_img value="2" checked>Sponsor</input><br>
                <br>
             <INPUT class="button" style='width:130px' TYPE="submit" name ="confirm" value="Add Image" >
            <br>
            </td></tr>
            </table>
         </form>

         <FORM ACTION="goMenu.action" METHOD="POST">
             <center>
                <br><br><INPUT class="button" style='width:130px' TYPE="submit" name ="confirm" value="Back" >
             </center>
         </form>
        </td>
    </table>
    </body>
</html>