<%-- 
    Document   : configurationRestrictions2
    Created on : Jul 8, 2009, 1:32:56 PM
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
        <title>Data Base Fields Configuration</title>
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
     <center><font class="styleTitle">Data Base Fields Configuration:</font></center><br>

    <script type='text/javascript'>

        function goTable(obj) {
         //   if (obj.value != "-1") {
                if (obj.name=="listTables")
                    document.getElementById("formTableList").submit();
            }
        
    </script>
        <%
                String ts = (String)request.getSession().getAttribute("tabSelec");
                //esta comprobacion es para cuando se ejecuta por segunda vez para
                //configurar un segundo campo
                //la variable de sesion tableSelected desaparece en algun punto
                //y la restauro en tabSelect en configurationTable4.jsp
                //otro misterio de la informatica
                if (ts == null){
                    request.getSession().setAttribute("tabSelec","-1");
                    ts = (String)request.getSession().getAttribute("tabSelec");
                }
                //PASAMOS A INT EL NUMERO DE LA TABLA
               int tableSelected = Integer.parseInt(ts);
         %>
            <form id="formTableList" action="listFields.action" method="POST">
            
                Select table:<br>
                <select class="style33" name="listTables" onchange="javascript:goTable(this);">
                <option value="-1" default selected>-- Please Select --</option>
                <%
                for (int j=0; j<Base.getNumTables(); j++) {
                    if (Base.getTable(j).getVisible().equals("YES"))
                    {
                
                    out.print("<option value=" + j);
                    if (tableSelected == j)
                        out.print(" default selected ");
                    out.println(">" + Base.getTable(j).getNameT() + "</option>");
   
                    }//if
                }//for
                %>
            </select><br>           
                   <%
                   if (tableSelected != -1)
                   {//if -1
                    out.println("<br>Fields:<br>");
                    for (int z = 0; z<Base.getTable(tableSelected).getNumFields();z++)
                        {
                           out.print("<input type=radio ");                           
                      //esta comprobación es para evitar que un campo oculto,
                     //se pueda configurar

                       //     if (Base.getTable(tableSelected).getField(z).getVisible().equals("NO"))
                      //         out.print("disabled");
                           out.println(" name=selectField value=" + z + " >" + Base.getTable(tableSelected).getField(z).getNameF() +" <br>");
                        }
                   out.println("<br><center><INPUT class=button style='width:130px' TYPE=submit name=confField value='Configure Field' ></center><br> ");
                   }//if -1
                    %>
        </form>
        <form ACTION="goConfView.action" METHOD="POST">
               <center>
             <br><br><INPUT class="button"  TYPE="submit" name ="button" value="Back">
             <INPUT class="button"  TYPE="submit" name ="button" value="Continue" >
                 </center>
         </form>
               
         </td>
    </table>

    </body>
</html>
