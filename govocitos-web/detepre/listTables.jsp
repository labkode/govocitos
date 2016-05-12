<%@page import="es.uvigo.ei.lia.ddms.GraphVizWrapper"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="es.uvigo.ei.lia.ddms.vcs.metadata.DBase"%>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" import="java.util.*" %>
<%@ page import="es.uvigo.ei.lia.ddms.dms.db.*" %>
<%@ page import="es.uvigo.ei.lia.ddms.dms.da.*" %>
<%@ page import="es.uvigo.ei.lia.ddms.dms.view.*" %>
<jsp:include page="checkLogin.jsp" />
<link href="<s:url value="/css/styles.css"/>" rel="stylesheet" type="text/css"/>
<script type='text/javascript'>
function goTable(obj) {
    if (obj.value != "1") {
        if (obj.name=="listTables") document.getElementById('formTableList').pageData.value = "0";
        document.getElementById("formTableList").submit();
    }
}
function mouseOverTR(obj,x) {
    if(x==1)
        obj.setAttribute("bgcolor", "f0f0f0");
    else
        obj.setAttribute("bgcolor","#dfdfdf");
}
function mouseOutTR(obj,x) {
    if(x==1)
        obj.setAttribute("bgcolor", "ffffff");
    else
        obj.setAttribute("bgcolor","#cccccc");
}
function mostrarOcultar(obj){
    diagramaER.style.visibility = (obj.checked) ? 'visible' : 'hidden';
    diagramaER.style.width = (obj.checked) ? '400' : '0';
    diagramaER.style.height = (obj.checked) ? '300' : '0';
    document.getElementById('formTableList').checkDia.value = "1";
    document.getElementById("formTableList").submit();
}

