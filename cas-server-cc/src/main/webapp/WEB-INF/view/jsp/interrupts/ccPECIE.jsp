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
  
  <script type="text/javascript">
  jQuery(function($) {
      var panelList = $('.draggablePanelList');

      panelList.sortable({
          // Only make the .panel-heading child elements support dragging.
          // Omit this to make then entire <li>...</li> draggable.
          handle: '.panel-heading', 
          update: function() {
        	  var contact_order_list = '';
              $('.panel',panelList).each(function(index, elem) {
                   var $listItem = $(elem);
                        var newIndex = $listItem.index();
                   		var ppid = $listItem.attr("id").replace('emr_contact_','');
                   		ppid = ppid.replace('parent_','');
                   		if(index != 0){
                   			contact_order_list += ',';
                   		}
                   		contact_order_list += ppid
						//console.log("newList: " + contact_order_list)
                   // Persist the new indices. 
              }); 
              $('#emr_order').val(contact_order_list);              
          },
          stop: function() {
              //console.log("stopped drag");
          }
      });
      
      //turn on bootstrap style switch for checkboxes with that class 
      $(".bootstrap-switch").bootstrapSwitch();
      
  }); 
  
  </script>
  
  <style type="text/css">
  	.separation_box{
  		border: 2px solid #D4E3FC;
  		padding: 10px;
  		border-radius: 10px;
  		margin-bottom: 20px;
  	}
  	/*set the width of the form here with max-width*/
  	@media (min-width: 1200px) {
	    .container{
	        max-width: 900px;
	    }
	}
	.q_check{
		margin: 0;
	}
	.glyphicon{
		font-size: 1.2em;
		padding: 0 5px;
	}
	.form_section{
		border: 2px solid #D4E3FC;
		border-radius: 10px;
		padding: 0 10px;
		margin: 0 0 10px;
	}
	.emergency_contact_switch{
		margin-left: 30px;
	}
	.required{
		color: red;
		font-size: 1.1em;
	}
	/* show the move cursor as the user moves the mouse over the panel header.*/
    .draggablePanelList .panel-heading {
        cursor: move;
    }
    .modal .modal-body {
	    overflow-y: auto;
	}
	#clnaddr table {
    	margin: 0 auto;
	}
	#clnaddr table tr, #clnaddr table td {
    	border: 1px solid #ccc;
    	border-radius: 4px;
	}
	.glyphicon-question-sign:hover,.glyphicon-question-sign:focus{
		text-decoration: none;
	}	
	.intl_number_switch{
		font-size: 12px;
		margin: -10px;
		padding: 0;
	}
	/*stop scroll to top of page when modal opens*/
	body.modal-open {
    	overflow: visible;
	}
	.grayed-out{
		color: #9F9F9F;
	}	

  </style>
</head>
<body>

<div class="container">
  <h2>Update Your Contact Information</h2>
  <p>Please enter your personal, parent/guardian and emergency contact information below.</p> 
  <form class="form-horizontal" method="post" role="form" id="STUDENT" onsubmit="return submitMainForm(this.id);"> 
 
  <div id="step1" class="form_section">
	<h3>Step 1 Verify Your Permanent Mailing Address</h3>
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
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address1">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>Address 1</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 1" name="fields[4]" class="form-control ccreq address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_STREET_LINE1" value="${StudentAddr['ADDR_STREET_LINE1']}">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address2">
		<label for="country" class="control-label col-sm-3">Address 2</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 2" name="fields[5]" class="form-control address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_STREET_LINE2" value="${StudentAddr['ADDR_STREET_LINE2']}">
		</div>
	</div>  

	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_country">
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
	<div class="form-group" id="group_student_city">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>City</label>
		<div class="col-sm-9">
				<input type="text" placeholder="City" name="fields[7]" class="form-control ccreq address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_CITY" value="${StudentAddr['ADDR_CITY']}">
		</div>
	</div>  
	<%-- ${options} --%>
