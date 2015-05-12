<jsp:directive.include file="includes/top.jsp" />
<div class="box noselect" style="background:none;border:0px;box-shadow:none;">
	<div class="info"><p><spring:message code="screen.confirmation.message" arguments="${fn:escapeXml(param.service)}${fn:indexOf(param.service, '?') eq -1 ? '?' : '&'}ticket=${serviceTicketId}" /></p>
	</div>
</div>
<jsp:directive.include file="includes/bottom.jsp" />
