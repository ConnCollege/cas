<jsp:directive.include file="includes/Top.jsp" />
<c:set var="hasForm" value="1" scope="page" />
<script type="text/javascript"> 
 
if (document.location.protocol != "https:") { 
	document.location.href = "https://"+document.domain +location.patdname; 
} 
var ccPopUp=1; 
var ccPassMin=8;
var ErrorColor = "#FFDAD9"; 
var ccFuncOnInvalid = true;  
function InLineValid(){ 
	bvalid = true; 
	var p1 = document.getElementById("field04"); 
	var p2 = document.getElementById("field05"); 
	//var pe = document.getElementById("field01Error"); 
	if (p1.value != p2.value) { 
		bvalid = false; 
		alert('The fields for password and verify password must match. ');
		p1.style.backgroundColor=ErrorColor; 
		p2.style.backgroundColor=ErrorColor; 
	}  
	return bvalid;
} 
</script> 
 <div class="info"> 
 			<h1>Create your Connecticut College account</h1>		
		 	<h2>1. Confirm your identity</h2>
		 	<c:choose>
		    	<c:when test='${fn:length(ErrorMsg)>3}'>
		        	<div id="MainErrorHead" style="background:#F00"> 
						<strong>There was an error with your form. Please fix all fields as noted above in pink.</strong> 
					</div>
		        	<div id="field01Error" style="background:#FFDAD9">
		            	${ErrorMsg}
		            </div>
		        </c:when>
		    </c:choose> 
		    <form:form action="/cas/login" commandName="${commandName}" htmlEscape="true" metdod="post" onSubmit="return InLineValid();">
				<table style="width:auto">
					<tr>
						<td colspan="2">
		 					<strong>Enter the following information:</strong>
		 				</td>
		 			</tr>
					<tr>
						<td align="right">
							Camel Username:
						</td>
						<td>
		        			<input size="25" id="uname" name="fields[1]" value="" ccreq="true" title="Camel Username" />
		        		</td>
		        	</tr>
					<tr>
						<td align="right">
							Birth Date:
						</td>
						<td>
		        			<input size="25" id="birthdate" name="fields[2]" placeholder="mm/dd/yyyy"  title="Birth Date" ccregex="(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20\d\d)" />
		        		</td>
		        	</tr>
					<tr>
						<td align="right">
							Camel Number:
						</td>
						<td>
		        			<input size="25" id="camelnumber" name="fields[3]" value="" ccreq="true" ccMinLength="8" ccNumOnly="true" title="Camel Number" />
		        		</td>
		        	</tr>
		        	<tr>
		        		<td colspan="2" align="center">
		        			Your Camel Username has been emailed to you.<br />
							Your eight-digit Camel Number appears on your decision letter.
		        		</td>
		        	</tr>
		        	<tr>
		        		<td colspan="2">
		        			<h2>2. Select your password</h2>
							<p>To ensure your privacy, your password must meet the following guidelines:</p>
							<ul>
								<li>It must be eight (8) characters in length or longer</li>
								<li>It cannot contain any part of your Camel Username</li>
								<li>It must contain at least three of the following types of characters:</li>
								<ul>
									<li>English uppercase characters (A through Z)</li>
									<li>English lowercase characters (a through z)</li>
									<li>Numbers (0 through 9)</li>
									<li>Special characters (!, $, #, %, etc.)</li>
								</ul>
							</ul>	

							<p>Please select a password that can be easily remembered so that you do not need to write it down.<br />
							 Here are some examples of valid, easy to remember passwords: <br />
							 &nbsp; &nbsp;Succe$$ful&nbsp; &nbsp;2S!ncere&nbsp; &nbsp;Came12oo4  <br/>
							 (please do not use these examples verbatim).</p>
							
						</td>
					</tr>
		        	<tr>
		        		<td align="right">
		        			Choose a password:
		        		</td>
		        		<td>
		        			<input type="password" Class="required" size="25" id="field04" name="fields[4]" ccvalid="password" title="password" />
		        		</td>
		        	</tr>
		        	<tr>
		        		<td align="right">
		        			Re-enter your password:
		        		</td>
		        		<td>
		        			 <input type="password" Class="required" size="25" id="field05" name="fields[5]" />
		        		</td>
		        	</tr>
		        </table>
				<input type="hidden" name="lt" value="${loginTicket}" />
				<input type="hidden" name="execution" value="${flowExecutionKey}" />
				<input type="hidden" name="_eventId" value="submit" />
		        <div align="center"><input type="submit" value="Continue" id="btnSubmit" /></div>  
		    </form:form>
		
</div>
<script src="https://www.conncoll.edu/scripts/ccValidator.js"></script>
<jsp:directive.include file="includes/Bottom.jsp" />