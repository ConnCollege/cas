<jsp:directive.include file="includes/Top.jsp" />
 <div class="info">
<div class="box noselect">
    <header>
        <h1>Batch Import</h1>
    </header>
    <p>Ready to import students using the query:</p>
    <form:form method="post" id="fm1" cssClass="fm-v clearfix" commandName="${commandName}" htmlEscape="true">
    <form:errors path="*" cssClass="errors" id="status" element="div" />
    	<textarea name="fields[1]" cols="40" rows="5">${Query}</textarea><br />        
        <input type="submit" value="Reset Password" tabindex="2" />
        <input type="hidden" name="lt" value="${loginTicket}" />
        <input type="hidden" name="execution" value="${flowExecutionKey}" />
        <input type="hidden" name="_eventId" value="submit" />  
    </form:form>
</div>         
<jsp:directive.include file="includes/Bottom.jsp" />

<p></p>
</div>
<jsp:directive.include file="includes/Bottom.jsp" />