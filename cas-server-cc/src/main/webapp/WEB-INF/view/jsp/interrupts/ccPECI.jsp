<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
  </style>
</head>
<body>

<%!

public String displayError(String label, String field_name){
	String fieldOut = "";
	fieldOut = fieldOut + "<div id=\"" + field_name + "_error\" class=\"alert alert-danger\" role=\"alert\" style=\"display:none;\">";
	fieldOut = fieldOut + "<span class=\"glyphicon glyphicon-exclamation-sign\" aria-hidden=\"true\"></span>";
	fieldOut = fieldOut + "<span class=\"sr-only\">Error:</span>";
	fieldOut = fieldOut + "<span class=\"custom-error\"></span>";
	fieldOut = fieldOut + "</div>";
	return fieldOut;
}

public String displaySectionStart(boolean required,String field_name,String label,int label_column, int div_column, String field_for,boolean displayed){
	String fieldOut = "";

	fieldOut = fieldOut + "<div id=\"group_" + field_name + "\" class=\"form-group\"";
	if(displayed){
		fieldOut = fieldOut + ">";
	}else{
		fieldOut = fieldOut + " style=\"display:none\">";
	}
	fieldOut = fieldOut + "<label class=\"control-label col-sm-" + label_column + "\" for=\"" + field_for + "\">";
	if(required){	
		fieldOut = fieldOut + "<span class=\"required\">* </span>";
	}
	fieldOut = fieldOut + label + "</label>";
	fieldOut = fieldOut + "<div class=\"col-sm-" + div_column + "\">";
	return fieldOut;
}

public String displayInput(boolean required, String label, int label_column, int div_column, String field_name, String field_for, String field_value, boolean displayed,boolean disabled){
	String fieldOut = "";
	
	fieldOut = fieldOut + displayError(label,field_name);
	
	fieldOut = fieldOut + displaySectionStart(required,field_name,label,label_column,div_column,field_for,displayed);
	
	fieldOut = fieldOut + "<input id=\"" + field_name + "\" type=\"" + field_for + "\" class=\"form-control";  
	if(required){
		fieldOut = fieldOut + " ccreq\"";
	}	
	fieldOut = fieldOut + "\" name=\"" + field_name + "\" placeholder=\"" + label + "\"";
	if(disabled){
		fieldOut = fieldOut + " disabled=\"disabled\"";
	}
	
	fieldOut = fieldOut + ">";
	
	fieldOut = fieldOut + "</div>";
	fieldOut = fieldOut + "</div>"; 
	return fieldOut;
}

public String displayCheckbox(boolean required, String label, int label_column, int div_column, String field_name, String field_for, String field_value, String question){
	String fieldOut = "";	
	if(question.length() > 0){
	    fieldOut = fieldOut + "<p id=\"paragraph_" + field_name + "\" class=\"q_check\">" + question + "</p>";
	}	
	
	fieldOut = fieldOut + displayError(label,field_name);
		
	fieldOut = fieldOut + "<div id=\"group_" + field_name + "\" class=\"form-group\">";      
	fieldOut = fieldOut + "<div class=\"col-sm-offset-1 col-sm-10\">";
	fieldOut = fieldOut + "<div class=\"checkbox\">";
	fieldOut = fieldOut + "<label><input id=\"" + field_name + "\" type=\"checkbox\" name=\"" + field_name + "\"";
	if(required){
		fieldOut = fieldOut + " class=\"ccreq\"";
	}	
	fieldOut = fieldOut + "> " + label + "</label>";
	fieldOut = fieldOut + "</div>";
	fieldOut = fieldOut + "</div>";
	fieldOut = fieldOut + "</div>";   
  return fieldOut;
	
}

