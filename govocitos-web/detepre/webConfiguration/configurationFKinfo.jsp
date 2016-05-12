<%-- 
    Document   : configurationFKinfo
    Created on : Aug 5, 2009, 6:07:43 PM
    Author     : anrodriguez2
--%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />

<html>     <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
                Connection connection = Base.getCon();
                Statement statement = connection.createStatement();
            %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Data Base Relationships Configuration</title>
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
     <center><font class="styleTitle">Data Base Relationships Configuration:</font></center>

        <br><font color=red size=2><s:actionerror /></font><br>
        
   <script type='text/javascript'>

        function goTable(obj) {
         //   if (obj.value != "-1") {
                if (obj.name=="listTables"){
                    document.formulario.action="setFkFields.action";
                    document.getElementById("formFkTableList").submit();
                }
            }
        
    </script>
    <%        
                    String ts = (String)request.getSession().getAttribute("fktableSelec");
                    //PASAMOS A INT EL NUMERO DE LA TABLA
                    int fktableSelected = Integer.parseInt(ts);
    %>

  <form name="formulario" id="formFkTableList" action="" method="POST">

                        <center>Select table:</center><br>
                        <center><select class="style33" name="listTables" onchange="javascript:goTable(this);">
                        <option value="-1" default selected>-- Please Select --</option>
                        <%
                        for (int j=0; j<Base.getNumTables(); j++) {
                            if (Base.getTable(j).getVisible().equals("YES") && 
                                Base.getTable(j).getVector_foreignList().size()>0)
                            {//if
                            out.print("<option value=" + j);
                            if (fktableSelected == j)
                                out.print(" default selected ");
                            out.println(">" + Base.getTable(j).getNameT() + "</option>");

                            }//if
                          }

                      out.println("</select>");

                    if ((fktableSelected != -1) && (Base.getTable(fktableSelected).getVector_foreignList().size()>0))
                     {//if2

                       out.println("<br><br>Select fields to be shown:<br>");
                       out.print("<table border=1><tr>");
                       for (int p = 0;p<Base.getTable(fktableSelected).getVector_foreignList().size();p++)
                           out.print("<td>" + Base.getTable(fktableSelected).getVector_foreignList().elementAt(p).getFkTable() + "</td>");
                       out.print("</tr><tr>");

                       for (int p = 0;p<Base.getTable(fktableSelected).getVector_foreignList().size();p++)
                        {//for1
                            out.print("<td>");
                            String auxT = Base.getTable(fktableSelected).getVector_foreignList().elementAt(p).getFkTable();
                            for (int y =0;y<Base.getTable(Base.getTableByName(auxT)).getNumFields();y++)
                                {
                                    if(!(Base.getTable(Base.getTableByName(auxT)).getField(y).getIsfk().equalsIgnoreCase("YES") && Base.getTable(Base.getTableByName(auxT)).getField(y).getIspk().equalsIgnoreCase("NO"))){
                                        out.print("<INPUT TYPE=CHECKBOX ");
                                        for (int z=0;z<Base.getTable(fktableSelected).getVector_foreignList().elementAt(p).getLFields().size();z++)
                                        {  //esto es para que aparezcan seleccionados los checkbox de los showFK
                                            if (Base.getTable(Base.getTableByName(auxT)).getField(y).getNameF().equals( Base.getTable(fktableSelected).getVector_foreignList().elementAt(p).getLFields().elementAt(z) ))
                                                out.print(" CHECKED ");
                                        }
                                        out.print (" NAME=" + "fkShow" + p + y + " >" + Base.getTable(Base.getTableByName(auxT)).getField(y).getNameF() + "<br>");
                                    }
                                }
                            out.print("<br><br>Relationship name:<br>");
                            out.print("<input type=text ");
                            out.print("value="+Base.getTable(fktableSelected).getVector_foreignList().elementAt(p).getName());
                            out.print(" name=relationName"+p+"></input>");
                            out.print("</td>");

                        }//for1
                       out.print("</tr></table>");
                     }//if2
                      if (fktableSelected != -1)
                          out.println("<br><br><br><INPUT class='button' style='width:140px' TYPE='submit' name='confFK' onClick=\"document.formulario.action='setFkFields.action';\" value='Save this table' ><br>");
                      %><br><br><br><INPUT class="button"  TYPE="submit" name ="confirm" onClick="document.formulario.action='goConfTable.action';" value="Back" >
                      <%out.println("<INPUT class='button' TYPE='submit' name='confFK' onClick=\"document.formulario.action='setFkFields.action';\" value='Continue' ><br>");%>
                    </center>
                   </form>
             
         </td>
    </table>


    </body>
</html>
