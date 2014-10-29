<jsp:directive.include file="includes/Top.jsp" />
<c:set var="hasForm" value="1" scope="page" />
<script type="text/javascript"> 
 
if (document.location.protocol != "https:") { 
	document.location.href = "https://"+document.domain +location.patdname; 
} 
var ccPopUp=0; 
var ccPassMin=8;
var ErrorColor = "#FFDAD9"; 
var ccFuncOnInvalid = true; 
ccHTMLHead = '<strong>'; 
ccHTMLFoot = '</strong>'; 
function InLineValid(){ 
	bvalid = true; 
	var p1 = document.getElementById("field01"); 
	var p2 = document.getElementById("field02"); 
	var pe = document.getElementById("field01Error"); 
	if (p1.value != p2.value) { 
		bvalid = false; 
		pe.innerHTML = pe.innerHTML + '<strong> New password and confirm new password must match.</strong>'; 
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
		 	<h2>Please confirm your identity and choose your first password.</h2>
		 	<div id="MainErrorHead" style="display:none;background:#F00"> 
				<strong>There was an error with your form. Please fix all fields as noted above in pink.</strong> 
			</div>
        	<div id="field01Error" style="display:none;background:#FFDAD9"></div> 
		    <form:form commandName="${commandName}" htmlEscape="true" metdod="post">
		    	<div align="center">
				<table>
					<tr>
						<td align="right">
							Assigned Camel Username:
						</td>
						<td>
		        			<input size="25" name="fields[1]" value="" ccreq="true" title="Camel Username" />
		        		</td>
		        	</tr>
					<tr>
						<td align="right">
							Your Birth Date:
						</td>
						<td>
		        			<input size="25" name="fields[2]" value="mm/dd/yyyy" ccreq="true" title="Birtd Date" />
		        		</td>
		        	</tr>
					<tr>
						<td align="right">
							Assigned Camel Id:
						</td>
						<td>
		        			<input size="25" name="fields[3]" value="" ccreq="true" title="Camel Id" />
		        		</td>
		        	</tr>
		        	<tr>
		        		<td colspan="2" align="center">
		        			Your eight-digit ID is on the address label of most mailings we send you. The ID is circled on the sample below<br>
		        			<img src="https://www.conncoll.edu/camelwebSSL/images/alumni/login/label.jpg">
		        		</td>
		        	</tr>
		        	<tr>
		        		<td colspan="2">
		        		<p>The password cannot contain all or part of your user account name and it must be <b>at least</b> eight characters in length. The password also <b>may not contain any part of your login id</b>. In addition it needs to contain characters from three of the following categories:</p>
						<p>English uppercase characters (A through Z)<br />
						
						English lower case characters (a through z)<br />
						Numbers (0 through 9)<br />
						Non-alphabetic characters (for example, ! $,#, %).</p>
						<p>If you are unable to log in to your email account after changing your password, contact the computer IT Service Desk at x4357 </p>
						<p>Below are some examples of passwords that would follow the necessary criteria:<br />
						&amp;Ez2do Suce$$ful 2S!ncere Etc&amp;etc Came12oo4</p>
						
						<p>Passwords will now need to be changed every 180 days. Please choose a password that meets the above requirements but is easy enough to remember that you do not have to write it down. The three previous passwords cannot be used. (If you do feel the need to write your password down, please store it in a secure location!)<br />
						<em>Do not use the example passwords above.</em></p>
						</td>
					</tr>
		        	<tr>
		        		<td align="right">
		        			Choose a password:
		        		</td>
		        		<td>
		        			<input type="password" Class="required" size="25" tabindex="1" id="field01" name="fields[4]" ccvalid="password"  />
		        		</td>
		        	</tr>
		        	<tr>
		        		<td align="right">
		        			Re-enter your password:
		        		</td>
		        		<td>
		        			 <input type="password" Class="required" size="25" tabindex="1" id="field01" name="fields[2]" ccvalid="password"  />
		        		</td>
		        	</tr>
		        </table>
				<input type="hidden" name="lt" value="${loginTicket}" />
				<input type="hidden" name="execution" value="${flowExecutionKey}" />
				<input type="hidden" name="_eventId" value="submit" />
		        <input type="submit" value="Continue" id="btnSubmit" />
		        <div id="MainErrorFoot" style="display:none;background:#F00"> 
					<strong>There was an error with your form. Please fix all fields as noted above in pink.</strong> 
				</div>
	        	<div id="field01Error" style="display:none;background:#FFDAD9"></div>
		        </div>
		    </form:form>
		
</div>
<script src="https://www.conncoll.edu/scripts/ccValidator.js"></script>
<jsp:directive.include file="includes/Bottom.jsp" />