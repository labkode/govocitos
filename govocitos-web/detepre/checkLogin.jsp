<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8" import="java.util.*"%>
<html>
      <s:if test="!#session.containsKey('logged-in')">
      <jsp:forward  page="index.html" />
      </s:if>
</html>