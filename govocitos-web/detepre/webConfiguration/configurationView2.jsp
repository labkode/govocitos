<%--
    Document   : configurationView2
    Created on : Jul 2, 2009, 1:00:14 PM
    Author     : anrodriguez2
--%>
<%@page import="java.util.Vector"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page contentType="text/html" pageEncoding="UTF-8"
import="java.sql.*" import="es.uvigo.ei.lia.ddms.vcs.metadata.*"
import="es.uvigo.ei.lia.ddms.xml.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

   <jsp:include page="checkisAdmin.jsp" />


<html xmlns="http://www.w3.org/1999/xhtml"lang="es" xml:lang="es">
<head>

    <!-- ############ CARGAMOS LOS CSS DE ESTILO ########## -->
<style type="text/css">

@import  url(css/templateCW2.css);

</style>

<style type="text/css" media="print" >

    @import  url(css/templateCW2_2.css);

</style>
    <!-- ############ CARGAMOS LOS CSS DE ESTILO ########## -->



    <!-- ############ DEFINIMOS TODOS LOS CUADROS DEL DRAG AND DROP ########## -->
<script type="text/javascript" src="JavaScript/tableCreation.js"></script>
    <!-- ############ DEFINIMOS TODOS LOS CUADROS DEL DRAG AND DROP ########## -->


</head>
<body>
    <br><font color=red size=2><s:actionerror /></font><br>

<%
             //RECIBIMOS LA BASE DE DATOS DE LA SESION
                DBase Base = (DBase)request.getSession().getAttribute("ses_Base");
             //RECIBIMOS QUE TABLA QUEREMOS MODIFICAR
                String aux = (String)request.getSession().getAttribute("view_mod_table");
             //PASAMOS A INT EL NUMERO DE LA TABLA
                int mod_table = Integer.parseInt(aux);
                
           //     request.getSession().setAttribute("mod_table", aux);


%>


<!-- ############ CREAMOS TODOS LOS CUADROS DEL DRAG AND DROP ########## -->
<div id="dhtmlgoodies_dragDropContainer">
	<div id="topBar">
		<img src="/images/heading3.gif">
	</div>
	<div id="dhtmlgoodies_listOfItems">
		<div>
			<p>Hidden Fields</p>
		<ul id="noVisibleField">

<%
                Vector<String> fkTables = new Vector();
          //METEMOS TODOS LOS CAMPOS DISPONIBLES EN EL CUADRO PRINCIPAL
                for (int i = 0;i<Base.getTable(mod_table).getNumFields();i++ )
                {//1
                    if (Base.getTable(mod_table).getField(i).getVisible().equals("NO")){
                            out.println("<li id="+Base.getTable(mod_table).getField(i).getNameF()+">");
                            if (Base.getTable(mod_table).getField(i).getVisNull().equals("YES"))
                                         out.println(Base.getTable(mod_table).getField(i).getNameF()+"</li> ");
                                    else
                                        out.println("*"+Base.getTable(mod_table).getField(i).getNameF()+"</li> ");
                        }
                    /*if (Base.getTable(mod_table).getField(i).getVisible().equals("NO")){
                            if(Base.getTable(mod_table).getField(i).getIsfk().equals("YES") && !fkTables.contains(Base.getTable(mod_table).getField(i).getFkTable())){
                                out.println("<li id="+Base.getTable(mod_table).getField(i).getFkTable()+">");
                                out.println("*"+Base.getTable(mod_table).getField(i).getFkTable()+"</li> ");
                                fkTables.add(Base.getTable(mod_table).getField(i).getFkTable());
                            }else{
                                out.println("<li id="+Base.getTable(mod_table).getField(i).getNameF()+">");
                                if (Base.getTable(mod_table).getField(i).getVisNull().equals("YES"))
                                             out.println(Base.getTable(mod_table).getField(i).getNameF()+"</li> ");
                                        else
                                            out.println("*"+Base.getTable(mod_table).getField(i).getNameF()+"</li> ");
                            }
                        }*/
                }//1
                //fkTables.clear();
          
