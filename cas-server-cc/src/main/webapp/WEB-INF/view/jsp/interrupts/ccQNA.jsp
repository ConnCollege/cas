<jsp:directive.include file="includes/Top.jsp" />
<c:set var="hasForm" value="1" scope="page" />
 <div class="info"> 		
		 	<h2>Please choose a security question and answer.</h2>
		    The following security question and answer will be used for handling lost and forgotten passwords.<br />In order to reset your password, you will be required to answer the question you choose.<br />
		 	<form:form commandName="${commandName}" htmlEscape="true" method="post">
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
		        <input size="25" name="fields[2]" value="${default}" /><br /><br /><br /><br />
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
		        <input size="25" name="fields[4]" value="${default}" />
				<input type="hidden" name="lt" value="${loginTicket}" />
				<input type="hidden" name="execution" value="${flowExecutionKey}" />
				<input type="hidden" name="_eventId" value="submit" />
		        <div align="center"><input type="submit" value="Continue" id="btnSubmit" /></div>
		    </form:form>
		
</div>
<jsp:directive.include file="includes/Bottom.jsp" />