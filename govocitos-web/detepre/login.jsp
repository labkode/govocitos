<%@page import="java.util.Vector"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.io.File"%>
<%@page import="es.uvigo.ei.lia.ddms.vcs.metadata.DBase"%>
<%@page import="es.uvigo.ei.lia.ddms.WebProperties"%>
<%@page import="java.util.Properties"%>
<%@page import="com.opensymphony.xwork2.ActionContext"%>
<%@page import="java.util.Map"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
    <%
        Properties prop = WebProperties.getProperties(new File(this.getClass().getResource("/web.properties").getFile()));
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
            statement.executeUpdate("CREATE TABLE internal_images (name varchar(45), description varchar(200), type varchar(20), path varchar(200), link varchar(200)) ENGINE=MyISAM");
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
<head>
<title>Login</title>

<link href="<s:url value="/css/main.css"/>" rel="stylesheet" type="text/css"/>
<%if(!iconpath.equals("")){%>
<link rel="shortcut icon" href="<%=iconpath%>"/>
<%}%>

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
            <%if(!logopath.equals("")){%>
            <td><a href="<%=logolink%>"><img border="0" src="<%=logopath%>" width="300" height="105"/></a></td>
            <td></td>
            <%}%>
        </tr>
        <tr>
            <td colspan="3"></td>
        </tr>
    </tbody>
</table>
<s:form action="login" method="POST">
<tr>
<td style="width:42%;">&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td colspan="2" class="styleTitle">Access Control</td>
</tr>

  <tr>
   <td colspan="2">
         <s:actionerror />
   </td>
  </tr>
  <s:textfield name="username" label="Login name" size="16" value="%{#username}"/>
  <s:password name="password" label="Password" size="16"/>
  <s:submit cssClass="button" value="Login" align="center"/>

<tr>
<td colspan="2">

</td>

</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>


</s:form>
<table border="0" align="center" cellspacing="20">
        <tr>
            <td colspan="7"></td>
        </tr>
        <tr>
            <%if(sponsorpath != null){
                for(int i = 0; i < sponsorpath.size();i++){
					if(i % 4 == 0){%>
						</tr><tr>
					<%}%>
                    <td><a href="<%=sponsorlink.get(i)%>"><img border="0" src="<%=sponsorpath.get(i)%>" /></a></td>
                <%}
            }%>
        </tr>
        <tr>
            <td colspan="7"></td>
        </tr>
</table>
</body>

</html>