%>
		</ul>
		</div>
	</div>
	<div id="dhtmlgoodies_mainContainer">
		<!-- ONE <UL> for each "room" -->
        <%
     //CREAMOS TODOS LOS CUADROS RECIPIENTES DONDE SE ARRASTRARAN LOS CAMPOS
        int rowAux = 0;
        int colAux = 0;
         for (int i = 0;i<Base.getTable(mod_table).getNumFields()*10;i++){
                if ((i % 10) == 0 && i != 0){
                        rowAux++;
                        colAux=0;
                    }
                if (i < 100)//para poner ceros delante del numero
                     if (i < 10)
                         out.print("<div><ul id=box00"+i+" boder=0> ");
                     else
                         out.print("<div><ul id=box0"+i+" boder=0> ");
                else
                   out.print("<div><ul id=box"+i+" boder=0> ");
                //paso a int las filas y las columnas para compararlas con las variables integer
                for (int j = 0;j<Base.getTable(mod_table).getNumFields();j++ ){//1
                    if (Base.getTable(mod_table).getField(j).getVisible().equals("YES"))
                        if ((java.lang.Integer.parseInt(Base.getTable(mod_table).getField(j).getRow()) == rowAux) && (java.lang.Integer.parseInt(Base.getTable(mod_table).getField(j).getColumn()) == colAux))
                                {
                                    out.print(" <li id="+Base.getTable(mod_table).getField(j).getNameF()+" >");
                                   if (Base.getTable(mod_table).getField(j).getVisNull().equals("YES"))
                                         out.println(Base.getTable(mod_table).getField(j).getNameF()+"</li> ");
                                    else
                                        out.println("*"+Base.getTable(mod_table).getField(j).getNameF()+"</li> ");
                                }
                    /*if (Base.getTable(mod_table).getField(j).getVisible().equals("YES")){
                        if(Base.getTable(mod_table).getField(j).getIsfk().equals("YES") && !fkTables.contains(Base.getTable(mod_table).getField(j).getFkTable())){
                            if ((java.lang.Integer.parseInt(Base.getTable(mod_table).getField(j).getRow()) == rowAux) && (java.lang.Integer.parseInt(Base.getTable(mod_table).getField(j).getColumn()) == colAux)){
                                out.print(" <li id="+Base.getTable(mod_table).getField(j).getFkTable()+" >");
                                out.println("*"+Base.getTable(mod_table).getField(j).getFkTable()+"</li> ");
                                fkTables.add(Base.getTable(mod_table).getField(j).getFkTable());
                            }
                        }else{
                            if ((java.lang.Integer.parseInt(Base.getTable(mod_table).getField(j).getRow()) == rowAux) && (java.lang.Integer.parseInt(Base.getTable(mod_table).getField(j).getColumn()) == colAux) && Base.getTable(mod_table).getField(j).getIsfk().equals("NO")){
                                out.print(" <li id="+Base.getTable(mod_table).getField(j).getNameF()+" >");
                                if (Base.getTable(mod_table).getField(j).getVisNull().equals("YES"))
                                     out.println(Base.getTable(mod_table).getField(j).getNameF()+"</li> ");
                                else
                                    out.println("*"+Base.getTable(mod_table).getField(j).getNameF()+"</li> ");
                            }
                        }
                    }*/
                }//1
                out.println(" </ul></div>");
                colAux++;
              }
        %>
	</div>
</div>

<!-- ############ FORMULARIO CON EL BOTON SAVE ########## -->
<form name="myForm" method="post" action="goConfView3.action" onsubmit="saveDragDropNodes()">
<input type="hidden" name="listOfItems" value="">
<div id="footer">
<input type="button" value="Back" name="backButton" onclick="window.location ='goConfView.action'">
<input type="submit" value="Save" name="saveButton">
</div>
</form>



<ul id="dragContent"></ul>
<div id="dragDropIndicator"><img src="images/insert.gif"></div>
<div id="saveContent"><!-- THIS ID IS ONLY NEEDED FOR THE DEMO --></div>
</body>
</html>
      <!--      <button type="button" OnClick=>Save View</button>
            <br><br><br><A href="configurationView.jsp">Back</A><br>  -->
