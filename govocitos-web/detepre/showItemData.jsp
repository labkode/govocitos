<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="es.uvigo.ei.lia.ddms.vcs.metadata.DBase"%>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" import="java.util.*" %>
<%@ page import="es.uvigo.ei.lia.ddms.dms.db.*" %>
<%@ page import="es.uvigo.ei.lia.ddms.dms.view.*" %>
<jsp:include page="checkLogin.jsp" />
<link href="<s:url value="/css/styles.css"/>" rel="stylesheet" type="text/css"/>
<script type='text/javascript'>

function areYouSure() {
    if (document.getElementById("formItemData").clickedButton.value == "Delete") {
        return confirm("are you sure that you want to delete this item?");
    }else if (document.getElementById("formItemData").clickedButton.value == "Edit") {
        document.getElementById("formItemData").action = "showModifyItem.action";
        return true;
    }else {
        document.getElementById("formItemData").action = "showItemData.action";
        return true;
    }
}

function updateClickedButton(obj) {
    document.getElementById("formItemData").clickedButton.value = obj.value;
}

function showForeignRelationship(obj) {
    var form = document.getElementById('formItemData');
    form.selectedForeignRelationships.value = obj;
    if (areYouSure()) form.submit();
}

</script>
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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Item details</title>
    </head>
    <body>
        <%
        Table tableData = (Table)request.getAttribute("tableData");
        %>
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
                Table: <%= tableData.getVisibleTableName() %>
                </div>
            <input type="submit" class="boton" name="buttonBack" value="< Go back">
        </form>
        <%
        if (tableData != null) {
            PrimaryKey pk = tableData.getModel().getPrimaryKey();
            Vector<Relationship> relationships = tableData.getModel().getLRelationships();
            Vector<Field> fields;
            fields = tableData.getModel().getLFields();
            Vector<Registry> registries = tableData.getLRegistries();
            Vector<Field> sharedFields = tableData.getModel().getFieldsSoftEntities();
        %>
            <form id="formItemData" action="doDelete.action" method="post" onsubmit="javascript: return areYouSure()">
                <table border="0" cellspacing="8" cellpadding="0">
                    <input type="hidden" name="selectedForeignRelationships" value="">
                    <%
                    if(request.getSession().getAttribute("user_role").equals("superadmin")){
                        if (pk != null) {
                            for (int i=0; i<pk.getPrimaryFields().size(); i++) {
                                if (tableData.getModel().contains(sharedFields, pk.getPrimaryFields().get(i))) {
                        %>
                                    <input type="hidden" name="<%=pk.getPrimaryFields().get(i).getName()%>" value="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(i).getValue() %>">
                        <%
                                }else{
                            %>
                                    <tr style="height:25px;">
                                    <td width="60"></td><td align="right"><strong><%= pk.getPrimaryFields().get(i).getConfInfo().getVisibleName() %>:</strong></td>
                            <%
                                    if (pk.getPrimaryFields().get(i).getConfInfo().getHtmlControl() instanceof File) {
                                        if (((File)pk.getPrimaryFields().get(i).getConfInfo().getHtmlControl()).isImage()) {
                                            java.io.File file = new java.io.File(registries.get(0).getPrimaryKey().getPrimaryFields().get(i).getValue());
                                            String reducedPath = file.getParent()+"/reduced/"+file.getName();
                            %>
                                            <td><a href="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(i).getValue() %>"><img src="<%= reducedPath %>"></a>
                            <%
                                        }else{
                            %>
                                            <td><a href="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(i).getValue() %>">View file</a>
                            <%
                                        }
                                    }else{
                            %>
                                        <td><%= registries.get(0).getPrimaryKey().getPrimaryFields().get(i).getValue() %>
                            <%
                                    }
                            %>
                                    <input type="hidden" name="<%=pk.getPrimaryFields().get(i).getName()%>" value="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(i).getValue() %>">
                                    </td>
                                    </tr>
                            <%
                                }
                            }
                        }
                        %>

                        <%
                        if (relationships != null) {
                            for (int i=0; i<relationships.size(); i++) {
                                String mergedActualForeignKeys = "";
                                for (int x=0; x<relationships.get(i).getForeignVisibleFields().size(); x++) {
                                    if ((x+1)==relationships.get(i).getForeignVisibleFields().size())
                                        mergedActualForeignKeys += registries.get(0).getLRelationships().get(i).getForeignVisibleFields().get(x).getValue();
                                    else
                                        mergedActualForeignKeys += registries.get(0).getLRelationships().get(i).getForeignVisibleFields().get(x).getValue()+"-";
                                }

                                // Used to show foreign data if we click it
                                request.getSession().setAttribute("foreignRelationship"+registries.get(0).getLRelationships().get(i).getRelationshipName(), registries.get(0).getLRelationships().get(i));
                        %>
                                <tr style="height:25px;"><td></td>
                                <input type="hidden" name="<%= registries.get(0).getLRelationships().get(i).getRelationshipName() %>" value="<%= mergedActualForeignKeys %>">
                                <td align="right"><strong><%= relationships.get(i).getRelationshipVisibleName()  %>:</strong></td>
                                <%
                                if(registries.get(0).getLRelationships().get(i).getForeignTable().isConsult() || (request.getSession().getAttribute("user_role").equals("superadmin")) ){
                                %>
                                    <td><a href="#" onclick="javascript:showForeignRelationship('foreignRelationship<%= registries.get(0).getLRelationships().get(i).getRelationshipName() %>');">
                                        <%= mergedActualForeignKeys %></a></td>
                        <%
                                }else{
                                %>
                                    <td><%= mergedActualForeignKeys %></td>
                                <%
                                }
                            %>
                            </tr>
                            <%
                            }
                        }
                        %>

                        <%
                        if (fields != null) {
                            for (int i=0; i<fields.size(); i++) {
                        %>
                                <tr style="height:25px;"><td></td>
                                <td align="right"><strong><%= fields.get(i).getConfInfo().getVisibleName() %>:</strong></td>
                        <%
                                if (fields.get(i).getConfInfo().getHtmlControl() instanceof File) {
                                    if (registries.get(0).getLFields().get(i).getValue().isEmpty()) {
                        %>
                                        <td>There is not file
                        <%
                                    }else{
                                        if (((File)fields.get(i).getConfInfo().getHtmlControl()).isImage()) {
                                            java.io.File file = new java.io.File(registries.get(0).getLFields().get(i).getValue());
                                            String reducedPath = file.getParent()+"/reduced/"+file.getName();
                        %>
                                            <td><a href="<%= registries.get(0).getLFields().get(i).getValue() %>"><img src="<%= reducedPath %>"></a>
                        <%
                                        }else{
                        %>
                                            <td><a href="<%= registries.get(0).getLFields().get(i).getValue() %>">View file</a>
                        <%
                                        }
                                    }
                                }else if (fields.get(i) instanceof es.uvigo.ei.lia.ddms.dms.db.Boolean) {
                                    String valBool = "";
                                    if (registries.get(0).getLFields().get(i).getValue().equals("0")) valBool = "No";
                                    else valBool = "Yes";
                        %>
                                    <td><%= valBool %></td>
                        <%
                                }else {
                        %>
                                    <td><%= registries.get(0).getLFields().get(i).getValue() %></td>
                        <%
                                }
                        %>
                                </tr>
                        <%
                            }
                        }
                    }else{
                        List<String> fkused = new ArrayList<String>();
                        int fmax = tableData.getModel().maxRow(), f = 0, cmax, c= 0, ind = 0;
                        boolean yaFk = false;
                        while(f <= fmax){
                            cmax = tableData.getModel().maxCol(f);%>
                            <%
                            c=0;
                            while(c <= cmax){
                                ind = tableData.getModel().getFieldPorPosicion(f, c, 1);
                                if(ind == -1){//fK
                                    ind = tableData.getModel().getFieldPorPosicion(f, c, 0);
                                    if(ind == -1){//pK
                                        ind = tableData.getModel().getFieldPorPosicion(f, c, 2);
                                        if(ind != -1){
                                            //Fields
                                            if(c==0)%> <tr style="height:25px;"><td width="60"></td>
                                            <td align="right"><strong><%= fields.get(ind).getConfInfo().getVisibleName() %>:</strong></td>
                                            <%
                                            if (fields.get(ind).getConfInfo().getHtmlControl() instanceof File) {
                                                if (registries.get(0).getLFields().get(ind).getValue().isEmpty()) {
                                                %>
                                                    <td>There is not file</td>
                                                <%
                                                }else{
                                                    if (((File)fields.get(ind).getConfInfo().getHtmlControl()).isImage()) {
                                                        java.io.File file = new java.io.File(registries.get(0).getLFields().get(ind).getValue());
                                                        String reducedPath = file.getParent()+"/reduced/"+file.getName();
                                                        %>
                                                        <td><a href="<%= registries.get(0).getLFields().get(ind).getValue() %>"><img src="<%= reducedPath %>"></a></td>
                                                        <%
                                                    }else{
                                                        %>
                                                        <td><a href="<%= registries.get(0).getLFields().get(ind).getValue() %>">View file</a></td>
                                                        <%
                                                    }
                                                }
                                            }else if (fields.get(ind) instanceof es.uvigo.ei.lia.ddms.dms.db.Boolean) {
                                                        String valBool = "";
                                                        if (registries.get(0).getLFields().get(ind).getValue().equals("0")) valBool = "No";
                                                        else valBool = "Yes";
                                                        %>
                                                        <td><%= valBool %></td>
                                                        <%
                                                    }else {
                                                        %>
                                                        <td><%= registries.get(0).getLFields().get(ind).getValue() %></td>
                                                        <%
                                                    }
                                            }
                                        }else{
                                            if(c==0)%> <tr style="height:25px;"><td width="60"></td><%
                                            if (tableData.getModel().contains(sharedFields, pk.getPrimaryFields().get(ind))) {
                                                %>
                                                <input type="hidden" name="<%=pk.getPrimaryFields().get(ind).getName()%>" value="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(ind).getValue() %>">
                                                <%
                                            }else{
                                                %>
                                                <td align="right"><strong><%= pk.getPrimaryFields().get(ind).getConfInfo().getVisibleName() %>:</strong></td>
                                                <%
                                                if (pk.getPrimaryFields().get(ind).getConfInfo().getHtmlControl() instanceof File) {
                                                    if (((File)pk.getPrimaryFields().get(ind).getConfInfo().getHtmlControl()).isImage()) {
                                                        java.io.File file = new java.io.File(registries.get(0).getPrimaryKey().getPrimaryFields().get(ind).getValue());
                                                        String reducedPath = file.getParent()+"/reduced/"+file.getName();
                                                        %>
                                                        <td><a href="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(ind).getValue() %>"><img src="<%= reducedPath %>"></a>
                                                        <%
                                                    }else{
                                                        %>
                                                        <td><a href="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(ind).getValue() %>">View file</a>
                                                        <%
                                                    }
                                                }else{
                                                    %>
                                                    <td><%= registries.get(0).getPrimaryKey().getPrimaryFields().get(ind).getValue() %>
                                                    <%
                                                }
                                                %>
                                                <input type="hidden" name="<%=pk.getPrimaryFields().get(ind).getName()%>" value="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(ind).getValue() %>">
                                                </td>
                                                <%
                                            }
                                        }
                                    }else{//fk
                                        if(relationships.get(ind).getForeignVisibleFields().size()>1){
                                                int indaux = tableData.getModel().getFieldPorPosicion(f, c, 0);
                                                if(indaux != -1){
                                                        if(c==0) if(fkused.isEmpty() || !fkused.contains(relationships.get(ind).getRelationshipVisibleName())){ %> <tr style="height:25px;"><td width="60"></td><% }
                                                        if (tableData.getModel().contains(sharedFields, pk.getPrimaryFields().get(indaux))) {
                                                        %>
                                                                <input type="hidden" name="<%=pk.getPrimaryFields().get(indaux).getName()%>" value="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(indaux).getValue() %>">
                                                        <%
                                                        }
                                                        String mergedActualForeignKeys = "";
                                                        for (int x=0; x<relationships.get(ind).getForeignVisibleFields().size(); x++) {
                                                                if ((x+1)==relationships.get(ind).getForeignVisibleFields().size())
                                                                        mergedActualForeignKeys += registries.get(0).getLRelationships().get(ind).getForeignVisibleFields().get(x).getValue();
                                                                else
                                                                        mergedActualForeignKeys += registries.get(0).getLRelationships().get(ind).getForeignVisibleFields().get(x).getValue()+"-";
                                                        }
                                                        // Used to show foreign data if we click it
                                                        request.getSession().setAttribute("foreignRelationship"+registries.get(0).getLRelationships().get(ind).getRelationshipName(), registries.get(0).getLRelationships().get(ind));
                                                        %>
                                                        <!--<tr style="height:25px;">-->
                                                        <input type="hidden" name="<%= registries.get(0).getLRelationships().get(ind).getRelationshipName() %>" value="<%= mergedActualForeignKeys %>">
                                                        <%
                                                        if(fkused.isEmpty() || !fkused.contains(relationships.get(ind).getRelationshipVisibleName())){
                                                                %>
                                                                <td align="right"><strong><%= relationships.get(ind).getRelationshipVisibleName()  %>:</strong></td>
                                                                <%
                                                                if(registries.get(0).getLRelationships().get(ind).getForeignTable().isConsult() || (request.getSession().getAttribute("user_role").equals("superadmin")) ){
                                                                %>
                                                                        <td><a href="#" onclick="javascript:showForeignRelationship('foreignRelationship<%= registries.get(0).getLRelationships().get(ind).getRelationshipName() %>');"><%= mergedActualForeignKeys %></a></td>
                                                                <%
                                                                }else{
                                                                %>
                                                                        <td><%= mergedActualForeignKeys %></td>
                                                                <%
                                                                }
                                                        fkused.add(relationships.get(ind).getRelationshipVisibleName());
                                                        }
                                                }
                                        }else{
                                                if(c==0){ %> <tr style="height:25px;"><td width="60"></td><% }
                                                        if (tableData.getModel().contains(sharedFields, pk.getPrimaryFields().get(ind))) {
                                                        %>
                                                                <input type="hidden" name="<%=pk.getPrimaryFields().get(ind).getName()%>" value="<%= registries.get(0).getPrimaryKey().getPrimaryFields().get(ind).getValue() %>">
                                                        <%
                                                        }
                                                        String mergedActualForeignKeys = "";
                                                        for (int x=0; x<relationships.get(ind).getForeignVisibleFields().size(); x++) {
                                                                if ((x+1)==relationships.get(ind).getForeignVisibleFields().size())
                                                                        mergedActualForeignKeys += registries.get(0).getLRelationships().get(ind).getForeignVisibleFields().get(x).getValue();
                                                                else
                                                                        mergedActualForeignKeys += registries.get(0).getLRelationships().get(ind).getForeignVisibleFields().get(x).getValue()+"-";
                                                        }
                                                        // Used to show foreign data if we click it
                                                        request.getSession().setAttribute("foreignRelationship"+registries.get(0).getLRelationships().get(ind).getRelationshipName(), registries.get(0).getLRelationships().get(ind));
                                                        %>
                                                        <!--<tr style="height:25px;">-->
                                                        <input type="hidden" name="<%= registries.get(0).getLRelationships().get(ind).getRelationshipName() %>" value="<%= mergedActualForeignKeys %>">
                                                        <%
                                                        if(fkused.isEmpty() || !fkused.contains(relationships.get(ind).getRelationshipVisibleName())){
                                                                %>
                                                                <td align="right"><strong><%= relationships.get(ind).getRelationshipVisibleName()  %>:</strong></td>
                                                                <%
                                                                if(registries.get(0).getLRelationships().get(ind).getForeignTable().isConsult() || (request.getSession().getAttribute("user_role").equals("superadmin")) ){
                                                                %>
                                                                        <td><a href="#" onclick="javascript:showForeignRelationship('foreignRelationship<%= registries.get(0).getLRelationships().get(ind).getRelationshipName() %>');"><%= mergedActualForeignKeys %></a></td>
                                                                <%
                                                                }else{
                                                                %>
                                                                        <td><%= mergedActualForeignKeys %></td>
                                                                <%
                                                                }
                                                                fkused.add(relationships.get(ind).getRelationshipVisibleName());
                                                        }
                                       }//fin
                                    }
                                    //APLICAR LA COLUMNA
                                    c++;
                                }
                            %>
                            </tr>
                            <%
                            f++;
                            }
                        }
                    %>
                </table>
                    <table border="0" cellspacing="5" cellpadding="0">
                    <tr style="height:25px;">
                        <td width="33%" >&nbsp;</td>
                        <td>
                            <input type="hidden" name="clickedButton" value="">
                            <input type="hidden" name="sentence" value='<%= (String)request.getAttribute("sentence") %>'>
                            <input type="hidden" name="shownTable" value="<%= tableData.getTableName() %>">
                            <input type="hidden" name="listTables" value="<%= (String)request.getAttribute("tableSelected") %>">
                            <input type="hidden" name="maxRows" value="<%= (String)request.getAttribute("maxNumRows") %>">
                            <input type="hidden" name="pageData" value="<%= (String)request.getAttribute("pageData") %>">
                            <% if((tableData.isDelete() || request.getSession().getAttribute("user_role").equals("superadmin")) && !request.getSession().getAttribute("user_role").equals("guest")){ %>
                            <input onclick="javascript: updateClickedButton(this)" type="submit" class="boton" name="buttonDelete" value="Delete">&nbsp;&nbsp;
                            <%} if((tableData.isModify()  || request.getSession().getAttribute("user_role").equals("superadmin")) && !request.getSession().getAttribute("user_role").equals("guest")) {%>
                            <input onclick="javascript: updateClickedButton(this)" type="submit" class="boton" name="buttonEdit" value="Edit">
                            <%}%>
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