function showForeignRelationship(obj1, obj2) {
    var form = document.getElementById('formItemData'+obj1);
    form.selectedForeignRelationships.value = obj2;
    form.submit();
}
function writeValue(id) {
    var leftContent = document.getElementById('sentence').value.substring(0,document.getElementById('sentence').selectionStart);
    var rightContent = document.getElementById('sentence').value.substring(document.getElementById('sentence').selectionEnd,document.getElementById('sentence').value.length);
    if (id.type == 'text') {
        document.getElementById('sentence').value = leftContent+"\""+id.value+"\""+rightContent;
    }else if (id.type == 'button') {
        if (id.id == 'leftParenthesis') document.getElementById('sentence').value = leftContent+"("+rightContent;
        else document.getElementById('sentence').value = leftContent+")"+rightContent;
    }else {
        if (id.selectedIndex != 0) document.getElementById('sentence').value = leftContent+id.options[id.selectedIndex].text+rightContent;
    }
    if (document.getElementById('sentence').value.substring(document.getElementById('sentence').value.length-1, document.getElementById('sentence').value.length) != ' ')
        document.getElementById('sentence').value = document.getElementById('sentence').value+' ';
}
function clickedInputValue(obj) {
    if (obj.value == '-- Write a value --') {
        obj.value='';
        obj.style.color = '#000000';
    }
}
function bluredInputValue(obj) {
    obj.value='-- Write a value --';
    obj.style.color = '#b8b8b8';
}
</script>
<html>
      <%Properties prop = WebProperties.getProperties(new java.io.File(this.getClass().getResource("/web.properties").getFile()));
        DBase Base_user = new DBase(prop.getProperty("database_name"));
        Base_user.setServer(prop.getProperty("database_server"));
        Base_user.setUser(prop.getProperty("database_user"));
        Base_user.setPass(prop.getProperty("database_password"));
        Base_user.setPort(prop.getProperty("database_port"));
        Base_user.connectDB(prop.getProperty("dbms"));
        String iconpath = "";
        String logopath = "";
        String logolink = "";
        Vector<String> sponsorpath = new Vector<String>();
        Vector<String> sponsorlink= new Vector<String>();
        Connection connection = Base_user.getCon();
        Statement statement = connection.createStatement();
        try {
            statement.executeQuery("select * from internal_images");
        }catch(Exception e){
            statement.executeUpdate("CREATE TABLE internal_images (name varchar(20), description varchar(200), type varchar (20), path varchar (200), link varchar (200))");
        }finally {
            String sentenceSQL = "SELECT * from internal_images WHERE type = 'logo'";
            ResultSet resultQuery = statement.executeQuery(sentenceSQL);
            if (resultQuery.next()){
                logopath = resultQuery.getString("path");
                logolink = resultQuery.getString("link");
            }
            sentenceSQL = "SELECT * from internal_images WHERE type = 'icon'";
            resultQuery = statement.executeQuery(sentenceSQL);
            if (resultQuery.next()){
                iconpath = resultQuery.getString("path");
            }
            sentenceSQL = "SELECT * from internal_images WHERE type = 'sponsor'";
            resultQuery = statement.executeQuery(sentenceSQL);
            int i = 0;
            while(resultQuery.next()){
                sponsorpath.add(new String(resultQuery.getString("path")));
                sponsorlink.add(new String(resultQuery.getString("link")));
                i++;
            }
            resultQuery.close();
        }%>
       <link rel="shortcut icon" href="<%=iconpath%>"/>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>List of items</title>
    </head>
    <body>
    <table class="bordeGris" width="90%" align="center" border="0" cellspacing="50" bgcolor="#FFFFFF">
      <tr>
          <%if(!logopath.equals("")){%>
        <td>
            <img src="<%=logopath%>" width="300" height="105"/>
        </td>
        <%}%>
        <td>
            <div align="right">
            <%if(request.getSession().getAttribute("user_role").equals("superadmin")){%>
                 <a href="./webConfiguration/">Configure data base</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
			<%}
			if(request.getSession().getAttribute("user_role").equals("superadmin") || request.getSession().getAttribute("user_role").equals("operator")){%>
			<a href="../detepre/downloads/govocitos/setupGovocitos.exe">Download Govocitos</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
			<%}%>
            <a href="logout.action">Logout</a>
            </div>
        </td>
      </tr>
      <tr>
        <td colspan="2">
        <s:if test="%{!#request.tables}">
            <s:action name="listTable"/>
        </s:if>
        <%Vector<Table> vTables = (Vector<Table>)request.getAttribute("tables");
        String tableSelected = (String)request.getAttribute("tableSelected");
        Table tableData = (Table)request.getAttribute("tableData");
        String maxNumRows = (String)request.getAttribute("maxNumRows");
        if (maxNumRows == null) maxNumRows = "10";
        String pageData = (String)request.getAttribute("pageData");
        if (pageData == null) pageData = "0";
        String sentence = (String)request.getAttribute("sentence");
        if (sentence == null) sentence = "";
        String val="";%>

        <s:actionerror/>
        <s:form id="formTableList" action="listTable" method="POST">
            <input type="hidden" name="checkDia" value="0">
            <!--Diagrama estructura BD más comprobaciones-->
            <%if(new java.io.File(prop.getProperty("absolute_final_path")+"out.gif").exists()){
                String valu = (String) request.getSession().getAttribute("checkDiagramaValor");
                out.print("<tr><td>");%>
                    View diagram: <input type="checkbox" name="verDiag" <%out.print(valu);%> onClick="mostrarOcultar(this);"><%out.print("</td><td>");%>
                    <img name="diagramaER" style="<%if(valu.equals("")) out.print("visibility:hidden"); else out.print(val); %>" border="0" width="<%if(valu.equals("")) out.print("0"); else out.print("400"); %>" height="<%if(valu.equals("")) out.print("0"); else out.print("300"); %>" src="<% out.print(prop.getProperty("relative_final_path")+"out.gif");%>">
                <%out.print("</tr></td>");%>
            <%}%>
            <tr>
                <td>Selected table:</td>
                <td><select class="style33" name="listTables" onchange="javascript:goTable(this);">
                <option value="1">-- Please Select --</option>
                <%for (int i=0; vTables != null && i<vTables.size(); i++) {
                        if (vTables.get(i).getVisibleTableName().equals(tableSelected)) {%>
                        <option selected value="<%= vTables.get(i).getVisibleTableName() %>"><%= vTables.get(i).getVisibleTableName() %></option>
                    <%}else{%>
                        <option value="<%= vTables.get(i).getVisibleTableName() %>"><%= vTables.get(i).getVisibleTableName() %></option>
                    <%}
                    }%>
            </select>
                </td>
            </tr>
            <tr>
                <td>Number of rows:</td>
                <td>
                <select class="style33" name="maxRows" onchange="javascript:goTable(this);">
                <option <% if (maxNumRows.equals("10")) out.print("selected"); %> value="10">10</option>
                <option <% if (maxNumRows.equals("50")) out.print("selected"); %> value="50">50</option>
                <option <% if (maxNumRows.equals("100")) out.print("selected"); %> value="100">100</option>
                <option <% if (maxNumRows.equals("200")) out.print("selected"); %> value="200">200</option>
            </select>
            <input type="hidden" name="pageData" value="<%= pageData %>">
                </td>
            </tr>
        </s:form>
        <%if (tableData != null) {
            PrimaryKey pk = tableData.getModel().getPrimaryKey();
            Vector<Relationship> relationships = tableData.getModel().getLRelationships();
            Vector<Field> fields;
            if(request.getSession().getAttribute("user_role").equals("superadmin"))
                fields = tableData.getModel().getLFields();
            else fields = tableData.getModel().orderFields();
            Vector<Registry> registries = tableData.getLRegistries();
            Vector<Field> sharedFields = tableData.getModel().getFieldsSoftEntities();
            int numColumns = 0;
            if (fields != null) numColumns += fields.size();
            if (pk != null) numColumns += pk.getPrimaryFields().size();
            if (relationships != null) numColumns += relationships.size();
            if (numColumns > 5) numColumns = 5; // Como maximo solo muestro 5 columnas de datos. Para ver el resto hay que ver los detalles 
            numColumns += 1; // Le aÃ±ado una columna para el link "Show details"
        %>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                <th width="10" rowspan="<%= registries.size()*2+5 %>" scope="col">&nbsp;</th>
                    <th colspan="<%= numColumns-1 %>" scope="col">
                        <table border="0" cellspacing="3" cellpadding="0">
                            <tbody>
                                <tr>
                                    <td colspan="13">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="6">Advanced Search:</td>
                                    <td colspan="7" align="right"><a href="#" onclick="javascript:window.open('searchHelp.html','helpWindow')">Help</a></td>
                                </tr>
                                <tr>
                                    <td><input id="leftParenthesis" class="style33" type="button" value=" ( " onclick="writeValue(this);"></td>
                                    <td></td>
                                    <td>
                                        <select class="style33" id="field" onchange="writeValue(this);" onblur="this.options[0].selected = true;">
                                            <option selected>-- Select field --</option>
                                            <%for (int i=0; i<pk.getPrimaryFields().size(); i++) {
                                                out.write("<option>"+tableData.getVisibleTableName().replace(' ', '_')+"."+pk.getPrimaryFields().get(i).getConfInfo().getVisibleName().replace(' ', '_')+"</option>");
                                            }
                                            // Getting all table fields and all fields of each relationship of the table
                                            Vector<String> fieldsAndRelationships = DataOperator.getAllFieldsAndRelationship(tableData);
                                            Collections.sort(fieldsAndRelationships);
                                            for (int i=0; i<fieldsAndRelationships.size(); i++) {
                                                out.write("<option>"+fieldsAndRelationships.get(i).replace(' ', '_')+"</option>");
                                            }%>
                                        </select>
                                    </td>
                                    <td></td>
                                    <td>
                                        <select class="style33" id="relationalOperator" onchange="writeValue(this);" onblur="this.options[0].selected = true;">
                                            <option selected>-- Select relational operator --</option>
                                            <option>=</option>
                                            <option><></option>
                                            <option>></option>
                                            <option>>=</option>
                                            <option><</option>
                                            <option><=</option>
                                        </select>
                                    </td>
                                    <td></td>
                                    <td><input class="style33InputEmpty" id="value" type="text" size="15" value="-- Write a value --" onclick="clickedInputValue(this);" onblur="bluredInputValue(this);" onchange="writeValue(this);"></td>
                                    <td></td>
                                    <td><input id="rightParenthesis" class="style33" type="button" value=" ) " onclick="writeValue(this);"></td>
                                    <td></td>
                                    <td>
                                        <select class="style33" id="logicalOperator" onchange="writeValue(this);" onblur="this.options[0].selected = true;">
                                            <option selected>-- Select logical operator --</option>
                                            <option>and</option>
                                            <option>or</option>
                                        </select>
                                    </td>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="13"></td>
                                </tr>
                                <tr>
                                    <form id="formGoSearch" action="listTable.action" method="post">
                                        <td colspan="11"><input id="sentence" name="sentence" type="text" value='<%= sentence %>' style="width:100%; font-family: Tahoma; font-size: 11px; color:#384d93;"></td>
                                        <td>
                                            <input class="style33" type="submit" name="find" value="Find">
                                            <input type="hidden" name="listTables" value="<%=tableSelected%>">
                                            <input type="hidden" name="maxRows" value="<%=maxNumRows%>">
                                            <input type="hidden" name="pageData" value="<%= pageData %>">
                                        </td>
                                        <td><input class="style33" type="button" value="Clean" onclick="document.getElementById('sentence').value='';"></td>
                                    </form>
                                </tr>
                                <tr style="height:6px;">
                                    <td colspan="13"></td>
                                </tr>
                            </tbody>
                        </table>
                    </th>
                    <th width="102" scope="col" align="right" valign="bottom">
                        <form id="formDoAddNewItem" action="addNewItem.action" method="post">
                            <input type="hidden" name="sentence" value='<%= sentence %>'>
                            <input type="hidden" name="listTables" value="<%=tableSelected%>">
                            <input type="hidden" name="maxRows" value="<%=maxNumRows%>">
                            <input type="hidden" name="pageData" value="<%= pageData %>">
                            <%if((tableData.isAddNew() || request.getSession().getAttribute("user_role").equals("superadmin")) && !request.getSession().getAttribute("user_role").equals("guest")){%>
                                <a href="#" onclick="javascript: document.getElementById('formDoAddNewItem').submit();">+ Add new item</a>
                            <%}%>
                        </form>
                        <form id="formExport" action="exportCSV.action" method="post">
                            <input type="hidden" name="sentence" value='<%= sentence %>'>
                            <input type="hidden" name="listTables" value="<%=tableSelected%>">
                            <input type="hidden" name="maxRows" value="<%=maxNumRows%>">
                            <input type="hidden" name="pageData" value="<%= pageData %>">
                            <%if(tableData.getLRegistries().size() > 0){%>
                              <a href="#" onclick="javascript: document.getElementById('formExport').submit();">+ Export</a>
                            <%}%>
                        </form>
                    </th>
                    </tr>
                
                    <th width="10" rowspan="<%= registries.size()*2+5 %>" scope="col">&nbsp;</th>
                      </tr>
                      </table>
                <script type='text/javascript' src='./JavaScript/resizable-tables.js'></script>

                <table width ="100%" class="resizable" cellspacing="2">
                      <tr style="height:25px;">
                    <%int numColumnsCanShow = 5; // Maximo de columnas que podemos mostrar
                    if (pk != null) {
                        for (int i=0; i<pk.getPrimaryFields().size() && numColumnsCanShow != 0; i++) {
                            if (!tableData.getModel().contains(sharedFields, pk.getPrimaryFields().get(i))) {%>
                                <th bgcolor='C6D5D9'><div align='left' style='padding-left:15px; color: #384d93;'><strong><%= pk.getPrimaryFields().get(i).getConfInfo().getVisibleName() %></strong></div></th>
                                <%numColumnsCanShow--; // Ya me quedan menos columnas para poder mostrar
                            }
                        }
                    }%>
                    <%if (relationships != null) {
                        for (int i=0; i<relationships.size() && numColumnsCanShow != 0; i++) {%>
                            <th bgcolor='C6D5D9'><div align='left' style='padding-left:15px; color: #384d93;'><strong><%= relationships.get(i).getRelationshipVisibleName() %></strong></div></th>
                            <%numColumnsCanShow--;
                        }
                    }%>

                    <%if (fields != null) {
                        fields = tableData.getModel().orderFields();
                        for (int i=0; i<fields.size() && numColumnsCanShow != 0; i++) {%>
                                <th bgcolor='C6D5D9'><div align='left' style='padding-left:15px; color: #384d93;'><strong><%= fields.get(i).getConfInfo().getVisibleName() %></strong></div></th>
                                <%numColumnsCanShow--;
                        }
                    }%>
                            <td bgcolor='C6D5D9'></td>
				  </tr>
                  <%for (int i=0; i<registries.size(); i++) {
                      numColumnsCanShow = 5;%>
                  <form id="formItemData<%=i%>" action="showItemData.action" method="post">
                    <% if(i % 2 == 0){%>
                        <tr style="height:20px;" bgcolor="#ffffff" onmouseover="javascript:mouseOverTR(this,1);" onmouseout="javascript:mouseOutTR(this,1);">
                    <%}else{%>
                        <tr style="height:20px;" bgcolor="#cccccc" onmouseover="javascript:mouseOverTR(this,0);" onmouseout="javascript:mouseOutTR(this,0);">
                        <%}%>
                        <input type="hidden" name="sentence" value='<%= sentence %>'>
                        <input type="hidden" name="listTables" value="<%=tableSelected%>">
                        <input type="hidden" name="maxRows" value="<%=maxNumRows%>">
                        <input type="hidden" name="pageData" value="<%= pageData %>">
                        <input type="hidden" name="selectedForeignRelationships" value="">
                        <%if (pk != null) {
                            for (int x=0; x<registries.get(i).getPrimaryKey().getPrimaryFields().size() && numColumnsCanShow != 0; x++) {%>
                                <input type="hidden" name="<%= registries.get(i).getPrimaryKey().getPrimaryFields().get(x).getName() %>" value="<%= registries.get(i).getPrimaryKey().getPrimaryFields().get(x).getValue() %>">
                        <%if (!tableData.getModel().contains(sharedFields, pk.getPrimaryFields().get(x))) {
                                    if (pk.getPrimaryFields().get(x).getConfInfo().getHtmlControl() instanceof File) {%>
                                        <td><a style="padding-left:15px;" href="<%= registries.get(i).getPrimaryKey().getPrimaryFields().get(x).getValue() %>">View file</a></td>
                                <%}else{%>
                                        <td><div style="padding-left:15px;"><%= registries.get(i).getPrimaryKey().getPrimaryFields().get(x).getValue() %></div></td>
                                    <%}
                                    numColumnsCanShow--;
                                }
                            }
                        }%>
                        <%if (relationships != null) {
                            for (int x = 0; x < registries.get(i).getLRelationships().size() && numColumnsCanShow != 0; x++) {
                                String foreingKeyMerged = "";
                                for (int y = 0; y < registries.get(i).getLRelationships().get(x).getForeignVisibleFields().size(); y++) {
                                    if ((y+1) == registries.get(i).getLRelationships().get(x).getForeignVisibleFields().size())
                                        foreingKeyMerged += registries.get(i).getLRelationships().get(x).getForeignVisibleFields().get(y).getValue();
                                    else 
                                        foreingKeyMerged += registries.get(i).getLRelationships().get(x).getForeignVisibleFields().get(y).getValue()+"-";
                                }
                                // Used to show foreign data if we click it
                                request.getSession().setAttribute("foreignRelationship"+i+registries.get(i).getLRelationships().get(x).getRelationshipName(), registries.get(i).getLRelationships().get(x));%>
                            <%if(registries.get(i).getLRelationships().get(x).getForeignTable().isConsult() || (request.getSession().getAttribute("user_role").equals("superadmin"))){%>
                                    <td>
                                    <input type="hidden" name="<%= registries.get(i).getLRelationships().get(x).getRelationshipName() %>" value="<%= foreingKeyMerged %>">
                                    <div style="padding-left:15px;"><a href="#" onclick="javascript:showForeignRelationship(<%=i%>,'foreignRelationship<%= i+registries.get(i).getLRelationships().get(x).getRelationshipName() %>');"><%= foreingKeyMerged %></a></div></td>
                            <%}else{%>
                                    <td><div style="padding-left:15px;"><%= foreingKeyMerged %></div></td>
                                    <%}
                                numColumnsCanShow--;
                            }
                        }%>
                        <%if (fields != null) {
                            fields = tableData.getModel().getLFields();
                            //for (int x=0; x < registries.get(i).getLFields().size() && numColumnsCanShow != 0; x++) {
                            for (int x=0; x < fields.size() && numColumnsCanShow != 0; x++) {
                                //if(fields.get(x).getConfInfo().getVisible()){
                                Field f = Model.getFieldValue(fields.get(x).getName(), registries.get(i).getLFields());
                                if(f != null){
                                    if (fields.get(x).getConfInfo().getHtmlControl() instanceof File) {
                                        if (f.getValue().isEmpty()) {%>
                                            <td>There is not file</td>
                                        <%}else{%>
                                                <td><a style="padding-left:15px;" href="<%= f.getValue() %>">View file</a></td>
                                        <%}
                                    }else if (fields.get(x) instanceof es.uvigo.ei.lia.ddms.dms.db.Boolean) {
                                        String valBool = "";
                                        if (f.getValue().equals("0")) valBool = "No";
                                        else valBool = "Yes";%>
                                        <td><div style="padding-left:15px;"><%= valBool %></div></td>
                                    <%}else {%>
                                            <td><div style="padding-left:15px;"><%= f.getValue() %></div></td>
                                    <%}
                                    numColumnsCanShow--;
                                    }
                            }
                        }%>
                  <td width="100px"><a style="padding-left:15px;" href="#" onclick="javascript:document.getElementById('formItemData<%=i%>').submit();">Show details...</a></td>
                  </tr>
                  </form>
                  <tr class="filaAzul"><td colspan="<%= numColumns %>"></td></tr>
                  <%}%>
                  <tr>
                    <td colspan="<%= numColumns %>">&nbsp;</td>
                  </tr>
                  <tr>
                <td colspan="<%= numColumns %>" align="center">
                        <form id="formPreviousNext" action="listTable.action" method="post">
                            <input type="hidden" name="sentence" value='<%= sentence %>'>
                            <input type="hidden" name="listTables" value="<%=tableSelected%>">
                            <input type="hidden" name="maxRows" value="<%=maxNumRows%>">
                            <input type="hidden" name="pageData" value="<%= pageData %>">
                            <input type="hidden" name="button" value="next">
                            <%if (!pageData.equals("0")) {%>
                                <a href="#" onclick="javascript:document.getElementById('formPreviousNext').button.value='previous';document.getElementById('formPreviousNext').submit();"><<< Previous</a>&nbsp;&nbsp;&nbsp;
                            <%}
                            if (maxNumRows.equals(""+tableData.getLRegistries().size()+"")) {%>
                                <a href="#" onclick="javascript:document.getElementById('formPreviousNext').submit();">Next >>></a>
                            <%}%>
                        </form>
                  </td>
                  </tr>
                  <tr>
                    <td colspan="<%= numColumns %>">&nbsp;</td>
                  </tr>
        </table>
        <%}%>
    </table>
    </body>
</html>
