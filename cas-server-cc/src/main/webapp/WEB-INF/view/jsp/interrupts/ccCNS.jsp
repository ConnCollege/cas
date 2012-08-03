<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="hasForm" value="0" scope="page" />
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html dir="ltr" xmlns="http://www.w3.org/1999/xhtml">
<head>	<title>Connecticut College Intranet Login</title>
<meta content="text/html; charset=UTF-8" http-equiv="content-type" />
<link rel="Shortcut Icon" href="https://www.conncoll.edu/cw40/html/themes/classic/images/favicon.ico" />
</head>
<body>
<form:form method="post" id="fm1" cssClass="fm-v clearfix" htmlEscape="true">

remote address: ${userAddr}<br />

<input type="hidden" name="lt" value="${loginTicket}" />
<input type="hidden" name="execution" value="${flowExecutionKey}" />
<input type="hidden" name="_eventId" value="submit" />
<div align="center"><input type="submit" value="Continue" id="btnSubmit" /></div>
</form:form>
<script  type="text/javascript">
	//document.getElementById('fm1').submit();
</script>
</body>
</html>