public String displayDropdown(boolean required, String label, int label_column, int div_column, String field_name, String field_for, String field_value,boolean displayed,boolean disabled){
	String fieldOut = "";	
	
	fieldOut = fieldOut + displayError(label,field_name);
	
	fieldOut = fieldOut + displaySectionStart(required,field_name,label,label_column,div_column,field_for,displayed);
	fieldOut = fieldOut + "<select id=\"" + field_name + "\" name=\"" + field_name + "\" placeholder=\"" + label + "\" class=\"form-control";
	if(required){
		fieldOut = fieldOut + " ccreq";
	}	
	fieldOut = fieldOut + "\">";
	
	if(label == "Country"){

	}else if(label == "State"){		
		
	}else if(label == "Phone Carrier"){
		
	}else if(label == "Relationship"){
		
	}	

	fieldOut = fieldOut + "<option value=\"\">Choose " + label + "</option>";
	fieldOut = fieldOut + "<option value=\"New London\">New London</option>";
	fieldOut = fieldOut + "<option value=\"Connecticut\">Connecticut</option>";
	fieldOut = fieldOut + "</select>";
	fieldOut = fieldOut + "</div>";
	fieldOut = fieldOut + "</div>"; 
  return fieldOut;	
}

public String displayModalStart(String type,String modal_title){
	String ModalOut = "";	
  	ModalOut = ModalOut + "<div class=\"modal fade\" id=\"" + type + "_modal\" role=\"dialog\">";
  	ModalOut = ModalOut + "<div class=\"modal-dialog\">    ";
  	ModalOut = ModalOut + "<!-- Modal content-->";
  	ModalOut = ModalOut + "<div class=\"modal-content\">";
  	ModalOut = ModalOut + "<form class=\"form-horizontal\" role=\"form\" id=\"" + type + "_form\"  onsubmit=\"return formValidate(this.id)\">";
  	ModalOut = ModalOut + "<div class=\"modal-header\">";
  	ModalOut = ModalOut + "<button type=\"button\" class=\"close\" data-dismiss=\"modal\">&times;</button>";
  	ModalOut = ModalOut + "<h4 class=\"modal-title\">" + modal_title + "</h4>";
  	ModalOut = ModalOut + "</div>";
  	ModalOut = ModalOut + "<div class=\"modal-body\">";
  	return ModalOut;
}

public String displayModalEnd(String action){
	String ModalOut = "";
  	ModalOut = ModalOut + "<div class=\"form-group\">"; 
  	ModalOut = ModalOut + "<div class=\"col-sm-offset-5 col-sm-10\">";
  	ModalOut = ModalOut + "<button type=\"submit\" class=\"btn btn-primary\">" + action + "</button>";
  	ModalOut = ModalOut + "</div></div></form></div>";
  	ModalOut = ModalOut + "<div class=\"modal-footer\">";
  	ModalOut = ModalOut + "<button type=\"button\" class=\"btn btn-default\" data-dismiss=\"modal\">Close</button>";
  	ModalOut = ModalOut + "</div>";
  	ModalOut = ModalOut + "</div></div></div>";
  	return ModalOut;
}

