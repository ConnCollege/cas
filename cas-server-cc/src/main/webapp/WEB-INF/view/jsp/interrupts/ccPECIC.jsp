<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.webflow.execution.RequestContext" %>
<%@ page import="org.springframework.webflow.execution.RequestContextHolder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="hasForm" value="0" scope="page" />
<!DOCTYPE html>

<html lang="en">

<head>
  <title>Confirm Parent and Emergency Contact Information</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="https://code.jquery.com/ui/1.11.3/jquery-ui.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <script src="https://www.conncoll.edu/scripts/jqueryUI/touch-punch/jquery.ui.touch-punch.min.js"></script>
  <link rel="stylesheet" href="https://www.conncoll.edu/scripts/bootstrap-switch-master/dist/css/bootstrap3/bootstrap-switch.css">
  <script src="https://www.conncoll.edu/scripts/bootstrap-switch-master/dist/js/bootstrap-switch.js"></script>  
  
  <link rel="stylesheet" href="/cas/css/ccPECIC.css">  

</head>
<body>

<div class="container">
  <h2>Confirm Contact Information</h2>
  <div class="errorMessage" <c:if test="${SourceFlag != 'PECIE'}">style="padding-top:10px;"</c:if>>
  	<c:if test="${SourceFlag == 'PECIE'}">
  		<h3>Almost Done!</h3>
  	</c:if>
  	<p>Please confirm your contact information, parent/guardian and emergency contact information by clicking the <strong>Confirm</strong> button below.</p>
  </div>
 <%--  StudentAddr: ${StudentAddr} --%>
  <br>
  <%-- StudentHomePhone: ${StudentHomePhone} --%>
  <div id="step1">
  	<h3>Step 1 Verify Your Permanent Mailing Address <small><span class="edit_link">Edit My Info</span></small></h3>	
 	<div class="row">
      <div class="col-xs-3">
          <div>Address 1</div>
      </div>
      <div class="col-xs-9">
          <div>${StudentAddr['ADDR_STREET_LINE1']}</div>
      </div>
    </div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>Address 2</div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentAddr['ADDR_STREET_LINE2']}</div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>Country </div>
	 	</div>
	 	<div class="col-xs-9">	 		
	     	<div><c:out value="${fn:length(StudentAddr['ADDR_NATN_CODE']) == 0 ? 'U.S.' : StudentAddr['ADDR_NATN_CODE']}" /></div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>City </div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentAddr['ADDR_CITY']}</div>
	  	</div> 
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>
		    	<c:choose>
		    		<c:when test="${StudentAddr['ADDR_NATN_CODE'] == 'US'}">
		    			State
		    		</c:when>
		    		<c:otherwise>
		    			Province/Region
		    		</c:otherwise>
		    	</c:choose>
	    	</div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentAddr['ADDR_STAT_CODE']}</div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>Zip/Postal Code </div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentAddr['ADDR_ZIP']}</div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>Home Phone </div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>
		     	<c:choose>
		     		<c:when test="${fn:length(StudentHomePhone['PHONE_NUMBER_INTL']) != 0}">
		     			${StudentHomePhone['PHONE_NUMBER_INTL']}
		     		</c:when>
		     		<c:otherwise>
		     			${StudentHomePhone['PHONE_AREA_CODE']}&nbsp;${StudentHomePhone['PHONE_NUMBER']}
		     		</c:otherwise>
		     	</c:choose>
	     	</div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>Non College Email</div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentEmail['EMAIL_ADDRESS']}</div>
	  	</div>
	</div>
  </div> 
  <br>
