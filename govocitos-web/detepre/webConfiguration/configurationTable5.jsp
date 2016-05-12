<%-- 
    Document   : configurationTable5
    Created on : Jul 22, 2009, 6:13:27 PM
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
    <%
        //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
       %>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Data Base Fields Configuration</title>
        <link href="./css/main.css" rel="stylesheet" type="text/css"/>
        <link rel="shortcut icon" href="./images/gavidIcon.ico"/>

    <script type='text/javascript'>

        function showER(obj) {
            el = document.getElementById("textER");
            if (obj.value == "3")
               el.style.display = "block";
             else
                 el.style.display = "none";
            }

        function showFileInfo(obj) {
            el = document.getElementById("fileShow");
            if (obj.checked)
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
                String ts = (String)request.getSession().getAttribute("tab_to_mod");
                String fs = (String)request.getSession().getAttribute("field_to_mod");
                //PASAMOS A INT EL NUMERO DE LA TABLA y del campo
               int tableSelected = Integer.parseInt(ts);
               int fieldSelected = Integer.parseInt(fs);
%>

<form id="formFieldProps" action="setProps.action" method="POST">

    <br><INPUT class="button" style='width:130px' TYPE="submit" name ="confFieldProps" value="Continue" ><br>

    <br><INPUT class="button" style='width:152px' TYPE="submit" name ="confFieldProps" value="Configure another field" ><br>

        <br>
<%
             out.println("<br><table border=1><td>");
             out.println("Nullable:");
             //NULLABLE
             out.print("<INPUT TYPE=CHECKBOX");
                    if (Base.getTable(tableSelected).getField(fieldSelected).getIsNullable().equals("NO") &&
                        Base.getTable(tableSelected).getField(fieldSelected).getIsAutoinc().equals("NO"))
                             out.print(" disabled");
                    if (Base.getTable(tableSelected).getField(fieldSelected).getVisNull().equals("YES")
                    && Base.getTable(tableSelected).getField(fieldSelected).getIsNullable().equals("YES"))
                             out.print(" checked");
                    out.println (" NAME=cboxIsNullable ></input><br>");
                    if( Base.getTable(tableSelected).getField(fieldSelected).getIsAutoinc().equals("YES"))
                        out.println("<font size=2><i>-- Autoincrement --</i></font><br>");
              out.println("<br>Error message:<br>");
              out.print("<textarea cols=50 rows=4 name=errorNull >");
              out.print(Base.getTable(tableSelected).getField(fieldSelected).getErrorVisNull());
              out.println("</textarea><br>");
              out.println("</td></table>");

           if (Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("VARCHAR") ||
               Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("INT") ||
               Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("SMALLINT") ||
               Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("TINYINT")||
               Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("BIGINT") ||
               Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("FLOAT")||
               Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("DOUBLE")){
                    out.println("<br><table border=1><td>");
                    //MIN LENGTH
                    out.println ("Min length:<br>");
                    out.println ("<input type=text name=lenMin value=" + Base.getTable(tableSelected).getField(fieldSelected).getMinTam() + " ></input><br>");
                    //MAX LENGTH
                    out.println ("<br>Max length:<br>");
                    out.print ("<input type=text name=lenMax value=" + Base.getTable(tableSelected).getField(fieldSelected).getMaxTam() + " ><br>");
                    //   out.println(Base.getTable(tableSelected).getField(fieldSelected).getLen() + ")<br>");

                     out.println("<br>Error message:<br>");
                     out.print("<textarea cols=50 rows=4 name=errorLen >");
                     out.print(Base.getTable(tableSelected).getField(fieldSelected).getErrorTam());
                     out.println("</textarea><br>");

                     out.println("</td></table>");
            }//HAY Q VALIDAR QUE NO SEA MAYOR QUE EL MAX#######################

            if (Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("VARCHAR") ||
                Base.getTable(tableSelected).getField(fieldSelected).getType_F().equals("CHAR")){
                out.println("<br><table border=1><td>");
                out.println("Input text:<br>");
                out.println("<input type=radio name=inputText ");
                if(Base.getTable(tableSelected).getField(fieldSelected).getInputText().equals("LETTER"))
                    out.println(" checked ");
                out.println("value=0 >Only letters</input><br>");

                out.println("<input type=radio name=inputText ");
                if(Base.getTable(tableSelected).getField(fieldSelected).getInputText().equals("NUM"))
                    out.println(" checked ");
                out.println("value=1 >Only numbers</input><br>");

                out.println("<input type=radio name=inputText ");
                if(Base.getTable(tableSelected).getField(fieldSelected).getInputText().equals("ALL"))
                    out.println(" checked ");
                out.println("value=2 >Letters and numbers</input><br>");

                out.println("<br>Error message:<br>");
                out.print("<textarea cols=50 rows=4 name=errorInput >");
                out.print(Base.getTable(tableSelected).getField(fieldSelected).getErrorInput());
                out.println("</textarea><br>");

                out.println("</td></table>");
             

                out.println("<br><table border=1 ><td>");
                out.println("Format:<br>");

                out.println("<input type=radio name=formatText value=0 ");
                if(Base.getTable(tableSelected).getField(fieldSelected).getFormatText().equals("NONE"))
                    out.println(" checked ");
                out.println("onchange=showER(this) >None</input><br>");

                out.println("<input type=radio name=formatText value=1");
                if(Base.getTable(tableSelected).getField(fieldSelected).getFormatText().equals("EMAIL"))
                    out.println(" checked ");
                out.println(" onchange=showER(this) >E-mail</input><br>");

                out.println("<input type=radio name=formatText value=2 ");
                if(Base.getTable(tableSelected).getField(fieldSelected).getFormatText().equals("URL"))
                    out.println(" checked ");
                out.println(" onchange=showER(this) >URL</input><br>");

                out.println("<input type=radio name=formatText value=3 ");
                if(Base.getTable(tableSelected).getField(fieldSelected).getFormatText().equals("ER"))
                    out.println(" checked ");
                out.println("onchange=showER(this) >Regular Expresion</input><br>");

                if(Base.getTable(tableSelected).getField(fieldSelected).getFormatText().equals("ER"))
                           out.println("<div id=textER style=display:block >");
                else
                           out.println("<div id=textER style=display:none >");
                out.println("<input type=text name=ERtext value='" + Base.getTable(tableSelected).getField(fieldSelected).getEerr() + "' ></input></div>");

                out.println("<br>Error message:<br>");
                out.println("<textarea cols=50 rows=4 name=errorFormat >" + Base.getTable(tableSelected).getField(fieldSelected).getErrorFormat() + "</textarea><br>");
                out.println("</td></table>");
          }
      else{
            out.println("<br><table border=1 ><td>");
            out.println("Input Error message:<br>");
            out.println("<textarea cols=50 rows=4 name=errorInput >");
            out.print(Base.getTable(tableSelected).getField(fieldSelected).getErrorInput());
            out.println("</textarea><br>");
            out.println("</td></table>");
       }


     if (Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("IMAGE") ||
         Base.getTable(tableSelected).getField(fieldSelected).getShowType().equals("FILE")){
            out.println("<br><table border=1 ><td>");
            out.println("File size:<br><input TYPE=text NAME=sizeFile value='" + Base.getTable(tableSelected).getField(fieldSelected).getFileSize() + "' > KB</input><br>");
            out.println("<br>Types Allowed:<br> -one extension in each line<br>");
            out.println("<br> <textarea cols=5 rows=4 name=typesAllowed >" + Base.getTable(tableSelected).getField(fieldSelected).getExtAllowed() + "</textarea><br>");

            out.println("<br>Error message:<br>");
            out.print("<textarea cols=50 rows=4 name=errorFile >");
            out.print(Base.getTable(tableSelected).getField(fieldSelected).getErrorFile());
            out.println("</textarea><br>");
            out.println("</td></table>");
         }

  %>
    <br><INPUT class="button" style='width:130px' TYPE="submit" name ="confFieldProps" value="Continue" ><br>

    <br><INPUT class="button" style='width:152px' TYPE="submit" name ="confFieldProps" value="Configure another field" ><br>

</form>
</td>
    </table>
<br><br><br><br><br><br><br>
    </body>
</html>