<%-- States: ${options['States']}
${StudentAddr['ADDR_STAT_CODE']} --%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDR_STAT_CODE">
		<label for="state" class="control-label col-sm-3"><span class="required">* </span>State</label>
		<div class="col-sm-9">
			<select class="form-control address_field ccreq STUDENT_ADDRESS_FIELD" placeholder="State" name="fields[8]" id="STUDENT_ADDR_STAT_CODE">
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
	<div style="display:none;" class="form-group" id="GROUP_STUDENT_INTL_REGION">
		<label for="state" class="control-label col-sm-3">Province/Region</label>
		<%-- <div class="col-sm-9">
			<input type="text" placeholder="Province/Region" name="fields[9]" class="form-control address_field" id="STUDENT_ADDR_STAT_CODE" value="${StudentAddr['ADDR_STAT_CODE']}">
		</div> --%>
		<div class="col-sm-9">
			<select class="form-control address_field STUDENT_ADDRESS_FIELD" placeholder="State" name="fields[8]" id="STUDENT_ADDR_STAT_CODE" disabled="disabled">
				<option value="">Choose Province/Region</option>
				<c:forEach items="${options['Regions']}" var="regions">
					<option <c:if test="${regions.key == StudentAddr['ADDR_STAT_CODE']}">selected="selected"</c:if> value="${regions.key}">${regions.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_ZIP_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDR_ZIP">
		<label for="Postal Code" class="control-label col-sm-3 address_field"><span class="required">* </span>Zip/Postal Code</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Postal Code" name="fields[10]" class="form-control ccreq address_field STUDENT_ADDRESS_FIELD" id="STUDENT_ADDR_ZIP" value="${StudentAddr['ADDR_ZIP']}">
		</div>
	</div> 

	<div id='STUDENT_CLNADDR_RESULTS' name='STUDENT_CLNADDR_RESULTS'></div>	
	<div id="suggestionListDiv" style="display: none;"></div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_MA_PHONE_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_MA_PHONE_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<%-- ${StudentHomePhone} --%>
	<div class="form-group" id="GROUP_STUDENT_PHONE_MA_NUMBER">
		<label for="Phone" class="control-label col-sm-3">Home Phone</label>
		<div class="col-sm-3">
			<input type="tel" placeholder="Area Code" name="fields[27]" id="STUDENT_MA_PHONE_AREA_CODE" size="3" class="form-control area_code num_only" value="${StudentHomePhone['PHONE_AREA_CODE']}" maxlength="3">
		</div>
		<div class="col-sm-6">
			<input type="tel" placeholder="Home Phone" name="fields[11]" id="STUDENT_MA_PHONE_NUMBER" size="7" class="form-control num_only" value="${StudentHomePhone['PHONE_NUMBER']}" maxlength="7">
			<input type="hidden" name="fields[31]" id="STUDENT_MA_PHONE_SEQUENCE_NO" value="${StudentHomePhone['PHONE_SEQUENCE_NO']}">
		</div>
	</div> 
 <%-- Student Home Phone: ${StudentHomePhone} --%>
		<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_MA_PHONE_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
	<div style="display:none;" class="form-group" id="GROUP_STUDENT_PHONE_MA_NUMBER_INTL">
		<label for="tel" class="control-label col-sm-3">Home Phone</label>
		<div class="col-sm-9">
			<input type="text" placeholder="International Number" name="fields[28]" size="7" class="form-control" id="STUDENT_MA_PHONE_NUMBER_INTL" value="${StudentCellPhone['PHONE_NUMBER_INTL']}">
		</div>
	</div>	
	
	<div class="form-group" id="group_student_MA_intl_phone_switch">
		<label class="col-sm-4"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="MA" class="intl_number_switch col-sm-4">Enter International Number</span>							
	</div>		
	
	<div class="form-group" id="group_student_non_college_email">
		<label for="Email" class="control-label col-sm-3">Non-college email</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Non-college email" name="fields[12]" class="form-control" id="STUDENT_EMAIL_ADDRESS" value="${StudentEmail['EMAIL_ADDRESS']}">
		</div>
	</div> 
	
	</div>
 <%-- ${StudentCellPhone} --%>
	<div id="step2" class="form_section">
	<h3>Step 2 Your Emergency Phone Number</h3>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_CP_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_CP_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_PHONE_CP_NUMBER">
		<label for="Phone" class="control-label col-sm-3"><c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'N' || StudentBio['EMERG_NO_CELL_PHONE'] == null}"><span class="required">* </span></c:if>Mobile Phone</label>		
		<div class="col-sm-3">
			<input type="tel" data-phone-type="CP" placeholder="Area Code" name="fields[23]" id="STUDENT_PHONE_CP_AREA_CODE" size="3" class="form-control <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'N'}">ccreq</c:if> area_code num_only" value="${StudentCellPhone['PHONE_AREA_CODE']}" maxlength="3">
		</div>
		<div class="col-sm-6">
			<input type="tel" data-phone-type="CP" placeholder="Mobile Phone" name="fields[13]" id="STUDENT_PHONE_CP_NUMBER" size="7" class="form-control <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'N'}">ccreq</c:if> num_only" value="${StudentCellPhone['PHONE_NUMBER']}" maxlength="7">
			<input type="hidden" name="fields[32]" id="STUDENT_CP_PHONE_SEQUENCE_NO" value="${StudentCellPhone['PHONE_SEQUENCE_NO']}">
		</div>
	</div> 	
	<%-- Student Cell Phone: ${StudentCellPhone} --%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
	<div style="display:none;" class="form-group" id="GROUP_STUDENT_PHONE_CP_NUMBER_INTL">
		<label for="tel" class="control-label col-sm-3"><span class="required">* </span>Mobile Phone</label>
		<div class="col-sm-9">
			<input type="text" data-phone-type="INTL" placeholder="International Number" name="fields[24]" size="7" class="form-control" id="STUDENT_PHONE_CP_NUMBER_INTL" value="${StudentCellPhone['PHONE_NUMBER_INTL']}">
		</div>
	</div>		
	
	<div class="form-group" id="group_student_intl_phone_switch">
		<label class="col-sm-4"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="CP" class="intl_number_switch col-sm-4">Enter International Number</span>							
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
	<div class="form-group" id="GROUP_STUDENT_PHONE_EMERGENCY_NUMBER" <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'N' || StudentBio['EMERG_NO_CELL_PHONE'] == null}">style="display:none;"</c:if>>
		<label for="Phone" class="control-label col-sm-3 address_field"><span class="required">* </span>Emergency Phone</label>		
		<div class="col-sm-3">
			<input type="tel" data-phone-type="EMERGENCY" placeholder="Area Code" name="fields[29]" id="STUDENT_PHONE_EMERGENCY_AREA_CODE" size="3" class="form-control area_code num_only <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'Y'}">ccreq</c:if>" value="${StudentEmrPhone['PHONE_AREA_CODE']}" maxlength="3">
		</div>
		<div class="col-sm-6">
			<input type="tel" data-phone-type="EMERGENCY" placeholder="Emergency Phone" name="fields[16]" id="STUDENT_PHONE_EMERGENCY_NUMBER" size="7" class="form-control num_only <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'Y'}">ccreq</c:if>" value="${StudentEmrPhone['PHONE_NUMBER']}" maxlength="7">
			<input type="hidden" name="fields[34]" id="STUDENT_EMR_PHONE_SEQUENCE_NO" value="${StudentEmrPhone['PHONE_SEQUENCE_NO']}">			
		</div>
	</div> 
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_EMERGENCY_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
	<div <c:if test="${fn.length(StudentCellPhone['PHONE_NUMBER_INTL']) != 0 }">style="display:none;"</c:if> class="form-group" id="GROUP_STUDENT_PHONE_EMERGENCY_NUMBER_INTL">
		<label for="tel" class="control-label col-sm-3"><span class="required">* </span>Emergency Phone</label>
		<div class="col-sm-9">
			<input type="text" data-phone-type="EMERGENCY_INTL" placeholder="International Number" name="fields[30]" size="7" class="form-control" id="STUDENT_PHONE_EMERGENCY_NUMBER_INTL" value="${StudentCellPhone['PHONE_NUMBER_INTL']}">
		</div>
	</div>	
	
	<div class="form-group" id="GROUP_STUDENT_PHONE_EMERGENCY_NUMBER_INTL_SWITCH" <c:if test="${StudentBio['EMERG_NO_CELL_PHONE'] == 'N' || StudentBio['EMERG_NO_CELL_PHONE'] == null }">style="display:none;"</c:if>>
		<label class="col-sm-4"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="EMERGENCY" class="intl_number_switch col-sm-4">Enter International Number</span>							
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
	<p class="q_check" id="paragraph_alert_home_email_check">If you do not wish to receive campus alerts beyond those to your campus email and voice mail, check the box below:</p>
	<div style="display:none;" role="alert" class="alert alert-danger" id="alert_home_email_check_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_alert_home_email_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="fields[19]" id="alert_home_email_check" <c:if test="${StudentBio['EMERG_AUTO_OPT_OUT'] == 'Y'}">checked="checked"</c:if> value="Y">Opt out of automated campus alerts to my home email and cell phone</label>
			</div>
		</div>
	</div>
	

	
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
	    <div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error">You are required to designate at least one parent or guardian as an emergency contact. Exceptions to this policy must be approved by the Dean of the College doc@conncoll.edu</span></div>
	    <p id="doc_message">Please list <strong>all</strong> parent/guardian contacts below. You are required to designate at least one parent or guardian as an emergency contact. Exceptions to this policy must be approved by the Dean of the College doc@conncoll.edu.</p>
	    <p id="doc_opt_out_message" style="display:none;">You are not required to include a parent or guardian as an emergency contact. You are required to have at least one emergency contact, which you can add in the additional emergency contacts section below.</p>	   

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
	        <span id="PARENT_MAX_ENTERED" style="display:none;">&nbsp;You have entered the max number of parents (5).</span>
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
	        <span id="CONTACT_MAX_ENTERED" style="display:none;">&nbsp;You have entered the max number of contacts (5).</span>
	      </div>
	    </div>
    </div>
    <%-- ${EmmrgPhones} --%>
    <div id="step5" class="form_section">
	    <h3>Step 5 Campus Alert Phone Numbers</h3>
	    <p id="doc_message">Please choose up to five phone numbers to be contacted in the case of a campus emergency (your mobile phone will always be contacted).</p>
	    
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
		  	<form class="form-horizontal" role="form" id="<c:out value="${modalType}"/>" onsubmit="event.preventDefault();submitModal(this.id);return false;">
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
			  				<input type="text" placeholder="Rev., Dr., Atty" name="<c:out value="${modalType}"/>_LEGAL_PREFIX_NAME" class="form-control <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_LEGAL_PREFIX_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PREF_FIRST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_FIRST_NAME">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>First Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="First Name" name="<c:out value="${modalType}"/>_PREF_FIRST_NAME" class="form-control ccreq <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_PREF_FIRST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PREF_MIDDLE_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_MIDDLE_NAME">
			  			<label for="text" class="control-label col-sm-4">Middle Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Middle Name" name="<c:out value="${modalType}"/>_PREF_MIDDLE_NAME" class="form-control <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_PREF_MIDDLE_NAME">
			  			</div>
			  		</div>	  	
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PREF_LAST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PREF_LAST_NAME">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>Last Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Last Name" name="<c:out value="${modalType}"/>_PREF_LAST_NAME" class="form-control ccreq <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_PREF_LAST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME">
			  			<label for="text" class="control-label col-sm-4">Suffix</label>
			  			<div class="col-sm-3">
			  				<input type="text" placeholder="Jr., Sr., IV" name="<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME" class="form-control <c:out value="${modalType}"/>_DEMO_FIELD" id="<c:out value="${modalType}"/>_LEGAL_SUFFIX_NAME">
			  			</div>
			  		</div>
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	  		
			  		<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_CP_NUMBER">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-3">
		  					<input type="tel" placeholder="Area Code" name="<c:out value="${modalType}"/>_PHONE_CP_AREA_CODE" size="3" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_CP_AREA_CODE" maxlength="3">
		  				</div>
		  				<div class="col-sm-4">
		  					<input type="tel" placeholder="Mobile Phone Number" name="<c:out value="${modalType}"/>_PHONE_CP_NUMBER" size="7" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER" maxlength="7">		  					
		  				</div>
		  			</div>
		  			
		  			<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_CP_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_CP_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_CP_CODE" id="<c:out value="${modalType}"/>_PHONE_CP_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="CP"> 
		  			 
		  			<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group modal_intl_form_group" data-type="CP" id="GROUP_<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-6">
		  					<input type="text" placeholder="International Number" name="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL">
		  				</div>
		  			</div>
		  			
		  			<div class="form-group" id="group_<c:out value="${modalType}"/>_intl_phone_switch">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="CP"  class="intl_number_switch col-sm-4">Enter International Number</span>							
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
							<input type="tel" placeholder="Area Code" name="fields[29]" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_AREA_CODE" size="3" class="form-control area_code num_only" value="" maxlength="3">
						</div>
						<div class="col-xs-4">
							<input type="tel" placeholder="Emergency Phone" name="fields[16]" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER" size="7" class="form-control num_only" value="" maxlength="7">
						</div>
					</div> 
					
					<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_EP_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_EP_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_EP_CODE" id="<c:out value="${modalType}"/>_PHONE_EP_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="EP">
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
					<div style="display:none;" class="form-group modal_intl_form_group" data-type="EMERGENCY" id="GROUP_<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL">
						<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Emergency Phone</label>
						<div class="col-sm-6">
							<input type="text" placeholder="International Number" name="fields[24]" size="7" class="form-control" id="<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL" value="${StudentCellPhone['PHONE_NUMBER_INTL']}">
						</div>
					</div>	
					
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_EMERGENCY_NUMBER_INTL_SWITCH" style="display:none;">
						<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="EMERGENCY" class="intl_number_switch col-sm-4">Enter International Number</span>							
					</div>	
										
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_MA_NUMBER">
						<label for="tel" class="control-label col-sm-4">Home Phone</label>
						<div class="col-sm-3">
		  					<input type="tel" placeholder="Area Code" name="<c:out value="${modalType}"/>_PHONE_MA_AREA_CODE" size="3" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_MA_AREA_CODE" maxlength="3">
		  				</div>
		  				<div class="col-sm-4">
		  					<input type="tel" placeholder="Home Phone Number" name="<c:out value="${modalType}"/>_PHONE_MA_NUMBER" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER" maxlength="7">
		  				</div>
					</div>	
					
					<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_MA_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_MA_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_MA_CODE" id="<c:out value="${modalType}"/>_PHONE_MA_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="MA"> 
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group modal_intl_form_group" data-type="MA" id="GROUP_<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL">
		  				<label for="tel" class="control-label col-sm-4">Home Phone</label>
		  				<div class="col-sm-6">
		  					<input type="text" placeholder="International Number" name="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL">
		  				</div>
		  			</div>	
		  			
		  			<div class="form-group" id="group_<c:out value="${modalType}"/>_intl_phone_switch">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="MA" class="intl_number_switch col-sm-4">Enter International Number</span>							
					</div>		
																					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_AREA_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>	
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_PHONE_BU_NUMBER" >
						<label for="tel" class="control-label col-sm-4">Office Phone</label>
						<div class="col-sm-3">
		  					<input type="tel" placeholder="Area Code" name="<c:out value="${modalType}"/>_PHONE_BU_AREA_CODE" size="3" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_BU_AREA_CODE" maxlength="3">
		  				</div>
		  				<div class="col-sm-4">
		  					<input type="tel" placeholder="Office Phone Number" name="<c:out value="${modalType}"/>_PHONE_BU_NUMBER" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD num_only" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER" maxlength="7">
		  				</div>
					</div>	
					
					<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_BU_SEQUENCE_NO" id="<c:out value="${modalType}"/>_PHONE_BU_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  		<input type="hidden" name="<c:out value="${modalType}"/>_PHONE_BU_CODE" id="<c:out value="${modalType}"/>_PHONE_BU_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value="BU"> 
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclaBUtion-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group modal_intl_form_group" data-type="BU" id="GROUP_<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL">
		  				<label for="tel" class="control-label col-sm-4">Office Phone</label>
		  				<div class="col-sm-6">
		  					<input type="text" placeholder="International Number" name="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL">
		  				</div>
		  			</div>		
		  			
		  			<div class="form-group" id="group_<c:out value="${modalType}"/>_intl_phone_switch">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-type="BU"  class="intl_number_switch col-sm-4">Enter International Number</span>							
					</div>						
										 						
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_EMAIL_ADDRESS_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_EMAIL_ADDRESS">
						<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
						<div class="col-sm-6">
							<input type="hidden" name="PECI_EMAIL_CODE" id="PECI_EMAIL_CODE" value="P" class="<c:out value="${modalType}"/>_EMAIL_FIELD">
							<input type="email" placeholder="Preferred Email" name="<c:out value="${modalType}"/>_EMAIL_ADDRESS" class="form-control  ccreq <c:out value="${modalType}"/>_EMAIL_FIELD" id="<c:out value="${modalType}"/>_EMAIL_ADDRESS">
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
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STREET_LINE1">
						<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address 1</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 1" name="<c:out value="${modalType}"/>_ADDR_STREET_LINE1" class="form-control ccreq address_field  <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE1">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STREET_LINE2">
						<label for="text" class="control-label col-sm-4">Address 2</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 2" name="<c:out value="${modalType}"/>_ADDR_STREET_LINE2" class="form-control address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE2">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_NATN_CODE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
						<div class="col-sm-5">
							<select class="form-control ccreq address_field country_field <c:out value="${modalType}"/>_ADDRESS_FIELD" placeholder="Country" name="<c:out value="${modalType}"/>_ADDR_NATN_CODE" id="<c:out value="${modalType}"/>_ADDR_NATN_CODE">
								<option value="">Choose Country</option>
								<c:forEach items="${options['Countries']}" var="countries">
									<option value="${countries.key}" <c:if test="${countries.key == 'US' }">selected="selected"</c:if>>${countries.value}</option>
								</c:forEach>
							</select>
						</div>
						<div class="col-sm-1">
							<a data-content="If you do not see the correct country listed, please select 'other' and email the Registrar's office at  &lt;a href='mailto:registrar@conncoll.edu' target='_blank'&gt;registrar@conncoll.edu&lt;/a&gt;. In your email, please let the Registrar's office know your full name and the name of the country." data-placement="top" data-title="Country Selection" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title="" style="top:8px;right:10px;"></a>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_CITY_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_CITY">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>City</label>
						<div class="col-sm-6">
							<input type="text" placeholder="City" name="<c:out value="${modalType}"/>_ADDR_CITY" class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_CITY">
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
							<select class="form-control address_field" placeholder="State" name="<c:out value="${modalType}"/>_ADDR_STAT_CODE" id="<c:out value="${modalType}"/>_ADDR_STAT_CODE">
								<option value="">Choose Province/Region</option>
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
							<input type="text" placeholder="Zip/Postal Code" name="<c:out value="${modalType}"/>_ADDR_ZIP" class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="<c:out value="${modalType}"/>_ADDR_ZIP">
						</div>
					</div>
					
					
					<div id='<c:out value="${modalType}"/>_CLNADDR_RESULTS' name='<c:out value="${modalType}"/>_CLNADDR_RESULTS'></div>
					
					<c:if test="${modalType == 'PARENT'}">
						<div style="display:none;" role="alert" class="alert alert-danger" id="DEPENDENT_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_DEPENDENT_CHECK">
							<div class="col-sm-offset-1 col-sm-10">
								<div class="checkbox">
									<label><span class="emergency_contact_switch">&nbsp;<input type="checkbox" name="DEPENDENT" checked="checked" class="bootstrap-switch <c:out value="${modalType}"/>_DEMO_FIELD" ID="DEPENDENT" data-off-text="No" data-on-text="Yes"></span> This parent claims me as a dependent</label>
							
							<a data-content="Please indicate whether your parents claim you as a tax dependent for federal income tax purposes. This is turned on by default. &lt;a href='http://www.conncoll.edu/academics/registrar/ferpa/' target='_blank'&gt; FERPA Information&lt;/a&gt;." data-placement="top" data-title="U.S. Tax Dependence Status Info" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title=""></a>
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

