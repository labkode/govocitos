<%--
    Document   : configurationTableVarchar
    Created on : Jul 13, 2009, 11:48:58 AM
    Author     : anrodriguez2
--%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />

<html>
    <head>
        <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
       %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Data Base Fields Configuration</title>
        <link href="./css/main.css" rel="stylesheet" type="text/css"/>
        <link rel="shortcut icon" href="./images/gavidIcon.ico"/>


    <script type='text/javascript'>
        function changeFile(id) {
            el = document.getElementById("showSub");
            if (id.value == "5")
               el.style.display = "block";
             else
                 el.style.display = "none";
            el = document.getElementById("showOps");
            if (id.value == "3" || id.value == "4")
               el.style.display = "block";
             else
                 el.style.display = "none";
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
     <center><font class="styleTitle">Data Base Fields Configuration:</font></center><br>

        <br><font color=red size=2><s:actionerror /></font><br>

        <%
                String ts = (String)request.getSession().getAttribute("tabSelec");
                String fs = (String)request.getSession().getAttribute("fiSelec");

                //PASAMOS A INT EL NUMERO DE LA TABLA y del campo
               int tableSelected = Integer.parseInt(ts);
               int fieldSelected = Integer.parseInt(fs);

               out.println("Table: " + Base.getTable(tableSelected).getNameT() + "<br>Field: " + Base.getTable(tableSelected).getField(fieldSelected).getNameF() + "<br><br>");
        %>

  <form name="formulario" id="formFieldConf" action="" method="POST">


         <br>Visible Name:<br>
         <input type=text name="visibleName" value="<% out.print(Base.getTable(tableSelected).getField(fieldSelected).getVisibleName()); %>"></input><br>

         <br>Description:<br>
         <textarea cols="50" rows="4" name="descriptionF"><% out.print(Base.getTable(tableSelected).getField(fieldSelected).getDescription()); %></textarea><br>   
<%
    /*      if (Base.getTable(tableSelected).getField(fieldSelected).getIsfk().equals("YES") )
                     {
                       out.println("<br>Select fields to be shown:<br>");
                       int fkTable = Base.getTableByName(Base.getTable(tableSelected).getField(fieldSelected).getFkTable());
                       for (int i = 0;i<Base.getTable(fkTable).getNumFields();i++)
                           {
                               out.print("<INPUT TYPE=CHECKBOX NAME=" + "fkShow" + i + " >" + Base.getTable(fkTable).getField(i).getNameF() + " <BR>");

                           }
                     } */

         out.println("<br><br>Show as: <br>");
  
         out.print("<INPUT TYPE=radio NAME=showAs value=0 onchange= changeFile(this)");
         if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("TEXT") ||
             Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("Undef"))
            out.print(" checked ");
         out.println(" >Textfield<br>");
         
         out.print("<INPUT TYPE=radio NAME=showAs value=1 onchange= changeFile(this)");
         if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("TEXTAREA"))
            out.print(" checked ");
         out.println(" >Area of text<br>");

         out.print("<INPUT TYPE=radio NAME=showAs value=3 onchange= changeFile(this)");
         if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("SELECT"))
            out.print(" checked ");
         out.println(" >Select box<br>");

         out.print("<INPUT TYPE=radio NAME=showAs value=4 onchange= changeFile(this)");
         if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("RADIO"))
            out.print(" checked ");
         out.println(" >Radio button<br>");


         if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("SELECT") ||
             Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("RADIO") )
              out.println("<div id=showOps style=display:block>");
         else
             out.println("<div id=showOps style=display:none>");

         out.print("Add options:<br> -one option in each line<br>");
         out.print("<textarea cols=50 rows=4 name=setOptions>");
         out.print(Base.getTable(tableSelected).getField(fieldSelected).getOptions() + "</textarea><br>");

         out.println("</div>");



        if (Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("BOOL") ||
            Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("TINYINT") ||
            Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("BIT")){
                 out.print("<INPUT TYPE=radio NAME=showAs value=2 onchange= changeFile(this)");
                 if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("CHECKBOX"))
                    out.print(" checked ");
                 out.println(" >Checkbox<br>");
            }
        if (Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("VARCHAR")){
             out.print("<INPUT TYPE=radio NAME=showAs value=5 onchange= changeFile(this)");
             if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("FILE") ||
                 Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("IMAGE") )
                 out.print(" checked ");
             out.println(" >File<br>");
        }
         if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("FILE") ||
             Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("IMAGE") )
              out.println("<div id=showSub style=display:block>");
         else
             out.println("<div id=showSub style=display:none>");

         out.println("Is image:");
         out.print("<input TYPE=CHECKBOX NAME=cboxIM ");
         if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("IMAGE"))
             out.print("checked");               
         out.println(" ></input></div><br>");
         //tengo que hacer esto, ya que las variables de sesion desaparecen por alguna razon
         //paso de la tabSelec (que desaparece) a tab_to_mod.
         request.getSession().setAttribute("tab_to_mod", (String)request.getSession().getAttribute("tabSelec"));
         request.getSession().setAttribute("field_to_mod", (String)request.getSession().getAttribute("fiSelec"));

         fs = (String)request.getSession().getAttribute("fiSelec");
%>
  <center><br><br><INPUT class="button"  TYPE="submit" name ="confirm" onClick="document.formulario.action='goConfTable3.action';"  value="Back" >
  <INPUT class="button"  TYPE="submit" name ="confFieldView" onClick="document.formulario.action='setView.action';" value="Continue" ></center><br>

  </form>
   </td>
</table>
</body>
</html>