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
      var panelList = $('#draggablePanelList');

      panelList.sortable({
          // Only make the .panel-heading child elements support dragging.
          // Omit this to make then entire <li>...</li> draggable.
          handle: '.panel-heading', 
          update: function() {
              $('.panel', panelList).each(function(index, elem) {
                   var $listItem = $(elem),
                       newIndex = $listItem.index();

                   // Persist the new indices. 
              }); 
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
    #draggablePanelList .panel-heading {
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
  </style>
</head>
<body>

<div class="container">
  <h2>Update Your Contact Information</h2>
  <p>Please enter your personal, parent/guardian and emergency contact information below.</p> 
  <form class="form-horizontal" role="form" id="STUDENT" onsubmit="return formValidate(this.id)"> 
 
  <div id="step1" class="form_section">
	<h3>Step 1 Verify Your Permanent Mailing Address</h3>
	<p>Please <strong>do not</strong> enter your local or campus address. </p>

	<p><span class="required">* </span>Required Field</p>  
		
	<div class="form-group" id="group_student_firstname">
		<label for="country" class="control-label col-sm-3">(Preferred) First Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="First Name" name="fields[1]" class="form-control" id="STUDENT_PREF_FIRST_NAME" value="${StudentBio['PREFERRED_FIRST_NAME']}">
		</div>
	</div>
	<div class="form-group" id="group_student_middle_name">
		<label for="country" class="control-label col-sm-3">(Preferred) Middle Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="Middle Name" name="fields[2]" class="form-control" id="STUDENT_PREF_MIDDLE_NAME" value="${StudentBio['PREFERRED_MIDDLE_NAME']}">
		</div>
	</div>
	<div class="form-group" id="group_student_last_name">
		<label for="country" class="control-label col-sm-3">(Preferred) Last Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="Last Name" name="fields[3]" class="form-control" id="STUDENT_PREF_LAST_NAME" value="${StudentBio['PREFERRED_LAST_NAME']}">
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address1">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>Address 1</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 1" name="fields[4]" class="form-control ccreq address_field" id="STUDENT_ADDR_STREET_LINE1" value="${StudentAddr['ADDR_STREET_LINE1']}">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address2">
		<label for="country" class="control-label col-sm-3">Address 2</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 2" name="fields[5]" class="form-control address_field" id="STUDENT_ADDR_STREET_LINE2" value="${StudentAddr['ADDR_STREET_LINE2']}">
		</div>
	</div>  
		<%
			/*out.print(displayInput(false,"","First Name",2,10,"student_first_name","text","",true,true));
			out.print(displayInput(false,"","Middle Name",2,10,"student_middle_name","text","",true,true));
			out.print(displayInput(false,"","Last Name",2,10,"student_last_name","text","",true,true));
			out.print(displayInput(true,"address_field","Address 1",2,10,"student_address1","text","",true,false));
			out.print(displayInput(false,"address_field","Address 2",2,10,"student_address2","text","",true,false));*/
	%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_country">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>Country</label>
		<div class="col-sm-9">
			<select class="form-control address_field ccreq country_field" placeholder="Country" name="fields[6]" id="STUDENT_ADDR_NATN_CODE">
				<option value="">Choose Country </option>
				<c:forEach items="${options['Countries']}" var="countries">
					<option <c:if test="${countries.key == StudentAddr['ADDR_NATN_CODE'] || ((countries.key == 'US') && (StudentAddr['ADDR_NATN_CODE'] == null))}">selected="selected"</c:if> value="${countries.key}">${countries.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_CITY_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_city">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>City</label>
		<div class="col-sm-9">
				<input type="text" placeholder="City" name="fields[7]" class="form-control ccreq address_field" id="STUDENT_ADDR_CITY" value="${StudentAddr['ADDR_CITY']}">
		</div>
	</div>  
	
	<% 
			/*out.print(displayInput(true,"address_field","City",2,10,"student_city","city","",true,false));*/
	%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_ADDR_STAT_CODE">
		<label for="state" class="control-label col-sm-3"><span class="required">* </span>State</label>
		<div class="col-sm-9">
			<select class="form-control address_field ccreq" placeholder="State" name="fields[8]" id="STUDENT_ADDR_STAT_CODE">
				<option value="">Choose State</option>
				<c:forEach items="${options['States']}" var="states">
					<option <c:if test="${states.key == StudentAddr['ADDR_STAT_CODE']}">selected="selected"</c:if> value="${states.key}">${states.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" class="form-group" id="GROUP_STUDENT_INTL_REGION">
		<label for="state" class="control-label col-sm-3"><span class="required">* </span>Province/Region</label>
		<div class="col-sm-9">
			<input type="text" placeholder="Province/Region" name="fields[9]" class="form-control address_field" id="STUDENT_ADDR_STAT_CODE" value="${StudentAddr['ADDR_STAT_CODE']}">
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_ADDR_ZIP_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_postal_code">
		<label for="Postal Code" class="control-label col-sm-3 address_field"><span class="required">* </span>Zip/Postal Code</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Postal Code" name="fields[10]" class="form-control ccreq address_field" id="STUDENT_ADDR_ZIP" value="${StudentAddr['ADDR_ZIP']}">
		</div>
	</div> 
	
	<div id='STUDENT_CLNADDR_RESULTS' name='STUDENT_CLNADDR_RESULTS'></div>
	<div id="suggestionListDiv" style="display: none;"></div>
	<div class="form-group" id="group_student_home_phone">
		<label for="Phone" class="control-label col-sm-3">Home Phone</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Home Phone" name="fields[11]" class="form-control" id="STUDENT_PHONE" value="(${StudentHomePhone['PHONE_AREA_CODE']}) ${StudentHomePhone['PHONE_NUMBER']}">
		</div>
	</div> 
	<div class="form-group" id="group_student_non_college_email">
		<label for="Email" class="control-label col-sm-3">Non-college email</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Non-college email" name="fields[12]" class="form-control" id="STUDENT_EMAIL_ADDRESS" value="${StudentEmail['EMAIL_ADDRESS']}">
		</div>
	</div> 
	
	<%
			/*out.print(displayInput(true,"address_field","Postal Code",2,10,"student_postal_code","postal code","",true,false));
			out.print("<div id='student_clnaddr_results' name='student_clnaddr_results'></div>");
			out.print(displayInput(false,"","Home Phone",2,10,"student_home_phone","tel","",true,false));
			out.print(displayInput(false,"","Non-college email",2,10,"student_non_college_email","email","",true,false));*/			
		%>   	
	</div>
	<div id="step2" class="form_section">
	<h3>Step 2 Your Emergency Phone Number</h3>
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_PHONE_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_PHONE_0_NUMBER">
		<label for="Phone" class="control-label col-sm-3 ccreq"><span class="required">* </span>Mobile Phone</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Mobile Phone" name="fields[13]" class="form-control ccreq" id="STUDENT_PHONE_NUMBER" value="(${StudentCellPhone['PHONE_AREA_CODE']}) ${StudentCellPhone['PHONE_NUMBER']}">
		</div>
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
					<option value="${carriers.key}" <c:if test="${StudentCellPhone['CELL_PHONE_CARRIER'] == carriers.value }">selected="selected"</c:if>>${carriers.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="form-group" id="group_student_mobile_phone_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" name="fields[15]" class="mobile_phone_check" data-mobile-type="STUDENT" <c:if test="${StudentCellPhone['EMERG_NO_CELL_PHONE'] == 'Y'}"> checked="checked"</c:if>>I don't have a mobile phone</label>
			</div>
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="STUDENT_EMERGENCY_PHONE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="GROUP_STUDENT_EMERGENCY_PHONE" style="display:none;">
		<label for="Phone" class="control-label col-sm-3 address_field"><span class="required">* </span>Emergency Phone</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Emergency Phone" name="fields[16]" class="form-control address_field" id="STUDENT_EMERGENCY_PHONE" value="${StudentEmrPhone['PHONE_NUMBER'] }">
		</div>
	</div> 
	
	<p class="q_check" id="paragraph_alert_text_check">Connecticut College will contact this number in the case of a campus emergency. Do you wish to also receive a text message at this number in the case of a campus emergency?</p>
	<div class="form-group" id="group_alert_text_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="fields[17]" id="alert_text_check" <c:if test="${StudentCellPhone['EMERG_SEND_TEXT'] == 'Y'}">checked="checked"</c:if>>Yes send me a text message in the event of an emergency</label>
			</div>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="tty_device_check_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<p class="q_check" id="paragraph_tty_device_check">If your mobile phone is a TTY device (for the hearing impaired) please indicate below:</p>
	<div class="form-group" id="group_tty_device_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="fields[18]" id="tty_device_check" <c:if test="${StudentCellPhone['PHONE_TTY_DEVICE'] == 'Y'}">checked="checked"</c:if>>This phone is a TTY device</label>
			</div>
		</div>
	</div>
	<p class="q_check" id="paragraph_alert_home_email_check">If you do not wish to receive campus alerts beyond those to your campus email and voice mail, check the box below:</p>
	<div style="display:none;" role="alert" class="alert alert-danger" id="alert_home_email_check_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_alert_home_email_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="fields[19]" id="alert_home_email_check" <c:if test="${StudentCellPhone['EMERG_AUTO_OPT_OUT'] == 'Y'}">checked="checked"</c:if>>Opt out of automated campus alerts to my home email and cell phone</label>
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
	    <p id="doc_message">Please list <strong>all</strong> parent/guardian contacts below. You are required to designate at least one parent or guardian as an emergency contact. Exceptions to this policy must be approved by the Dean of the College doc@conncoll.edu.</p>
	    <p id="doc_opt_out_message" style="display:none;">You are not required to include a parent or guardian as an emergency contact. You are required to have at least one emergency contact, which you can add in the additional emergency contacts section below.</p>	   
	
 	<c:forEach items="${StudentParents}" var="parents">
		<div class="panel panel-default">
		  <div class="panel-body">
		    <strong>${parents.PARENT_PREF_FIRST_NAME } &nbsp; ${parents.PARENT_PREF_LAST_NAME } </strong><a href="#" title="Edit" class="popModal" data-ppid="${parents.PARENT_PPID}" data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#DELETE_MODAL" data-person-name="${parents.PARENT_PREF_FIRST_NAME } &nbsp; ${parents.PARENT_PREF_LAST_NAME }" data-person-id="1"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a><span class="emergency_contact_switch">&nbsp;Emergency Contact: <input type="checkbox" name="parent" checked="checked" class="bootstrap-switch" data-off-text="No" data-on-text="Yes"></span>
		  </div>
		</div>
	</c:forEach>	

	    
	     <div class="form-group">        
	      <div class="col-sm-offset-1 col-sm-9">
	        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#PARENT_MODAL" data-parent-ppid="0">Add Parent</button>
	      </div>
	    </div>  
    </div>
   
    <div id="step4" class="form_section">
	    <h3>Step 4 Emergency Contacts</h3>
	    <p id="doc_message">You must have at least one emergency contact. Emergency contacts will be contacted in the order you specify below. Parent/Guardian contacts designated as Emergency Contacts above will appear automatically below. You may also add additional contacts.<br><strong>If Connecticut College is a long way from home, and there is someone who can be contacted nearby in the event of an emergency, please add that person as one of your contacts.</strong></p>
		<ul id="draggablePanelList" class="list-unstyled">
			<c:forEach items="${StudentEMR}" var="emr">
				<li class="panel panel-info"> 
		        	<div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div>
		        	<div class="panel-body"><strong>${emr.EMERG_PREF_FIRST_NAME}  ${emr.EMERG_PREF_LAST_NAME}</strong> &nbsp; <a href="#" title="Edit"  class="popModal" data-ppid="${emr.PARENT_PPID}" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#delete_modal" data-person-name="${emr.EMERG_PREF_FIRST_NAME}  ${emr.EMERG_PREF_LAST_NAME}" data-person-id="1"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div>
		    	</li>
			</c:forEach>
		</ul>
		
		<!-- Bootstrap 3 panel list. -->
		<%--<ul id="draggablePanelList" class="list-unstyled">
		    <li class="panel panel-info"> 
		        <div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div>
		        <div class="panel-body">Bob Smith &nbsp; <a href="#" title="Edit" data-toggle="modal" data-target="#EMERGENCY_CONTACT_MODAL"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#DELETE_MODAL" data-person-name="Bob Smith" data-person-id="1"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div>
		    </li>
		    <li class="panel panel-info">
		        <div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div>
		        <div class="panel-body">John Jones &nbsp; <a href="#" title="Edit" data-toggle="modal" data-target="#EMERGENCY_CONTACT_MODAL"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#DELETE_MODAL" data-person-name="John Jones" data-person-id="2"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div>
		    </li>
		</ul> --%>
	    
	     <div class="form-group">        
	      <div class="col-sm-offset-1 col-sm-9">
	        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#CONTACT_MODAL">Add Contact</button>
	      </div>
	    </div>
    </div>
    <div id="step5" class="form_section">
	    <h3>Step 5 Campus Alert Phone Numbers</h3>
	    <p id="doc_message">Please choose up to five phone numbers to be contacted in the case of a campus emergency (your mobile phone will always be contacted).</p>
	    

	</div>
	
	<div>	   
	     <div class="form-group">        
	      <div class="col-sm-offset-5 col-sm-9">
	        <button type="submit" class="btn btn-primary">Submit</button>
	      </div>
	    </div>  
	</div>      	

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
		  	<form class="form-horizontal" role="form" id="<c:out value="${modalType}"/>" onsubmit="return formValidate(this.id);return false;">
		  	<input type="hidden" name="<c:out value="${modalType}"/>_STUDENT_PIDM" id="<c:out value="${modalType}"/>_STUDENT_PIDM" value="">
		  	<input type="hidden" name="<c:out value="${modalType}"/>_PARENT_PPID" id="<c:out value="${modalType}"/>_PARENT_PPID" value="">
			  	<div class="modal-header">
			  		<button type="button" class="close" data-dismiss="modal">&times;</button>

			  		<h4 class="modal-title">Enter <c:out value="${modalType == 'PARENT' ? 'Parent' : 'Contact'}" /> Information</h4>
			  	</div>
			  	<div class="modal-body">	
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
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div class="form-group" id="GROUP_PHONE_CP_NUMBER">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-2">
		  					<input type="tel" placeholder="Area Code" name="PHONE_CP_AREA_CODE" size="3" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_CP_AREA_CODE">
		  				</div>
		  				<div class="col-sm-4">
		  					<input type="tel" placeholder="Mobile Phone Number" name="PHONE_CP_NUMBER" size="7" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_CP_NUMBER">
		  					<input type="hidden" name="PHONE_CP_SEQUENCE_NO" id="PHONE_CP_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  				<input type="hidden" name="PHONE_CP_CODE" id="PHONE_CP_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value=""> 
		  				</div>
		  			</div>
		  			
		  			<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_CP_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group" id="GROUP_PHONE_CP_INTL_NUMBER">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-6">
		  					<input type="tel" placeholder="International Number" name="PHONE_CP_NUMBER_INTL" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_CP_NUMBER_INTL">
		  				</div>
		  			</div>
		  			
		  			<div class="form-group" id="group_<c:out value="${modalType}"/>_intl_phone_switch">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-id="CP"  class="intl_number_switch col-sm-4" data-id="2">Enter International Number</a>							
					</div>
		  			
		  			<div style="display:none;" role="alert" class="alert alert-danger" id="PHONE_CP_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_PHONE_CP_CARRIER">
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
					
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_EMERG_NO_CELL_PHONE"><div class="col-sm-offset-1 col-sm-9"><div class="checkbox"><label><input type="checkbox" name="EMERG_NO_CELL_PHONE" id="EMERG_NO_CELL_PHONE" class="mobile_phone_check <c:out value="${modalType}"/>_DEMO_FIELD" data-mobile-type="<c:out value="${modalType}"/>">This person does not have a mobile phone</label></div></div></div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_EMERGENCY_PHONE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_EMERGENCY_PHONE" style="display:none;">
						<label for="Phone" class="control-label col-sm-4 address_field"><span class="required">* </span>Emergency Phone</label>
						<div class="col-sm-6">
								<input type="text" placeholder="Emergency Phone" name="EMERGENCY_PHONE" class="form-control address_field  <c:out value="${modalType}"/>_PHONE_FIELD" id="EMERGENCY_PHONE" value="">
						</div>
					</div>
										
					<div role="alert" style="display:none;" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_PHONE_MA_NUMBER">
						<label for="tel" class="control-label col-sm-4">Home Phone</label>
						<div class="col-sm-2">
		  					<input type="tel" placeholder="Area Code" name="PHONE_MA_AREA_CODE" size="3" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_MA_AREA_CODE">
		  				</div>
		  				<div class="col-sm-4">
		  					<input type="tel" placeholder="Mobile Phone Number" name="PHONE_MA_NUMBER" size="7" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_MA_NUMBER">
		  					<input type="hidden" name="PHONE_MA_SEQUENCE_NO" id="PHONE_MA_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  				<input type="hidden" name="PHONE_MA_CODE" id="PHONE_MA_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value=""> 
		  				</div>
					</div>	
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_MA_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group" id="GROUP_PHONE_MA_INTL_NUMBER">
		  				<label for="tel" class="control-label col-sm-4">Home Phone</label>
		  				<div class="col-sm-6">
		  					<input type="tel" placeholder="International Number" name="PHONE_MA_NUMBER_INTL" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_MA_NUMBER_INTL">
		  				</div>
		  			</div>	
		  			
		  			<div class="form-group" id="group_<c:out value="${modalType}"/>_intl_phone_switch">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-id="MA" class="intl_number_switch col-sm-4" data-id="2">Enter International Number</a>							
					</div>		
																					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_PHONE_BU_NUMBER" >
						<label for="tel" class="control-label col-sm-4">Office Phone</label>
						<div class="col-sm-2">
		  					<input type="tel" placeholder="Area Code" name="PHONE_BU_AREA_CODE" size="3" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_BU_AREA_CODE">
		  				</div>
		  				<div class="col-sm-4">
		  					<input type="tel" placeholder="Mobile Phone Number" name="PHONE_BU_NUMBER" size="7" class="form-control ccreq <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_BU_NUMBER">
		  					<input type="hidden" name="PHONE_BU_SEQUENCE_NO" id="PHONE_BU_SEQUENCE_NO" class=" <c:out value="${modalType}"/>_PHONE_FIELD" value="">
			  				<input type="hidden" name="PHONE_BU_CODE" id="PHONE_BU_CODE" class="<c:out value="${modalType}"/>_PHONE_FIELD" value=""> 
		  				</div>
					</div>	
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_PHONE_BU_NUMBER_INTL_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclaBUtion-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>			  		
			  		<div style="display:none;" class="form-group" id="GROUP_PHONE_BU_INTL_NUMBER">
		  				<label for="tel" class="control-label col-sm-4">Office Phone</label>
		  				<div class="col-sm-6">
		  					<input type="tel" placeholder="International Number" name="PHONE_BU_NUMBER_INTL" size="7" class="form-control <c:out value="${modalType}"/>_PHONE_FIELD" id="PHONE_BU_NUMBER_INTL">
		  				</div>
		  			</div>		
		  			
		  			<div class="form-group" id="group_<c:out value="${modalType}"/>_intl_phone_switch">
							<label class="col-sm-5"></label><span style="cursor:pointer;color: #23527c;text-decoration: underline;" data-id="BU"  class="intl_number_switch col-sm-4" data-id="2">Enter International Number</a>							
					</div>						
										 						
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_EMAIL_ADDRESS_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_EMAIL_ADDRESS">
						<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
						<div class="col-sm-6">
							<input type="hidden" name="PECI_EMAIL_CODE" id="PECI_EMAIL_CODE" value="" class="<c:out value="${modalType}"/>_EMAIL_FIELD">
							<input type="email" placeholder="Preferred Email" name="EMAIL_ADDRESS" class="form-control  ccreq <c:out value="${modalType}"/>_EMAIL_FIELD" id="EMAIL_ADDRESS">
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
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STREET_LINE1">
						<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address 1</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 1" name="ADDR_STREET_LINE1" class="form-control ccreq address_field  <c:out value="${modalType}"/>_ADDRESS_FIELD" id="ADDR_STREET_LINE1">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STREET_LINE2">
						<label for="text" class="control-label col-sm-4">Address 2</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 2" name="ADDR_STREET_LINE2" class="form-control address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="ADDR_STREET_LINE2">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_NATN_CODE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
						<div class="col-sm-6">
							<select class="form-control ccreq address_field country_field <c:out value="${modalType}"/>_ADDRESS_FIELD" placeholder="Country" name="ADDR_NATN_CODE" id="ADDR_NATN_CODE">
								<option value="">Choose Country</option>
								<c:forEach items="${options['Countries']}" var="countries">
									<option value="${countries.key}">${countries.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_CITY_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_CITY">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>City</label>
						<div class="col-sm-6">
							<input type="text" placeholder="City" name="ADDR_CITY" class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="ADDR_CITY">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_STAT_CODE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>State</label>
						<div class="col-sm-6">
							<select class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" placeholder="State" name="ADDR_STAT_CODE" id="ADDR_STAT_CODE">
								<option value="">Choose State</option>
								<c:forEach items="${options['States']}" var="states">
									<option value="${states.key}">${states.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div style="display:none;" class="form-group" id="GROUP_<c:out value="${modalType}"/>_INTL_REGION">
						<label for="state" class="control-label col-sm-4"><span class="required">* </span>Province/Region</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Province/Region" name="ADDR_STAT_CODE" class="form-control address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="ADDR_STAT_CODE">
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_ADDR_ZIP_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_ADDR_ZIP">
						<label for="Postal Code" class="control-label col-sm-4"><span class="required">* </span>Zip/Postal Code</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Zip/Postal Code" name="ADDR_ZIP" class="form-control ccreq address_field <c:out value="${modalType}"/>_ADDRESS_FIELD" id="ADDR_ZIP">
						</div>
					</div>
					
					
					<div id='<c:out value="${modalType}"/>_CLNADDR_RESULTS' name='<c:out value="${modalType}"/>_CLNADDR_RESULTS'></div>
					
					
						<div style="display:none;" role="alert" class="alert alert-danger" id="DEPENDENT_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_<c:out value="${modalType}"/>_DEPENDENT_CHECK">
							<div class="col-sm-offset-1 col-sm-10">
								<div class="checkbox">
									<label><span class="emergency_contact_switch">&nbsp;<input type="checkbox" name="DEPENDENT" checked="checked" class="bootstrap-switch <c:out value="${modalType}"/>_DEMO_FIELD" ID="DEPENDENT" data-off-text="No" data-on-text="Yes"></span> This parent claims me as a dependent</label>
							
							<a data-content="Please indicate whether your parents claim you as a tax dependent for federal income tax purposes. This is turned on by default. &lt;a href='http://www.conncoll.edu/academics/registrar/ferpa/' target='_blank'&gt; FERPA Information&lt;/a&gt;." data-placement="top" data-title="U.S. Tax Dependence Status Info" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title=""></a>
								</div>
							</div>
						</div>	
					
					
									  		
			  		<div class="form-group">
  						<div class="col-sm-offset-5 col-sm-9">
  							<button type="submit" class="btn btn-primary">Save</button>
  						</div>
  					</div>  				
  				</div>
 				</form>
 			</div>
 			<div class="modal-footer">
 				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
 			</div>
 		</div>
 	</div>
</c:forTokens>
 	
  	
<%
	/*out.print(displayEntryModal("parent","Enter Details","Save"));
	out.print(displayEntryModal("emergency_contact","Enter Details","Save"));
	out.print(displayDeleteModal("delete","Confirm Deletion","Yes, Delete"));*/

%>


 <script type="text/javascript" src="/clnaddr/js/clnaddr.js?version=10100"></script>   

 <script type="text/javascript">
 

 
 $(document).ready( function(){
	 
	 ajaxurl = "/cas/cas-rest-api/peci/";
	 
	 $("[data-toggle=popover]").popover();
	 $("[data-toggle=tooltip]").tooltip();
 
	$(".mobile_phone_check").change(function(){
		$thisType = $(this).attr("data-mobile-type");
		if(this.checked) {
			$("#GROUP_" + $thisType + "_EMERGENCY_PHONE").show();
			$("#" + $thisType + "_emergency_phone").addClass("ccreq");
			//remove error if it is already displaying
			$("#" + $thisType + "_mobile_phone_error").hide();
			$("#group_" + $thisType + "_mobile_phone").removeClass("has-error");
			//remove requirement for mobile phone
			$("#GROUP_" + $thisType + "_PHONE_0_NUMBER .required").hide();				
			$("#" + $thisType + "_mobile_phone").removeClass("ccreq");
			//remove requirement for phone carrier
			$("#group_" + $thisType + "_phone_carrier .required").hide();	
			$("#" + $thisType + "_phone_carrier").removeClass("ccreq");
			if($thisType == 'student'){
				//remove text alerts checkbox
				$("#paragraph_alert_text_check").hide();
				$("#group_alert_text_check").hide();	
				$("#paragraph_tty_device_check").html('If your emergency phone is a TTY device (for the hearing impaired) please indicate below:');
			}
	    }else{
	    	$("#GROUP_" + $thisType + "_EMERGENCY_PHONE").hide();	
	    	$("#" + $thisType + "_emergency_phone").removeClass("ccreq");
	    	//add requirement for mobile phone
	    	$("#GROUP_" + $thisType + "_PHONE_0_NUMBER .required").show();	
	    	$("#" + $thisType + "_mobile_phone").addClass("ccreq");
	    	//add requirement for phone carrier
			$("#group_" + $thisType + "_phone_carrier .required").show();	
			$("#" + $thisType + "_phone_carrier").addClass("ccreq");
			if($thisType == 'student'){
				//show text alerts checkbox
				$("#paragraph_alert_text_check").show();
				$("#group_alert_text_check").show();	
				$("#paragraph_tty_device_check").html('If your mobile phone is a TTY device (for the hearing impaired) please indicate below:');
			}
	    }		
	}); 
	
	//add phone
	$('.intl_number_switch').click(function (){		
		var form_id = $(this).closest('form').attr("id");
		var phone_type = $(this).attr("data-id");
		var intl_group = 'form#' + form_id + ' #GROUP_PHONE_' + phone_type + '_INTL_NUMBER';
		console.log(intl_group);
		var phone_group = 'form#' + form_id + ' #GROUP_PHONE_' + phone_type + '_NUMBER';		
		if($(intl_group).css('display') == 'none'){
			$(phone_group).hide();		
			//show international number
			$(intl_group).show();
			if(phone_type == 'CP'){
				//change required fields
				$(intl_group + ' #PHONE_' + phone_type + '_NUMBER_INTL').removeClass("ccreq");
				$(phone_group + ' #PHONE_' + phone_type + '_NUMBER').addClass("ccreq");
			}
			//change text of link
			$(this).html('Enter U.S. Number');
		}else{
			$(phone_group).show();			
			$(intl_group).hide();
			if(phone_type = 'CP'){
				$(phone_group + ' #PHONE_' + phone_type + '_NUMBER_INTL').removeClass("ccreq");
				$(intl_group + ' #PHONE_' + phone_type + '_NUMBER').addClass("ccreq");
			}
 			$(this).html('Enter International Number');
		}		

	});
	
	//state/province drop-down toggle based on country chosen
	$('.country_field').change(function(){
		$form_id = $(this).closest('form').attr("id");
		$intlField = '#GROUP_' + $form_id + '_INTL_REGION';
		$stateField = '#GROUP_' + $form_id + '_ADDR_STAT_CODE';
		if($(this).val() == 'United States' || $(this).val() == "US"){
			$($stateField).show();
			$($intlField).hide();
		}else{
			$($stateField).hide();
			$($intlField).show();
		}
		
	});
	
	//triggered when modal is about to be shown
	$('#DELETE_MODAL').on('show.bs.modal', function(e) {

	    //get data-id attribute of the clicked element
	    var person_name = $(e.relatedTarget).data('person-name');
	    var person_id = $(e.relatedTarget).data('person-id');

	    //populate the textbox
	    $(e.currentTarget).find('.name_block').html(person_name);
	    $(e.currentTarget).find('input[name="person_id"]').val(person_id);
	});
	
	$('#PARENT_MODAL, #CONTACT_MODAL, #DELETE_MODAL').on('hidden.bs.modal', function () {
		//on modal close, hide all modal error messages
	    $('#PARENT_MODAL .alert-danger, #CONTACT_MODAL .alert-danger, #DELETE_MODAL .alert-danger').hide();
		$('#PARENT_MODAL .form-group, #CONTACT_MODAL .form-group, #DELETE_MODAL .form-group').removeClass('has-error');
	});
	
	$('.popModal').click(function() {		
		modal_type = $(this).attr("data-modal-type");
		student_PIDM = ${StudentBio['STUDENT_PIDM']};
		PPID = $(this).attr("data-ppid");		
		$.ajax({
           type: "POST",
           url: ajaxurl,
           data: JSON.stringify({"PIDM": student_PIDM, "PPID": PPID, "DATA": modal_type, "MODE": "READ"}),
           datatype: "json",
           contentType: "application/json",
           success: function(data)           
           {   
        	  $('#' + modal_type + '_STUDENT_PPID').val();
        	  $('#' + modal_type + '_STUDENT_PIDM').val(student_PIDM);
        	  $('#' + modal_type + '_PARENT_PPID').val(PPID);
        	  $('#' + modal_type + '_PARENT_PIDM').val();
        	  if(modal_type == 'PARENT'){
	        	  $.each(data.parent, function(index, element){	       
	        		  $('form#' + modal_type + ' #' + index).val(element);
	        		  
	        	   	//$('#' + index).val(element);
	        	  });
        	  }else{
        		  $.each(data.contact, function(index, element){  	 
        			  $('form#' + modal_type + ' #' + index).val(element);
  	        	   	//$('#' + index).val(element);
  	        	  });
        	  }

        	  $.each(data.email, function(index,element){        
        		 $('form#' + modal_type + ' #' + index).val(element);
        	  	 //$('#' + modal_type + "_" + index).val(element); 	
        	  });

        	  $.each(data.address, function(index,element){        		 
        		  if(index == 'ADDR_NATN_CODE' && element == null){
        			  $('form#' + modal_type + ' #' + index).val('US');
        			//$('#' + modal_type + "_" + index).val('US');
        		  }else{
        			  $('form#' + modal_type + ' #' + index).val(element);
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
        		  $('form#' + modal_type + ' #PHONE_' + phone_code + '_CODE').val(phone_code);
        		  $('form#' + modal_type + ' #PHONE_' + phone_code + '_AREA_CODE').val(phone_area_code);
        		  if(phone_number_intl != "" && phone_number_intl != null){
        			  console.log(phone_number_intl);
        			  $('form#' + modal_type + ' #GROUP_PHONE_' + phone_code + '_NUMBER').hide();
        			  $('form#' + modal_type + ' #PHONE_' + phone_code + '_NUMBER_INTL').val(phone_number_intl);
        			  $('form#' + modal_type + ' #GROUP_PHONE_' + phone_code + '_NUMBER_INTL').show();        			  
        		  }else{
        			  $('form#' + modal_type + ' #GROUP_PHONE_' + phone_code + '_NUMBER_INTL').hide();
        			  $('form#' + modal_type + ' #PHONE_' + phone_code + '_NUMBER').val(phone_number);
        			  $('form#' + modal_type + ' #GROUP_PHONE_' + phone_code + '_NUMBER').show();        			 
        		  }       		  
        		  
        		  $('form#' + modal_type + ' #PHONE_' + phone_code + '_SEQUENCE_NO').val(phone_sequence_no);
        		  $('form#' + modal_type + ' #PHONE_' + phone_code + '_CARRIER').val(phone_carrier);    
        	  }
        	  
        	  /*$.each(data.phones, function(index1,element1){
        		  //console.log("modaltype:" + modal_type);
        		  //console.log('#GROUP_' + modal_type + '_PHONE' + index1 + '_SECTION');
        		  $('#GROUP_' + modal_type + '_PHONE' + index1 + '_SECTION').show();       
        		  //console.log("index1: " + index1['PHONE_CODE']);
        		  //console.log("element1: " + element1);
        		  $.each(this, function(index2,element2){     
        			  //console.log("index2: " + index2 + " element2: " + element2);
            		  if(index2 == 'PHONE_CODE'){
            			  //console.log('form#' + modal_type + ' input[name="PHONE_' + index1 + '_TYPE"]' + " element2: " + element2);
            			  $('form#' + modal_type + ' #PHONE_' + index1 + '_CODE').val(element2);
            			  //$('#' + modal_type + '_PHONE_' + index1 + '_TYPE').val(element2);         			  
            		  }else if(index2 == 'PHONE_AREA_CODE'){
            			  $('form#' + modal_type + ' #PHONE_' + index1 + '_NUMBER').val(element2);
            			  //$('#' + modal_type + '_PHONE_' + index1 + '_NUMBER').val(element2);
            		  }else if(index2 == 'PHONE_NUMBER'){
            			  $('form#' + modal_type + ' #PHONE_' + index1 + '_NUMBER').val($('form#' + modal_type + ' #PHONE_' + index1 + '_NUMBER').val() + element2);
            			  //$('#' + modal_type + '_PHONE_' + index1 + '_NUMBER').val($('#' + modal_type + '_PHONE_' + index1 + '_NUMBER').val() + element2);
            		  }else if(index2 == 'PHONE_SEQUENCE_NO'){
               			  $('form#' + modal_type + ' #PHONE_' + index1 + '_SEQUENCE_NO').val(element2);
            		  }		
        			  //console.log("4 peci phone code" +  element2);        			  
        		  });        		 
          	  	//$('#' + $modal_type + "_" + index).val(element); 		   
          	  });*/
           },
           error: function (request, status, error) {
               console.log("ERROR: " + request.responseText);
           }
	    });		    
		
		$('#' + modal_type + "_MODAL").modal('show');
	});
	

 
	 $('#CONTACT_MODAL').on('hidden.bs.modal', function () {
		 document.getElementById("CONTACT").reset();
	 });
	 
	 $('#PARENT_MODAL').on('hidden.bs.modal', function () {
		 document.getElementById("PARENT").reset();
	 });
 
 });
 
 function formValidate(form_id) { 
	 showMainError = 0;
	 //required fields
	 $("#" + form_id + " .ccreq").each(function(){
		 var field_value = $(this).val();
		 var field_id = $(this).attr("id");
		 var field_type = $(this).attr("type");
		 var field_label = $(this).attr("placeholder");
		 if(field_value.length == 0){
			 $("#" + field_id + "_ERROR" + " .custom-error").html('Please Enter ' + field_label);	
			 $("#" + field_id + "_ERROR").show();		
			 $("#group_" + field_id).addClass("has-error");
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
			 $("#" + field_id + "_error" + " .custom-error").html('The ' + field_label + ' you entered is invalid. Please enter a valid ' + field_label);	
			 $("#" + field_id + "_error").show();		
			 $("#group_" + field_id).addClass("has-error");
			 showMainError = 1;
		 }else{
			 
		 }
	 });
	/* $("#" + form_id + " input[type=tel]").each(function(){
		 var field_value = $(this).val();
		 var field_name = $(this).attr("name");
		 var field_type = $(this).attr("type");
		 var field_label = $(this).attr("placeholder");
		 var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		 valid_email = regex.test(field_value);
		 if(!valid_email){
			 $("#" + field_name + "_error" + " .custom-error").html('The ' + field_label + ' you entered is invalid. Please enter a valid ' + field_label);	
			 $("#" + field_name + "_error").show();		
			 $("#group_" + field_name).addClass("has-error");
			 showMainError = 1;
		 }else{
			 
		 }
	 });*/
	 if(showMainError){
		 window.scrollTo(0,0);
		 $('#' + modal_type + '_MODAL').animate({ scrollTop: 0 }, 'fast');
		 return false;		 
	 }else{
		 //close any former error messages
		 $(".alert_danger").hide();
		 parent_ppid = $('#' + form_id + '_PARENT_PPID').val();
		 student_pidm = $('#' + form_id + '_STUDENT_PIDM').val();
		 //submit via ajax
		
		 //var formData = JSON.stringify($('#' + form_id).serializeArray());
		 formData = '{"PIDM" : "' + student_pidm + '","PPID" : "' + parent_ppid + '","DATA" : "' + form_id + '","MODE" : "WRITE",';
		 
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
					 val = $(this).val();
					 name = $(this).attr("name");
					 //console.log("val: " + val + " name: " + name + " x: " + x + "test: " + test);
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
		var phoneCodeArray = ["CP","MA","BU"];		 
		 for (var j = 0; j < phoneCodeArray.length; j++) {
			if(phoneCodeArray[j] != "CP"){
				formData = formData + "},{";
			}
			var phone_sequence_no = $('form#' + form_id + ' #PHONE_' + phoneCodeArray[j] + '_SEQUENCE_NO').val();
			var phone_area_code = $('form#' + form_id + ' #PHONE_' + phoneCodeArray[j] + '_AREA_CODE').val();
			var phone_number = $('form#' + form_id + ' #PHONE_' + phoneCodeArray[j] + '_NUMBER').val();
			var phone_carrier = $('form#' + form_id + ' #PHONE_' + phoneCodeArray[j] + '_CARRIER').val();
			var phone_code = $('form#' + form_id + ' #PHONE_' + phoneCodeArray[j] + '_CODE').val();;
			formData = formData + '"PHONE_SEQUENCE_NO" : "' + phone_sequence_no + '",';
			formData = formData + '"PHONE_AREA_CODE" : "' + phone_area_code + '",';
			formData = formData + '"PHONE_NUMBER" : "' + phone_number + '",';
			formData = formData + '"PHONE_CODE" : "' + phone_code + '",';
			if(phone_carrier == undefined){
				formData = formData + '"PHONE_CARRIER" : null';
			}else{
				formData = formData + '"PHONE_CARRIER" : "' + phone_carrier + '"';
			}
			
		 }	
		
		
		/*for (var i = 0; i < 5; i++) {
				if(i != 0){
					formData = formData + "},{";
				}
				var phone_sequence_no = $('form#' + form_id + ' #PHONE_' + i + '_SEQUENCE_NO').val();
				var phone_number = $('form#' + form_id + ' #PHONE_' + i + '_NUMBER').val();
				var phone_carrier = $('form#' + form_id + ' #PHONE_' + i + '_CARRIER').val();
				var phone_code = $('form#' + form_id + ' #PHONE_' + i + '_CODE').val();;
				formData = formData + '"PHONE_SEQUENCE_NO" : "' + phone_sequence_no + '",';
				formData = formData + '"PHONE_NUMBER" : "' + phone_number + '",';
				formData = formData + '"PHONE_CODE" : "' + phone_code + '",';
				formData = formData + '"PHONE_CARRIER" : "' + phone_carrier + '"';
		}*/
		formData = formData + "}]";		
				
		formData = formData + "}";
		 		 
		console.log(formData);
		 
		$.ajax({
	           type: "POST",
	           url: ajaxurl,
	           //data: JSON.stringify($('#' + form_id).serialize()),
	           data: formData,
	           dataType: "json",
	           contentType: "application/json",
	           success: function(data)
	           {   
	        	   console.log(data);
		           //console.log("recipientSubmitAjax: id:" + id + " formID:" + formID + " formToSubmitTo:" + formToSubmitTo);  
	              
	           },
	           error: function(e){
	        	   console.log(e);
	        	   return false;
	           }
		    });	 
		 return false;
		 
	 }	 
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
 
	
 </script>

</body>
</html>
