<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" import="java.util.*"%>
<html>
    <head></head>
    <body>
      <%// <s:if test="!#session.containsKey('logged-in')">%>
      <s:if test="#session.user_role!='superadmin'">
      <jsp:forward  page="authError.jsp" />
      </s:if>

    </body>


</html>