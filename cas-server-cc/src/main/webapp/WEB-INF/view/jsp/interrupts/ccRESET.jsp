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
        <h1>Select the account to be reset</h1>
    </header>
    <p>Enter your Camel Username only, for example: 'jsmith'. Do not use 'jsmith@conncoll.edu', 'joe.smith@conncoll.edu', or 'joe.smith'</p>
    <form:form method="post" id="fm1" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">
    <form:errors path="*" cssClass="errors" id="status" element="div" />
        <form:input cssClass="required" cssErrorClass="error" id="username" size="25" tabindex="1" accesskey="${userNameAccessKey}" path="username" autocomplete="false" htmlEscape="true" placeholder="Camel Username" />
        <br />        
        <input type="submit" value="Reset Password" />
        <input type="hidden" name="lt" value="${loginTicket}" />
        <input type="hidden" name="execution" value="${flowExecutionKey}" />
        <input type="hidden" name="_eventId" value="Reset My Password" />  
    </form:form>
</div>         
<jsp:directive.include file="includes/bottom.jsp" />
