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
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="https://code.jquery.com/ui/1.11.3/jquery-ui.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <script src="https://www.conncoll.edu/scripts/jqueryUI/touch-punch/jquery.ui.touch-punch.min.js"></script>
  <link rel="stylesheet" href="https://www.conncoll.edu/scripts/bootstrap-switch-master/dist/css/bootstrap3/bootstrap-switch.css">
  <script src="https://www.conncoll.edu/scripts/bootstrap-switch-master/dist/js/bootstrap-switch.js"></script>  
  
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
	<div class="form-group" id="group_student_state">
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
	<div class="form-group" id="group_student_mobile_phone">
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
	<div class="form-group" id="group_student_emergency_phone" style="display:none;">
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

  
  
  <!-- Parent Modal -->
  
 <div class="modal fade" id="PARENT_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
		  	<form class="form-horizontal" role="form" id="PARENT" onsubmit="return formValidate(this.id)">
			  	<div class="modal-header">
			  		<button type="button" class="close" data-dismiss="modal">&times;</button>
			  		<h4 class="modal-title">Enter Parent Information</h4>
			  	</div>
			  	<div class="modal-body">	
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_LEGAL_PREFIX_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_parent_first_name">
			  			<label for="text" class="control-label col-sm-4">Prefix</label>
			  			<div class="col-sm-3">
			  				<input type="text" placeholder="Rev., Dr., Atty" name="fields[20]" class="form-control" id="PARENT_LEGAL_PREFIX_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PREF_FIRST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_parent_first_name">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>First Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="First Name" name="fields[21]" class="form-control  ccreq" id="PARENT_PREF_FIRST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PREF_MIDDLE_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_parent_middle_name">
			  			<label for="text" class="control-label col-sm-4">Middle Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Middle Name" name="fields[22]" class="form-control" id="PARENT_PREF_MIDDLE_NAME">
			  			</div>
			  		</div>	  	
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PREF_LAST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_parent_last_name">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>Last Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Last Name" name="fields[23]" class="form-control  ccreq " id="PARENT_PREF_LAST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_LEGAL_SUFFIX_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_parent_first_name">
			  			<label for="text" class="control-label col-sm-4">Suffix</label>
			  			<div class="col-sm-3">
			  				<input type="text" placeholder="Jr., Sr., IV" name="fields[24]" class="form-control" id="PARENT_LEGAL_SUFFIX_NAME">
			  			</div>
			  		</div>
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_0_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_parent_mobile_phone">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-6">
		  					<input type="tel" placeholder="Mobile Phone" name="fields[25]" class="form-control  ccreq  " id="PARENT_PHONE_0_NUMBER">
		  				</div>
		  			</div>
		  			<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_0_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_PARENT_PHONE_0_CARRIER">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Phone Carrier</label>
						<div class="col-sm-6">
							<select class="form-control ccreq" placeholder="Phone Carrier" name="fields[26]" id="PARENT_PHONE_0_CARRIER">
								<option value="">Choose Phone Carrier</option>
								<c:forEach items="${options['Carriers']}" var="carriers">
									<option value="${carriers.key}">${carriers.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group" id="group_parent_mobile_phone_check"><div class="col-sm-offset-1 col-sm-9"><div class="checkbox"><label><input type="checkbox" name="fields[27]" id="parent_mobile_phone_check" class="mobile_phone_check" data-mobile-type="PARENT">This person does not have a mobile phone</label></div></div></div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_EMERGENCY_PHONE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>

					<div class="form-group" id="GROUP_PARENT_EMERGENCY_PHONE" style="display:none;">
						<label for="Phone" class="control-label col-sm-4 address_field"><span class="required">* </span>Emergency Phone</label>
						<div class="col-sm-6">
								<input type="text" placeholder="Emergency Phone" name="fields[28]" class="form-control address_field" id="PARENT_EMERGENCY_PHONE" value="">
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_1_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_PARENT_PHONE_1_NUMBER">
						<label for="tel" class="control-label col-sm-4">Additional Phone</label>
						<div class="col-sm-6">
							<input type="tel" placeholder="Additional Phone" name="fields[29]" class="form-control" id="PARENT_PHONE_1_NUMBER">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_1_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_PARENT_PHONE_1_TYPE">
						<label for="" class="control-label col-sm-4">Phone Type</label>
						<div class="col-sm-6">
							<select class="form-control phone_type" placeholder="Phone Type" name="fields[30]" id="PARENT_PHONE_1_TYPE" data-id="1">
								<option value="">Choose Phone Type</option>
								<option value="C">Mobile</option>
								<option value="H">Home</option>
								<option value="O">Office</option>
							</select>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_1_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div style="display:none;" class="form-group" id="GROUP_PARENT_PHONE_1_CARRIER">
						<label for="" class="control-label col-sm-4">Phone Carrier</label>
						<div class="col-sm-6">
							<select class="form-control" placeholder="Phone Carrier" name="fields[31]" id="PARENT_PHONE_1_CARRIER">
								<option value="">Choose Phone Carrier</option>
								<c:forEach items="${options['Carriers']}" var="carriers">
									<option value="${carriers.key}">${carriers.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
																	
					<div id="GROUP_PARENT_PHONE2_SECTION" style="display:none;">
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_2_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_2_NUMBER" >
							<label for="tel" class="control-label col-sm-4">Additional Phone 2</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone 2" name="fields[32]" class="form-control" id="PARENT_PHONE_2_NUMBER">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_2_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_2_TYPE">
							<label for="" class="control-label col-sm-4">Phone 2 Type</label>
							<div class="col-sm-6">
								<select class="form-control phone_type" placeholder="Phone 2 Type" name="fields[33]" id="PARENT_PHONE_2_TYPE" data-id="2">
									<option value="">Choose Phone Type</option>
									<option value="C">Mobile</option>
									<option value="H">Home</option>
									<option value="O">Office</option>
								</select>
							</div>
						</div>							
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_2_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_2_CARRIER"r" style="display:none;">
							<label for="" class="control-label col-sm-4">Phone 2 Carrier</label>
							<div class="col-sm-6">
								<select class="form-control" placeholder="Phone 2 Carrier" name="fields[34]" id="PARENT_PHONE_2_CARRIER">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>			
					
					<div id="GROUP_PARENT_PHONE3_SECTION" style="display:none;">
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_3_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_3_NUMBER" >
							<label for="tel" class="control-label col-sm-4">Additional Phone 3</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone 3" name="fields[35]" class="form-control" id="PARENT_PHONE_3_NUMBER">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_3_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_3_TYPE">
							<label for="" class="control-label col-sm-4">Phone 3 Type</label>
							<div class="col-sm-6">
								<select class="form-control phone_type" placeholder="Phone 3 Type" name="fields[36]" id="PARENT_PHONE_3_TYPE" data-id="3">
									<option value="">Choose Phone Type</option>
									<option value="C">Mobile</option>
									<option value="H">Home</option>
									<option value="O">Office</option>
								</select>
							</div>
						</div>							
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_3_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_3_CARRIER" style="display:none;">
							<label for="" class="control-label col-sm-4">Phone 3 Carrier</label>
							<div class="col-sm-6">
								<select class="form-control" placeholder="Phone 3 Carrier" name="fields[37]" id="PARENT_PHONE_3_CARRIER">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>		
					
					<div id="GROUP_PARENT_PHONE4_SECTION" style="display:none;">
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_4_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_4_NUMBER" >
							<label for="tel" class="control-label col-sm-4">Additional Phone 4</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone 4" name="fields[38]" class="form-control" id="PARENT_PHONE_4_NUMBER">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_4_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_4_TYPE">
							<label for="" class="control-label col-sm-4">Phone 4 Type</label>
							<div class="col-sm-6">
								<select class="form-control phone_type" placeholder="Phone 4 Type" name="fields[39]" id="PARENT_PHONE_4_TYPE" data-id="4">
									<option value="">Choose Phone Type</option>
									<option value="C">Mobile</option>
									<option value="H">Home</option>
									<option value="O">Office</option>
								</select>
							</div>
						</div>							
						<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_PHONE_4_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_PARENT_PHONE_4_CARRIER" style="display:none;">
							<label for="" class="control-label col-sm-4">Phone 4 Carrier</label>
							<div class="col-sm-6">
								<select class="form-control" placeholder="Phone 4 Carrier" name="fields[40]" id="PARENT_PHONE_4_CARRIER">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>									
					
					<div class="form-group" id="GROUP_PARENT_ADD_PHONE">
						<label for="" class="control-label col-sm-4"><span style="cursor:pointer;color: #23527c;text-decoration: underline;" id="PARENT_ADD_ANOTHER_PHONE" class="addAnotherPhone" data-id="2">Add Another Phone</a></label>							
					</div>
					 						
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_EMAIL_ADDRESS_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_preferred_email">
						<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
						<div class="col-sm-6">
							<input type="email" placeholder="Preferred Email" name="fields[41]" class="form-control  ccreq" id="PARENT_EMAIL_ADDRESS">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_RELT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_relationship">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Relationship</label>
						<div class="col-sm-6">
							<select class="form-control ccreq " placeholder="Relationship" name="fields[42]" id="PARENT_RELT_CODE">
								<option value="">Choose Relationship</option>
								<c:forEach items="${options['Relationships']}" var="relationships">
									<option value="${relationships.key}">${relationships.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_address1">
						<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address 1</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 1" name="fields[43]" class="form-control  ccreq address_field " id="PARENT_ADDR_STREET_LINE1">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_address2">
						<label for="text" class="control-label col-sm-4">Address 2</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 2" name="fields[44]" class="form-control address_field " id="PARENT_ADDR_STREET_LINE2">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_country">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
						<div class="col-sm-6">
							<select class="form-control ccreq address_field country_field" placeholder="Country" name="fields[45]" id="PARENT_ADDR_NATN_CODE">
								<option value="">Choose Country</option>
								<c:forEach items="${options['Countries']}" var="countries">
									<option value="${countries.key}">${countries.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ADDR_CITY_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_city">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>City</label>
						<div class="col-sm-6">
							<input type="text" placeholder="City" name="fields[46]" class="form-control ccreq address_field" id="PARENT_ADDR_CITY">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_PARENT_STATE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>State</label>
						<div class="col-sm-6">
							<select class="form-control ccreq address_field" placeholder="State" name="fields[47]" id="PARENT_ADDR_STAT_CODE">
								<option value="">Choose State</option>
								<c:forEach items="${options['States']}" var="states">
									<option value="${states.key}">${states.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div style="display:none;" class="form-group" id="GROUP_PARENT_INTL_REGION">
						<label for="state" class="control-label col-sm-4"><span class="required">* </span>Province/Region</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Province/Region" name="fields[48]" class="form-control address_field" id="PARENT_ADDR_STAT_CODE">
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="PARENT_ADDR_ZIP_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_postal_code">
						<label for="Postal Code" class="control-label col-sm-4"><span class="required">* </span>Zip/Postal Code</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Zip/Postal Code" name="fields[49]" class="form-control ccreq address_field " id="PARENT_ADDR_ZIP">
						</div>
					</div>
					
					
					<div id='PARENT_CLNADDR_RESULTS' name='PARENT_CLNADDR_RESULTS'></div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="DEPENDENT_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_parent_dependent_check">
						<div class="col-sm-offset-1 col-sm-10">
							<div class="checkbox">
								<label><span class="emergency_contact_switch">&nbsp;<input type="checkbox" name="fields[50]" checked="checked" class="bootstrap-switch" ID="DEPENDENT" data-off-text="No" data-on-text="Yes"></span> This parent claims me as a dependent</label>
						
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
 	
 	<!-- Emergency Contact Modal -->
 	<div class="modal fade" id="CONTACT_MODAL" role="dialog">
  	<div class="modal-dialog">    
	  	<!-- Modal content-->
	  	<div class="modal-content">
		  	<form class="form-horizontal" role="form" id="CONTACT"  onsubmit="return formValidate(this.id)">
			  	<div class="modal-header">
			  		<button type="button" class="close" data-dismiss="modal">&times;</button>
			  		<h4 class="modal-title">Enter Emergency Contact Information</h4>
			  	</div>
			  	<div class="modal-body">	
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="EMERG_LEGAL_PREFIX_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_emergency_contact_first_name">
			  			<label for="text" class="control-label col-sm-4">Prefix</label>
			  			<div class="col-sm-3">
			  				<input type="text" placeholder="Rev., Dr., Atty" name="fields[51]" class="form-control" id="EMERG_LEGAL_PREFIX_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="EMERG_PREF_FIRST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_emergency_contact_first_name">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>First Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="First Name" name="fields[52]" class="form-control  ccreq" id="EMERG_PREF_FIRST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="EMERG_PREF_MIDDLE_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_emergency_contact_middle_name">
			  			<label for="text" class="control-label col-sm-4">Middle Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Middle Name" name="fields[53]" class="form-control" id="EMERG_PREF_MIDDLE_NAME">
			  			</div>
			  		</div>	  	
			  		
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="EMERG_PREF_LAST_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_emergency_contact_last_name">
			  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>Last Name</label>
			  			<div class="col-sm-6">
			  				<input type="text" placeholder="Last Name" name="fields[54]" class="form-control  ccreq " id="EMERG_PREF_LAST_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="EMERG_LEGAL_SUFFIX_NAME_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="group_emergency_contact_last_name">
			  			<label for="text" class="control-label col-sm-4">Suffix</label>
			  			<div class="col-sm-3">
			  				<input type="text" placeholder="Jr., Sr., IV" name="fields[55]" class="form-control" id="EMERG_LEGAL_SUFFIX_NAME">
			  			</div>
			  		</div>
			  		<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_0_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
			  		<div class="form-group" id="GROUP_CONTACT_PHONE_0_NUMBER">
		  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
		  				<div class="col-sm-6">
		  					<input type="tel" placeholder="Mobile Phone" name="fields[56]" class="form-control  ccreq  " id="CONTACT_PHONE_0_NUMBER">
		  				</div>
		  			</div>
		  			<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_0_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_CONTACT_PHONE_0_CARRIER">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Phone Carrier</label>
						<div class="col-sm-6">
							<select class="form-control ccreq" placeholder="Phone Carrier" name="fields[57]" id="CONTACT_PHONE_0_CARRIER">
								<option value="">Choose Phone Carrier</option>
								<c:forEach items="${options['Carriers']}" var="carriers">
									<option value="${carriers.key}">${carriers.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-group" id="group_contact_mobile_phone_check"><div class="col-sm-offset-1 col-sm-9"><div class="checkbox"><label><input type="checkbox" name="fields[58]" id="EMERG_NO_CELL_PHONE" class="mobile_phone_check" data-mobile-type="CONTACT">This person does not have a mobile phone</label></div></div></div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_EMERGENCY_PHONE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>

					<div class="form-group" id="GROUP_CONTACT_EMERGENCY_PHONE" style="display:none;">
						<label for="Phone" class="control-label col-sm-4 address_field"><span class="required">* </span>Emergency Phone</label>
						<div class="col-sm-6">
								<input type="text" placeholder="Emergency Phone" name="fields[59]" class="form-control address_field" id="CONTACT_EMERGENCY_PHONE" value="">
					</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_1_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_CONTACT_PHONE_1_NUMBER">
						<label for="tel" class="control-label col-sm-4">Additional Phone</label>
						<div class="col-sm-6">
							<input type="tel" placeholder="Additional Phone" name="fields[60]" class="form-control ccreq" id="CONTACT_PHONE_1_NUMBER">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_1_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_CONTACT_PHONE_1_TYPE">
						<label for="" class="control-label col-sm-4">Phone Type</label>
						<div class="col-sm-6">
							<select class="form-control ccreq phone_type" placeholder="Phone Type" name="fields[61]" id="CONTACT_PHONE_1_TYPE" data-id="1">
								<option value="">Choose Phone Type</option>
								<option value="C">Mobile</option>
								<option value="H">Home</option>
								<option value="O">Office</option>
							</select>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_1_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div style="display:none;" class="form-group" id="GROUP_CONTACT_PHONE_1_CARRIER">
						<label for="" class="control-label col-sm-4">Phone Carrier</label>
						<div class="col-sm-6">
							<select class="form-control ccreq" placeholder="Phone Carrier" name="fields[62]" id="CONTACT_PHONE_1_CARRIER">
								<option value="">Choose Phone Carrier</option>
								<c:forEach items="${options['Carriers']}" var="carriers">
									<option value="${carriers.key}">${carriers.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
																	
					<div id="GROUP_CONTACT_PHONE2_SECTION" style="display:none;">
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_2_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_2_NUMBER" >
							<label for="tel" class="control-label col-sm-4">Additional Phone 2</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone 2" name="fields[63]" class="form-control" id="CONTACT_PHONE_2_NUMBER">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_2_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_2_TYPE">
							<label for="" class="control-label col-sm-4">Phone 2 Type</label>
							<div class="col-sm-6">
								<select class="form-control ccreq phone_type" placeholder="Phone 2 Type" name="fields[64]" id="CONTACT_PHONE_2_TYPE" data-id="2">
									<option value="">Choose Phone Type</option>
									<option value="C">Mobile</option>
									<option value="H">Home</option>
									<option value="O">Office</option>
								</select>
							</div>
						</div>							
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_2_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_2_CARRIER" style="display:none;">
							<label for="" class="control-label col-sm-4">Phone 2 Carrier</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Phone 2 Carrier" name="fields[65]" id="CONTACT_PHONE_2_CARRIER">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>			
					
					<div id="GROUP_CONTACT_PHONE3_SECTION" style="display:none;">
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_3_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_3_NUMBER" >
							<label for="tel" class="control-label col-sm-4">Additional Phone 3</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone 3" name="fields[66]" class="form-control" id="CONTACT_PHONE_3_NUMBER">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_3_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_3_TYPE">
							<label for="" class="control-label col-sm-4">Phone 3 Type</label>
							<div class="col-sm-6">
								<select class="form-control ccreq phone_type" placeholder="Phone 3 Type" name="fields[67]" id="CONTACT_PHONE_3_TYPE" data-id="3">
									<option value="">Choose Phone Type</option>
									<option value="C">Mobile</option>
									<option value="H">Home</option>
									<option value="O">Office</option>
								</select>
							</div>
						</div>							
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_3_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_3_CARRIER" style="display:none;">
							<label for="" class="control-label col-sm-4">Phone 3 Carrier</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Phone 3 Carrier" name="fields[68]" id="CONTACT_PHONE_3_CARRIER">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>		
					
					<div id="GROUP_CONTACT_PHONE4_SECTION" style="display:none;">
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_4_NUMBER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_4_NUMBER" >
							<label for="tel" class="control-label col-sm-4">Additional Phone 4</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone 4" name="fields[69]" class="form-control" id="CONTACT_PHONE_4_NUMBER">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_4_TYPE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_4_TYPE">
							<label for="" class="control-label col-sm-4">Phone 4 Type</label>
							<div class="col-sm-6">
								<select class="form-control ccreq phone_type" placeholder="Phone 4 Type" name="fields[70]" id="CONTACT_PHONE_4_TYPE" data-id="4">
									<option value="">Choose Phone Type</option>
									<option value="C">Mobile</option>
									<option value="H">Home</option>
									<option value="O">Office</option>
								</select>
							</div>
						</div>							
						<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_PHONE_4_CARRIER_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="GROUP_CONTACT_PHONE_4_CARRIER" style="display:none;">
							<label for="" class="control-label col-sm-4">Phone 4 Carrier</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Phone 4 Carrier" name="fields[71]" id="CONTACT_PHONE_4_CARRIER">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
					</div>
					
					
					<div class="form-group" id="GROUP_CONTACT_ADD_PHONE">
						<label for="" class="control-label col-sm-4"><span style="cursor:pointer;color: #23527c;text-decoration: underline;" id="CONTACT_ADD_ANOTHER_PHONE" class="addAnotherPhone" data-id="2">Add Another Phone</a></label>							
					</div>
					 						
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_EMAIL_ADDRESS_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_emergency_contact_preferred_email">
						<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
						<div class="col-sm-6">
							<input type="email" placeholder="Preferred Email" name="fields[72]" class="form-control  ccreq" id="CONTACT_EMAIL_ADDRESS">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_RELT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_emergency_contact_relationship">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Relationship</label>
						<div class="col-sm-6">
							<select class="form-control ccreq " placeholder="Relationship" name="fields[73]" id="CONTACT_RELT_CODE">
								<option value="">Choose Relationship</option>
								<c:forEach items="${options['Relationships']}" var="relationships">
									<option value="${relationships.key}">${relationships.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_ADDR_STREET_LINE1_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_emergency_contact_address1">
						<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address 1</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 1" name="fields[74]" class="form-control  ccreq address_field " id="CONTACT_ADDR_STREET_LINE1">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_ADDR_STREET_LINE2_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_emergency_contact_address2">
						<label for="text" class="control-label col-sm-4">Address 2</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Address 2" name="fields[75]" class="form-control address_field " id="CONTACT_ADDR_STREET_LINE2">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_ADDR_NATN_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_emergency_contact_country">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
						<div class="col-sm-6">
							<select class="form-control ccreq address_field country_field" placeholder="Country" name="fields[76]" id="CONTACT_ADDR_NATN_CODE">
								<option value="">Choose Country</option>
								<c:forEach items="${options['Countries']}" var="countries">
									<option value="${countries.key}">${countries.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_ADDR_CITY_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_emergency_contact_city">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>City</label>
						<div class="col-sm-6">
							<input type="text" placeholder="City" name="fields[77]" class="form-control ccreq address_field" id="CONTACT_ADDR_CITY">
						</div>
					</div>
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="GROUP_CONTACT_STATE">
						<label for="" class="control-label col-sm-4"><span class="required">* </span>State</label>
						<div class="col-sm-6">
							<select class="form-control ccreq address_field" placeholder="State" name="fields[78]" id="CONTACT_ADDR_STAT_CODE">
								<option value="">Choose State</option>
								<c:forEach items="${options['States']}" var="states">
									<option value="${states.key}">${states.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_ADDR_STAT_CODE_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div style="display:none;" class="form-group" id="GROUP_CONTACT_INTL_REGION">
						<label for="state" class="control-label col-sm-4"><span class="required">* </span>Province/Region</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Province/Region" name="fields[79]" class="form-control ccreq address_field" id="CONTACT_ADDR_STAT_CODE">
						</div>
					</div>
					
					<div style="display:none;" role="alert" class="alert alert-danger" id="CONTACT_ADDR_ZIP_ERROR"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
					<div class="form-group" id="group_emergency_contact_postal_code">
						<label for="Postal Code" class="control-label col-sm-4"><span class="required">* </span>Zip/Postal Code</label>
						<div class="col-sm-6">
							<input type="text" placeholder="Postal Code" name="fields[80]" class="form-control ccreq address_field " id="CONTACT_ADDR_ZIP">
						</div>
					</div>
					
					<div id='CONTACT_CLNADDR_RESULTS' name='CONTACT_CLNADDR_RESULTS'></div>
									  		
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

  	



<%
	/*out.print(displayEntryModal("parent","Enter Details","Save"));
	out.print(displayEntryModal("emergency_contact","Enter Details","Save"));
	out.print(displayDeleteModal("delete","Confirm Deletion","Yes, Delete"));*/

%>


 <script type="text/javascript" src="/clnaddr/js/clnaddr.js?version=10100"></script>   

 <script type="text/javascript">
 

 
 $(document).ready( function(){
	 
	 $("[data-toggle=popover]").popover();
	 $("[data-toggle=tooltip]").tooltip();
 
	$(".mobile_phone_check").change(function(){
		$thisType = $(this).attr("data-mobile-type");
		console.log($thisType);
		if(this.checked) {
			$("#GROUP_" + $thisType + "_EMERGENCY_PHONE").show();
			$("#" + $thisType + "_emergency_phone").addClass("ccreq");
			//remove error if it is already displaying
			$("#" + $thisType + "_mobile_phone_error").hide();
			$("#group_" + $thisType + "_mobile_phone").removeClass("has-error");
			//remove requirement for mobile phone
			$("#group_" + $thisType + "_mobile_phone .required").hide();				
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
	    	$("#group_" + $thisType + "_mobile_phone .required").show();	
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
	$('.addAnotherPhone').click(function (){
		$form_id = $(this).closest('form').attr("id");
		$current_id = $(this).attr("data-id");
		$next_id = parseInt($current_id) + 1;
		console.log("current_id: " + $current_id);	
		console.log('#GROUP_' + $form_id + '_PHONE' + $current_id + '_SECTION');
		if ($('#GROUP_' + $form_id + '_PHONE' + $current_id + '_SECTION').css('display') == 'none') {
			$('#GROUP_' + $form_id + '_PHONE' + $current_id + '_SECTION').fadeIn();	
			$(this).attr("data-id",$next_id);
			//alert("next ID: " + $next_id);	
		}	

		if($next_id == 5){
			$('#GROUP_' + $form_id + '_ADD_PHONE').hide();
		}else{
			$('#GROUP_' + $form_id + '_ADD_PHONE').show();
		}
	});
	
	//phone carrier display
	$('.phone_type').change(function(){
		$form_id = $(this).closest('form').attr("id");
		//C==Cell/Mobile
		if($(this).val() == 'C'){
			$data_id = $(this).attr("data-id");
			if($('#GROUP_' + $form_id + '_PHONE_' + $data_id + '_CARRIER').css('display') == 'none'){
				$('#GROUP_' + $form_id + '_PHONE_' + $data_id + '_CARRIER').fadeIn();
			}
		}else{
			$data_id = $(this).attr("data-id");
			if($('#GROUP_' + $form_id + '_PHONE_' + $data_id + '_CARRIER').css('display') != 'none'){
				$('#GROUP_' + $form_id + '_PHONE_' + $data_id + '_CARRIER').hide();
			}
		}
	});
	
	//state/province drop-down toggle based on country chosen
	$('.country_field').change(function(){
		$form_id = $(this).closest('form').attr("id");
		console.log('form_id:' + $form_id);
		console.log('thisVal:' + $(this).val());
		$intlField = '#GROUP_' + $form_id + '_INTL_REGION';
		console.log('intlField:' + $intlField)
		$stateField = '#GROUP_' + $form_id + '_STATE';
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
		console.log(modal_type);
		$.ajax({
           type: "POST",
           url: '/cas/cas-rest-api/peci/',
           data: JSON.stringify({"PIDM": student_PIDM, "PPID": PPID, "DATA": modal_type, "MODE": "READ"}),
           datatype: "json",
           contentType: "application/json",
           success: function(data)           
           {   
        	  if(modal_type == 'PARENT'){
	        	  $.each(data.parent, function(index, element){	        		
	        	   	$('#' + index).val(element);
	        	  });
        	  }else{
        		  $.each(data.contact, function(index, element){  	        		
  	        	   	$('#' + index).val(element);
  	        	  });
        	  }
        	  //use first email: data.parent_email[0]?
        	  $.each(data.email[0], function(index,element){        		 
        	  	$('#' + modal_type + "_" + index).val(element); 		   
        	  });
        	  //use first address: data.parent_address[0]?
        	  $.each(data.address[0], function(index,element){        		 
        		  if(index == 'ADDR_NATN_CODE' && element == null){
        			$('#' + modal_type + "_" + index).val('US');
        		  }else{
          	  		$('#' + modal_type + "_" + index).val(element);
        		  }
          	  });
        	  $.each(data.phones, function(index1,element1){
        		  console.log("modaltype:" + modal_type);
        		  console.log('#GROUP_' + modal_type + '_PHONE' + index1 + '_SECTION');
        		  newIndex = parseInt(index1) + 1;
        		  $('#' + modal_type + '_ADD_ANOTHER_PHONE').attr('data-id',newIndex);
        		  $('#GROUP_' + modal_type + '_PHONE' + index1 + '_SECTION').show();        		  
        		  $.each(this, function(index2,element2){     
        			  //console.log(index2 + ":" + element2);
            		  if(index2 == 'PECI_PHONE_CODE'){
            			  $('#' + modal_type + '_PHONE_' + index1 + '_TYPE').val(element2);         			  
            		  }else if(index2 == 'PHONE_AREA_CODE'){
            			  $('#' + modal_type + '_PHONE_' + index1 + '_NUMBER').val(element2);
            		  }else if(index2 == 'PHONE_NUMBER'){
            			  $('#' + modal_type + '_PHONE_' + index1 + '_NUMBER').val($('#' + modal_type + '_PHONE_' + index1 + '_NUMBER').val() + element2);
            		  } 		
        			  //console.log("4 peci phone code" +  element2);        			  
        		  });        		 
          	  	//$('#' + $modal_type + "_" + index).val(element); 		   
          	  });
           },
           error: function (request, status, error) {
               console.log("ERROR: " + request.responseText);
           }
	    });		    
		
		$('#' + modal_type + "_MODAL").modal('show');
	});
	
 });
 
 $('#CONTACT_MODAL').on('hidden.bs.modal', function () {
	 document.getElementById("CONTACT").reset();
 });
 
 $('#PARENT_MODAL').on('hidden.bs.modal', function () {
	 document.getElementById("PARENT").reset();
 });
 
 function formValidate(form_id) {
	 showMainError = 0;
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
		 update_url = "";
		 $(".alert_danger").hide();
		 //submit via ajax
		 alert("test submit");
			/*$.ajax({
		           type: "POST",
		           url: '/cas/cas-rest-api/peci/',
		           data: JSON.stringify($('#' + form_id).serialize()),
		           success: function(data)
		           {   
		        	   console.log(data);
			           //console.log("recipientSubmitAjax: id:" + id + " formID:" + formID + " formToSubmitTo:" + formToSubmitTo);  
		              
		           }
			    });	 */
		 
	 }	 	

	}
 
	
 </script>

</body>
</html>
