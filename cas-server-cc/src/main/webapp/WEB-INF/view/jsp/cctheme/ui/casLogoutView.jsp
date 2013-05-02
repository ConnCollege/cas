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
		<div id="msg" class="success">
			<h2><spring:message code="screen.logout.header" /></h2>

			<p><spring:message code="screen.logout.success" /></p>
			<p><spring:message code="screen.logout.security" /></p>
			
			<%--
			 Implementation of support for the "url" parameter to logout as recommended in CAS spec section 2.3.1.
			 A service sending a user to CAS for logout can specify this parameter to suggest that we offer
			 the user a particular link out from the logout UI once logout is completed.  We do that here.
			--%>
			<c:if test="${not empty param['url']}">
			<p>
				<spring:message code="screen.logout.redirect" arguments="${fn:escapeXml(param.url)}" />
			</p>
			</c:if>
		</div>
</div>  
<jsp:directive.include file="includes/bottom.jsp" />
