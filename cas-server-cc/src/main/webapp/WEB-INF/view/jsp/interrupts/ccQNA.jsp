<jsp:directive.include file="includes/Top.jsp" />
<c:set var="hasForm" value="1" scope="page" />
<script type="text/javascript"> 
 
if (document.location.protocol != "https:") { 
	document.location.href = "https://"+document.domain +location.pathname; 
} 
var ccPopUp=0; 
var ErrorColor = "#FFDAD9"; 
var ccFuncOnInvalid = true; 
ccHTMLHead = '<strong>'; 
ccHTMLFoot = '</strong>'; 
function InLineValid(){ 
	bvalid = true; 
	var p1 = document.getElementById("field01"); 
	var p2 = document.getElementById("field03"); 
	var pe = document.getElementById("field01Error"); 
	if (p1.options[p1.selectedIndex].value == p2.options[p2.selectedIndex].value) { 
		bvalid = false; 
		pe.innerHTML = pe.innerHTML + '<strong> You must pick two different quesitons.</strong>'; 
		pe.style.display=''; 
		p1.style.backgroundColor=ErrorColor; 
		p2.style.backgroundColor=ErrorColor; 
		document.getElementById("MainErrorHead").style.display=''; 
		document.getElementById("MainErrorFoot").style.display=''; 
	}  
	return bvalid; 
} 
</script> 
 <div class="info"> 		
		 	<h2>IMPORTANT - In order to reset your password, please choose two security questions/answers.</h2>
		    The following security questions and answers will be used for handling lost and forgotten passwords.<br />In order to reset your password, you will be required to answer the questions you choose.<br />
		 	<form:form commandName="${commandName}" htmlEscape="true" method="post">
			 	<div id="MainErrorHead" style="display:none;background:#F00"> 
					<strong>There was an error with your form. Please fix all fields as noted above in pink.</strong> 
				</div>
	        	<div id="field01Error" style="display:none;background:#FFDAD9"></div>
		        <strong>Pick a Question:</strong><br />
		        <select name="fields[1]">
		        	<c:forEach items="${questionList}" var="choice">
		        		<c:if test="${(choice.QuestNum == 1) || (choice.active == true)}">
	        				<c:choose>
	        					<c:when test="${choice.QuestNum == 1}">
	            					<option value="${choice.id}" selected="selected">${choice.qChoice}</option>
	            					<c:set var="default"  value="${choice.answer}" scope="page" />
	            				</c:when>
	            				<c:otherwise>
	            					<option value="${choice.id}">${choice.qChoice}</option>
	            				</c:otherwise>
	            			</c:choose>	
	            		</c:if>	
		            </c:forEach>
		        </select><br /><br />
		        <strong>Security Answer</strong><br />
		        <input size="25" name="fields[2]" value="${default}" ccreq="true" title="First Security Answer" /><br /><br /><br /><br />
		        <c:set var="default"  value="" scope="page" />
		        <strong>Pick a Question:</strong><br />
		        <select name="fields[3]">
		        	<c:forEach items="${questionList}" var="choice">
		        		<c:if test="${(choice.QuestNum == 2) || (choice.active == true)}">
	        				<c:choose>
	        					<c:when test="${choice.QuestNum == 2}">
	            					<option value="${choice.id}" selected="selected">${choice.qChoice}</option>
	            					<c:set var="default"  value="${choice.answer}" scope="page" />
	            				</c:when>
	            				<c:otherwise>
	            					<option value="${choice.id}">${choice.qChoice}</option>
	            				</c:otherwise>
	            			</c:choose>
	            		</c:if>
		            </c:forEach>
		        </select><br /><br />
		        <strong>Security Answer</strong><br />
		        <input size="25" name="fields[4]" value="${default}" ccreq="true" title="Second Security Answer" />
				<input type="hidden" name="lt" value="${loginTicket}" />
				<input type="hidden" name="execution" value="${flowExecutionKey}" />
				<input type="hidden" name="_eventId" value="submit" />
				<div id="MainErrorFoot" style="display:none;background:#F00"> 
					<strong>There was an error with your form. Please fix all fields as noted above in pink.</strong> 
				</div>
	        	<div id="field01Error" style="display:none;background:#FFDAD9"></div>
		        <div align="center"><input type="submit" value="Continue" id="btnSubmit" /></div>
		    </form:form>
		
</div>
<script src="https://www.conncoll.edu/scripts/ccValidator.js"></script>
<jsp:directive.include file="includes/Bottom.jsp" />