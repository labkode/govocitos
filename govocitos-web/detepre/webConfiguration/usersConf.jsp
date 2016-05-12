<%-- 
    Document   : usersConf
    Created on : Apr 29, 2010, 11:57:43 AM
    Author     : anrodriguez2
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
     <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
         //se inicializan en goConfUsers.action
            String status = (String)request.getSession().getAttribute("status");
            String auxRol = (String)request.getSession().getAttribute("auxRol");
       %>
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
       <center><font class="styleTitle">Users Management:</font></center>

        <br><font color=red size=2><s:actionerror /></font><br>

         <FORM id="formulario" name="formulario" ACTION="manageUser.action" METHOD="POST">
          <table border =1 >             
                
              <tr><td>
                  New User:<br><br>
                <input type=text name=login_add >Login</input><br>
                <input type=password name=pass_add >Password</input><br>
                <input type=password name=repeatpass_add >Repeat Password</input><br>
                <input type=radio name=rol_add value="0" >SuperAdmin</input><br>
                 <input type=radio name=rol_add value="1" >Operator</input><br>
                  <input type=radio name=rol_add value="2" checked>Guest</input><br>

                <br>
             <INPUT class="button" style='width:130px' TYPE="submit" name ="confirm" value="Add User" >
            <br>
              </td></tr>
            </table>

            <br><br>
           <table border =1 >

              <tr><td>
                  Modify User:<br><br>

                <input type=text name=login_mod <% if (status.equals("search")){
                                                    out.println(" readonly ");
                                                   out.println(" value = '" + (String)request.getSession().getAttribute("auxLogin") + "' ");} %> >Login</input><br>
                <input type=password name=pass_mod enable = false value ="" <% if (!status.equals("search"))
                                                                           out.println(" disabled = disabled ");%>>Password</input><br>
                <input type=password name=repeatpass_mod enable = false value ="" <% if (!status.equals("search"))
                                                                            out.println(" disabled = disabled ");%>>Repeat Password</input><br>


                <input type=radio name=rol_mod value="0" <% if (!status.equals("search"))
                                                              out.println(" disabled = disabled ");
                                                            if (auxRol.equals("superadmin"))
                                                                out.println(" checked ");
                                                                            %>>SuperAdmin</input><br>
                 <input type=radio name=rol_mod value="1" <% if (!status.equals("search"))
                                                               out.println("disabled = disabled");
                                                                if (auxRol.equals("operator"))
                                                                out.println(" checked ");%>>Operator</input><br>
                  <input type=radio name=rol_mod value="2" <% if (!status.equals("search"))
                                                               out.println(" disabled = disabled ");
                                                                  if (auxRol.equals("guest"))
                                                                out.println(" checked ");%>>Guest</input><br>
                <br>
             <INPUT class="button" style='width:130px' TYPE="submit" name="confirm" <% if (!status.equals("search")) out.println(" value= Search ");
                                                                                        else out.println(" value= 'New Search' ");  %>>
             


                     <INPUT class="button" style='width:130px' TYPE="submit" name ="confirm"  <% if (!status.equals("search")) out.println(" disabled = disabled "); %> value="Save User" >
              <br></td></tr>
            </table>

            <br><br>
            <table border =1 >

            <tr><td>
                  Delete User:<br><br>
                <input type=text name=login_del >Login</input><br>

                <br>
              <INPUT class="button" onclick="Confirmar()" style='width:130px' TYPE="button" name ="confirm" value="Delete User" >
              
              <br></td></tr>
            </table>


        </FORM>

         <FORM ACTION="goMenu.action" METHOD="POST">
               <center>
             <br><br><INPUT class="button" style='width:130px' TYPE="submit" name ="confirm" value="Back" >
                 </center>
             </form>
                </td>
    </table>
    </body>
</html>