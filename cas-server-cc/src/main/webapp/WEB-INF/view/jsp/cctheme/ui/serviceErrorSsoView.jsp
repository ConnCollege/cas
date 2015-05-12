<jsp:directive.include file="includes/top.jsp" />
	<div class="box noselect" style="background:none;border:0px;box-shadow:none;">
		<div id="status" class="errors">
			<h2><spring:message code="screen.service.sso.error.header" /></h2>
			<p><spring:message code="screen.service.sso.error.message"  arguments="${fn:escapeXml(request.requestURI)}" /></p>
		</div>
	</div>
<jsp:directive.include file="includes/bottom.jsp" />
