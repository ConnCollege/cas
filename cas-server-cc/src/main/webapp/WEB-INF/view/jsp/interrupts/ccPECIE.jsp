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
  <title>Parent and Emergency Contact Information</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="//code.jquery.com/ui/1.11.3/jquery-ui.min.js"></script>
  <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <script src="//www.conncoll.edu/scripts/jqueryUI/touch-punch/jquery.ui.touch-punch.min.js"></script>
  <link rel="stylesheet" href="//www.conncoll.edu/scripts/bootstrap-switch-master/dist/css/bootstrap3/bootstrap-switch.css">
  <script src="//www.conncoll.edu/scripts/bootstrap-switch-master/dist/js/bootstrap-switch.js"></script> 
  
  <link rel="stylesheet" href="/cas/css/ccPECIE.css"> 
  
  <script type="text/javascript">
  jQuery(function($) {
      var panelList = $('.draggablePanelList');

      panelList.sortable({
          // Only make the .panel-heading child elements support dragging.
          // Omit this to make then entire <li>...</li> draggable.
          handle: '.panel-heading', 
          update: function() {        	  
              setEmrOrder();    
          },
          stop: function() {
              //console.log("stopped drag");
          }
      });
      
      //turn on bootstrap style switch for checkboxes with that class 
      $(".bootstrap-switch").bootstrapSwitch();
      
  }); 
  
  </script>
  
  <noscript>
    <style type="text/css">
        .container {display:none;}
    </style>
    <div id="noscriptmsg">
    	<p style="margin-top: 30px;"><center>The Parent and Emergency Contact Information Form <strong>requires javascript enabled</strong> in your browser.<br>Please turn on javascript or use a browser with javascript enabled.</center></p>
    </div>
</noscript>

</head>
<body>

<div class="container">
  <h2>Your Contact Information</h2>
  <p>Please enter your personal, parent/guardian and emergency contact information below.</p> 
  <form class="form-horizontal" method="post" role="form" id="STUDENT" onsubmit="return submitMainForm(this.id);"> 
 
  <div id="step1" class="form_section">
	<h3>Step 1 Your Permanent Mailing Address</h3>
	<p>Please <strong>do not</strong> enter your local or campus address. </p>

	<p><span class="required">* </span>Required Field</p>  
	<%-- ${StudentBio} --%> 
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_FORM_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error">There was an error with your form submission. Please fix the areas indicated in red below.</span></div>
		
	<div class="form-group" id="group_student_firstname">
		<label for="country" class="control-label col-sm-3">First Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="First Name" name="" class="form-control" id="STUDENT_PREF_FIRST_NAME" value="${StudentBio['PREFERRED_FIRST_NAME']}">
		</div>
	</div>
	<div class="form-group" id="group_student_middle_name">
		<label for="country" class="control-label col-sm-3">Middle Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="Middle Name" name="" class="form-control" id="STUDENT_PREF_MIDDLE_NAME" value="${StudentBio['PREFERRED_MIDDLE_NAME']}">
		</div>
	</div>
	<div class="form-group" id="group_student_last_name">
		<label for="country" class="control-label col-sm-3">Last Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="Last Name" name="" class="form-control" id="STUDENT_PREF_LAST_NAME" value="${StudentBio['PREFERRED_LAST_NAME']}">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_CAMPUS_ADDR_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDRESS_STREET_LINE1">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>Address Line 1</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 1" name="fields[4]" maxlength="75" class="form-control ccreq address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_STREET_LINE1" value="${StudentAddr['ADDR_STREET_LINE1']}">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDRESS_STREET_LINE2">
		<label for="country" class="control-label col-sm-3">Address Line 2</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 2" name="fields[5]" maxlength="75" class="form-control address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_STREET_LINE2" value="${StudentAddr['ADDR_STREET_LINE2']}">
		</div>
	</div>  

	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDR_NATN_CODE">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>Country</label>
		<div class="col-sm-8">
			<select class="form-control address_field ccreq country_field STUDENT_ADDRESS_FIELD" placeholder="Country" name="fields[6]" id="STUDENT_ADDR_NATN_CODE">
				<option value="">Choose Country </option>
				<c:forEach items="${options['Countries']}" var="countries">
					<option <c:if test="${countries.key == StudentAddr['ADDR_NATN_CODE'] || ((countries.key == 'US') && (StudentAddr['ADDR_NATN_CODE'] == null))}">selected="selected"</c:if> value="${countries.key}">${countries.value}</option>
				</c:forEach>
			</select>			
		</div>
		<div class="col-sm-1">
			<a data-content="If you do not see the correct country listed, please select 'other' and email the Registrar's office at  &lt;a href='mailto:registrar@conncoll.edu' target='_blank'&gt;registrar@conncoll.edu&lt;/a&gt;. In your email, please let the Registrar's office know your full name and the name of the country." data-placement="top" data-title="Country Selection" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title="" style="top:8px;right:10px;"></a>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_CITY_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDR_CITY">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span><span class="city"><c:out value="${StudentAddr['ADDR_NATN_CODE'] != 'US' && StudentAddr['ADDR_NATN_CODE'] != null && fn:length(StudentAddr['ADDR_NATN_CODE']) != 0 ? 'Postal Code & City' : 'City'}"></c:out></span></label>
		<div class="col-sm-9">
				<input type="text" placeholder="City" name="fields[7]" maxlength="75" class="form-control ccreq address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_CITY" value="${StudentAddr['ADDR_CITY']}">
		</div>
	</div>  
	<%-- ${options} --%>