<div class="modal fade" id="ALERT_NUMBER_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
	  		<div class="modal-header">
			  	<button type="button" class="close" data-dismiss="modal">&times;</button>

			  	<h4 class="modal-title">Maximum selected</h4>
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
 	
  	
<%
	/*out.print(displayEntryModal("parent","Enter Details","Save"));
	out.print(displayEntryModal("emergency_contact","Enter Details","Save"));
	out.print(displayDeleteModal("delete","Confirm Deletion","Yes, Delete"));*/

%>


 <script type="text/javascript" src="/clnaddr/js/clnaddr.js?version=10101"></script>   

 <script type="text/javascript">
 

 
 $(document).ready( function(){
	 
	 //draggable panel events
/* 	  $( ".draggablePanelList li" ).draggable({
      start: function() {
        console.log("started drag");
      },
      drag: function() {
      },
      stop: function() {
        console.log("stopped drag");
      }
    }); */
	 
	 checked_phone_numbers = $("input[name=checked_phone_numbers]").map(function(i,c){ return c.value; });
     //console.log(checked_phone_numbers);
	 ajaxurl = "/cas/cas-rest-api/peci/";
	 console.log(ajaxurl);
	 student_PIDM = ${StudentBio['STUDENT_PIDM']};
	 
	 //check parent and contact numbers on page load and disable any new entries if 5 or over entered
	 if(checkNum('PARENT') >= 5){
		disableModalEnter('PARENT');
	 }
	 if(checkNum('CONTACT') >= 5){
		disableModalEnter('CONTACT');
	 }
	 		 
	 $("[data-toggle=popover]").popover();
	 $("[data-toggle=tooltip]").tooltip(); 
	 
	 //only select Yes on parents that are listed as emergency contacts on page load
	 $('#CONTACT_LIST li').each(function(){
		 var thisID = $(this).attr("id");
		 thisID = thisID.replace('emr_contact_','');
		 console.log("thisID: " + thisID);
		 if($('#PARENT_LIST #parent_' + thisID).length){
			 //this contact is also a parent, flip emr switch on
			 console.log('Turn this user on with: ' + '#parent_' + thisID + ' .parent-bootstrap-switch');
			 $('#parent_' + thisID + ' .parent-bootstrap-switch').bootstrapSwitch('state',true);
		 }
		//console.log("contact_listed: " + thisID); 
	 });	 
	
	//get count of number of emr switches that are "On". If only 1, make it read-only since at least 1 parent needs to be checked
	emr_switch_count = $('.parent-bootstrap-switch:checked').length;
	console.log('emr_switch_count: ' + emr_switch_count);
	if(emr_switch_count == 1){
		console.log('emr_switch_count = 1');
		//$('.parent-bootstrap-switch').closest('.bootstrap-switch-wrapper').addClass('bootstrap-switch-readonly');
		$('.parent-bootstrap-switch:checked').bootstrapSwitch('disabled',true);
	}	
	 	 
	$('mobile_phone_check').each(function(){
		if(this.checked){
			var checked = 1;
			var form_id = $(this).closest('form').attr("id"); 
			emergencyNumberToggle(form_id, checked);
		}
	});	
 
	$('.mobile_phone_check').change(function(){
		var form_id = $(this).closest('form').attr("id");
		//var thisValue = $(this.checked);	
		var checked = this.checked ? 1 : 0;
		emergencyNumberToggle(form_id, checked);
	}); 
	
	//switch to international phone
	$('.intl_number_switch').click(function (){		
		var form_id = $(this).closest('form').attr("id");
		var phone_type = $(this).attr("data-type");
		var intl_group = '#GROUP_' + form_id + '_PHONE_' + phone_type + '_NUMBER_INTL';
		//console.log("intl_group: " + intl_group);
		var phone_group = '#GROUP_' + form_id + '_PHONE_' + phone_type + '_NUMBER';	
		//console.log("phone group: " + phone_group);		
		if($(intl_group).css('display') == 'none'){
			//console.log("display none");
			$(phone_group).hide();		
			//show international number
			$(intl_group).show();
			console.log('phone_type: ' + phone_type);
			if(phone_type == 'CP' || phone_type == 'EMERGENCY'){
				//intl number now showing, change required fields
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER_INTL').addClass("ccreq");
				$('#' + form_id + '_PHONE_' + phone_type + '_AREA_CODE').removeClass('ccreq');
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER').removeClass('ccreq');			
			}
			//change text of link
			$(this).html('Enter U.S. Number');
		}else{
			$(phone_group).show();			
			$(intl_group).hide();
			if(phone_type == 'CP' || phone_type == 'EMERGENCY'){
				//change required fields
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER_INTL').removeClass("ccreq");
				$('#' + form_id + '_PHONE_' + phone_type + '_AREA_CODE').addClass('ccreq');
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER').addClass('ccreq');			
			}
 			$(this).html('Enter International Number');
		}	
		if(form_id == 'STUDENT'){
			addCampusAlertNumber($(this).val(), '${StudentBio['PREFERRED_FIRST_NAME']} ${StudentBio['PREFERRED_LAST_NAME']}', 'STUDENT');
		}

	});
	
	$('#STUDENT_PHONE_CP_NUMBER, #STUDENT_PHONE_CP_AREA_CODE, #STUDENT_PHONE_EMERGENCY_NUMBER, #STUDENT_PHONE_EMERGENCY_AREA_CODE, #STUDENT_PHONE_EMERGENCY_NUMBER_INTL').focusout(function(){
		var thisType = $(this).attr('data-phone-type');
		if(thisType == 'CP'){
			phone_number = $('#STUDENT_PHONE_CP_AREA_CODE').val() + '' + $('#STUDENT_PHONE_CP_NUMBER').val();
		}else if(thisType == 'EMERGENCY'){
			phone_number = $('#STUDENT_PHONE_EMERGENCY_AREA_CODE').val() + '' + $('#STUDENT_PHONE_EMERGENCY_NUMBER').val();
		}else if(thisType == 'EMERGENCY_INTL'){
			phone_number = $('#STUDENT_PHONE_EMERGENCY_NUMBER_INTL').val();
		}			
		if($('#STUDENT_EP_NUMBER').length){
			$('#STUDENT_EP_NUMBER').val(phone_number);
			$('#STUDENT_EP_NUMBER_TEXT').html("&nbsp;" + phone_number + "&nbsp;(${StudentBio['PREFERRED_FIRST_NAME']} ${StudentBio['PREFERRED_LAST_NAME']} - Your phone number will always be contacted)");
		}else{
			var newAlertNumber = "<li class=\"list-unstyled grayed-out phone_number\"><input type=\"checkbox\" value=\"" + phone_number + "\" name=\"fields[25]\" checked=\"checked\" disabled=\"disabled\" id=\"STUDENT_EP_NUMBER\"><span id=\"STUDENT_EP_NUMBER_TEXT\">&nbsp;&nbsp;" + phone_number + "&nbsp;(${StudentBio['PREFERRED_FIRST_NAME']} ${StudentBio['PREFERRED_LAST_NAME']} - Your phone number will always be contacted)</span></li>";			
			$('#CAMPUS_ALERT_NUMBERS').prepend(newAlertNumber);
		}				
		
		/* if($.inArray(phone_number,checked_phone_numbers) == -1){
			//add number to campus alert phone number list
			addCampusAlertNumber(phone_number, '${StudentBio['PREFERRED_FIRST_NAME']} ${StudentBio['PREFERRED_LAST_NAME']}', 'STUDENT');
		} */
	});
	
	//switching off emergency contacts
	$('input[name="PARENT"]').on('switchChange.bootstrapSwitch', function(event, state) {
		//$('#PARENT_ERROR').hide();
		var ppid = $(this).attr("data-ppid");
		var thisName = $('#parent_' + ppid + ' .contact-name').html();
		emergencySwitchToggle(ppid,thisName,event,state);
	});
	
	//state/province drop-down toggle based on country chosen
	$('.country_field').change(function(){
		var form_id = $(this).closest('form').attr("id");
		var intlFieldGroup = '#GROUP_' + form_id + '_INTL_REGION';
		var intlField = intlFieldGroup + ' #' + form_id + '_ADDR_STAT_CODE';
		var stateFieldGroup = '#GROUP_' + form_id + '_ADDR_STAT_CODE';
		var stateField = stateFieldGroup + ' #' + form_id + '_ADDR_STAT_CODE';
		console.log(stateField);
		var zipFieldGroup = '#GROUP_' + form_id + '_ADDR_ZIP';		
		var zipField = '#' + form_id + '_ADDR_ZIP';
		if($(this).val() == 'United States' || $(this).val() == "US"){
			$(stateFieldGroup).show();
			$(stateField).addClass('ccreq');
			$(stateField).removeProp('disabled');
			$(zipField).addClass('ccreq');
			$(zipFieldGroup + ' .required').show();
			$(intlFieldGroup).hide();
			$(intlField).prop('disabled','disabled');
		}else{
			$(stateFieldGroup).hide();
			$(stateField).removeClass('ccreq');
			$(stateField).prop('disabled','disabled');
			$(zipField).removeClass('ccreq');
			$(zipFieldGroup + ' .required').hide();
			$(intlFieldGroup).show();
			$(intlField).removeProp('disabled');
		}
		
	});
	
	//triggered when modal is about to be shown
	/* $('#DELETE_MODAL').on('show.bs.modal', function(e) {

	    //get data-type attribute of the clicked element
	    var person_name = $(e.relatedTarget).data('person-name');
	    var person_id = $(e.relatedTarget).data('ppid');
	    var type = $(e.relatedTarget).data('modal-type');

	    //populate the textbox
	    $(e.currentTarget).find('.name_block').html(person_name);
	    $(e.currentTarget).find('#ppid_to_delete').val(person_id);
	    $(e.currentTarget).find('#type_to_delete').val(type);
	}); */	

	$('.showModal').click(function() {		
		modal_type = $(this).attr("data-modal-type");		
		ppid = $(this).attr("data-ppid");		
		populateModal(modal_type,ppid);
	});		
	
	$('.deleteModal').click(function(){
		var type = $(this).attr("data-modal-type");
		var ppid = $(this).attr("data-ppid");
		var name = $(this).attr("data-name");
		showDeleteModal(type,ppid,name);
	});		
	
	//don't allow any special characters in phone number fields, only 0-9, backspace, delete
	$(".num_only").keypress(function (e) {
		//console.log(e.which);
		if (/^\d+$/.test(e.key) ){
			//console.log("character accepted: " + e.key)
		} else {
			//console.log("illegal character detected: "+ e.key)
			var charCode = (e.which) ? e.which : e.keyCode
			if (e.key == 'Delete'){
				//console.log('character accepted' + e.key);
			}else if (charCode > 31 && (charCode < 48 || charCode > 57)){
				//console.log("illegal character detected: "+ e.key)
				return false;
			}
		}
	});

	//check to see if parents are emerg contacts, turn off switch if not
	/* $('.parent-bootstrap-switch').each(function(){
		var ppid = $(this).attr("data-ppid");
		var student_PIDM = ${StudentBio['STUDENT_PIDM']};
		$.ajax({
	           type: "POST",
	           url: ajaxurl,
	           data: JSON.stringify({"PIDM": student_PIDM, "PPID": ppid, "DATA": "CONTACT", "MODE": "READ"}),
	           datatype: "json",
	           contentType: "application/json",
	           success: function(data)           
	           {  
	        	   //IS A CONTACT
	        	   //console.log("is a contact: " + ppid);
	           },
	           error: function (request, status, error) {
	               //console.log("ERROR: " + request.responseText);
	               //console.log("is NOT a contact: " + ppid);
	               var this_parent_switch = $('.parent-bootstrap-switch').attr("data-ppid",ppid);
	               $(this_parent_switch).bootstrapSwitch('state',false);
	               
	           }
		 });		 
	});	 */
	
	
	//reset the modal form fields if modal is closed
	  $('#CONTACT_MODAL').on('hidden.bs.modal', function () {
		 document.getElementById("CONTACT").reset();
		 if($('.modal_mobile_phone_check').is(':checked')){
			 $('.modal_mobile_phone_check').prop('checked',false).change();
		 }
	 });	 
	 $('#PARENT_MODAL').on('hidden.bs.modal', function () {
		 document.getElementById("PARENT").reset();
		 if($('.modal_mobile_phone_check').is(':checked')){
			 $('.modal_mobile_phone_check').prop('checked',false).change();
		 }
	 });
	 
	//hide all modal error messages if modal is closed 
	$('#PARENT_MODAL, #CONTACT_MODAL, #DELETE_MODAL').on('hidden.bs.modal', function () {		
	    $('#PARENT_MODAL .alert-danger, #CONTACT_MODAL .alert-danger, #DELETE_MODAL .alert-danger').hide();
		$('#PARENT_MODAL .form-group, #CONTACT_MODAL .form-group, #DELETE_MODAL .form-group').removeClass('has-error');
	});
 
	//only allow 5 alert numbers to be checked
	var alert_number_limit = 5;
	$('input.alert_phone_number').on('change', function(evt) {
		//first add to array if not already there
		var thisVal = $(this).val();
		console.log("thisVal: " + thisVal);
		if($(this).is(':checked')){
			//add to array if not already there
			if($.inArray(thisVal,checked_phone_numbers) == -1){
	 			checked_phone_numbers.push(thisVal);
	 		}
			console.log(checked_phone_numbers);
		}else{
			//remove from array if present
			if($.inArray(thisVal,checked_phone_numbers) != -1){
				checked_phone_numbers.splice( $.inArray(thisVal, checked_phone_numbers), 1 );
	 		}
			console.log(checked_phone_numbers);
		}		
		var alertNum = $("input[name='fields[25]']:checked").length;
		//console.log("number of alert numbers: " + alertNum);
	   	if($("input[name='fields[25]']:checked").length > alert_number_limit) {
	      	this.checked = false;
	      	$('#ALERT_NUMBER_MODAL').modal();
	   	}
	});
	
	$('.address_to_use_checkbox').change(function(){
		var thisName = $(this).attr('name');
		var thisType = $(this).attr('data-type');
		var typeToSteal = $('#SELECT_' + thisName).val();
		if($(this).prop('checked')){			
			if(typeToSteal == 'STUDENT'){
				$('.STUDENT_ADDRESS_FIELD').each(function(){
					if($(this).is(':visible')){
						var thisID = $(this).attr('id');
						var thisID = thisID.replace('STUDENT','');
						var thisVal = $(this).val();
						$('#'+ thisType + thisID).val(thisVal);
					}
				});
			}				
		}else{
			if(typeToSteal == 'STUDENT'){
				$('.STUDENT_ADDRESS_FIELD').each(function(){
					if($(this).is(':visible')){
						var thisID = $(this).attr('id');
						var thisID = thisID.replace('STUDENT','');
						var thisVal = $(this).val();
						$('#'+ thisType + thisID).val('');
					}
				});
			}
		}
	});
	
	
 });
 
