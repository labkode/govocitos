<%-- 
    Document   : configurationTable2
    Created on : Jul 10, 2009, 10:37:27 AM
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
        <title>Data Base Tables Configuration</title>

        <link href="./css/main.css" rel="stylesheet" type="text/css"/>

        <link rel="shortcut icon" href="./images/gavidIcon.ico"/>
        
        <script type='text/javascript'>

        function showDesc(obj) {
            el = document.getElementById("showSub" + obj.id);
             
             if (el.style.display == "block")
                  el.style.display = "none";
              else
                  el.style.display = "block";
            }
    </script>
        
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

        <form name="formulario" action="" method="POST">
            
                <br>Select Operations Allowed:<br><br>
                
                    <br><INPUT align="right" class="button" TYPE="submit" onClick="document.formulario.action='setOperations.action';document.formulario.submit();" name ="buttonOp" value="Continue" ><br><br>
                <%
                for (int j=0; j<Base.getNumTables(); j++) {
                    if (Base.getTable(j).getVisible().equals("YES")){
                        out.println("<table border =1 ><td>");
                        out.println("Table: <b>" + Base.getTable(j).getNameT() + "</b><br>");
                        out.print("<INPUT TYPE=CHECKBOX ");
                        if (Base.getTable(j).getAddNew().equals("YES"))
                             out.print("checked");
                        out.println(" NAME=add" + j + " >Add<BR>");
                        out.print("<INPUT TYPE=CHECKBOX ");
                        if (Base.getTable(j).getConsult().equals("YES"))
                             out.print("checked");
                        out.println(" NAME=consult" + j + " >Consult<BR>");
                        out.println("<INPUT TYPE=CHECKBOX ");
                        if (Base.getTable(j).getModify().equals("YES"))
                             out.print("checked");
                        out.println(" NAME=modify" + j + " >Modify<BR>");
                        out.print("<INPUT TYPE=CHECKBOX ");
                        if (Base.getTable(j).getDelete().equals("YES"))
                             out.print("checked");
                        out.println(" NAME=delete" + j + " >Delete<BR>");
                        out.println("Visible name: <INPUT TYPE=TEXT NAME=visible_name" + j + " value = '" + Base.getTable(j).getVisibleName() + "' ><BR><BR>");
            %>
                         <INPUT TYPE="BUTTON" id ="<%out.print(j);%>" name="descButton" value="Description" OnClick= "showDesc(this)" ></input><br>

                         <div id="showSub<%out.print(j);%>" style="display:none">
                             <textarea cols="30" rows="4" name="descTable<%out.print(j);%>" ><%out.print(Base.getTable(j).getDescription()); %></textarea>
                          </div>

                           </td>
                     </table><br>
                <%
                    }//if
                }//for
                %>
               <center>
             <br><br><INPUT class="button" TYPE="submit" onClick="document.formulario.action='goConfTable.action';document.formulario.submit();" name ="confirm" value="Back" >
             <INPUT class="button" TYPE="submit" onClick="document.formulario.action='setOperations.action';document.formulario.submit();" name ="buttonOp" value="Continue" ><br>
             </center>
        </form>
         </td>
    </table>



    </body>
</html>