public String displayEntryModal(String type,String modal_title,String action){
	String ModalOut = "";
	ModalOut = ModalOut + displayModalStart(type,modal_title);
  	ModalOut = ModalOut + displayInput(true,"First Name",4,6,type + "_first_name","text","",true,false);
  	ModalOut = ModalOut + displayInput(false,"Middle Name",4,6,type + "_middle_name","text","",true,false);
  	ModalOut = ModalOut + displayInput(true, "Last Name",4,6, type + "_last_name" , "text","", true, false);
  	ModalOut = ModalOut + displayInput(true, "Mobile Phone",4,6, type + "_mobile_phone" , "tel","", true, false);
  	ModalOut = ModalOut + displayDropdown(true,"Phone Carrier",4,6,type + "_phone_carrier","","",true,false);
  	ModalOut = ModalOut + displayCheckbox(false,"This person does not have a mobile phone",4,6, type +"_mobile_phone_check", "", "", "");
  	ModalOut = ModalOut + displayInput(true, "Additional Phone",4,6, type + "_addional_phone1" , "tel","", true, false);
  	ModalOut = ModalOut + displayDropdown(false,"Phone Carrier",4,6,type + "_additional_phone1_carrier","","",true,false);	  	
  	ModalOut = ModalOut + displayInput(true, "Preferred Email",4,6, type + "_preferred_email" , "email","", true, false);
  	ModalOut = ModalOut + displayDropdown(true,"Relationship",4,6,type + "_relationship","","",true,false);
  	if(type == "emergency_contact"){
  		//address not required for emergency contact
	  	ModalOut = ModalOut + displayInput(false,"Address 1",4,6,type + "_address1","text","",true,false);
	  	ModalOut = ModalOut + displayInput(false,"Address 2",4,6,type + "_address2","text","",true,false);
	  	ModalOut = ModalOut + displayDropdown(false,"Country",4,6,type + "_country","","",true,false);
	  	ModalOut = ModalOut + displayDropdown(false,"City",4,6,type + "_city","","",true,false);
	  	ModalOut = ModalOut + displayDropdown(false,"State",4,6,type + "_state","","",true,false);
	  	ModalOut = ModalOut + displayInput(false,"Postal Code",4,6,type + "_student_postal_code","postal code","",true,false);	  	
  	}else{
	  	ModalOut = ModalOut + displayInput(true,"Address 1",4,6,type + "_address1","text","",true,false);
	  	ModalOut = ModalOut + displayInput(false,"Address 2",4,6,type + "_address2","text","",true,false);
	  	ModalOut = ModalOut + displayDropdown(true,"Country",4,6,type + "_country","","",true,false);
	  	ModalOut = ModalOut + displayDropdown(true,"City",4,6,type + "_city","","",true,false);
	  	ModalOut = ModalOut + displayDropdown(true,"State",4,6,type + "_state","","",true,false);
	  	ModalOut = ModalOut + displayInput(true,"Postal Code",4,6,type + "_student_postal_code","postal code","",true,false);
	  	ModalOut = ModalOut + displayCheckbox(false,"This parent claims me as a dependent",4,6, type +"_dependent_check", "", "", "");
  	}
  	//save and close buttons
	ModalOut = ModalOut + displayModalEnd(action);
  	return ModalOut;
}

public String displayDeleteModal(String type,String modal_title,String action){
	String ModalOut = "";
	ModalOut = ModalOut + displayError("Deletion","deletion");
	ModalOut = ModalOut + displayModalStart(type,modal_title);
	ModalOut = ModalOut + "<p>Are you sure you want to delete this person?</p>";
	ModalOut = ModalOut + "<p><strong><span class=\"name_block\"></span></strong></p>";
	ModalOut = ModalOut + "<form>";
	ModalOut = ModalOut + "<input type=\"hidden\" name=\"person_id\" value=\"\" class=\"ccreq\">";
	ModalOut = ModalOut + "</form>";
	ModalOut = ModalOut + displayModalEnd(action);
  	return ModalOut;
}

%>