<%-- States: ${options['States']} --%>
<%-- ${StudentAddr['ADDR_NATN_CODE']} --%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDR_STAT_CODE" style="<c:if test="${StudentAddr['ADDR_NATN_CODE'] != 'US' && StudentAddr['ADDR_NATN_CODE'] != null}">display:none;</c:if>">
		<label for="state" class="control-label col-sm-3"><span class="required">* </span>State</label>
		<div class="col-sm-9">
			<select class="form-control address_field <c:if test="${StudentAddr['ADDR_NATN_CODE'] == 'US' || StudentAddr['ADDR_NATN_CODE'] == null || fn:length(StudentAddr['ADDR_NATN_CODE']) == 0}">ccreq</c:if> STUDENT_ADDRESS_FIELD" placeholder="State" name="fields[8]" id="STUDENT_ADDR_STAT_CODE" <c:if test="${StudentAddr['ADDR_NATN_CODE'] != 'US' && StudentAddr['ADDR_NATN_CODE'] != null && fn:length(StudentAddr['ADDR_NATN_CODE']) != 0}">disabled="disabled"</c:if>>
				<option value="">Choose State</option>
				<c:forEach items="${options['States']}" var="states">
					<option <c:if test="${states.key == StudentAddr['ADDR_STAT_CODE']}">selected="selected"</c:if> value="${states.key}">${states.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<%-- Regions: ${options['Regions']}
	StudentAddr: ${StudentAddr} --%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div  style="<c:if test="${StudentAddr['ADDR_NATN_CODE'] == 'US' || StudentAddr['ADDR_NATN_CODE'] == null || fn:length(StudentAddr['ADDR_NATN_CODE']) == 0}">display:none;</c:if>" class="form-group" id="GROUP_STUDENT_INTL_REGION">
		<label for="state" class="control-label col-sm-3">Province/Region</label>
		<%-- <div class="col-sm-9">
			<input type="text" placeholder="Province/Region" name="fields[9]" class="form-control address_field" id="STUDENT_ADDR_STAT_CODE" value="${StudentAddr['ADDR_STAT_CODE']}">
		</div> --%>
		<div class="col-sm-9">
			<select class="form-control address_field STUDENT_ADDRESS_FIELD" placeholder="State" name="fields[8]" id="STUDENT_ADDR_PROV_REGION" <c:if test="${StudentAddr['ADDR_NATN_CODE'] == 'US' || StudentAddr['ADDR_NATN_CODE'] == null || fn:length(StudentAddr['ADDR_NATN_CODE']) == 0}">disabled="disabled"</c:if>>
				<option value="">Choose Province/Region</option>
				<option value="">Not Applicable</option>
				<option value="">Other</option>
				<c:forEach items="${options['Regions']}" var="regions">
					<option <c:if test="${regions.key == StudentAddr['ADDR_STAT_CODE']}">selected="selected"</c:if> value="${regions.key}">${regions.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_ZIP_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDR_ZIP" style="<c:if test="${StudentAddr['ADDR_NATN_CODE'] != 'US' && StudentAddr['ADDR_NATN_CODE'] != null && fn:length(StudentAddr['ADDR_NATN_CODE']) != 0}">display:none;</c:if>">
		<label for="Postal Code" class="control-label col-sm-3 address_field"><span class="required" style="<c:if test="${StudentAddr['ADDR_NATN_CODE'] != 'US' && StudentAddr['ADDR_NATN_CODE'] != null && fn:length(StudentAddr['ADDR_NATN_CODE']) != 0}">display:none;</c:if>">* </span>Zip/Postal Code</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Postal Code" name="fields[10]" maxlength="30" class="form-control <c:if test="${StudentAddr['ADDR_NATN_CODE'] == 'US' || StudentAddr['ADDR_NATN_CODE'] == null || fn:length(StudentAddr['ADDR_NATN_CODE']) == 0}">ccreq</c:if> address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_ZIP" value="${StudentAddr['ADDR_ZIP']}">
		</div>
	</div> 

	<div id='STUDENT_CLNADDR_RESULTS' name='STUDENT_CLNADDR_RESULTS'></div>	
	<div id="suggestionListDiv" style="display: none;"></div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_MA_PHONE_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_MA_PHONE_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<%-- ${StudentHomePhone} --%>
	<div class="form-group" id="GROUP_STUDENT_PHONE_MA_NUMBER" style="<c:if test="${fn:length(StudentHomePhone['PHONE_NUMBER_INTL']) != 0}">display:none;</c:if>">
		<label for="Phone" class="control-label col-sm-3">Home Phone</label>
		<div class="col-sm-3">
			<span class="mobile_label">Area Code: </span><input type="tel" placeholder="Area Code" name="fields[27]" id="STUDENT_PHONE_MA_AREA_CODE" size="3" class="form-control area_code num_only" value="${StudentHomePhone['PHONE_AREA_CODE']}" maxlength="3">
		</div>
		<div class="col-sm-6">
			<span class="mobile_label">Phone Number: </span><input type="tel" placeholder="Home Phone" name="fields[11]" id="STUDENT_PHONE_MA_NUMBER" size="7" class="form-control phone_number num_only" value="${StudentHomePhone['PHONE_NUMBER']}" maxlength="7">
			<input type="hidden" name="fields[31]" id="STUDENT_MA_PHONE_SEQUENCE_NO" value="${StudentHomePhone['PHONE_SEQUENCE_NO']}">
		</div>
	</div> 
 <%-- Student Home Phone: ${StudentHomePhone} --%>
		<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_MA_PHONE_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
	<div style="<c:if test="${fn:length(StudentHomePhone['PHONE_NUMBER_INTL']) == 0}">display:none;</c:if>" class="form-group" id="GROUP_STUDENT_PHONE_MA_NUMBER_INTL">
		<label for="tel" class="control-label col-sm-3">Home Phone</label>
		<div class="col-sm-9">
			<input type="text" placeholder="International Number" name="fields[28]" size="7" maxlength="45" class="form-control" id="STUDENT_PHONE_MA_NUMBER_INTL" value="${StudentHomePhone['PHONE_NUMBER_INTL']}">
		</div>
	</div>	
	
	<div class="form-group" id="group_student_MA_intl_phone_switch">
		<label class="col-sm-4"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="MA" class="intl_number_switch col-sm-4">Enter <c:out value="${fn:length(StudentHomePhone['PHONE_NUMBER_INTL']) == 0 ? 'International' : 'U.S.'}" /> Number</span>							
	</div>		
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_EMAIL_ADDRESS_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	
	<div class="form-group" id="group_student_non_college_email">
		<label for="Email" class="control-label col-sm-3">Non-college email</label>
		<div class="col-sm-9">
				<input type="email" type="text" placeholder="Non-college email" maxlength="75" name="fields[12]" maxlength="128" class="form-control" id="STUDENT_EMAIL_ADDRESS" value="${StudentEmail['EMAIL_ADDRESS']}">
		</div>
	</div> 
	
	</div>
 <%-- ${StudentCellPhone} --%>

	<div id="step2" class="form_section">
	<h3>Step 2 Your Emergency Phone Number</h3>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_CP_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_CP_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_PHONE_CP_NUMBER" style="<c:if test="${fn:length(StudentCellPhone['PHONE_NUMBER_INTL']) != 0}">display:none;</c:if>">
		<label for="Phone" class="control-label col-sm-3"><span class="required" style="<c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'Y'}">display:none;</c:if>">* </span>Mobile Phone</label>		
		<div class="col-sm-3">
			<span class="mobile_label">Area Code: </span><input type="tel" data-phone-type="CP" data-phone-intl="0" placeholder="Area Code" name="fields[23]" id="STUDENT_PHONE_CP_AREA_CODE" size="3" class="form-control <c:if test="${(StudentBio['EMERG_NO_CELL_PHONE'] == 'N'  || fn:length(StudentBio['EMERG_NO_CELL_PHONE']) == 0) && fn:length(StudentCellPhone['PHONE_NUMBER_INTL']) == 0}">ccreq</c:if> area_code num_only student_phone_field" value="${StudentCellPhone['PHONE_AREA_CODE']}" maxlength="3">
		</div>
		<div class="col-sm-6">
			<span class="mobile_label">Phone Number: </span><input type="tel" data-phone-type="CP" data-phone-intl="0" placeholder="Mobile Phone" name="fields[13]" id="STUDENT_PHONE_CP_NUMBER" size="7" class="form-control <c:if test="${(StudentBio['EMERG_NO_CELL_PHONE'] == 'N'  || fn:length(StudentBio['EMERG_NO_CELL_PHONE']) == 0) && fn:length(StudentCellPhone['PHONE_NUMBER_INTL']) == 0}">ccreq</c:if> num_only phone_number student_phone_field" value="${StudentCellPhone['PHONE_NUMBER']}" maxlength="7">
			<input type="hidden" name="fields[32]" id="STUDENT_CP_PHONE_SEQUENCE_NO" value="${StudentCellPhone['PHONE_SEQUENCE_NO']}">
		</div>
	</div> 	
	<%-- Student Cell Phone: ${StudentCellPhone} --%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_CP_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
	<div style="<c:if test="${fn:length(StudentCellPhone['PHONE_NUMBER_INTL']) == 0}">display:none;</c:if>" class="form-group" id="GROUP_STUDENT_PHONE_CP_NUMBER_INTL">
		<label for="tel" class="control-label col-sm-3"><span class="required">* </span>Mobile Phone</label>
		<div class="col-sm-9">
			<input type="text" data-phone-type="CP" data-phone-intl="1" placeholder="International Number" name="fields[24]" size="7" maxlength="45" class="form-control student_phone_field" id="STUDENT_PHONE_CP_NUMBER_INTL" value="${StudentCellPhone['PHONE_NUMBER_INTL']}">
		</div>
	</div>		
	
	<div class="form-group" id="group_student_intl_phone_switch">
		<label class="col-sm-4"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="CP" class="intl_number_switch col-sm-4">Enter <c:out value="${fn:length(StudentCellPhone['PHONE_NUMBER_INTL']) == 0 ? 'International' : 'U.S.'}" /> Number</span>							
	</div>		  			
		  				
		<%
			/*out.print(displayInput(true,"","Mobile Phone",2,10,"student_mobile_phone","tel","",true,false));*/
		%>

	<div class="form-group" id="GROUP_STUDENT_PHONE_CARRIER">
		<label for="Phone Carrier" class="control-label col-sm-3">Phone Carrier</label>
		<div class="col-sm-9">
			<select class="form-control" placeholder="Phone Carrier" name="fields[14]" id="STUDENT_PHONE_CARRIER">
				<option value="">Choose Phone Carrier</option>
				<c:forEach items="${options['Carriers']}" var="carriers">
					<option value="${carriers.key}" <c:if test="${StudentCellPhone['CELL_PHONE_CARRIER'] == carriers.key }">selected="selected"</c:if>>${carriers.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="form-group" id="group_student_mobile_phone_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" name="fields[15]" class="mobile_phone_check" data-mobile-type="STUDENT" <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'Y'}"> checked="checked"</c:if>>I don't have a mobile phone</label>
			</div>
		</div>
	</div>

	 <%-- EmrPhone: ${StudentEmrPhone} --%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_EMERGENCY_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_EMERGENCY_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_PHONE_EMERGENCY_NUMBER" style="<c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'N' || StudentBio['EMERG_NO_CELL_PHONE'] == null || fn:length(StudentEmrPhone['PHONE_NUMBER_INTL']) != 0 }">display:none;</c:if>">
		<label for="Phone" class="control-label col-sm-3 address_field"><span class="required">* </span>Emergency Phone</label>		
		<div class="col-sm-3">
			<span class="mobile_label">Area Code: </span><input type="tel" data-phone-type="EMERGENCY" data-phone-intl="0" placeholder="Area Code" name="fields[29]" id="STUDENT_PHONE_EMERGENCY_AREA_CODE" size="3" class="form-control area_code num_only <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'Y' && fn:length(StudentEmrPhone['PHONE_NUMBER_INTL']) == 0}">ccreq</c:if> student_phone_field" value="${StudentEmrPhone['PHONE_AREA_CODE']}" maxlength="3">
		</div>
		<div class="col-sm-6">
			<span class="mobile_label">Phone Number: </span><input type="tel" data-phone-type="EMERGENCY" data-phone-intl="0" placeholder="Emergency Phone" name="fields[16]" id="STUDENT_PHONE_EMERGENCY_NUMBER" size="7" class="form-control phone_number num_only <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'Y' && fn:length(StudentEmrPhone['PHONE_NUMBER_INTL']) == 0}">ccreq</c:if> student_phone_field" value="${StudentEmrPhone['PHONE_NUMBER']}" maxlength="7">
			<input type="hidden" name="fields[34]" id="STUDENT_EMR_PHONE_SEQUENCE_NO" value="${StudentEmrPhone['PHONE_SEQUENCE_NO']}">			
		</div>
	</div> 
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_EMERGENCY_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
	<div style="<c:if test="${fn:length(StudentEmrPhone['PHONE_NUMBER_INTL']) == 0 || StudentBio['EMERG_NO_CELL_PHONE'] == 'N' }">display:none;</c:if>" class="form-group" id="GROUP_STUDENT_PHONE_EMERGENCY_NUMBER_INTL">
		<label for="tel" class="control-label col-sm-3"><span class="required">* </span>Emergency Phone</label>
		<div class="col-sm-9">
			<input type="text" data-phone-type="EMERGENCY" data-phone-intl="1" placeholder="International Number" name="fields[30]" size="7" maxlength="45" class="form-control student_phone_field" id="STUDENT_PHONE_EMERGENCY_NUMBER_INTL" value="${StudentEmrPhone['PHONE_NUMBER_INTL']}">
		</div>
	</div>	
	
	<div class="form-group" id="GROUP_STUDENT_PHONE_EMERGENCY_NUMBER_INTL_SWITCH" style="<c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'N' || StudentBio['EMERG_NO_CELL_PHONE'] == null }">display:none;</c:if>">
		<label class="col-sm-4"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="EMERGENCY" class="intl_number_switch col-sm-4">Enter <c:out value="${fn:length(StudentEmrPhone['PHONE_NUMBER_INTL']) == 0 ? 'International' : 'U.S.'}" /> Number</span>							
	</div>	
	
	<p class="q_check" id="paragraph_alert_text_check">Connecticut College will contact this number in the case of a campus emergency. Do you wish to also receive a text message at this number in the case of a campus emergency?</p>
	<div class="form-group" id="group_alert_text_check"> 
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="fields[17]" id="alert_text_check" <c:if test="${StudentBio['EMERG_SEND_TEXT'] == 'Y'}">checked="checked"</c:if> value="Y">Yes send me a text message in the event of an emergency</label>
			</div>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="tty_device_check_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<p class="q_check" id="paragraph_tty_device_check">If your mobile phone is a TTY device (for the hearing impaired) please indicate below:</p>
	<div class="form-group" id="group_tty_device_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="fields[18]" id="tty_device_check" <c:if test="${StudentBio['EMERG_PHONE_TTY_DEVICE'] == 'Y'}" >checked="checked"</c:if> value="Y">This phone is a TTY device</label>
			</div>
		</div>
	</div>
<%-- 	<p class="q_check" id="paragraph_alert_home_email_check">If you do not wish to receive campus alerts beyond those to your campus email and voice mail, check the box below:</p>
	<div style="display:none;" role="alert" class="alert alert-danger" id="alert_home_email_check_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_alert_home_email_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="fields[19]" id="alert_home_email_check" <c:if test="${StudentBio['EMERG_AUTO_OPT_OUT'] == 'Y'}">checked="checked"</c:if> value="Y">Opt out of automated campus alerts to my home email and cell phone</label>
			</div>
		</div>
	</div> --%>
	

	
	<%
			/*out.print(displayCheckbox(false,"I don't have a mobile phone",2,10, "student_mobile_phone_check", "", "", "",false,false,"",""));
			out.print(displayInput(false,"","Emergency Phone",2,10,"student_emergency_phone","tel","",false,false));
			out.print(displayCheckbox(false,"Yes send me a text message in the event of an emergency",2,10, "alert_text_check", "", "", "Connecticut College will contact this number in the case of a campus emergency. Do you wish to also receive a text message at this number in the case of a campus emergency?",false,false,"",""));
			out.print(displayCheckbox(false,"This phone is a TTY device",2,10,"tty_device_check","","","If your mobile phone is a TTY device (for the hearing impaired) please indicate below:",false,false,"",""));
			out.print(displayCheckbox(false,"Opt out of automated campus alerts to my home email and cell phone",2,10,"alert_home_email_check","","","If you do not wish to receive campus alerts beyond those to your campus email and voice mail, check the box below:",false,false,"",""));*/
		%>
    </div>
    <div id="step3" class="form_section">
	    <h3>Step 3 Parent/Guardian Information</h3>
	    <div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_NUM_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error">You are required to enter at least one parent</span></div>
	    <div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error">You are required to designate at least one parent or guardian as an emergency contact. Exceptions to this policy must be approved by the Dean of the College <a href="mailto:doc@conncoll.edu" target="_blank">doc@conncoll.edu</a></span></div>
	    
	    <c:choose>
	    	<c:when test = "${StudentBio['DEAN_EXCEPTION_DATE'] != null}">
	    		<p id="doc_message">You are <strong>not</strong> required to include a parent or guardian as an emergency contact. You are required to have at least one emergency contact, which you can add in the additional emergency contacts section below.</strong></p>
	    	</c:when>
	    	<c:otherwise>
	    		<p id="doc_message">Please list <strong>all</strong> parent/guardian contacts below. You are required to designate at least one parent or guardian as an emergency contact. Exceptions to this policy must be approved by the Dean of the College <a href="mailto:doc@conncoll.edu" target="_blank">doc@conncoll.edu</a>. <a data-content="<strong>For students with no living parent/guardian</strong> - please enter a spouse or the most appropriate next of kin (aunt, uncle, etc.).<br/><br/><strong>For students who do not wish to list parents or guardians as emergency contacts</strong> - please enter one parent/guardian to complete this form. You may email the Dean of the College for an exception at &lt;a href='mailto:doc@conncoll.edu' target='_blank'&gt;doc@conncoll.edu&lt;/a&gt;. Once granted, the form will permit you to remove the parent/guardian from your emergency contacts." data-placement="top" data-title="Parent/Guardian Exception" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title=""></a></p>
	    	</c:otherwise>
	    </c:choose> 

	<div id="PARENT_LIST">
	 	<c:forEach items="${StudentParents}" var="parents">
			<div class="panel panel-default PARENT-LISTED" id="parent_${parents.PARENT_PPID}">
			  <div class="panel-body">
			    <span class="contact-name"><strong>${parents.PARENT_PREF_FIRST_NAME } ${parents.PARENT_PREF_LAST_NAME } </strong></span><a href="#" title="Edit" class="showModal" data-ppid="${parents.PARENT_PPID}" data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="${parents.PARENT_PREF_FIRST_NAME } ${parents.PARENT_PREF_LAST_NAME }" data-ppid="${parents.PARENT_PPID}" data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a><span class="emergency_contact_switch">&nbsp;Emergency Contact: <input type="checkbox" name="PARENT" class="bootstrap-switch parent-bootstrap-switch" data-ppid="${parents.PARENT_PPID}" data-off-text="No" data-on-text="Yes"></span>
			  </div>
			</div>
		</c:forEach>	
	</div>
	 
	     <div class="form-group">        
	      <div class="col-sm-offset-1 col-sm-9">
	        <button id="ADD_PARENT" type="button" class="btn btn-primary" data-toggle="modal" data-target="#PARENT_MODAL" data-parent-ppid="0">Add Parent</button>
	        <span id="PARENT_MAX_ENTERED" style="display:none;">&nbsp;You have entered the maximum number of parents (5).</span>
	      </div>
	    </div>  
    </div>

    <div id="step4" class="form_section">
	    <h3>Step 4 Emergency Contacts</h3>
	    <div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_NUM_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error">You are required to enter at least one emergency contact</span></div>
	    <p id="doc_message">You must have at least one emergency contact. Emergency contacts will be contacted in the order you specify below. Parent/Guardian contacts designated as Emergency Contacts above will appear automatically below. You may also add additional contacts.<br><strong>If Connecticut College is a long way from home, and there is someone who can be contacted nearby in the event of an emergency, please add that person as one of your contacts.</strong></p>
		<ul id="CONTACT_LIST" class="draggablePanelList list-unstyled">
			<c:set var="emergency_contact_order" value="" scope="page" />
			<c:forEach items="${StudentEMR}" var="emr" varStatus="status">
				<li class="panel panel-info CONTACT-LISTED" id="emr_contact_${emr.PARENT_PPID}"> 
		        	<div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div>
		        	<div class="panel-body"><span class="contact-name"><strong>${emr.EMERG_PREF_FIRST_NAME}  ${emr.EMERG_PREF_LAST_NAME}</strong></span> &nbsp; <a href="#" title="Edit"  class="showModal" data-ppid="${emr.PARENT_PPID}" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="${emr.EMERG_PREF_FIRST_NAME}  ${emr.EMERG_PREF_LAST_NAME}" data-ppid="${emr.PARENT_PPID}" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div>
		    	</li>
		    	<c:set var="emergency_contact_order" value="${emergency_contact_order}${status.first ? '' : ','}${emr.PARENT_PPID}" scope="page" />		    	
			</c:forEach>
			<input name="fields[26]" type="hidden" id="emr_order" value="${emergency_contact_order}" />
		</ul>	
	    
	     <div class="form-group">        
	      <div class="col-sm-offset-1 col-sm-9">
	        <button id="ADD_CONTACT" type="button" class="btn btn-primary" data-toggle="modal" data-target="#CONTACT_MODAL">Add Contact</button>
	        <span id="CONTACT_MAX_ENTERED" style="display:none;">&nbsp;You have entered the maximum number of contacts (6).</span>
	      </div>
	    </div>
    </div>
    <%-- ${EmmrgPhones} --%>
    <div id="step5" class="form_section">
	    <h3>Step 5 Campus Alert Phone Numbers</h3>
	    <p id="doc_message">Please choose up to five phone numbers that may be contacted in the case of a campus emergency (your mobile phone, if it is a U.S. number, will always be contacted).</p>
	    
	    <ul ID="CAMPUS_ALERT_NUMBERS">
		    <c:forEach items="${EmmrgPhones}" var="emmrg">	
		    	<li class="list-unstyled <c:out value="${emmrg.PHONE_CODE == 'EP' ? 'grayed-out' : 'NON-STUDENT-EP-NUMBER'}" />">
		    	<input <c:if test="${emmrg.PHONE_CODE == 'EP' }">id="STUDENT_EP_NUMBER" disabled="disabled"</c:if> type="checkbox" class="alert_phone_number" <c:if test="${emmrg.PHONE_CODE == 'EP' || fn:length(fn:substringAfter(emmrg.PHONE_CODE,'EP')) != 0 }">checked="checked"</c:if> value="${emmrg.PHONE_NUM}" name="fields[25]" >
		    	<span <c:if test="${emmrg.PHONE_CODE == 'EP' }">id="STUDENT_EP_NUMBER_TEXT"</c:if>>&nbsp;${emmrg.PHONE_NUM}&nbsp;(${emmrg.PREF_NAME}<c:if test="${emmrg.PHONE_CODE == 'EP' }"> - Your phone number will always be contacted</c:if>)</span></li>	 
		    	<c:if test="${emmrg.PHONE_CODE == 'EP' || fn:length(fn:substringAfter(emmrg.PHONE_CODE,'EP')) != 0 }"><input type="hidden" name="checked_phone_numbers" value="${emmrg.PHONE_NUM}"></span></c:if>
		  
		    
		    	 <%-- <c:choose>
		    	 	<c:when test="${emmrg.PHONE_CODE == 'EP' }">
		    	 		<!-- Student's emergency number, grey out, check it off and disable it -->
		    	 		<div id="GROUP_STUDENT_EP_NUMBER">
			    	 		<li class="list-unstyled grayed-out"><input id="STUDENT_EP_NUMBER" type="checkbox" class="alert_phone_number" disabled="disabled" checked="checked" value="${emmrg.PHONE_NUM}" name="fields[25]" ><span id="STUDENT_EP_NUMBER_TEXT">&nbsp;${emmrg.PHONE_NUM}&nbsp;(${emmrg.PREF_NAME} - Your phone number will always be contacted)</li>	
		    	 		</div>
		    	 		<input type="hidden" name="checked_phone_numbers" value="${emmrg.PHONE_NUM}"></span>
		    	 	</c:when>
		    	 	<div id="GROUP_ALL_EP_NUMBERS">
			    	 	<c:when test="${fn:length(fn:substringAfter(emmrg.PHONE_CODE,'EP')) != 0 }">
			    	 		<!-- This number is has been previously checked off as a campus alert number, check it off by default -->
			    	 		<li class="list-unstyled"><input type="checkbox" class="alert_phone_number" value="${emmrg.PHONE_NUM}" name="fields[25]" checked="checked">
			    	 		&nbsp;${emmrg.PHONE_NUM}&nbsp;(${emmrg.PREF_NAME})</li>	
			    	 		<input type="hidden" name="checked_phone_numbers" value="${emmrg.PHONE_NUM}">
			    	 	</c:when>
			    	 	<c:otherwise>
			    	 		<li class="list-unstyled"><input type="checkbox" class="alert_phone_number value="${emmrg.PHONE_NUM}" name="fields[25]">
			    	 		&nbsp;${emmrg.PHONE_NUM}&nbsp;(${emmrg.PREF_NAME})</li>	
			    			<input type="hidden" name="checked_phone_numbers" value="${emmrg.PHONE_NUM}">
			    	 	</c:otherwise>	
		    	 	</div>	    	 
		    	 </c:choose> --%>
		    	 
		    </c:forEach>
		</ul>
		
	</div>
	
	<div>	   
	     <div class="form-group">        
	      <div class="col-sm-offset-5 col-sm-9">
	        <button type="submit" class="btn btn-primary">Submit</button>
	      </div>
	    </div>  
	</div>      	
		<input type="hidden" name="fields[1]" value="update">
	    <input type="hidden" name="lt" value="${loginTicket}" />
        <input type="hidden" name="execution" value="${flowExecutionKey}" />
        <input type="hidden" name="_eventId" value="submit" />  
  </form>
</div>


<form id="clnaddr_hidden_form">
	<input type="hidden"  name="statuscode"   id="statuscode">            
    <input type="hidden"  name="dpverrorcode" id="dpverrorcode">
    <input type="hidden"  name="message"      id="message">
    <input type="hidden"  name="clnaddrbypass" id="clnaddrbypass" value="0">
</form>

  
  
 <!-- Modals -->
<c:forTokens items="PARENT,CONTACT" delims="," var="modalType">
 <div class="modal fade" id="<c:out value="${modalType}"/>_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
		  	<form class="form-horizontal" role="form" id="<c:out value="${modalType}"/>" onsubmit="event.preventDefault();submitModal(this.id,'${StudentBio['STUDENT_PIDM']}');return false;">
		  	<input type="hidden" name="<c:out value="${modalType}"/>_STUDENT_PIDM" id="<c:out value="${modalType}"/>_STUDENT_PIDM" value="${StudentBio['STUDENT_PIDM']}">
		  	<input type="hidden" name="<c:out value="${modalType}"/>_PARENT_PPID" id="<c:out value="${modalType}"/>_PARENT_PPID" value="0">
			  	<div class="modal-header">
			  		<button type="button" class="close" data-dismiss="modal">&times;</button>

			  		<h4 class="modal-title">Enter <c:out value="${modalType == 'PARENT' ? 'Parent' : 'Contact'}" /> Information</h4>
			  	</div>
			  	<div class="modal-body">	
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_MODAL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error">There was an error with your form submission. Please fix the fields indicated in red below.</span></div>
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_LEGAL_PREFIX_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_LEGAL_PREFIX_NAME">
			  			<label for="text" class="control-label col-sm-4">Prefix</label>
			  			<div class="col-sm-3">
			  				<input type="text" placeholder="Rev., Dr., Atty" maxlength="20" name="<c:out value="${modalType}"/>_LEGAL_PREFIX_NAME" class="form-control <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_LEGAL_PREFIX_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PREF_FIRST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_FIRST_NAME">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>First Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="First Name" maxlength="60" name="<c:out value="${modalType}"/>_PREF_FIRST_NAME" class="form-control ccreq <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_PREF_FIRST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PREF_MIDDLE_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_MIDDLE_NAME">
			  			<label for="text" class="control-label col-sm-4">Middle Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Middle Name" maxlength="60" name="<c:out value="${modalType}"/>_PREF_MIDDLE_NAME" class="form-control <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_PREF_MIDDLE_NAME">
			  			</div>
			  		</div>	  	
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PREF_LAST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PREF_LAST_NAME">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>Last Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Last Name" maxlength="60" name="<c:out value="${modalType}"/>_PREF_LAST_NAME" class="form-control ccreq <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_PREF_LAST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME">
			  			<label for="text" class="control-label col-sm-4">Suffix</label>
			  			<div class="col-sm-3">
			  				<input type="text" placeholder="Jr., Sr., IV" maxlength="20" name="<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME" class="form-control <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME">
			  			</div>
			  		</div>
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	  		
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_CP_NUMBER">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-3">
		  					<span class="mobile_label">Area Code: </span><input type="tel" placeholder="Area Code" name="<c:out value="${modalType}"/>_PHONE_CP_AREA_CODE" size="3" class="form-control area_code ccreq <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_CP_AREA_CODE" maxlength="3">
		  				</div>
		  				<div class="col-sm-4">
		  					<span class="mobile_label">Phone Number: </span><input type="tel" placeholder="Mobile Phone Number" name="<c:out value="${modalType}"/>_PHONE_CP_NUMBER" size="7" class="form-control phone_number ccreq <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER" maxlength="7">		  					
		  				</div>
		  			</div>
		  			
		  			<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_CP_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_CP_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_CP_CODE" id="<c:out value="${modalType}"/>_PHONE_CP_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="CP"> 
		  			 
		  			<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group modal_intl_form_group" data-type="CP" id="GROUP_<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-6">
		  					<input type="text" placeholder="International Number" name="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL" size="7" maxlength="45" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL">
		  				</div>
		  			</div>
		  			
		  			<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL_SWITCH">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="CP"  class="intl_number_switch modal_intl_number_switch col-sm-4">Enter International Number</span>							
					</div>
		  			
		  			<div style="display:none;" role="alert" class="alert alert-danger" id="PHONE_CP_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_CP_CARRIER">
						<label for="" class="control-label col-sm-4">Phone Carrier</label>
						<div class="col-sm-6">
							<select class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" placeholder="Phone Carrier" name="PHONE_CP_CARRIER" id="PHONE_CP_CARRIER">
								<option value="">Choose Phone Carrier</option>
								<c:forEach items="${options['Carriers']}" var="carriers">
									<option value="${carriers.key}">${carriers.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_EMERG_NO_CELL_PHONE"><div class="col-sm-offset-1 col-sm-9"><div class="checkbox"><label><input type="checkbox" value="Y" name="<c:out value="${modalType}"/>_EMERG_NO_CELL_PHONE" id="<c:out value="${modalType}"/>_EMERG_NO_CELL_PHONE" class="mobile_phone_check modal_mobile_phone_check <c:out value="${modalType}"/>_DEMO_FIELD" data-mobile-type="<c:out value="${modalType}"/>">This person does not have a mobile phone</label></div></div></div>					
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER" style="display:none;">
						<label for="Phone" class="control-label col-sm-4 address_field"><span class="required">* </span>Emergency Phone</label>		
						<div class="col-xs-3">
							<span class="mobile_label">Area Code: </span><input type="tel" placeholder="Area Code" name="fields[29]" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_AREA_CODE" size="3" class="form-control area_code num_only" value="" maxlength="3">
						</div>
						<div class="col-xs-4">
							<span class="mobile_label">Phone Number: </span><input type="tel" placeholder="Emergency Phone" name="fields[16]" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER" size="7" class="form-control phone_number num_only" value="" maxlength="7">
						</div>
					</div> 
					
					<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_EP_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_EP_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_EP_CODE" id="<c:out value="${modalType}"/>_PHONE_EP_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="EP">
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
					<div style="display:none;" class="form-group modal_intl_form_group" data-type="EMERGENCY" id="GROUP_<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL">
						<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Emergency Phone</label>
						<div class="col-sm-6">
							<input type="text" placeholder="International Number" name="fields[24]" size="7" maxlength="45" class="form-control" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL" value="${StudentCellPhone['PHONE_NUMBER_INTL']}">
						</div>
					</div>	
					
					<div class="form-group"  id="GROUP_<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL_SWITCH" style="display:none;">
						<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="EMERGENCY" class="intl_number_switch modal_intl_number_switch col-sm-4">Enter International Number</span>							
					</div>	
										
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_MA_NUMBER">
						<label for="tel" class="control-label col-sm-4">Home Phone</label>
						<div class="col-sm-3">
		  					<span class="mobile_label">Area Code: </span><input type="tel" placeholder="Area Code" name="<c:out value="${modalType}"/>_PHONE_MA_AREA_CODE" size="3" class="form-control area_code <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_MA_AREA_CODE" maxlength="3">
		  				</div>
		  				<div class="col-sm-4">
		  					<span class="mobile_label">Phone Number: </span><input type="tel" placeholder="Home Phone Number" name="<c:out value="${modalType}"/>_PHONE_MA_NUMBER" size="7" class="form-control phone_number <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER" maxlength="7">
		  				</div>
					</div>	
					
					<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_MA_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_MA_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_MA_CODE" id="<c:out value="${modalType}"/>_PHONE_MA_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="MA"> 
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group modal_intl_form_group" data-type="MA" id="GROUP_<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL">
		  				<label for="tel" class="control-label col-sm-4">Home Phone</label>
		  				<div class="col-sm-6">
		  					<input type="text" placeholder="International Number" name="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL" size="7" maxlength="45" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL">
		  				</div>
		  			</div>	
		  			
		  			<div class="form-group"  id="GROUP_<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL_SWITCH">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="MA" class="intl_number_switch modal_intl_number_switch col-sm-4">Enter International Number</span>							
					</div>		
																					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_BU_NUMBER" >
						<label for="tel" class="control-label col-sm-4">Office Phone</label>
						<div class="col-sm-3">
		  					<span class="mobile_label">Area Code: </span><input type="tel" placeholder="Area Code" name="<c:out value="${modalType}"/>_PHONE_BU_AREA_CODE" size="3" class="form-control area_code <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_BU_AREA_CODE" maxlength="3">
		  				</div>
		  				<div class="col-sm-4">
		  					<span class="mobile_label">Phone Number: </span><input type="tel" placeholder="Office Phone Number" name="<c:out value="${modalType}"/>_PHONE_BU_NUMBER" size="7" class="form-control phone_number <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER" maxlength="7">
		  				</div>
					</div>	
					
					<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_BU_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_BU_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_BU_CODE" id="<c:out value="${modalType}"/>_PHONE_BU_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="BU"> 
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclaBUtion-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group modal_intl_form_group" data-type="BU" id="GROUP_<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL">
		  				<label for="tel" class="control-label col-sm-4">Office Phone</label>
		  				<div class="col-sm-6">
		  					<input type="text" placeholder="International Number" name="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL" size="7" maxlength="45" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL">
		  				</div>
		  			</div>		
		  			
		  			<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL_SWITCH">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="BU"  class="intl_number_switch modal_intl_number_switch col-sm-4">Enter International Number</span>							
					</div>						
										 						
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_EMAIL_ADDRESS_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_EMAIL_ADDRESS">
						<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
						<div class="col-sm-6">
							<input type="hidden" name="PECI_EMAIL_CODE" id="PECI_EMAIL_CODE" value="P" class="<c:out value="${modalType}"/>_EMAIL_FIELD">
							<input type="email" placeholder="Preferred Email" name="<c:out value="${modalType}"/>_EMAIL_ADDRESS" class="form-control  ccreq <c:out value="${modalType}"/>_EMAIL_FIELD" id="<c:out value="${modalType}"/>_EMAIL_ADDRESS" maxlength="128">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_RELT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_RELT_CODE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Relationship</label>
						<div class="col-sm-6">
							<select class="form-control ccreq <c:out value="${modalType}"/>_DEMO_FIELD" placeholder="Relationship" name="<c:out value="${modalType}"/>_RELT_CODE" id="<c:out value="${modalType}"/>_RELT_CODE">
								<option value="">Choose Relationship</option>
								<c:forEach items="${options['Relationships']}" var="relationships">
									<option value="${relationships.key}">${relationships.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDRESS_TO_USE"><div class="col-sm-offset-1 col-sm-9"><div class="checkbox"><label><input type="checkbox" name="<c:out value="${modalType}"/>_ADDRESS_TO_USE" data-type="<c:out value="${modalType}"/>" class="address_to_use_checkbox">Use my address information </label>&nbsp;&nbsp;<select name="<c:out value="${modalType}"/>_ADDRESS_TO_USE" id="SELECT_<c:out value="${modalType}"/>_ADDRESS_TO_USE" style="display:none;"><option value="STUDENT">My Address</option></select></div></div></div>	
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_CAMPUS_ADDR_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STREET_LINE1">
						<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address Line 1</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 1" name="<c:out value="${modalType}"/>_ADDR_STREET_LINE1" class="form-control ccreq address_field  <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE1" maxlength="75">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STREET_LINE2">
						<label for="text" class="control-label col-sm-4">Address Line 2</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 2" name="<c:out value="${modalType}"/>_ADDR_STREET_LINE2" class="form-control address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE2" maxlength="75">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_NATN_CODE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
						<div class="col-sm-5">
							<select class="form-control ccreq address_field country_field <c:out value="${modalType}"/>_ADDRESS_FIELD" placeholder="Country" name="<c:out value="${modalType}"/>_ADDR_NATN_CODE" id="<c:out value="${modalType}"/>_ADDR_NATN_CODE">
								<option value="">Choose Country</option>
								<c:forEach items="${options['Countries']}" var="countries">
									<option value="${countries.key}">${countries.value}</option>
								</c:forEach>
							</select>
						</div>
						<div class="col-sm-1">
							<a data-content="If you do not see the correct country listed, please select 'other' and email the Registrar's office at  &lt;a href='mailto:registrar@conncoll.edu' target='_blank'&gt;registrar@conncoll.edu&lt;/a&gt;. In your email, please let the Registrar's office know your full name and the name of the country." data-placement="top" data-title="Country Selection" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title="" style="top:8px;right:10px;"></a>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_CITY_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_CITY">
						<label for="" class="control-label col-sm-4"><span class="required">* </span><span class="city">City</span></label>
						<div class="col-sm-6">
							<input type="text" placeholder="City" maxlength="50" name="<c:out value="${modalType}"/>_ADDR_CITY" class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_CITY">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STAT_CODE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>State</label>
						<div class="col-sm-6">
							<select class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" placeholder="State" name="<c:out value="${modalType}"/>_ADDR_STAT_CODE" id="<c:out value="${modalType}"/>_ADDR_STAT_CODE">
								<option value="">Choose State</option>
								<c:forEach items="${options['States']}" var="states">
									<option value="${states.key}">${states.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div style="display:none;" class="form-group" id="GROUP_<c:out value="${modalType}"/>_INTL_REGION">
						<label for="state" class="control-label col-sm-4">Province/Region</label>						
						<div class="col-sm-6">
							<select class="form-control address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" placeholder="State" name="<c:out value="${modalType}"/>_ADDR_STAT_CODE" id="<c:out value="${modalType}"/>_ADDR_PROV_REGION">
								<option value="">Choose Province/Region</option>
								<option value="">Not Applicable</option>
								<option value="">Other</option>
								<c:forEach items="${options['Regions']}" var="regions">
									<option value="${regions.key}">${regions.value}</option>
								</c:forEach>
							</select>
						</div>				
						
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_ZIP_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_ZIP">
						<label for="Postal Code" class="control-label col-sm-4"><span class="required">* </span>Zip/Postal Code</label>
						<div class="col-sm-6">
							<input type="text" maxlength="30" placeholder="Zip/Postal Code" name="<c:out value="${modalType}"/>_ADDR_ZIP" class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_ZIP">
						</div>
					</div>
					
					
					<div id='<c:out value="${modalType}"/>_CLNADDR_RESULTS' name='<c:out value="${modalType}"/>_CLNADDR_RESULTS'></div>
					
					<c:if test="${modalType == 'PARENT'}">
						<div style="display:none;" role="alert" class="alert alert-danger" id="DEPENDENT_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_DEPENDENT_CHECK">
							<div class="col-sm-offset-1 col-sm-10">
								<div class="checkbox">
									<label><span class="emergency_contact_switch">&nbsp;<input type="checkbox" name="DEPENDENT" checked="checked" class="bootstrap-switch <c:out value="${modalType}"/>_DEMO_FIELD" ID="DEPENDENT" data-off-text="No" data-on-text="Yes"></span> This parent claims me as a dependent</label>
							
							<a data-content="Under the Federal Educational Rights and Privacy Act (FERPA), Connecticut College is permitted to disclose information from your education records to your parents if your parents (or one of your parents) claim you as a dependent for U.S. federal tax purposes. If you have questions, please contact the Dean of the College office, 860-439-2050." data-placement="top" data-title="U.S. Tax Dependence Status Info" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title=""></a>
								</div>
							</div>
						</div>	
					</c:if>
					
									  		
			  		<div class="form-group">
  						<div class="col-sm-offset-5 col-sm-9">
  							<button type="submit" class="btn btn-primary">Save</button>
  						</div>
  					</div>  				
  				</div>
 				</form>
 			</div>
 			<div class="modal-footer">
 				<button type="button" id="<c:out value="${modalType}"/>_CLOSE_BUTTON" class="btn btn-default" data-dismiss="modal">Close</button>
 			</div>
 		</div>
 	</div>
</c:forTokens>

<div class="modal fade" id="CONFIRMATION_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
	  		<div class="modal-header">
			  	<button type="button" class="close" data-dismiss="modal">&times;</button>

			  	<h4 class="modal-title">Changes Saved</h4>
			  </div>
			  <div class="modal-body">	
				<p><strong>Your changes have been saved</strong></p>
				<p>You can edit any of your parent/guardians or contacts by clicking the edit icon next to their name.</p>
			  </div>
			</div>
			<div class="modal-footer">
 				<button type="button" id="CONFIRMATION_CLOSE_BUTTON" class="btn btn-default" data-dismiss="modal">Close</button>
 			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="DELETE_MODAL" role="dialog">  	
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
		  	<form class="form-horizontal" role="form" id="delete_form"  onsubmit="deleteIndividual();return false">
			  	<div class="modal-header">
			  		<button type="button" class="close" data-dismiss="modal">&times;</button>
			  		<h4 class="modal-title">Confirm Deletion</h4>
			  	</div>
			  	<div class="modal-body">		
					<p>Are you sure you want to delete this <strong><span id="type"></span></strong>?</p>
					<p><strong><span class="name_block"></span></strong></p>	
					<p><span id="note"></span></p>			
					<input type="hidden" name="ppid" value="" id="ppid_to_delete" class="ccreq">
					<input type="hidden" name="type" value="" id="type_to_delete" class="ccreq">
				  	<div class="form-group">
			  			<div class="col-sm-offset-4">
			  				<button type="submit" class="btn btn-primary">Yes, Delete</button>
			  	  		</div>
			  		</div>
			  	</div>
		  	</form>
		</div>
	  	<div class="modal-footer">
	  		<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
	  	</div>
  	</div>
</div>

<div class="modal fade" id="MAX_CONTACTS_ALLOWED_MODAL" role="dialog">  	
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">		  	
		  	<div class="modal-header">
		  		<button type="button" class="close" data-dismiss="modal">&times;</button>
		  		<h4 class="modal-title"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span>Maximum Allowed</h4>
		  	</div>
		  	<div class="modal-body">	
				<p><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span>You have the maximum number of contacts. Only <strong>six</strong> contacts are allowed.</p>
				<p><strong>Please note</strong>: You are required to designate at least one parent or guardian as an emergency contact. Exceptions to this policy must be approved by the Dean of the College doc@conncoll.edu.</p>
		  </div>		  	
		</div>
	  	<div class="modal-footer">
	  		<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	  	</div>
  	</div>
</div>

<div class="modal fade" id="MAX_PARENTS_ALLOWED_MODAL" role="dialog">  	
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">		  	
		  	<div class="modal-header">
		  		<button type="button" class="close" data-dismiss="modal">&times;</button>
		  		<h4 class="modal-title"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span>Maximum Allowed</h4>
		  	</div>
		  	<div class="modal-body">	
				<p><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span>You have the maximum number of parents. Only <strong>five</strong> parents are allowed.</p>				
		  </div>		  	
		</div>
	  	<div class="modal-footer">
	  		<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	  	</div>
  	</div>
</div>

<div class="modal fade" id="ALERT_NUMBER_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
	  		<div class="modal-header">
			  	<button type="button" class="close" data-dismiss="modal">&times;</button>

			  	<h4 class="modal-title">Maximum Selected</h4>
			  </div>
			  <div class="modal-body">	
				<p>Only <strong>five</strong> numbers can be selected as campus alert numbers.</p>
				<p>Please note: Your mobile/emergency phone number will always be contacted.</p>
			  </div>
			</div>
			<div class="modal-footer">
 				<button type="button" id="CONFIRMATION_CLOSE_BUTTON" class="btn btn-default" data-dismiss="modal">Close</button>
 			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="ALERT_NUMBER_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
	  		<div class="modal-header">
			  	<button type="button" class="close" data-dismiss="modal">&times;</button>

			  	<h4 class="modal-title">Maximum Selected</h4>
			  </div>
			  <div class="modal-body">	
				<p>Only <strong>five</strong> numbers can be selected as campus alert numbers.</p>
				<p>Please note: Your mobile/emergency phone number will always be contacted.</p>
			  </div>
			</div>
			<div class="modal-footer">
 				<button type="button" id="CONFIRMATION_CLOSE_BUTTON" class="btn btn-default" data-dismiss="modal">Close</button>
 			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="ERROR_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
	  		<div class="modal-header">
			  	<button type="button" class="close" data-dismiss="modal">&times;</button>

			  	<h4 class="modal-title"><span style="color: red;"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span> ERROR</span></h4>
			  </div>
			  <div class="modal-body">	
				<p><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign" style="color:red;"></span> There was an error with your submission. Please refresh this page and try again.<br/><br/>If you continue to have problems, please contact the IT Service Desk at 860-439-4357.</p>
			  </div>
			</div>
			<div class="modal-footer">
 				<button type="button" id="CONFIRMATION_CLOSE_BUTTON" class="btn btn-default" data-dismiss="modal">Close</button>
 			</div>
		</div>
	</div>
</div>
 	
  	
<%
	/*out.print(displayEntryModal("parent","Enter Details","Save"));
	out.print(displayEntryModal("emergency_contact","Enter Details","Save"));
	out.print(displayDeleteModal("delete","Confirm Deletion","Yes, Delete"));*/

%>


<script type="text/javascript" src="/clnaddr/js/clnaddr.js?version=10106"></script>  
<script type="text/javascript"> 
	ajaxurl = "/cas/cas-rest-api/peci/";
	student_PIDM = '${StudentBio['STUDENT_PIDM']}';
	student_name = '${StudentBio['PREFERRED_FIRST_NAME']} ${StudentBio['PREFERRED_LAST_NAME']}';
	deanExceptionDate = "${StudentBio['DEAN_EXCEPTION_DATE']}"; 
</script> 
<script type="text/javascript" src="/cas/js/ccPECIE.js?version=10105"></script>    

</body>
</html>
