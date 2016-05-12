<%@page import="java.sql.ResultSet"%>
<%@page import="es.uvigo.ei.lia.ddms.vcs.metadata.DBase"%>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" import="java.util.*" %>
<%@ page import="es.uvigo.ei.lia.ddms.dms.db.*" %>
<%@ page import="es.uvigo.ei.lia.ddms.dms.view.*" %>
<jsp:include page="checkLogin.jsp" />
<link href="<s:url value="/css/styles.css"/>" rel="stylesheet" type="text/css"/>
<html>
     <%
        Properties prop = WebProperties.getProperties(new java.io.File(this.getClass().getResource("/web.properties").getFile()));
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
            //Cogemos el path del properties
        }
       %>
       <link rel="shortcut icon" href="<%=iconpath%>"/>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>New item</title>
    </head>
    <body>
        <%
        Table table = (Table)request.getAttribute("table");
        PrimaryKey pk = null;
        Vector<Relationship> relationships = null;
        Vector<Field> fields = null;
        String limpiar = (String)request.getAttribute("limpiar");
        %>
    <table class="bordeGris" width="90%" align="center" border="0" cellspacing="50" bgcolor="#FFFFFF">
      <tr>
        <td>
            <%if(!logopath.equals("")){%>
            <img src="<%=logopath%>" width="300" height="105"/>
            <%}%>
        </td>
        <td>
            <div align="right">
            <%if(request.getSession().getAttribute("user_role").equals("superadmin")){%>
            <a href="./webConfiguration/">Configure data base</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
            <%}%>
            <a href="logout.action">Logout</a>
            </div>
        </td>
      </tr>
      <tr>
        <td colspan="2">
        <s:actionerror/>
        <s:actionmessage/><br>
        <form action="listTable.action" method="post">
            <input type="hidden" name="sentence" value='<%= (String)request.getAttribute("sentence") %>'>
            <input type="hidden" name="listTables" value="<%= (String)request.getAttribute("tableSelected") %>">
            <input type="hidden" name="maxRows" value="<%= (String)request.getAttribute("maxNumRows") %>">
            <input type="hidden" name="pageData" value="<%= (String)request.getAttribute("pageData") %>">
            <div align="center">
                Table: <%= table.getVisibleTableName() %>
                </div>
            <input type="submit" class="boton" name="buttonBack" value="< Go back">
        </form>
        <%
        if (table != null) {
            pk = table.getModel().getPrimaryKey();
            relationships = table.getModel().getLRelationships();
            fields = table.getModel().getLFields();
            Vector<Field> sharedFields = table.getModel().getFieldsSoftEntities();
            String asterisk = "";
        %>
            <form id="formAddItemData" enctype="multipart/form-data" action="doAdd.action" method="post">
                <table border="0" cellspacing="8" cellpadding="0">
                    <%
                    if(request.getSession().getAttribute("user_role").equals("superadmin")){
                        if (pk != null) {
                            for (int i=0; i<pk.getPrimaryFields().size(); i++) {
                                if (pk.getPrimaryFields().get(i).getValidator() != null && pk.getPrimaryFields().get(i).getValidator().hasNotNullValidation()) asterisk = "*&nbsp;&nbsp;";
                                if (!table.getModel().contains(sharedFields, pk.getPrimaryFields().get(i))) {
                        %>
                                <tr style="height:25px;">
                                    <td align="right"><strong><%= asterisk+pk.getPrimaryFields().get(i).getConfInfo().getVisibleName() %>:</strong></td>
                                <td>
                                    <%
                                    if (pk.getPrimaryFields().get(i).getConfInfo().getHtmlControl() instanceof File) {
                                    %>
                                    <input type="file" name="<%=pk.getPrimaryFields().get(i).getName()%>" value="">&nbsp;&nbsp;<%= pk.getPrimaryFields().get(i).getConfInfo().getRightMessage() %>

                                    <%
                                    }else {
                                    %>
                                    <input type="text" name="<%=pk.getPrimaryFields().get(i).getName()%>" value="<% if (request.getAttribute(pk.getPrimaryFields().get(i).getName()) != null && limpiar == null ) out.print((String)request.getAttribute(pk.getPrimaryFields().get(i).getName())); else out.print(""); %>">&nbsp;&nbsp;<%= pk.getPrimaryFields().get(i).getConfInfo().getRightMessage() %>
                                    <%
                                    }
                                    %>
                                </td>
                                </tr>
                        <%
                                }
                                asterisk = "";
                            }
                        }
                        %>

                        <%
                        if (relationships != null) {
                            for (int i=0; i<relationships.size(); i++) {
                                if (relationships.get(i).isNotNull()) asterisk = "*&nbsp;&nbsp;";
                        %>
                                <tr style="height:25px;">
                                <td align="right"><strong><%= asterisk+relationships.get(i).getRelationshipVisibleName()  %>:</strong></td>
                                <td><select id="<%= relationships.get(i).getRelationshipName()  %>" name="<%= relationships.get(i).getRelationshipName()  %>">
                                    <%
                                    if (!relationships.get(i).isNotNull()) {
                                        if(limpiar == null){
                                    %>
                                        <option value="">----</option>
                                    <%
                                        }else{
                                    %>
                                            <option selected value="">----</option>
                                    <%
                                        }
                                    }
                                    Table foreignTableData = (Table)request.getAttribute("tableData"+relationships.get(i).getForeignTable().getTableName());
                                    for (int x=0; x<foreignTableData.getLRegistries().size(); x++) {
                                        String mergedForeignPrimaryKeys = "";
                                        for (int y=0; y<foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().size(); y++) {
                                            if ((y+1)==foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().size())
                                                mergedForeignPrimaryKeys += foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getValue();
                                            else
                                                mergedForeignPrimaryKeys += foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getValue()+"##";
                                        }

                                        String mergedForeignVisibleFields = "";
                                        for (int w = 0; w < relationships.get(i).getForeignVisibleFields().size(); w++) {
                                            for (int y = 0; y < foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().size(); y++) {
                                                if (foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getName().equals(relationships.get(i).getForeignVisibleFields().get(w).getName()))
                                                    mergedForeignVisibleFields += foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getValue()+"-";
                                            }
                                            for (int y=0; foreignTableData.getLRegistries().get(x).getLRelationships()!=null && y<foreignTableData.getLRegistries().get(x).getLRelationships().size(); y++) {
                                                for (int c=0; c<foreignTableData.getLRegistries().get(x).getLRelationships().get(y).getForeignFields().size(); c++) {
                                                    if (foreignTableData.getLRegistries().get(x).getLRelationships().get(y).getForeignFields().get(c).getName().equals(relationships.get(i).getForeignVisibleFields().get(w).getName())
                                                        && !table.getModel().contains(sharedFields, relationships.get(i).getForeignVisibleFields().get(w)))
                                                        mergedForeignVisibleFields += foreignTableData.getLRegistries().get(x).getLRelationships().get(y).getForeignFields().get(c).getValue()+"-";
                                                }
                                            }
                                            if(foreignTableData.getLRegistries().get(x).getLFields() != null){
                                                for (int y=0; y<foreignTableData.getLRegistries().get(x).getLFields().size(); y++) {
                                                    if (foreignTableData.getLRegistries().get(x).getLFields().get(y).getName().equals(relationships.get(i).getForeignVisibleFields().get(w).getName()))
                                                        mergedForeignVisibleFields += foreignTableData.getLRegistries().get(x).getLFields().get(y).getValue()+"-";
                                                }
                                            }
                                        }

                                        mergedForeignVisibleFields = mergedForeignVisibleFields.substring(0, (mergedForeignVisibleFields.length()-1));

                                        if (mergedForeignPrimaryKeys.equals((String)request.getAttribute(relationships.get(i).getRelationshipName()))) {
                                            if(limpiar == null){
                                    %>
                                                <option selected value="<%= mergedForeignPrimaryKeys %>"><%= mergedForeignVisibleFields %></option>
                                    <%
                                            }else{%>
                                                <option value="<%= mergedForeignPrimaryKeys %>"><%= mergedForeignVisibleFields %></option>
                                            <%}
                                        }else{
                                    %>
                                        <option value="<%= mergedForeignPrimaryKeys %>"><%= mergedForeignVisibleFields %></option>
                                    <%
                                        }
                                    }
                                    %>
                                </select></td>
                                </tr>
                        <%
                                asterisk = "";
                            }
                        }
                        %>

                        <%
                        if (fields != null) {
                            for (int i=0; i<fields.size(); i++) {
                                asterisk = "";
                                if (fields.get(i).getValidator() != null && fields.get(i).getValidator().hasNotNullValidation()) asterisk = "*&nbsp;&nbsp;";
                        %>
                                <tr style="height:25px;">
                                <%if(!fields.get(i).getName().equals("md5")){%>
                                    <td align="right"><strong><%= asterisk+fields.get(i).getConfInfo().getVisibleName() %>:</strong></td>
                                <%}%>
                                <td>
                                <%
                                    if (fields.get(i).getConfInfo().getHtmlControl() instanceof File) {
                                %>
                                        <input type="file" name="<%= fields.get(i).getName() %>" value="">&nbsp;&nbsp;<%= fields.get(i).getConfInfo().getRightMessage() %>
                                <%
                                    }else if (fields.get(i) instanceof es.uvigo.ei.lia.ddms.dms.db.Boolean) {
                                %>
                                        <input type="checkbox" name="<%= fields.get(i).getName() %>" <% if (request.getAttribute(fields.get(i).getName()) != null && limpiar == null && ((String)request.getAttribute(fields.get(i).getName())).equals("on")) out.print("checked");%> >&nbsp;&nbsp;<%= fields.get(i).getConfInfo().getRightMessage() %>
                                <%
                                    }else if (fields.get(i) instanceof es.uvigo.ei.lia.ddms.dms.db.Timestamp) {
                                 %>
                                        <input type="text" name="<%= fields.get(i).getName() %>" value="<% if (request.getAttribute(fields.get(i).getName()) != null && limpiar == null) out.print((String)request.getAttribute(fields.get(i).getName())); else out.print(""); %>">&nbsp;&nbsp;<%= fields.get(i).getConfInfo().getRightMessage() %>
                                <%
                                    }else if (fields.get(i).getConfInfo().getHtmlControl() instanceof SelectList) {
                                        Field field = (Field)fields.get(i);
                                        SelectList select = (SelectList)fields.get(i).getConfInfo().getHtmlControl();
                                %>
                                        <select name="<%= field.getName() %>">
                                <%
                                            for (int x=0; x<select.getOptionsValues().size(); x++) {
                                                String optionValue = select.getOptionsValues().get(x);
                                                if (request.getAttribute(field.getName()) != null && optionValue.equals(request.getAttribute(field.getName()))) {
                                            %>
                                                <option selected value="<%= optionValue %>"><%= optionValue %></option>
                                            <%
                                                }else{
                                            %>
                                                <option value="<%= optionValue %>"><%= optionValue %></option>
                                            <%
                                                }
                                            }
                                            %>
                                        </select>&nbsp;&nbsp;<%= field.getConfInfo().getRightMessage() %>
                                <%
                                    }else{
                                        if (fields.get(i).getConfInfo().getHtmlControl() instanceof RadioButton) {
                                            Field field = (Field)fields.get(i);
                                            RadioButton select = (RadioButton)fields.get(i).getConfInfo().getHtmlControl();
                                                for (int x=0; x<select.getOptionsValues().size(); x++) {
                                                    String optionValue = select.getOptionsValues().get(x);
                                                    if (request.getAttribute(field.getName()) != null && optionValue.equals(request.getAttribute(field.getName()))) {
                                                %>
                                                    <input checked type="radio" name="<%= field.getName() %>" value="<%=optionValue%>"><%= optionValue %></input>
                                                <%
                                                    }else{
                                                    %>
                                                        <input type="radio" name="<%= field.getName() %>" value="<%=optionValue%>"><%= optionValue %></input>
                                                    <%
                                                    }
                                                }
                                                %>
                                                &nbsp;&nbsp;<%= field.getConfInfo().getRightMessage() %>
                                        <%
                                        }else{
                                            if(!fields.get(i).getName().equals("md5")){
                                     %>
                                            <input type="text" name="<%= fields.get(i).getName() %>" value="<% if (request.getAttribute(fields.get(i).getName()) != null && limpiar == null) out.print((String)request.getAttribute(fields.get(i).getName())); else out.print(""); %>">&nbsp;&nbsp;<%= fields.get(i).getConfInfo().getRightMessage() %>
                                    <%
                                            }
                                        }
                                %>
                                </td>
                                </tr>
                        <%
                                asterisk = "";
                            }
                        }
                    }
                }else{//Si el usuario no es administrador aplicamos lo configurado
                        //fmax=numero máximo de filas, cmax=numero máximo de columnas
                        //f=contador de filas, c=contador de columnas
                        //ind controlador de si el campo es Fk, Pk, o field
                    List<String> fkused = new ArrayList<String>();
                    int fmax = table.getModel().maxRow(), f = 0, cmax, c= 0, ind = 0;
                    boolean isFk = false;
                    while(f <= fmax){
                        cmax = table.getModel().maxCol(f);
                        c=0;
                        while(c <= cmax){
                            ind = table.getModel().getFieldPorPosicion(f, c, 1);
                            if(ind == -1){//FK
                                ind = table.getModel().getFieldPorPosicion(f, c, 0);
                                if(ind == -1){//PK
                                    ind = table.getModel().getFieldPorPosicion(f, c, 2);
                                    if(ind != -1){//Fields
                                        asterisk = "";
                                        if(c==0)%> <tr style="height:25px;"><td width="60"></td><%
                                        if (fields.get(ind).getValidator() != null && fields.get(ind).getValidator().hasNotNullValidation()) asterisk = "*&nbsp;&nbsp;";
                                        if(!fields.get(ind).getName().equals("md5")){%>
                                        <td align="right"><strong><%= asterisk+fields.get(ind).getConfInfo().getVisibleName() %>:</strong></td>
                                        <%}%>
                                        <td>
                                        <%
                                        if (fields.get(ind).getConfInfo().getHtmlControl() instanceof File) {
                                        %>
                                            <input type="file" name="<%= fields.get(ind).getName() %>" value="">&nbsp;&nbsp;<%= fields.get(ind).getConfInfo().getRightMessage() %>
                                        <%
                                        }else if (fields.get(ind) instanceof es.uvigo.ei.lia.ddms.dms.db.Boolean) {
                                            %>
                                                <input type="checkbox" name="<%= fields.get(ind).getName() %>" <% if (request.getAttribute(fields.get(ind).getName()) != null && limpiar == null && ((String)request.getAttribute(fields.get(ind).getName())).equals("on")) out.print("checked");%> >&nbsp;&nbsp;<%= fields.get(ind).getConfInfo().getRightMessage() %>
                                            <%
                                            }else if (fields.get(ind) instanceof es.uvigo.ei.lia.ddms.dms.db.Timestamp) {
                                                %>
                                                    <input type="text" name="<%= fields.get(ind).getName() %>" value="<% if (request.getAttribute(fields.get(ind).getName()) != null && limpiar == null) out.print((String)request.getAttribute(fields.get(ind).getName())); else out.print(""); %>">&nbsp;&nbsp;<%= fields.get(ind).getConfInfo().getRightMessage() %>
                                                <%
                                                }else if (fields.get(ind).getConfInfo().getHtmlControl() instanceof SelectList) {
                                                        Field field = (Field)fields.get(ind);
                                                        SelectList select = (SelectList)fields.get(ind).getConfInfo().getHtmlControl();
                                                        %>
                                                        <select name="<%= field.getName() %>">
                                                        <%
                                                        for (int x=0; x<select.getOptionsValues().size(); x++) {
                                                        //String[] optionValue =new String[select.getOptionsValues().size()];
                                                            String optionValue = select.getOptionsValues().get(x);
                                                            if (request.getAttribute(field.getName()) != null && optionValue.equals(request.getAttribute(field.getName()))) {
                                                            %>
                                                                <option selected value="<%= optionValue %>"><%= optionValue %></option>
                                                            <%
                                                            }else{
                                                        %>
                                                            <option value="<%= optionValue %>"><%= optionValue %></option>
                                                        <%
                                                            }
                                            }
                                            %>
                                        </select>&nbsp;&nbsp;<%= field.getConfInfo().getRightMessage() %>
                                <%
                                    }else{
                                        if (fields.get(ind).getConfInfo().getHtmlControl() instanceof RadioButton) {
                                            Field field = (Field)fields.get(ind);
                                            RadioButton select = (RadioButton)fields.get(ind).getConfInfo().getHtmlControl();
                                                for (int x=0; x<select.getOptionsValues().size(); x++) {
                                                    //String[] optionValue =new String[select.getOptionsValues().size()];
                                                    String optionValue = select.getOptionsValues().get(x);
                                                    if (request.getAttribute(field.getName()) != null && optionValue.equals(request.getAttribute(field.getName()))) {
                                                %>
                                                    <input checked type="radio" name="<%= field.getName() %>" value="<%=optionValue%>"><%= optionValue %></input>
                                                <%
                                                    }else{
                                                    %>
                                                        <input type="radio" name="<%= field.getName() %>" value="<%=optionValue%>"><%= optionValue %></input>
                                                    <%
                                                    }
                                                }
                                                %>
                                                &nbsp;&nbsp;<%= field.getConfInfo().getRightMessage() %>
                                        <%
                                        }else{
                                            if(!fields.get(ind).getName().equals("md5")){
                                        %>
                                            <input type="text" name="<%= fields.get(ind).getName() %>" value="<% if (request.getAttribute(fields.get(ind).getName()) != null && limpiar == null) out.print((String)request.getAttribute(fields.get(ind).getName())); else out.print(""); %>">&nbsp;&nbsp;<%= fields.get(ind).getConfInfo().getRightMessage() %>
                                        <%
                                            }
                                        }
                                        %>
                                        </td>
                                        <%
                                        asterisk = "";
                                    }
                                }//end Fields
                            }else{//PK
                                if(c==0)%> <tr style="height:25px;"><td width="60"></td><%
                                if (pk.getPrimaryFields().get(ind).getValidator() != null && pk.getPrimaryFields().get(ind).getValidator().hasNotNullValidation()) asterisk = "*&nbsp;&nbsp;";
                                    if (!table.getModel().contains(sharedFields, pk.getPrimaryFields().get(ind))) {
                                        %>
                                        <td align="right"><strong><%= asterisk+pk.getPrimaryFields().get(ind).getConfInfo().getVisibleName() %>:</strong></td>
                                        <td>
                                        <%
                                        if (pk.getPrimaryFields().get(ind).getConfInfo().getHtmlControl() instanceof File) {
                                            %>
                                            <input type="file" name="<%=pk.getPrimaryFields().get(ind).getName()%>" value="">&nbsp;&nbsp;<%= pk.getPrimaryFields().get(ind).getConfInfo().getRightMessage() %>
                                            <%
                                        }else {
                                            %>
                                            <input type="text" name="<%=pk.getPrimaryFields().get(ind).getName()%>" value="<% if (request.getAttribute(pk.getPrimaryFields().get(ind).getName()) != null && limpiar == null ) out.print((String)request.getAttribute(pk.getPrimaryFields().get(ind).getName())); else out.print(""); %>">&nbsp;&nbsp;<%= pk.getPrimaryFields().get(ind).getConfInfo().getRightMessage() %>
                                            <%
                                        }
                                        %>
                                        </td>
                                        <%
                                    }
                                    asterisk = "";
                            }//End PK
                        }else{//FK
                            if(fkused.isEmpty() || !fkused.contains(relationships.get(ind).getRelationshipVisibleName())){
                                if(c==0)%> <tr style="height:25px;"><td width="60"></td><%
                                if (relationships.get(ind).isNotNull()) asterisk = "*&nbsp;&nbsp;";
                                %>
                                <td align="right"><strong><%= asterisk+relationships.get(ind).getRelationshipVisibleName()  %>:</strong></td>
                                <td><select id="<%= relationships.get(ind).getRelationshipName()  %>" name="<%= relationships.get(ind).getRelationshipName()  %>">
                                <%
                                if (!relationships.get(ind).isNotNull()) {
                                    if(limpiar == null){
                                %>
                                    <option value="">----</option>
                                <%
                                    }else{
                                %>
                                        <option selected value="">----</option>
                                <%
                                    }
                                }
                                    Table foreignTableData = (Table)request.getAttribute("tableData"+relationships.get(ind).getForeignTable().getTableName());
                                    for (int x=0; x<foreignTableData.getLRegistries().size(); x++) {
                                        String mergedForeignPrimaryKeys = "";
                                        for (int y=0; y<foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().size(); y++) {
                                            if ((y+1)==foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().size())
                                                mergedForeignPrimaryKeys += foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getValue();
                                            else
                                                mergedForeignPrimaryKeys += foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getValue()+"##";
                                        }

                                        String mergedForeignVisibleFields = "";
                                        for (int w = 0; w < relationships.get(ind).getForeignVisibleFields().size(); w++) {
                                            for (int y = 0; y < foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().size(); y++) {
                                                if (foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getName().equals(relationships.get(ind).getForeignVisibleFields().get(w).getName()))
                                                    mergedForeignVisibleFields += foreignTableData.getLRegistries().get(x).getPrimaryKey().getPrimaryFields().get(y).getValue()+"-";
                                            }
                                            for (int y=0; foreignTableData.getLRegistries().get(x).getLRelationships()!=null && y<foreignTableData.getLRegistries().get(x).getLRelationships().size(); y++) {
                                                for (int t=0; t<foreignTableData.getLRegistries().get(x).getLRelationships().get(y).getForeignFields().size(); t++) {
                                                    if (foreignTableData.getLRegistries().get(x).getLRelationships().get(y).getForeignFields().get(t).getName().equals(relationships.get(ind).getForeignVisibleFields().get(w).getName())
                                                        && !table.getModel().contains(sharedFields, relationships.get(ind).getForeignVisibleFields().get(w)))
                                                        mergedForeignVisibleFields += foreignTableData.getLRegistries().get(x).getLRelationships().get(y).getForeignFields().get(t).getValue()+"-";
                                                }
                                            }
                                            if(foreignTableData.getLRegistries().get(x).getLFields()!=null){
                                                for (int y=0; y<foreignTableData.getLRegistries().get(x).getLFields().size(); y++) {
                                                    if (foreignTableData.getLRegistries().get(x).getLFields().get(y).getName().equals(relationships.get(ind).getForeignVisibleFields().get(w).getName()))
                                                        mergedForeignVisibleFields += foreignTableData.getLRegistries().get(x).getLFields().get(y).getValue()+"-";
                                                }
                                            }
                                        }
                                        mergedForeignVisibleFields = mergedForeignVisibleFields.substring(0, (mergedForeignVisibleFields.length()-1));
                                        if (mergedForeignPrimaryKeys.equals((String)request.getAttribute(relationships.get(ind).getRelationshipName()))) {
                                            if(limpiar == null){
                                    %>
                                                <option selected value="<%= mergedForeignPrimaryKeys %>"><%= mergedForeignVisibleFields %></option>
                                    <%
                                            }else{%>
                                                <option value="<%= mergedForeignPrimaryKeys %>"><%= mergedForeignVisibleFields %></option>
                                            <%}
                                        }else{
                                        %>
                                            <option value="<%= mergedForeignPrimaryKeys %>"><%= mergedForeignVisibleFields %></option>
                                        <%
                                        }
                                    }
                                    %>
                                </select></td>
                                <%
                                asterisk = "";
                                fkused.add(relationships.get(ind).getRelationshipVisibleName());
                                }
                        }//End FK
                        c++;
                    }//end while cols
                    %>
                    </tr>
                    <%
                    f++;
                }//end while filas
            }//end else
                    %>
            </table>
                <table width="100%" border="0" cellspacing="5" cellpadding="0">
                    <tr style="height:25px;">
                        <td width="25%" >&nbsp;</td>
                        <td>
                            <input type="hidden" name="sentence" value='<%= (String)request.getAttribute("sentence") %>'>
                            <input type="hidden" name="listTables" value="<%= (String)request.getAttribute("tableSelected") %>">
                            <input type="hidden" name="maxRows" value="<%= (String)request.getAttribute("maxNumRows") %>">
                            <input type="hidden" name="pageData" value="<%= (String)request.getAttribute("pageData") %>">
                            <input type="submit" class="boton" name="button" value="Save">
                            <input type="submit" class="boton" style='width:110px' name="button" value="Save&Clean">
                        </td>
                    </tr>
                </table>
            </form>

        <%
        }
        %>
        <form action="listTable.action" method="post">
            <input type="hidden" name="sentence" value='<%= (String)request.getAttribute("sentence") %>'>
            <input type="hidden" name="listTables" value="<%= (String)request.getAttribute("tableSelected") %>">
            <input type="hidden" name="maxRows" value="<%= (String)request.getAttribute("maxNumRows") %>">
            <input type="hidden" name="pageData" value="<%= (String)request.getAttribute("pageData") %>">
            <input type="submit" class="boton" name="buttonBack" value="< Go back">
        </form>
        </td>
      </tr>
    </table>

    </body>
</html>