function checkNum(type){	
	var num = $('.' + type + '-LISTED:visible').length;
	//console.log(type + " num: " + num);
	return num;
}

function disableModalEnter(type){
	$('#ADD_' + type).attr("disabled","disabled");
	$('#' + type + '_MAX_ENTERED').show();
}

function enableModalEnter(type){
	$('#ADD_' + type).removeAttr("disabled","disabled");
	$('#' + type + '_MAX_ENTERED').hide();
}

function showDeleteModal(type,ppid,name){	
	$('#DELETE_MODAL').modal();
	//console.log("showDeleteModal, name: " + name + "ppid: " + ppid + "type: " + type);
	$('#delete_form').find('#type').html(type.toLowerCase());
	$('#delete_form').find('.name_block').html(name);
	$('#delete_form').find('#ppid_to_delete').val(ppid);
	$('#delete_form').find('#type_to_delete').val(type);	
}

 function deleteIndividual(){
	 ppid_to_delete = $('#delete_form #ppid_to_delete').val();
	 type = $('#delete_form  #type_to_delete').val();
	 performDelete(ppid_to_delete,type);	 
 } 
 
 function performDelete(ppid_to_delete,type){
	 $.ajax({
         type: "POST",
         url: ajaxurl,
         data: JSON.stringify({"PIDM": student_PIDM, "PPID": ppid_to_delete, "DATA": type, "MODE": "DELETE"}),
         datatype: "json",
         contentType: "application/json",
         success: function(data)           
         {  
        	 var emr_switch_count = $('.parent-bootstrap-switch:checked').length;
        	 $('#DELETE_MODAL').modal('hide');
        	 if(type == 'CONTACT'){
        		 $('#emr_contact_'+ppid_to_delete).hide();
        	 }else{
        		 $('#parent_'+ppid_to_delete).hide();
        	 }    
        	 if(checkNum(type) >= 5){
      		   disableModalEnter(type);
      	   	}else{
      		   enableModalEnter(type);
      	   	}
        	 if(emr_switch_count == 1){
        		 $('.parent-bootstrap-switch:checked').each(function(){
     				$(this).bootstrapSwitch('disabled',false);
     			});
        	 }
         },
         error: function (request, status, error) {
             //console.log("ERROR: " + request.responseText);
         }
	    });			 
	 return false;
 }
 
 function formValidate(form_id){
	 showMainError = 0;
	 $('.alert').hide();
	 //required fields
	 $("#" + form_id + " .ccreq").each(function(){
		 //console.log($(this));
		 var field_value = $(this).val();
		 var field_id = $(this).attr("id");
		 var field_type = $(this).attr("type");
		 var field_label = $(this).attr("placeholder");
		 if(field_value.length == 0){
			 $("#" + field_id + "_ERROR" + " .custom-error").html('Please Enter ' + field_label);	
			 $("#" + field_id + "_ERROR").show();		
			 $("#group_" + field_id).addClass("has-error");
			 console.log(" error on: field_id: " + field_id + " field_label: " + field_label + " field_value: " + field_value + " field_type: " + field_type);			 
			 console.log("#" + field_id + "_ERROR");
			 showMainError = 1
		 }else{
			 $("#" + field_id + "_ERROR").hide();		
			 $("#group_" + field_id).removeClass("has-error");
		 }		 
		 //console.log(input);
	 });
	 //email validation
	 $("#" + form_id + " input[type=email]").each(function(){
		 var field_value = $(this).val();
		 var field_id = $(this).attr("id");
		 var field_type = $(this).attr("type");
		 var field_label = $(this).attr("placeholder");
		 var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		 valid_email = regex.test(field_value);
		 if(!valid_email){
			 $("#" + field_id + "_ERROR" + " .custom-error").html('The ' + field_label + ' you entered is invalid. Please enter a valid ' + field_label);	
			 $("#" + field_id + "_ERROR").show();		
			 $("#group_" + field_id).addClass("has-error");
			 //console.log("error on: " + field_label);
			 showMainError = 1;
		 }else{
			 $("#group_" + field_id).removeClass("has-error");
		 }
	 });
	 //telephone validation
	 $("#" + form_id + " input[type=tel]").each(function(){
		 var field_value = $(this).val();
		 var field_id = $(this).attr("id");
		 var field_type = $(this).attr("type");
		 var field_label = $(this).attr("placeholder");
		 var field_size = $(this).attr("size");
		 if((field_value.length != field_size && field_value.length > 0) || (field_value.length == 0 && $(this).hasClass("ccreq"))){
			 $("#" + field_id + "_ERROR" + " .custom-error").html('The ' + field_label + ' you entered is the incorrect length. Please enter a valid ' + field_label);	
			 $("#" + field_id + "_ERROR").show();		
			 $("#group_" + field_id).addClass("has-error");
			 console.log("error on phone: field_id: " + field_id + "field_size: " + field_size + "field_value.length: " + field_value.length);
			 showMainError = 1;
		 }else{
			 $("#" + field_id + "_ERROR").hide();
			 $("#group_" + field_id).removeClass("has-error");
		 }
	 });
	 
	 
	 if(form_id == 'STUDENT'){
		 if(checkNum('PARENT') == 0){
			 $('#PARENT_NUM_ERROR').show();
			 showMainError = 1;
		 }else{
			 $('#PARENT_NUM_ERROR').hide();
		 }
		 if(checkNum('CONTACT') == 0){
			 $('#CONTACT_NUM_ERROR').show();
			 showMainError = 1;
		 }else{
			 $('#CONTACT_NUM_ERROR').hide();
		 }
 	}
}
 
 //save main form
 function submitMainForm(form_id){
	 formValidate(form_id);
	 if(showMainError){
		 window.scrollTo(0,0);
		 $('#' + form_id + '_MODAL').animate({ scrollTop: 0 }, 'fast'); 
		 $('#STUDENT_FORM_ERROR').show();
		 //$('#' + form_id + '_MODAL').scrollTop(0);
		 return false;	
	 }else{
		 $('#STUDENT_FORM_ERROR').hide();
		 //$('#' + form_id).submit();
		 return true;
	 }
 }
 
 function populateModal(modal_type,ppid){
		student_PIDM = ${StudentBio['STUDENT_PIDM']};
		$.ajax({
	           type: "POST",
	           url: ajaxurl,
	           data: JSON.stringify({"PIDM": student_PIDM, "PPID": ppid, "DATA": modal_type, "MODE": "READ"}),
	           datatype: "json",
	           contentType: "application/json",
	           success: function(data)           
	           {   
	        	  //$('#' + modal_type + '_STUDENT_PPID').val();
	        	  $('#' + modal_type + '_STUDENT_PIDM').val(student_PIDM);
	        	  $('#' + modal_type + '_PARENT_PPID').val(ppid);
	        	  //$('#' + modal_type + '_PARENT_PIDM').val();
	        	  if(modal_type == 'PARENT'){
		        	  $.each(data.parent, function(index, element){	       
		        		  $('form#' + modal_type + ' #' + index).val(element);	 
		        		  if(index == 'EMERG_NO_CELL_PHONE'){
		        			  console.log('Emerg_no_cell_phone: ' + index);
		        			  if(element == 'Y'){
		        				  console.log('element: ' + element);
		        				  console.log('modal_type: ' + modal_type);
		        				  //$('#' + modal_type + '_' + index).attr('checked','checked');
		        				  $('.modal_mobile_phone_check').prop('checked',true).change();
		        				  emergencyNumberToggle(modal_type, 1);
		        			  }
		        		  }
		        	   	//$('#' + index).val(element);
		        	  });
	        	  }else{
	        		  $.each(data.contact, function(index, element){
	        			  var new_index = index;
	        			  var new_index = new_index.replace('EMERG','CONTACT')
	        			  $('form#' + modal_type + ' #' + new_index).val(element);
	        			  if(index == 'EMERG_NO_CELL_PHONE'){
		        			  console.log('Emerg_no_cell_phone: ' + index);
		        			  if(element == 'Y'){
		        				  console.log('element: ' + element);
		        				  console.log('modal_type: ' + modal_type);
		        				  $('#' + modal_type + '_' + index).attr('checked','checked');
		        				  emergencyNumberToggle(modal_type, 1);
		        			  }
		        		  }
	  	        	   	//$('#' + index).val(element);
	  	        	  });
	        	  }

	        	  $.each(data.email, function(index,element){        
	        		 $('form#' + modal_type + ' #' + modal_type + '_' + index).val(element);
	        	  	 //$('#' + modal_type + "_" + index).val(element); 	
	        	  });

	        	  $.each(data.address, function(index,element){        		 
	        		  if(index == 'ADDR_NATN_CODE' && element == null){
	        			  $('form#' + modal_type + ' #' + modal_type + '_' + index).val('US');
	        			//$('#' + modal_type + "_" + index).val('US');
	        		  }else{
	        			  $('form#' + modal_type + ' #' + modal_type + '_' + index).val(element);
	          	  		//$('#' + modal_type + "_" + index).val(element);
	         		  }
	          	  });
	        	  //phones
	        	  for(i=0;i<data.phones.length;i++){
	          		  var phone_code = data.phones[i].PHONE_CODE;
	        		  //var phone_number = data.phones[i].PHONE_AREA_CODE + data.phones[i].PHONE_NUMBER;
	        		  var phone_area_code = data.phones[i].PHONE_AREA_CODE;
	        		  var phone_number = data.phones[i].PHONE_NUMBER;
	        		  var phone_number_intl = data.phones[i].PHONE_NUMBER_INTL;
	        		  var phone_sequence_no = data.phones[i].PHONE_SEQUENCE_NO;
	        		  var phone_carrier = data.phones[i].PHONE_CARRIER;     
	        		  
	        		  $('#' + modal_type + '_PHONE_' + phone_code + '_CODE').val(phone_code);
	        		  
	        		 if(phone_code == 'EP'){
	        			 //handle emergency number
	        			 if($('#' + modal_type + '_' + 'EMERG_NO_CELL_PHONE').is(':checked')){
		        			  if(phone_number_intl != "" && phone_number_intl != null){
		   	        			  //console.log(phone_number_intl);
		   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER').hide();
		   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').val(phone_number_intl);
		   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').show();   
		   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').addClass('ccreq');
								  $('#' + modal_type + '_PHONE_EMERGENCY_AREA_CODE').removeClass('ccreq');
								  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER').removeClass('ccreq');
		   	        		  }else{
		   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').hide();
		   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_AREA_CODE').val(phone_area_code);
		   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER').val(phone_number);
		   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER').show();  
		  						  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').removeClass('ccreq');
								  $('#' + modal_type + '_PHONE_EMERGENCY_AREA_CODE').addClass('ccreq');
								  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER').addClass('ccreq');	
		   	        		  } 
	        			 }else{
	        				 //$('#' + modal_type + '_PHONE_' + phone_code + '_AREA_CODE').val(phone_area_code);
	        				 //$('#' + modal_type + '_PHONE_' + phone_code + '_NUMBER').val(phone_number);
	        			 }
	        		 }else{
	        		  	$('#' + modal_type + '_PHONE_' + phone_code + '_AREA_CODE').val(phone_area_code);
		        		  if(phone_number_intl != "" && phone_number_intl != null){
		        			  //console.log(phone_number_intl);
		        			  $('#GROUP_' + modal_type + '_PHONE_' + phone_code + '_NUMBER').hide();
		        			  $('#' + modal_type + '_PHONE_' + phone_code + '_NUMBER_INTL').val(phone_number_intl);
		        			  $('#GROUP_' + modal_type + '_PHONE_' + phone_code + '_NUMBER_INTL').show();        			  
		        		  }else{
		        			  $('#GROUP_' + modal_type + '_PHONE_' + phone_code + '_NUMBER_INTL').hide();
		        			  $('#' + modal_type + '_PHONE_' + phone_code + '_NUMBER').val(phone_number);
		        			  $('#GROUP_' + modal_type + '_PHONE_' + phone_code + '_NUMBER').show();        			 
		        		  }   
	        		 	}	        		  
	        		  $('#' + modal_type + '_PHONE_' + phone_code + '_SEQUENCE_NO').val(phone_sequence_no);
	        		  $('#' + modal_type + '_PHONE_' + phone_code + '_CARRIER').val(phone_carrier);   
	        	  }
	        	  
	           },
	           error: function (request, status, error) {
	               //console.log("ERROR: " + request.responseText);
	           }
		    });		    
			
			$('#' + modal_type + "_MODAL").modal('show');
	}
 
 //save modal
 function submitModal(form_id) { 
	 //console.log("submitModal");	  
	 formValidate(form_id);
	 //console.log("after form validates");
	 //console.log("show main error: " + showMainError);
	 if(showMainError){
		 window.scrollTo(0,0);
		 $('#' + form_id + '_MODAL').animate({ scrollTop: 0 }, 'fast');
		 //console.log("show main error");
		 $('#' + form_id + '_MODAL_ERROR').show();
		 return false;		 
	 }else{
		 $('#' + form_id + '_MODAL_ERROR').hide();
		 //console.log("continue save");
		 //close any former error messages
		 $(".alert_danger").hide();
		 var parent_ppid = $('#' + form_id + '_PARENT_PPID').val();
		 //console.log("parent_ppid: " + parent_ppid);
		 var student_pidm = $('#' + form_id + '_STUDENT_PIDM').val();
		 //console.log("student_pidm: " + student_pidm);
		 var new_contact_name = $('#' + form_id + '_PREF_FIRST_NAME').val() + ' ' + $('#' + form_id + '_PREF_LAST_NAME').val();
		 //submit via ajax
		
		 //var formData = JSON.stringify($('#' + form_id).serializeArray());
		 formData = '{"PIDM" : "' + student_pidm + '",';
		 if(parent_ppid == 0){
			 formData = formData + '"PPID" : null,';
		 }else{
			 formData = formData + '"PPID" :  "' + parent_ppid + '",';
		 }
		 formData = formData + '"DATA" : "' + form_id + '","MODE" : "WRITE",';
		 
		 var typeArray = ["DEMO","EMAIL","ADDRESS"];
		 
		 for (var i = 0; i < typeArray.length; i++) {
			if(typeArray[i] == "DEMO"){
				if(form_id == 'PARENT'){
					 formData = formData + '"parent" : {';
				}else{
					formData = formData + '"contact" : {';
				}
			}else{							
				formData = formData + '"' + typeArray[i].toLowerCase() + '": {';
			}							
			
			x=0;
			 $('.' + form_id + '_' + typeArray[i] + '_FIELD').each(function(){
				 if($(this).is(':visible') || ($(this).attr("name","PECI_EMAIL_CODE") && typeArray[i] == 'EMAIL')){
					 //test = $(this).is(':visible');
					 var val = $(this).val();
					 var name = $(this).attr("name");
					 if(typeArray[i] != "DEMO"){					 	
					 	var name = name.replace("PARENT_","");
					 	var name = name.replace("EMERG_","");	
					 	var name = name.replace("CONTACT_","");
					 }else{
						var name = name.replace("CONTACT","EMERG");
					 }
					 if(name == 'DEPENDENT'){
						dependent_field = 'form#' + form_id + ' #DEPENDENT';
					 	if ($(dependent_field).is(":checked")){
							var val = "Y";
						}else{
							var val = "N";
						}					 
					 }
					 if(name.substr(name.length - 19) == 'EMERG_NO_CELL_PHONE'){
						 name = "EMERG_NO_CELL_PHONE";
						 if($(this).is(':checked')){
							 var val = 'Y';
						 }else{
							 var val = 'N';
						 }
					 }
					 //console.log("val: " + val + " name: " + name);
					 if(x == 0){						
						x = x + 1;						
					 }else{
						 formData = formData + ",";
					 }
					 addToFormData(val,name);
				}
			 });

			formData = formData + "},";			
		 }

		//loop phones separately as array
		formData = formData + '"phones": [ {';
		var phoneCodeArray = ["CP","EP","MA","BU"];			
		 for (var j = 0; j < phoneCodeArray.length; j++) {
			if(phoneCodeArray[j] != "CP"){
				formData = formData + "},{";
			}
			var phone_sequence_no = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_SEQUENCE_NO').val();
			var phone_code = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_CODE').val();
			if(phoneCodeArray[j] == "EP"){
				if($('#' + form_id + '_EMERG_NO_CELL_PHONE').is(':checked')){
					var emerg_no_cell_phone = 'Y';					
					if($('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL').is(':visible')){					
						var phone_area_code = '';
						var phone_number = '';
						var phone_intl = $('#' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL').val();
					}else{					
						var phone_area_code = $('#' + form_id + '_PHONE_EMERGENCY_AREA_CODE').val();
						var phone_number = $('#' + form_id + '_PHONE_EMERGENCY_NUMBER').val();
						var phone_intl = '';	
					}	
					
					//check if CP number has data, if it does, wipe it out
					var phone_cp_sequence_no = $('#' + form_id + '_PHONE_CP_SEQUENCE_NO').val();
					if(phone_cp_sequence_no.length != 0){
						//wipe out current number					
						var phone_area_code = '';
						var phone_number = '';						
						var phone_code = 'CP';
						var phone_intl = '';
						var emerg_no_cell_phone = '';
						var phone_carrier = '';
					}					
					
				}else{
					//emerg_no_cell_phone not checked, don't send any EP number, wipe out whats there
					var emerg_no_cell_phone = 'N';	
					//check if EP number has data, if it does, wipe it out
					var phone_ep_sequence_no = $('#' + form_id + '_PHONE_EP_SEQUENCE_NO').val();
					if(phone_ep_sequence_no.length != 0){
						//wipe out current number					
						var phone_area_code = '';
						var phone_number = '';						
						var phone_code = 'EP';
						var phone_intl = '';
						var emerg_no_cell_phone = '';
						var phone_carrier = '';
					}							
				}
			}else{
				var submitNumber = 1;
				var emerg_no_cell_phone = 'N';					
				if($('#GROUP_' + form_id + '_PHONE_' + phoneCodeArray[j] + '_NUMBER_INTL').is(':visible')){
					var phone_area_code = '';
					var phone_number = '';
					var phone_intl = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_NUMBER_INTL').val();
				}else{
					var phone_area_code = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_AREA_CODE').val();
					var phone_number = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_NUMBER').val();
					var phone_intl = '';
				}					
				
			}
			var phone_carrier = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_CARRIER').val();
			//phone_code = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_CODE').val();
			
			if(phone_sequence_no.length == 0){
				formData = formData + '"PHONE_SEQUENCE_NO" : null,';
			}else{
				formData = formData + '"PHONE_SEQUENCE_NO" : "' + phone_sequence_no + '",';
			}
			formData = formData + '"PHONE_AREA_CODE" : "' + phone_area_code + '",';
			formData = formData + '"PHONE_NUMBER" : "' + phone_number + '",';
			formData = formData + '"PHONE_CODE" : "' + phone_code + '",';
			formData = formData + '"PHONE_NUMBER_INTL" : "' + phone_intl + '",';
			formData = formData + '"EMERG_NO_CELL_PHONE" : "' + emerg_no_cell_phone + '",';
			if(phone_carrier == undefined || phone_sequence_no.length == 0){
				formData = formData + '"CELL_PHONE_CARRIER" : null';
			}else{
				formData = formData + '"CELL_PHONE_CARRIER" : "' + phone_carrier + '"';
			}	
			//show number in step 5	
								
			if(phoneCodeArray[j] == "CP"){
				if($('#' + form_id + '_EMERG_NO_CELL_PHONE').is(':checked')){
					emerg_no_cell_phone = 'Y';					
					if($('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL').is(':visible')){
						var alert_phone_number = phone_intl;
					}else{
						var alert_phone_number = "" + phone_area_code + phone_number;
					}	
				}else{
					var emerg_no_cell_phone = 'N';
					if($('#GROUP_' + form_id + '_PHONE_' + phoneCodeArray[j] + '_NUMBER_INTL').is(':visible')){
						var alert_phone_number = phone_intl;
					}else{
						var alert_phone_number = "" + phone_area_code + phone_number;
					}		
				}
			}else{
				var alert_phone_number = "" + phone_area_code + phone_number;
			}
			
			/* if($.inArray(alert_phone_number,checked_phone_numbers) == -1){
				//add number to campus alert phone number list
				console.log("add this num: " + alert_phone_number);
				addCampusAlertNumber(alert_phone_number, new_contact_name, form_id);
			}else{
				console.log("DONT ADD: " + phone_number);
			} */
			
     	   //reset hidden form fields on modal manually because Safari is old and cranky and can't reset fields it can't see	
			$('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_SEQUENCE_NO').val('');
		 }	
		 
		 //set emr separately
		 $('#' + form_id + '_PHONE_EMR_SEQUENCE_NO').val('');

		formData = formData + "}]";					
		formData = formData + "}";		 		 
		console.log(formData);
		 
		if(new_contact_name.length > 1){
			$.ajax({
		           type: "POST",
		           url: ajaxurl,
		           //data: JSON.stringify($('#' + form_id).serialize()),
		           data: formData,
		           dataType: "json",
		           contentType: "application/json",
		           success: function(data)
		           {   
		        	   //console.log(data);
		        	   //console.log(data.PARENT_PPID);
		        	   if(parent_ppid == 0){
		        	   	addToList(form_id,new_contact_name,data.PARENT_PPID);
		        	   }else{
		        		   	$('#PARENT_LIST #parent_' + parent_ppid + ' .contact-name').html('<strong>' + new_contact_name + '</strong>');  
		        	   		$('#CONTACT_LIST #emr_contact_' + parent_ppid + ' .contact-name').html('<strong>' + new_contact_name + '</strong>');  
		        	   }
		        	   $('#' + form_id + '_PARENT_PPID').val(0);
		        	   document.getElementById(form_id).reset();
		        	   resetIntlModalNumbers();
		        	   getAlertNumbers();
		        	   if($('.modal_mobile_phone_check').is(':checked')){
		      			 $('.modal_mobile_phone_check').prop('checked',false).change();
		      		   }
		        	   //$('.modal_mobile_phone_check').trigger('click');
		        	   $('#'+ form_id + '_MODAL').hide();
		        	   $('#' + form_id + '_CLOSE_BUTTON').trigger('click');
		        	   $('#CONFIRMATION_MODAL').modal('show');
		        	   if(checkNum(form_id) >= 5){
		        		   disableModalEnter(form_id);
		        	   }else{
		        		   enableModalEnter(form_id);
		        	   }
		        	   //add to emr_order
		        	   var current_emr_order = $('#emr_order').val();
		        	   if(current_emr_order.length > 0){
		        		   $('#emr_order').val(current_emr_order + ',' + data.PARENT_PPID); 
		        	   }else{
		        		   $('#emr_order').val(current_emr_order + '' + data.PARENT_PPID); 
		        	   }
		        	      
		        	   
			           //console.log("recipientSubmitAjax: id:" + id + " formID:" + formID + " formToSubmitTo:" + formToSubmitTo);  
		              
		           },
		           error: function(e){
		        	   console.log(e);
		        	   return false;
		           }
			    });	 
			}
		 return false;
		 
	 }	 
	}
	
	 function resetIntlModalNumbers(){
  	     //reset all international numbers in modal back to US numbers after modal submission
		 $('.modal_intl_form_group').each(function(){
   	   		if($(this).is(':visible')){
   	   			  var type = $(this).attr('data-type');
   	   			  $('.intl_number_switch[data-type=' + type + ']').trigger('click');
   	   		}
    	 });
	 }
	 
	function addToFormData(val,name){
		formData = formData + '"' + name + '" : ';
		 if(val.length != 0){
		 	formData = formData + '"' + val + '"';
		 }else{
			 formData = formData + "null"
		 }
		 return formData;
	}
	
	function addToList(type,new_contact_name,ppid){
		if(type == 'PARENT'){
			//always add parents as emergency contacts
			addParent(type,ppid,new_contact_name);
			addContact(type,ppid,new_contact_name);
		}else{
			addContact(type,ppid,new_contact_name);
		}		
	}
	
	function addParent(type,ppid,new_contact_name){
		var parent_info = '<div class="panel panel-default PARENT-LISTED" id="parent_' + ppid + '"><div class="panel-body"><span class="contact-name"><strong>' + new_contact_name + '</strong></span><a href="#" title="Edit" class="showModal" data-ppid="' + ppid + '" data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="' + new_contact_name + '" data-ppid="' + ppid + '"  data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a><span class="emergency_contact_switch">&nbsp;Emergency Contact: <input type="checkbox" name="PARENT" checked="checked" class="bootstrap-switch parent-bootstrap-switch" data-ppid="' + ppid + '" data-off-text="No" data-on-text="Yes"></span></div></div>';
		$('#PARENT_LIST').append(parent_info);
		//$('#PARENT_LIST #parent_' + ppid + ' .bootstrap-switch').attr("data-ppid",ppid).bootstrapSwitch('state', true);
		//$('#PARENT_LIST #parent_' + ppid + ' .bootstrap-switch').bootstrapSwitch();		
		
		var emr_switch_count = $('.parent-bootstrap-switch:checked').length;
		console.log('emr_switch_count: ' + emr_switch_count);
		if(emr_switch_count == 1){
			$('#PARENT_LIST #parent_' + ppid + ' .bootstrap-switch').bootstrapSwitch('disabled',true);
		}else if(emr_switch_count > 1){
			$('.parent-bootstrap-switch:checked').each(function(){
				$(this).bootstrapSwitch('disabled',false);
			});
			//$('.bootstrap-switch').bootstrapSwitch('disabled',false);
		}
		
		//attach click event to bootstrap switch for new contact
		$('#PARENT_LIST #parent_' + ppid + ' .bootstrap-switch').on('switchChange.bootstrapSwitch', function(event, state) {
			emergencySwitchToggle(ppid,new_contact_name,event,state);
		});
		//attach click event for Edit icon on new contact
		$('#PARENT_LIST #parent_' + ppid).on('click','.showModal',function(){
			populateModal(type,ppid);
		});
		//attach click event for Delete icon on new contact
		$('#PARENT_LIST #parent_' + ppid).on('click','.deleteModal',function(){
			showDeleteModal('PARENT',ppid,new_contact_name);
		});
	}
	
	function addContact(type,ppid,new_contact_name){
		console.log("add Contact: " + new_contact_name + ' '  + ppid);	
	
		var contact_info = '<li class="panel panel-info CONTACT-LISTED" id="emr_contact_' + ppid + '"><div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div><div class="panel-body"><span class="contact-name"><strong>' + new_contact_name + '</strong></span> &nbsp; <a href="#" title="Edit"  class="showModal" data-ppid="' + ppid + '" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="' + new_contact_name + '" data-ppid="' + ppid + '"  data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div></li>'
		$('#CONTACT_LIST').append(contact_info);
		$('#CONTACT_LIST #emr_contact_' + ppid).on('click','.showModal',function(){
			populateModal(type,ppid);
		});
		$('#CONTACT_LIST #emr_contact_' + ppid).on('click','.deleteModal',function(){
			showDeleteModal('CONTACT',ppid,new_contact_name);
		});
	}
	
/* 	function addCampusAlertNumber(alert_phone_number, new_contact_name, type){		
		if(type == 'STUDENT'){
			if($('#STUDENT_EP_NUMBER').length){
				$('#STUDENT_EP_NUMBER').val(alert_phone_number);
				$('#STUDENT_EP_NUMBER_TEXT').html('&nbsp;' + alert_phone_number + '&nbsp;(' + new_contact_name + ' - Your phone number will always be contacted)');
			}else{
				var newAlertNumber = '<li class="list-unstyled grayed-out alert_phone_number"><input type="checkbox" value="' + alert_phone_number + '" name="fields[25]" checked="checked" disabled="disabled" id="STUDENT_EP_NUMBER"><span id="STUDENT_EP_NUMBER_TEXT">&nbsp;&nbsp;' + alert_phone_number + '&nbsp;(' + new_contact_name + ' - Your phone number will always be contacted)</span></li>';			
				$('#CAMPUS_ALERT_NUMBERS').prepend(newAlertNumber);
			}			
		}else{
			var newAlertNumber = '<li class="list-unstyled alert_phone_number"><input type="checkbox" value="' + alert_phone_number + '" name="fields[25]">&nbsp;' + alert_phone_number + '&nbsp;(' + new_contact_name + ')</li>';
			$('#CAMPUS_ALERT_NUMBERS').append(newAlertNumber);
		}	
		//push to all phone number array
		//checked_phone_numbers.push(alert_phone_number);
		//console.log("New all phone numbers: " + checked_phone_numbers);
	} */
	
	function emergencyNumberToggle(form_id, checked){
		if(checked) {
			$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER').show();
			$('#' + form_id + '_EMERGENCY_PHONE').addClass('ccreq');
			$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL_SWITCH').show();
			//remove error if it is already displaying
			$('form#' + form_id + ' PHONE_CP_NUMBER_ERROR').hide();
			//$('#GROUP_' + form_id + '_PHONE_CP_NUMBER').removeClass('has-error');
			//remove requirement for mobile phone
			$('#GROUP_' + form_id + '_PHONE_CP_NUMBER .required').hide();				
			$('#' + form_id + '_PHONE_CP_AREA_CODE').removeClass('ccreq');
			$('#' + form_id + '_PHONE_CP_NUMBER').removeClass('ccreq');
			$('#' + form_id + '_PHONE_CP_NUMBER_INTL').removeClass('ccreq');
			//add requirement for emergency phone
			$('#' + form_id + '_PHONE_EMERGENCY_AREA_CODE').addClass('ccreq');
			$('#' + form_id + '_PHONE_EMERGENCY_NUMBER').addClass('ccreq');
			//remove requirement for phone carrier
			$('#GROUP_' + form_id + '_PHONE_CARRIER .required').hide();	
			if(form_id == 'STUDENT'){
				//remove text alerts checkbox
				$('#paragraph_alert_text_check').hide();
				$('#group_alert_text_check').hide();	
				$('#paragraph_tty_device_check').html('If your emergency phone is a TTY device (for the hearing impaired) please indicate below:');
			}
	    }else{
	    	$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER').hide();	
	    	$('#' + form_id + '_EMERGENCY_PHONE').removeClass('ccreq');
	    	$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL_SWITCH').hide();
	    	//add requirement for mobile phone
	    	$('#GROUP_' + form_id + '_PHONE_CP_NUMBER .required').show();	
	    	$('#' + form_id + '_PHONE_CP_AREA_CODE').addClass('ccreq');
			$('#' + form_id + '_PHONE_CP_NUMBER').addClass('ccreq');
			//add requirement for emergency phone
			$('#' + form_id + '_PHONE_EMERGENCY_AREA_CODE').removeClass('ccreq');
			$('#' + form_id + '_PHONE_EMERGENCY_NUMBER').removeClass('ccreq');
	    	//add requirement for phone carrier
			$('form#' + form_id + ' #GROUP_PHONE_CARRIER .required').show();	
			if(form_id == 'STUDENT'){
				//show text alerts checkbox
				$('#paragraph_alert_text_check').show();
				$('#group_alert_text_check').show();	
				$('#paragraph_tty_device_check').html('If your mobile phone is a TTY device (for the hearing impaired) please indicate below:');
			}
	    }		
		
	}
	
	function emergencySwitchToggle(ppid, name, event, state){
		var x = 0;
		var removeParentFromContact = false;
		var emr_switch_count = $('.parent-bootstrap-switch:checked').length;
		console.log('emr_switch_count from emergencySwitchToggle: ' + emr_switch_count);
		if(state == false){
			//turning parent off
			if(emr_switch_count < 1){
				//turn back on
				$(this).bootstrapSwitch('state',true);
			}else if(emr_switch_count == 1){
				$('.parent-bootstrap-switch:checked').bootstrapSwitch('disabled',true);					
				removeParentFromContact = true;
			}else{
				$('.parent-bootstrap-switch').bootstrapSwitch('disabled',false);
				removeParentFromContact = true;
			}			
			if(removeParentFromContact){
				$('#emr_contact_'+ppid).hide();
				performDelete(ppid,'CONTACT');
			}
		}else{
			//turning parent on
			//show in emerg contacts list
			if($('#emr_contact_' + ppid).length){
				//already exists, just show it
				console.log('contact already exists, show it');
				$('#emr_contact_' + ppid).fadeIn();
				$('.parent-bootstrap-switch').bootstrapSwitch('disabled',false);
			}else{
				console.log('contact does not exist, use ajax to create');	
				if(emr_switch_count < 1){
					//turn back on
					$(this).bootstrapSwitch('state',true);
				}else if(emr_switch_count == 1){
					$('.parent-bootstrap-switch:checked').bootstrapSwitch('disabled',true);					
					removeParentFromContact = true;
				}else{
					$('.parent-bootstrap-switch').bootstrapSwitch('disabled',false);
					removeParentFromContact = true;
				}	
			}
			//create contact by promoting through restlet
			$.ajax({
		           type: "POST",
		           url: ajaxurl,
		           data: JSON.stringify({"PIDM": student_PIDM, "PPID": ppid, "DATA": "PARENT", "MODE": "PROMOTE"}),
		           datatype: "json",
		           contentType: "application/json",
		           success: function(data)           
		           {  
		        	   addToList('CONTACT',name,ppid);
		           },
		           error: function (request, status, error) {
		               
		           }
			 });		 
						
			//change read-only state
			/* if(x > 1){
				$('.bootstrap-switch-wrapper').removeClass('bootstrap-switch-readonly').removeProp('disabled');
			} */
		}		

		  //console.log("ppid: " + ppid);
		  //console.log("form_id: " + form_id);
		  //console.log(this); // DOM element
		  //console.log(event); // jQuery event
		  //console.log(state); // true | false
	}
	
	function getAlertNumbers(){
		$.ajax({
	           type: "POST",
	           url: ajaxurl,
	           data: JSON.stringify({"PIDM": student_PIDM, "PPID": null, "DATA": "PHONES", "MODE": "READ"}),
	           datatype: "json",
	           contentType: "application/json",
	           success: function(data)           
	           {  
	        	 //phones
	        	 if(data.phones.length > 0){
	        		 $('.NON-STUDENT-EP-NUMBER').remove();	        		 
	        	 }
	        	  for(i=0;i<data.phones.length;i++){
	          		  var phone_code = data.phones[i].PHONE_CODE;
	        		  //var phone_number = data.phones[i].PHONE_AREA_CODE + data.phones[i].PHONE_NUMBER;
	        		  if(phone_code != 'EP'){
		        		  var phone_area_code = data.phones[i].PHONE_AREA_CODE;
		        		  var phone_number = data.phones[i].PHONE_NUMBER;
		        		  var phone_number_intl = data.phones[i].PHONE_NUMBER_INTL;
		        		  var phone_sequence_no = data.phones[i].PHONE_SEQUENCE_NO;
		        		  var contact_name = data.phones[i].Pref_Name;
		        		  if(phone_number_intl.length > 0){
		        			  var alert_phone_number = phone_number_intl;
		        		  }else{
		        			  var alert_phone_number = '' + phone_area_code + phone_number;
		        		  }
		        		  if($.inArray(alert_phone_number,checked_phone_numbers) == -1){
		        			  var newAlertNumber = '<li class="list-unstyled NON-STUDENT-EP-NUMBER alert_phone_number"><input type="checkbox" value="' + alert_phone_number + '" name="fields[25]">&nbsp;' + alert_phone_number + '&nbsp;(' + contact_name + ')</li>';
			      			}else{
			      				var newAlertNumber = '<li class="list-unstyled NON-STUDENT-EP-NUMBER alert_phone_number"><input type="checkbox" checked="checked" value="' + alert_phone_number + '" name="fields[25]">&nbsp;' + alert_phone_number + '&nbsp;(' + contact_name + ')</li>';
			      			}
		      			  $('#CAMPUS_ALERT_NUMBERS').append(newAlertNumber);   
		      			
	        		  }
	        	  }		        		  
	           },
	           error: function (request, status, error) {
	               
	           }
		 });		 
	}
 
	
 </script>

</body>
</html>
