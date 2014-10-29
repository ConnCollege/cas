<jsp:directive.include file="includes/Top.jsp" />
<jsp:directive.page import="net.tanesha.recaptcha.ReCaptcha" />
<jsp:directive.page import="net.tanesha.recaptcha.ReCaptchaFactory" />
<c:set var="recaptchaPublicKey" scope="page"
	value="${recaptchaPublicKey}" />
<c:set var="recaptchaPrivateKey" scope="page"
	value="${recaptchaPrivateKey}" />
<c:set var="hasForm" value="1" scope="page" />
<script type="text/javascript">
	if (document.location.protocol != "https:") {
		document.location.href = "https://" + document.domain
				+ location.patdname;
	}
	var ccPopUp = 0;
	var ccPassMin = 8;
	var ErrorColor = "#FFDAD9";
	var ccFuncOnInvalid = true;
	ccHTMLHead = '<strong>';
	ccHTMLFoot = '</strong>';
	function InLineValid() {
		bvalid = true;
		var p1 = document.getElementById("field01");
		var p2 = document.getElementById("field02");
		var pe = document.getElementById("field01Error");
		if (p1.value != p2.value) {
			bvalid = false;
			pe.innerHTML = pe.innerHTML
					+ '<strong> New password and confirm new password must match.</strong>';
			pe.style.display = '';
			p1.style.backgroundColor = ErrorColor;
			p2.style.backgroundColor = ErrorColor;
			document.getElementById("MainErrorHead").style.display = '';
			document.getElementById("MainErrorFoot").style.display = '';
		}
		return bvalid;
	}
</script>
<div class="info">
	<h1>Reset a Forgotten Password</h1>

	<strong>Please verify your identity by answering the following
		questions</strong><br />
	<div id="MainErrorHead" style="display: none; background: #F00">
		<strong>There was an error with your form. Please fix all
			fields as noted above in pink.</strong>
	</div>
	<div id="field01Error" style="display: none; background: #FFDAD9"></div>
	<form:form commandName="${commandName}" htmlEscape="true" metdod="post">
		<c:forEach items="${UserQNA}" var="question">
			${question.question} 
			<input size="25" name="fields[${question.questnum}]" value=""
				ccreq="true" title="First Security Answer" />
			<br />
			<br />
		</c:forEach>
		<div>
			<label class="fl-label" for="recaptcha">Please enter the
				following text:</label>
			<%
				ReCaptcha c = ReCaptchaFactory
							.newSecureReCaptcha((String) pageContext
									.getAttribute("recaptchaPublicKey"),
									(String) pageContext
											.getAttribute("recaptchaPrivateKey"),
									true);
					out.print(c.createRecaptchaHtml(null, null));
			%>
		</div>
		<input type="hidden" name="lt" value="${loginTicket}" />
		<input type="hidden" name="execution" value="${flowExecutionKey}" />
		<input type="hidden" name="_eventId" value="submit" />
		<input type="submit" value="Continue" id="btnSubmit" />
		<div id="MainErrorFoot" style="display: none; background: #F00">
			<strong>There was an error with your form. Please fix all
				fields as noted above in pink.</strong>
		</div>
		<div id="field01Error" style="display: none; background: #FFDAD9"></div>
	</form:form>

</div>
<script src="https://www.conncoll.edu/scripts/ccValidator.js"></script>
<jsp:directive.include file="includes/Bottom.jsp" />