<div class="container">
  <h2>Update Your Contact Information</h2>
  <p>Please enter your contact information, parent/guardian and emergency contact information below.</p> 
  <form class="form-horizontal" role="form" id="main_form" onsubmit="return formValidate(this.id)"> 
  <div id="step1" class="form_section">
	  <h3>Step 1 Verify Your Permanent Mailing Address</h3>
	  <p>Please do not enter your local or campus address.</p>
	  <select>
	  	<c:forEach items="${options.Countries}" var="countries">
			<option value="${countries.key}" selected="selected">${country.value}</option>
		</c:forEach>
	  </select>
	  <p><span class="required">* </span>Required Field</p>  
		<%
			out.print(displayInput(false,"First Name",2,10,"student_first_name","text","",true,true));
			out.print(displayInput(false,"Middle Name",2,10,"student_middle_name","text","",true,true));
			out.print(displayInput(false,"Last Name",2,10,"student_last_name","text","",true,true));
			out.print(displayInput(true,"Address 1",2,10,"student_address1","text","",true,false));
			out.print(displayInput(false,"Address 2",2,10,"student_address2","text","",true,false));
			out.print(displayDropdown(true,"Country",2,10,"student_country","country","",true,false));
			out.print(displayDropdown(true,"City",2,10,"student_city","city","",true,false));
			out.print(displayDropdown(true,"State",2,10,"student_state","state","",true,false));
			out.print(displayInput(true,"Postal Code",2,10,"student_postal_code","postal code","",true,false));
			out.print("<div id='HiddenDiv1' name='HiddenDiv1'></div>");
			out.print(displayInput(false,"Home Phone",2,10,"student_home_phone","tel","",true,false));
			out.print(displayInput(false,"Non-college email",2,10,"student_non_college_email","email","",true,false));			
		%>   	
	</div>
	<div id="step2" class="form_section">
		<h3>Step 2 Your Emergency Contact Information</h3>		
		<%
			out.print(displayInput(true,"Mobile Phone",2,10,"student_mobile_phone","tel","",true,false));
			out.print(displayDropdown(true,"Phone Carrier",2,10,"student_phone_carrier","","",true,false));
			out.print(displayCheckbox(false,"I don't have a mobile phone",2,10, "student_mobile_phone_check", "", "", ""));
			out.print(displayInput(false,"Emergency Phone",2,10,"student_emergency_phone","tel","",false,false));
			out.print(displayCheckbox(false,"Yes send me a text message in the event of an emergency",2,10, "alert_text_check", "", "", "Connecticut College will contact this number in the case of a campus emergency. Do you wish to also receive a text message at this number in the case of a campus emergency?"));
			out.print(displayCheckbox(false,"This phone is a TTY device",2,10,"tty_device_check","","","If your mobile phone is a TTY device (for the hearing impaired) please indicate below:"));
			out.print(displayCheckbox(false,"Opt out of automated campus alerts to my home email and cell phone",2,10,"alert_home_email_check","","","If you do not wish to receive campus alerts beyond those to your campus email and voice mail, check the box below:"));
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
	      <div class="col-sm-offset-1 col-sm-10">
	        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#parent_modal">Add Parent</button>
	      </div>
	    </div>  
    </div>
    <div id="step4" class="form_section">
	    <h3>Step 4 Emergency Contacts</h3>
	    <p id="doc_message">You must enter at least one emergency contact. Emergency contacts will be contacted in the order you specify below.</p>
		
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
	      <div class="col-sm-offset-1 col-sm-10">
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
	      <div class="col-sm-offset-5 col-sm-10">
	        <button type="submit" class="btn btn-primary">Submit</button>
	      </div>
	    </div>  
	</div>      
	
	<input type="hidden"  name="statuscode"   id="student_statuscode">            
    <input type="hidden"  name="dpverrorcode" id="student_dpverrorcode">
    <input type="hidden"  name="message"      id="student_message">
    <input type="hidden"  name="clnaddrbypass" id="clnaddrbypass" value="0">
	
  </form>
</div>


    

<%
	out.print(displayEntryModal("parent","Enter Details","Save"));
	out.print(displayEntryModal("emergency_contact","Enter Details","Save"));
	out.print(displayDeleteModal("delete","Confirm Deletion","Yes, Delete"));

%>

 <script type="text/javascript" src="/clnaddr/js/clnaddr.js?version=1003"></script>   

 <script type="text/javascript">
 
 
 $(document).ready( function(){
	$("#student_mobile_phone_check").change(function(){
		if(this.checked) {
			$("#group_student_emergency_phone").show();
			//remove requirement for mobile phone
			$("#group_student_mobile_phone .required").hide();	
			$("#student_mobile_phone").removeClass("ccreq");
			//remove requirement for phone carrier
			$("#group_student_phone_carrier .required").hide();	
			$("#student_phone_carrier").removeClass("ccreq");
			//remove text alerts checkbox
			$("#paragraph_alert_text_check").hide();
			$("#group_alert_text_check").hide();			
	    }else{
	    	$("#group_student_emergency_phone").hide();	
	    	//add requirement for mobile phone
	    	$("#group_student_mobile_phone .required").show();	
	    	$("#student_mobile_phone").addClass("ccreq");
	    	//add requirement for phone carrier
			$("#group_student_phone_carrier .required").show();	
			$("#student_phone_carrier").addClass("ccreq");
			//show text alerts checkbox
			$("#paragraph_alert_text_check").show();
			$("#group_alert_text_check").show();	
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
