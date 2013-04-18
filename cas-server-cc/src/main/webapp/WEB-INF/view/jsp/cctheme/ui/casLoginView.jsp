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
        <img src="https://www.conncoll.edu/media/website-media/login/logo.png" style="margin: 0 auto;" />
    </header>
    <p>Enter your user ID only, for example: 'jsmith'. Do not use 'jsmith@conncoll.edu', 'joe.smith@conncoll.edu', or 'joe.smith'</p>
    <form:form method="post" id="fm1" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">
    <form:errors path="*" cssClass="errors" id="status" element="div" />
        <form:input cssClass="required" cssErrorClass="error" id="username" size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" autocomplete="false" htmlEscape="true" />
        <br />
        <form:password cssClass="required" cssErrorClass="error" id="password" size="25" tabindex="2" path="password"  accesskey="${passwordAccessKey}" htmlEscape="true" autocomplete="off" />
        <br />
        <input type="submit" value="Log In" />
        <input type="hidden" name="lt" value="${loginTicket}" />
        <input type="hidden" name="execution" value="${flowExecutionKey}" />
        <input type="hidden" name="_eventId" value="submit" />
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
