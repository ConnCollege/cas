<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:directive.include file="includes/top.jsp" />      
                
<ul class="slidesplash">
    <li><span>Image 01</span></li>
    <li><span>Image 02</span></li>
    <li><span>Image 03</span></li>
    <li><span>Image 04</span></li>
    <li><span>Image 05</span></li>
    <li><span>Image 06</span></li>
</ul> 
<div class="box noselect">
    <header>
        <img src="https://www.conncoll.edu/media/website-media/login/logo.png" />
    </header>
    <p>Enter your Camel Username only, for example: 'jsmith'. Do not use 'jsmith@conncoll.edu', 'joe.smith@conncoll.edu', or 'joe.smith'</p>
    <form:form method="post" id="fm1" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">
    <form:errors path="*" cssClass="errors" id="status" element="div" />
        <form:input cssClass="required" cssErrorClass="error" id="username" size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" autocomplete="false" htmlEscape="true" placeholder="Camel Username" />
        <br />
        <form:password cssClass="required" cssErrorClass="error" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" placeholder="Password" />
        <br />
        <input type="submit" value="Log In" />
        <input type="hidden" name="lt" value="${loginTicket}" />
        <input type="hidden" name="execution" value="${flowExecutionKey}" />
        <input type="hidden" name="_eventId" value="submit" />
        <input class="btn-reset" name="changePassword" value="<spring:message code="screen.welcome.button.changePassword" />" tabindex="6" type="button" onclick="document.location.href='<c:url value="login"/>?execution=${flowExecutionKey}&_eventId=changePassword'; return false;" />
        <input class="btn-reset" name="changePassword" value="<spring:message code="screen.welcome.button.forgotPassword" />" tabindex="" type="button" onclick="document.location.href='<c:url value="login"/>?execution=${flowExecutionKey}&_eventId=forgotPassword'; return false;" />
        <input class="btn-reset" name="changePassword" value="<spring:message code="screen.welcome.button.initPassword" />" tabindex="8" type="button" onclick="document.location.href='<c:url value="login"/>?execution=${flowExecutionKey}&_eventId=initalzie'; return false;" />
    </form:form>
    <p><a href="http://www.conncoll.edu">Connecticut College Homepage</a></p>
</div>               
                
<script type="text/javascript">
	var UserObj = document.getElementById('username');
	var PassObj = document.getElementById('password');
	if (UserObj.value == ''){
		UserObj.focus();
	} else {
		PassObj.focus();
	}
</script>
<jsp:directive.include file="includes/bottom.jsp" />