<%-- StudentCellPhone: ${StudentCellPhone} 
 StudentEmrPhone: ${StudentEmrPhone } --%>
  <div id="step2">
  	<h3>Step 2 Your Emergency Contact Information</h3>
  	<c:choose>	
	  	<c:when test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'Y'}">
			<div class="row">
				<div class="col-xs-3">
			    	<div>Emergency Phone </div>
			 	</div>
			 	<div class="col-xs-9">
			     	<div>
				     	<c:choose>
				     		<c:when test="${fn:length(StudentEmrPhone['PHONE_NUMBER_INTL']) != 0}">
				     			${StudentEmrPhone['PHONE_NUMBER_INTL']}
				     		</c:when>
				     		<c:otherwise>
				     			${StudentEmrPhone['PHONE_AREA_CODE']}&nbsp;${StudentEmrPhone['PHONE_NUMBER']}
				     		</c:otherwise>
				     	</c:choose>
			     	</div>
			  	</div>
			</div>
		</c:when>
		<c:otherwise>
			<div class="row">
				<div class="col-xs-3">
			    	<div>Mobile Phone </div>
			 	</div>
			 	<div class="col-xs-9">
			     	<div>
				     	<c:choose>
				     		<c:when test="${fn:length(StudentCellPhone['PHONE_NUMBER_INTL']) != 0}">
				     			${StudentCellPhone['PHONE_NUMBER_INTL']}
				     		</c:when>
				     		<c:otherwise>
				     			${StudentCellPhone['PHONE_AREA_CODE']}&nbsp;${StudentCellPhone['PHONE_NUMBER']}
				     		</c:otherwise>
				     	</c:choose>
			     	</div>
			  	</div>
			</div>
		</c:otherwise>
	</c:choose>
	<div class="row">
		<div class="col-xs-3">
	    	<div>Phone Carrier </div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentCellPhone['CELL_PHONE_CARRIER']}</div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>Send Text </div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentBio['EMERG_SEND_TEXT']}</div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>TTY Device</div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentBio['EMERG_PHONE_TTY_DEVICE']}</div>
	  	</div>
	</div>
<%-- 	<div class="row">
		<div class="col-xs-3">
	    	<div>Opt Out of Campus Alerts</div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentBio['EMERG_AUTO_OPT_OUT']}</div>
	  	</div>
	</div>
  </div> --%>
  
  <div id="step3">
  	<h3>Step 3 Parent/Guardian Information <small><span class="edit_link">Edit Parent/Guardian Info</span></small></h3>	
  	
  	<div class="confirm_section"> 
		<c:set var="x" value="0" scope="page" />	    
	    <c:forEach items="${StudentParents}" var="parents">
	    	<c:set var="x" value="${x + 1}" scope="page" /> 
	    	<div class="contact_info info_box" id="PARENT_${parents.PARENT_PPID}" data-type-id="PARENT" data-ppid="${parents.PARENT_PPID}">
				<h4>Parent/Guardian ${x}</h4>
		    </div>	   		    
	    </c:forEach>    
	    <c:if test="${x == 0 }">
	    	<p><em>None Entered</em></p>
	    </c:if>
    </div>
  </div>
  
    <div id="step4">
  	<h3>Step 4 Emergency Contacts <small><span class="edit_link">Edit or Reorder Contacts</span></small></h3>
  	<%-- ${StudentEMR} --%>
  	<div class="confirm_section">
  		<c:set var="y" value="0" scope="page" />	
	  	 <c:forEach items="${StudentEMR}" var="contacts">
	  	 	<c:if test="${fn:length(contacts.PARENT_PPID) > 0 }">
		  	 	<c:set var="y" value="${y + 1}" scope="page" />	
		    	<div class="contact_info info_box" id="CONTACT_${contacts.PARENT_PPID}" data-type-id="CONTACT" data-ppid="${contacts.PARENT_PPID}">
					<h4>Emergency Contact ${y}</h4>
			    </div>
			 </c:if>			        
	    </c:forEach> 
	    <c:if test="${y == 0 }">
	    	<p><em>None Entered</em></p>
	    </c:if>   
    </div>
  </div>
 <%-- ${EmmrgPhones} --%>
   <div id="step5">
  	<h3>Step 5 Campus Alert Phone Numbers <small><span class="edit_link">Edit Campus Alert Phone Numbers</span></small></h3>
  	<%-- EmmergPhones: ${EmmrgPhones} --%>
  	<div class="confirm_section">
  	<p id="doc_message">These numbers will be contacted in the case of a campus emergency.</p>
  		<ul>
		    <c:forEach items="${EmmrgPhones}" var="emmrg">
		    	 <c:if test="${fn:length(emmrg.PHONE_CODE) != 0 }">
		    	 	<c:choose>
		    	 		<c:when test="${fn:length(emmrg.PHONE_NUMBER_INTL) != 0 }">
		    	 			<li class="list-unstyled">&nbsp;${emmrg.PHONE_NUMBER_INTL}&nbsp;(${emmrg.PREF_NAME })</li>
		    	 		</c:when>
		    	 		<c:otherwise>
		    	 			<li class="list-unstyled">&nbsp;${emmrg.PHONE_AREA_CODE}&nbsp;${emmrg.PHONE_NUMBER}&nbsp;(${emmrg.PREF_NAME })</li>
		    	 		</c:otherwise>
		    	 	</c:choose>
		    	 	
		    	 </c:if>
		    </c:forEach>
		</ul>
    </div>
    <div class="row">
    	<div class="col-sm-offset-4  col-xs-3">
    		<button type="submit" id="confirm_button" class="btn btn-primary">Confirm</button>
    	</div>
    </div>
  </div>

