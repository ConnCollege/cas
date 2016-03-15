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
  <p>Please enter your contact information, parent/guardian and emergency contact information below.</p> 
  <form class="form-horizontal" role="form" id="student" onsubmit="return formValidate(this.id)"> 
  <div id="step1" class="form_section">
	<h3>Step 1 Verify Your Permanent Mailing Address</h3>
	<p>Please do not enter your local or campus address. </p>

	<p><span class="required">* </span>Required Field</p>  
		
	<div class="form-group" id="group_student_firstname">
		<label for="country" class="control-label col-sm-3">(Preferred) First Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="First Name" name="student_first_name" class="form-control" id="student_first_name" value="${StudentBio['PREFERRED_FIRST_NAME']}">
		</div>
	</div>
	<div class="form-group" id="group_student_middle_name">
		<label for="country" class="control-label col-sm-3">(Preferred) Middle Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="Middle Name" name="student_middle_name" class="form-control" id="student_middle_name" value="${StudentBio['PREFERRED_MIDDLE_NAME']}">
		</div>
	</div>
	<div class="form-group" id="group_student_last_name">
		<label for="country" class="control-label col-sm-3">(Preferred) Last Name</label>
		<div class="col-sm-9">
				<input type="text" disabled="disabled" placeholder="Last Name" name="student_last_name" class="form-control" id="student_last_name" value="${StudentBio['PREFERRED_LAST_NAME']}">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_address1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address1">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>Address 1</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 1" name="student_address1" class="form-control ccreq address_field" id="student_address1" value="${StudentAddr['ADDR_STREET_LINE1']}">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_address2_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address2">
		<label for="country" class="control-label col-sm-3">Address 2</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Address 2" name="student_address2" class="form-control address_field" id="student_address2" value="${StudentAddr['ADDR_STREET_LINE2']}">
		</div>
	</div>  
		<%
			/*out.print(displayInput(false,"","First Name",2,10,"student_first_name","text","",true,true));
			out.print(displayInput(false,"","Middle Name",2,10,"student_middle_name","text","",true,true));
			out.print(displayInput(false,"","Last Name",2,10,"student_last_name","text","",true,true));
			out.print(displayInput(true,"address_field","Address 1",2,10,"student_address1","text","",true,false));
			out.print(displayInput(false,"address_field","Address 2",2,10,"student_address2","text","",true,false));*/
	%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_country_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_country">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>Country</label>
		<div class="col-sm-9">
			<select class="form-control address_field ccreq country_field" placeholder="Country" name="student_country" id="student_country">
				<option value="">Choose Country </option>
				<c:forEach items="${options['Countries']}" var="countries">
					<option <c:if test="${countries.key == StudentAddr['ADDR_NATN_CODE']}">selected="selected"</c:if> value="${countries.key}">${countries.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_city_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_city">
		<label for="country" class="control-label col-sm-3"><span class="required">* </span>City</label>
		<div class="col-sm-9">
				<input type="text" placeholder="City" name="student_city" class="form-control ccreq address_field" id="student_city" value="${StudentAddr['ADDR_CITY']}">
		</div>
	</div>  
	
	<% 
			/*out.print(displayInput(true,"address_field","City",2,10,"student_city","city","",true,false));*/
	%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_state_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_state">
		<label for="state" class="control-label col-sm-3"><span class="required">* </span>State</label>
		<div class="col-sm-9">
			<select class="form-control address_field ccreq" placeholder="State" name="student_state" id="student_state">
				<option value="">Choose State</option>
				<c:forEach items="${options['States']}" var="states">
					<option <c:if test="${states.key == StudentAddr['ADDR_STAT_CODE']}">selected="selected"</c:if> value="${states.key}">${states.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_intl_region_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div style="display:none;" class="form-group" id="group_student_intl_region">
		<label for="state" class="control-label col-sm-3"><span class="required">* </span>Province/Region</label>
		<div class="col-sm-9">
			<input type="text" placeholder="Province/Region" name="student_intl_region" class="form-control ccreq address_field" id="student_intl_region" value="${StudentAddr['ADDR_STAT_CODE']}">
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_postal_code_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_postal_code">
		<label for="Postal Code" class="control-label col-sm-3 address_field"><span class="required">* </span>Zip/Postal Code</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Postal Code" name="student_postal_code" class="form-control ccreq address_field" id="student_postal_code" value="${StudentAddr['ADDR_ZIP']}">
		</div>
	</div> 
	<div id='student_clnaddr_results' name='student_clnaddr_results'></div>
	<div id="suggestionListDiv" style="display: none;"></div>
	<div class="form-group" id="group_student_home_phone">
		<label for="Phone" class="control-label col-sm-3">Home Phone</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Home Phone" name="student_home_phone" class="form-control" id="student_home_phone" value="(${StudentHomePhone['PHONE_AREA_CODE']}) ${StudentHomePhone['PHONE_NUMBER']}">
		</div>
	</div> 
	<div class="form-group" id="group_student_non_college_email">
		<label for="Email" class="control-label col-sm-3">Non-college email</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Non-college email" name="student_non_college_email" class="form-control" id="student_non_college_email" value="${StudentEmail['EMAIL_ADDRESS']}">
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
	<h3>Step 2 Your Emergency Contact Information</h3>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_mobile_phone_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_mobile_phone">
		<label for="Phone" class="control-label col-sm-3 ccreq"><span class="required">* </span>Mobile Phone</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Mobile Phone" name="student_mobile_phone" class="form-control ccreq" id="student_mobile_phone" >
		</div>
	</div> 		
		<%
			/*out.print(displayInput(true,"","Mobile Phone",2,10,"student_mobile_phone","tel","",true,false));*/
		%>
		
	<div class="form-group" id="group_student_phone_carrier">
		<label for="Phone Carrier" class="control-label col-sm-3">Phone Carrier</label>
		<div class="col-sm-9">
			<select class="form-control" placeholder="Phone Carrier" name="student_phone_carrier" id="student_phone_carrier">
				<option value="">Choose Phone Carrier</option>
				<c:forEach items="${options['Carriers']}" var="carriers">
					<option value="${carriers.key}">${carriers.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="form-group" id="group_student_mobile_phone_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" name="student_mobile_phone_check" id="student_mobile_phone_check">I don't have a mobile phone</label>
			</div>
		</div>
	</div>
	
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_emergency_phone_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_emergency_phone" style="display:none;">
		<label for="Phone" class="control-label col-sm-3 address_field"><span class="required">* </span>Emergency Phone</label>
		<div class="col-sm-9">
				<input type="text" placeholder="Emergency Phone" name="student_emergency_phone" class="form-control address_field" id="student_emergency_phone">
		</div>
	</div> 
	
	<p class="q_check" id="paragraph_alert_text_check">Connecticut College will contact this number in the case of a campus emergency. Do you wish to also receive a text message at this number in the case of a campus emergency?</p>
	<div class="form-group" id="group_alert_text_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="alert_text_check" id="alert_text_check">Yes send me a text message in the event of an emergency</label>
			</div>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="tty_device_check_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<p class="q_check" id="paragraph_tty_device_check">If your mobile phone is a TTY device (for the hearing impaired) please indicate below:</p>
	<div class="form-group" id="group_tty_device_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="tty_device_check" id="tty_device_check">This phone is a TTY device</label>
			</div>
		</div>
	</div>
	<p class="q_check" id="paragraph_alert_home_email_check">If you do not wish to receive campus alerts beyond those to your campus email and voice mail, check the box below:</p>
	<div style="display:none;" role="alert" class="alert alert-danger" id="alert_home_email_check_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_alert_home_email_check">
		<div class="col-sm-offset-1 col-sm-9">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="alert_home_email_check" id="alert_home_email_check">Opt out of automated campus alerts to my home email and cell phone</label>
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
	    <p id="doc_message">You are required to name at least one parent or guardian as an emergency contact. Exceptions to this policy must be approved by the Dean of the College doc@conncoll.edu.</p>
	    <p id="doc_opt_out_message" style="display:none;">You are not required to include a parent or guardian as an emergency contact. You are required to have at least one emergency contact, which you can add in the additional emergency contacts section below.</p>	   
	
		
		<div class="panel panel-default">
		  <div class="panel-body">
		    Bob Smith &nbsp; <a href="#" title="Edit" data-toggle="modal" data-target="#parent_modal"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#delete_modal" data-person-name="Bob Smith" data-person-id="1"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a><span class="emergency_contact_switch">&nbsp;Emergency Contact: <input type="checkbox" name="parent1" checked="checked" class="bootstrap-switch"></span>
		  </div>
		</div>
		<div class="panel panel-default">
		  <div class="panel-body">
		    John Jones &nbsp; <a href="#" title="Edit" data-toggle="modal" data-target="#parent_modal"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#delete_modal" data-person-name="John Jones" data-person-id="2"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a><span class="emergency_contact_switch">&nbsp;Emergency Contact: <input type="checkbox" name="parent2" checked="checked" class="bootstrap-switch"></span>
		  </div>
		</div>
	    
	     <div class="form-group">        
	      <div class="col-sm-offset-1 col-sm-9">
	        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#parent_modal">Add Parent</button>
	      </div>
	    </div>  
    </div>
    <div id="step4" class="form_section">
	    <h3>Step 4 Emergency Contacts</h3>
	    <p id="doc_message">You must enter at least one emergency contact. Emergency contacts will be contacted in the order you specify below.<br><strong>If Connecticut College is a long way from home, and there is someone who can be contacted nearby in the event of an emergency, please add that person as one of your contacts.</strong></p>
		
		<!-- Bootstrap 3 panel list. -->
		<ul id="draggablePanelList" class="list-unstyled">
		    <li class="panel panel-info"> 
		        <div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div>
		        <div class="panel-body">Bob Smith &nbsp; <a href="#" title="Edit" data-toggle="modal" data-target="#emergency_contact_modal"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#delete_modal" data-person-name="Bob Smith" data-person-id="1"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div>
		    </li>
		    <li class="panel panel-info">
		        <div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div>
		        <div class="panel-body">John Jones &nbsp; <a href="#" title="Edit" data-toggle="modal" data-target="#emergency_contact_modal"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" data-toggle="modal" data-target="#delete_modal" data-person-name="John Jones" data-person-id="2"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div>
		    </li>
		</ul>
	    
	     <div class="form-group">        
	      <div class="col-sm-offset-1 col-sm-9">
	        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#emergency_contact_modal">Add Contact</button>
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

  
  
  <!-- Modal windows -->
  
  <c:forTokens items="parent,emergency_contact" delims="," var="modalType">
  	<div class="modal fade" id="<c:out value="${modalType}"/>_modal" role="dialog">
	  	<div class="modal-dialog">    
		  	<!-- Modal content-->
		  	<div class="modal-content">
			  	<form class="form-horizontal" role="form" id="<c:out value="${modalType}"/>"  onsubmit="return formValidate(this.id)">
				  	<div class="modal-header">
				  		<button type="button" class="close" data-dismiss="modal">&times;</button>
				  		<h4 class="modal-title">Enter <c:out value="${modalType}"/> Information</h4>
				  	</div>
				  	<div class="modal-body">	
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_first_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_<c:out value="${modalType}"/>_first_name">
				  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>First Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="First Name" name="<c:out value="${modalType}"/>_first_name" class="form-control  ccreq" id="<c:out value="${modalType}"/>_first_name">
				  			</div>
				  		</div>
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_middle_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_<c:out value="${modalType}"/>_middle_name">
				  			<label for="text" class="control-label col-sm-4">Middle Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="Middle Name" name="<c:out value="${modalType}"/>_middle_name" class="form-control" id="<c:out value="${modalType}"/>_middle_name">
				  			</div>
				  		</div>	  	
				  		
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_last_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_<c:out value="${modalType}"/>_last_name">
				  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>Last Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="Last Name" name="<c:out value="${modalType}"/>_last_name" class="form-control  ccreq " id="<c:out value="${modalType}"/>_last_name">
				  			</div>
				  		</div>
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_mobile_phone_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_<c:out value="${modalType}"/>_mobile_phone">
			  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
			  				<div class="col-sm-6">
			  					<input type="tel" placeholder="Mobile Phone" name="<c:out value="${modalType}"/>_mobile_phone" class="form-control  ccreq  " id="<c:out value="${modalType}"/>_mobile_phone">
			  				</div>
			  			</div>
			  			<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_phone_carrier_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_phone_carrier">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Phone Carrier</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Phone Carrier" name="<c:out value="${modalType}"/>_phone_carrier" id="<c:out value="${modalType}"/>_phone_carrier">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_mobile_phone_check"><div class="col-sm-offset-1 col-sm-9"><div class="checkbox"><label><input type="checkbox" class="" name="<c:out value="${modalType}"/>_mobile_phone_check" id="<c:out value="${modalType}"/>_mobile_phone_check">This person does not have a mobile phone</label></div></div></div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_addional_phone1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_addional_phone1">
							<label for="tel" class="control-label col-sm-4">Additional Phone</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone" name="<c:out value="${modalType}"/>_addional_phone1" class="form-control  ccreq  " id="<c:out value="${modalType}"/>_addional_phone1">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_phone1_type_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_phone1_type">
							<label for="" class="control-label col-sm-4">Phone Type</label>
							<div class="col-sm-6">
								<select class="form-control ccreq phone_type" placeholder="Phone Type" name="<c:out value="${modalType}"/>_phone1_type" id="<c:out value="${modalType}"/>_phone1_type" data-id="1">
									<option value="">Choose Phone Type</option>
									<option value="Mobile">Mobile</option>
									<option value="Home">Home</option>
									<option value="Business">Business</option>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_phone1_carrier_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div style="display:none;" class="form-group" id="group_<c:out value="${modalType}"/>_phone1_carrier">
							<label for="" class="control-label col-sm-4">Phone <c:out value="${i}"/> Carrier</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Phone Carrier" name="<c:out value="${modalType}"/>_phone1_carrier" id="<c:out value="${modalType}"/>_phone1_carrier">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<c:forEach var="i" begin="2" end="4">							
							<div id="group_<c:out value="${modalType}"/>_phone<c:out value="${i}"/>_section" style="display:none;">
								<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_addional_phone<c:out value="${i}"/>_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
								<div class="form-group" id="group_<c:out value="${modalType}"/>_addional_phone<c:out value="${i}"/>" >
									<label for="tel" class="control-label col-sm-4">Additional Phone <c:out value="${i}"/></label>
									<div class="col-sm-6">
										<input type="tel" placeholder="Additional Phone <c:out value="${i}"/>" name="<c:out value="${modalType}"/>_addional_phone<c:out value="${i}"/>" class="form-control" id="<c:out value="${modalType}"/>_addional_phone<c:out value="${i}"/>">
									</div>
								</div>
								<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_phone_type_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
								<div class="form-group" id="group_<c:out value="${modalType}"/>_phone_type">
									<label for="" class="control-label col-sm-4">Phone <c:out value="${i}"/> Type</label>
									<div class="col-sm-6">
										<select class="form-control ccreq phone_type" placeholder="Phone <c:out value="${i}"/> Type" name="<c:out value="${modalType}"/>_phone<c:out value="${i}"/>_type" id="<c:out value="${modalType}"/>_phone<c:out value="${i}"/>_type" data-id="<c:out value="${i}"/>">
											<option value="">Choose Phone Type</option>
											<option value="Mobile">Mobile</option>
											<option value="Home">Home</option>
											<option value="Business">Business</option>
										</select>
									</div>
								</div>							
								<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_phone<c:out value="${i}"/>_carrier_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
								<div class="form-group" id="group_<c:out value="${modalType}"/>_phone<c:out value="${i}"/>_carrier" style="display:none;">
									<label for="" class="control-label col-sm-4">Phone <c:out value="${i}"/> Carrier</label>
									<div class="col-sm-6">
										<select class="form-control ccreq" placeholder="Phone <c:out value="${i}"/> Carrier" name="<c:out value="${modalType}"/>_phone<c:out value="${i}"/>_carrier" id="<c:out value="${modalType}"/>_phone<c:out value="${i}"/>_carrier">
											<option value="">Choose Phone Carrier</option>
											<c:forEach items="${options['Carriers']}" var="carriers">
												<option value="${carriers.key}">${carriers.value}</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</div>
						</c:forEach>						
						
						<div class="form-group" id="group_<c:out value="${modalType}"/>_add_phone">
							<label for="" class="control-label col-sm-4"><span style="cursor:pointer;color: #23527c;text-decoration: underline;" class="addAnotherPhone" data-id="2">Add Another Phone</a></label>							
						</div>
						 						
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_preferred_email_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_preferred_email">
							<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
							<div class="col-sm-6">
								<input type="email" placeholder="Preferred Email" name="<c:out value="${modalType}"/>_preferred_email" class="form-control  ccreq" id="<c:out value="${modalType}"/>_preferred_email">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_relationship_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_relationship">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Relationship</label>
							<div class="col-sm-6">
								<select class="form-control ccreq " placeholder="Relationship" name="<c:out value="${modalType}"/>_relationship" id="<c:out value="${modalType}"/>_relationship">
									<option value="">Choose Relationship</option>
									<c:forEach items="${options['Relationships']}" var="relationships">
										<option value="${relationships.key}">${relationships.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_address1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_address1">
							<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address 1</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Address 1" name="<c:out value="${modalType}"/>_address1" class="form-control  ccreq address_field " id="<c:out value="${modalType}"/>_address1">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_address2_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_address2">
							<label for="text" class="control-label col-sm-4">Address 2</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Address 2" name="<c:out value="${modalType}"/>_address2" class="form-control address_field " id="<c:out value="${modalType}"/>_address2">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_country_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_country">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
							<div class="col-sm-6">
								<select class="form-control ccreq address_field country_field" placeholder="Country" name="<c:out value="${modalType}"/>_country" id="<c:out value="${modalType}"/>_country">
									<option value="">Choose Country</option>
									<c:forEach items="${options['Countries']}" var="countries">
										<option value="${countries.key}">${countries.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_city_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_city">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>City</label>
							<div class="col-sm-6">
								<input type="text" placeholder="City" name="<c:out value="${modalType}"/>_city" class="form-control ccreq address_field" id="<c:out value="${modalType}"/>_city">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_state_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_state">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>State</label>
							<div class="col-sm-6">
								<select class="form-control ccreq address_field" placeholder="State" name="<c:out value="${modalType}"/>_state" id="<c:out value="${modalType}"/>_state">
									<option value="">Choose State</option>
									<c:forEach items="${options['States']}" var="states">
										<option value="${states.key}">${states.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_intl_region_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div style="display:none;" class="form-group" id="group_<c:out value="${modalType}"/>_intl_region">
							<label for="state" class="control-label col-sm-4"><span class="required">* </span>Province/Region</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Province/Region" name="<c:out value="${modalType}"/>_intl_region" class="form-control ccreq address_field" id="<c:out value="${modalType}"/>_intl_region">
							</div>
						</div>
						
						<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_postal_code_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_<c:out value="${modalType}"/>_postal_code">
							<label for="Postal Code" class="control-label col-sm-4"><span class="required">* </span>Zip/Postal Code</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Postal Code" name="<c:out value="${modalType}"/>_postal_code" class="form-control ccreq address_field " id="<c:out value="${modalType}"/>_postal_code">
							</div>
						</div>
						
						<c:if test = "${modalType == 'parent'}">
							<div id='<c:out value="${modalType}"/>_clnaddr_results' name='<c:out value="${modalType}"/>_clnaddr_results'></div>
							<div style="display:none;" role="alert" class="alert alert-danger" id="<c:out value="${modalType}"/>_dependent_check_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
							<div class="form-group" id="group_<c:out value="${modalType}"/>_dependent_check">
								<div class="col-sm-offset-1 col-sm-10">
									<div class="checkbox">
										<label><span class="emergency_contact_switch">&nbsp;<input type="checkbox" name="<c:out value="${modalType}"/>1" checked="checked" class="bootstrap-switch"></span> This <c:out value="${modalType}"/> claims me as a dependent</label>
								
								<a data-content="Please indicate whether your <c:out value="${modalType}"/>s claim you as a tax dependent for federal income tax purposes. This is turned on by default. &lt;a href='http://www.conncoll.edu/academics/registrar/ferpa/' target='_blank'&gt; FERPA Information&lt;/a&gt;." data-placement="top" data-title="U.S. Tax Dependence Status Info" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title=""></a>
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


 <script type="text/javascript" src="/clnaddr/js/clnaddr.js?version=10081"></script>   

 <script type="text/javascript">
 

 
 $(document).ready( function(){
	 
	 $("[data-toggle=popover]").popover();
	 $("[data-toggle=tooltip]").tooltip();
 
	$("#student_mobile_phone_check").change(function(){
		if(this.checked) {
			$("#group_student_emergency_phone").show();
			$("#student_emergency_phone").addClass("ccreq");
			//remove error if it is already displaying
			$("#student_mobile_phone_error").hide();
			$('#group_student_mobile_phone').removeClass("has-error");
			//remove requirement for mobile phone
			$("#group_student_mobile_phone .required").hide();				
			$("#student_mobile_phone").removeClass("ccreq");
			//remove requirement for phone carrier
			$("#group_student_phone_carrier .required").hide();	
			$("#student_phone_carrier").removeClass("ccreq");
			//remove text alerts checkbox
			$("#paragraph_alert_text_check").hide();
			$("#group_alert_text_check").hide();	
			$("#paragraph_tty_device_check").html('If your emergency phone is a TTY device (for the hearing impaired) please indicate below:');
	    }else{
	    	$("#group_student_emergency_phone").hide();	
	    	$("#student_emergency_phone").removeClass("ccreq");
	    	//add requirement for mobile phone
	    	$("#group_student_mobile_phone .required").show();	
	    	$("#student_mobile_phone").addClass("ccreq");
	    	//add requirement for phone carrier
			$("#group_student_phone_carrier .required").show();	
			$("#student_phone_carrier").addClass("ccreq");
			//show text alerts checkbox
			$("#paragraph_alert_text_check").show();
			$("#group_alert_text_check").show();	
			$("#paragraph_tty_device_check").html('If your mobile phone is a TTY device (for the hearing impaired) please indicate below:');
	    }		
	}); 
	
	//add phone
	$('.addAnotherPhone').click(function (){
		$form_id = $(this).closest('form').attr("id");
		$current_id = $(this).attr("data-id");
		$next_id = parseInt($current_id) + 1;
		//alert("current_id: " + $current_id);	
		//alert('#group_' + $form_id + '_phone' + $current_id + '_section');
		if ($('#group_' + $form_id + '_phone' + $current_id + '_section').css('display') == 'none') {
			$('#group_' + $form_id + '_phone' + $current_id + '_section').fadeIn();	
			$(this).attr("data-id",$next_id);
			//alert("next ID: " + $next_id);	
		}	
		if($next_id == 5){
			$('#group_' + $form_id + '_add_phone').hide();
		}else{
			$('#group_' + $form_id + '_add_phone').show();
		}
	});
	
	//phone carrier display
	$('.phone_type').change(function(){
		$form_id = $(this).closest('form').attr("id");
		if($(this).val() == 'Mobile'){
			$data_id = $(this).attr("data-id");
			if($('#group_' + $form_id + '_phone' + $data_id + '_carrier').css('display') == 'none'){
				$('#group_' + $form_id + '_phone' + $data_id + '_carrier').fadeIn();
			}
		}else{
			if($('#group_' + $form_id + '_phone' + $data_id + '_carrier').css('display') != 'none'){
				$('#group_' + $form_id + '_phone' + $data_id + '_carrier').hide();
			}
		}
	});
	
	//state/province drop-down toggle based on country chosen
	$('.country_field').change(function(){
		$form_id = $(this).closest('form').attr("id");
		console.log('form_id:' + $form_id);
		console.log('thisVal:' + $(this).val());
		$intlField = '#group_' + $form_id + '_intl_region';
		console.log('intlField:' + $intlField)
		$stateField = '#group_' + $form_id + '_state';
		if($(this).val() == 'United States' || $(this).val() == "US"){
			$($stateField).show();
			$($intlField).hide();
		}else{
			$($stateField).hide();
			$($intlField).show();
		}
		
	});
	
	//triggered when modal is about to be shown
	$('#delete_modal').on('show.bs.modal', function(e) {

	    //get data-id attribute of the clicked element
	    var person_name = $(e.relatedTarget).data('person-name');
	    var person_id = $(e.relatedTarget).data('person-id');

	    //populate the textbox
	    $(e.currentTarget).find('.name_block').html(person_name);
	    $(e.currentTarget).find('input[name="person_id"]').val(person_id);
	});
	
	$('#parent_modal, #emergency_contact_modal, #delete_modal').on('hidden.bs.modal', function () {
		//on modal close hide all modal error messages
	    $('#parent_modal .alert-danger, #emergency_contact_modal .alert-danger, #delete_modal .alert-danger').hide();
		$('#parent_modal .form-group, #emergency_contact_modal .form-group, #delete_modal .form-group').removeClass('has-error');
	});
	
 });
 
 function formValidate(form_id) {
	 showMainError = 0;
	 $("#" + form_id + " .ccreq").each(function(){
		 var field_value = $(this).val();
		 var field_name = $(this).attr("name");
		 var field_type = $(this).attr("type");
		 var field_label = $(this).attr("placeholder");
		 if(field_value.length == 0){
			 $("#" + field_name + "_error" + " .custom-error").html('Please Enter ' + field_label);	
			 $("#" + field_name + "_error").show();		
			 $("#group_" + field_name).addClass("has-error");
			 showMainError = 1
		 }else{
			 $("#" + field_name + "_error").hide();		
			 $("#group_" + field_name).removeClass("has-error");
		 }		 
		 //console.log(input);
	 });
	 $("#" + form_id + " input[type=email]").each(function(){
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
		 return false;		 
	 }else{
		 //close any former error messages
		 $(".alert_danger").hide();
	 }	 	

	}
 </script>

</body>
</html>
