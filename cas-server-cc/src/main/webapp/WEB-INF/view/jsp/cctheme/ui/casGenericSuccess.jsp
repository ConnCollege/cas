<jsp:directive.include file="includes/top.jsp" />
	<div class="box noselect" style="background:none;border:0px;box-shadow:none;">
		<div id="msg" class="success">
			<h2><spring:message code="screen.success.header" /></h2>
			<p><spring:message code="screen.success.success" /></p>
			<p><spring:message code="screen.success.security" /></p>
		</div>
	</div>
        <c:forEach items="${parameters}" var="entry">
         <textarea rows=10 cols=80 name="${entry.key}"><c:out value="${entry.value}" /></textarea>
       </c:forEach>
<jsp:directive.include file="includes/bottom.jsp" />