</div>


<form:form id="editForm" commandName="${commandName}" htmlEscape="true" method="post" >
	<input type="hidden" name="lt" value="${loginTicket}" />
	<input type="hidden" name="execution" value="${flowExecutionKey}" />
	<input type="hidden" name="_eventId" value="submit" />
	<input type="hidden" name="fields[1]" value="edit">		
</form:form>

<form:form id="confirmForm" commandName="${commandName}" htmlEscape="true" method="post" >
	<input type="hidden" name="lt" value="${loginTicket}" />
	<input type="hidden" name="execution" value="${flowExecutionKey}" />
	<input type="hidden" name="_eventId" value="submit" />
	<input type="hidden" name="fields[1]" value="confirm">	
</form:form>

<script type="text/javascript">	
	demoFields = ["PARENT_LEGAL_PREFIX_NAME","PARENT_PREF_FIRST_NAME","PARENT_PREF_MIDDLE_NAME","PARENT_PREF_LAST_NAME","PARENT_LEGAL_SUFFIX_NAME","EMERG_RELT_CODE","PARENT_RELT_CODE","DEPENDENT","ADDR_STREET_LINE1","ADDR_STREET_LINE2","ADDR_CITY","ADDR_STAT_CODE","ADDR_ZIP","ADDR_NATN_CODE","EMAIL_ADDRESS","EMERG_LEGAL_PREFIX_NAME","EMERG_PREF_FIRST_NAME","EMERG_PREF_MIDDLE_NAME","EMERG_PREF_LAST_NAME","EMERG_LEGAL_SUFFIX_NAME","DEPENDENT","ADDR_STREET_LINE1","ADDR_STREET_LINE2","ADDR_CITY","ADDR_STAT_CODE","ADDR_ZIP","ADDR_NATN_CODE","EMAIL_ADDRESS","EMERG_NO_CELL_PHONE"];
	demoValues = ["Prefix","First Name","Middle Name","Last Name","Suffix","Relationship","Relationship","Dependent","Address 1","Address 2","City","State","Zip/Postal","Country","Email Address","Prefix","First Name","Middle Name","Last Name","Suffix","Dependent","Address 1","Address 2","City","State","Zip/Postal","Country","Email Address","No Cell Phone"]
	
	phoneFields = ["PECI_PHONE_CODE","PHONE_AREA_CODE","PHONE_NUMBER","CELL_PHONE_CARRIER"];
	phoneValues= ["Phone Type","Area Code","Phone Number","Phone Carrier"]
	relationshipCodes  = [];
	relationshipValues = [];
	<c:forEach items="${options['Relationships']}" var="relationships">
		relationshipCodes.push("${relationships.key}");
		relationshipValues.push("${relationships.value}");
	</c:forEach>
	stateCodes  = [];
	stateValues = [];
	<c:forEach items="${options['States']}" var="states">
		stateCodes.push("${states.key}");
		stateValues.push("${states.value}");
	</c:forEach>
	countryCodes  = [];
	countryValues = [];
	<c:forEach items="${options['Countries']}" var="countries">
		countryCodes.push("${countries.key}");
		countryValues.push("${countries.value}");
	</c:forEach>
	regionCodes  = [];
	regionValues = [];
	<c:forEach items="${options['Regions']}" var="regions">
		regionCodes.push("${regions.key}");
		regionValues.push("${regions.value}");
	</c:forEach>
	
	$student_PIDM = '${StudentBio['STUDENT_PIDM']}';	
	var x = 0;
	var y= 0;

</script>
<script type="text/javascript" src="/cas/js/ccPECIC.js?version=10105"></script>   	

</body>
</html>
