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

<%!


   public String test() {
	   String fieldOut = "";
      // Create a hash map
      HashMap hm = new HashMap();
      // Put elements to the map
      hm.put("Zara", new Double(3434.34));
      hm.put("Mahnaz", new Double(123.22));
      hm.put("Ayan", new Double(1378.00));
      hm.put("Daisy", new Double(99.22));
      hm.put("Qadir", new Double(-19.08));
      
      // Get a set of the entries
      RequestContext requestContext = RequestContextHolder.getRequestContext();
    	
      
      Set set = hm.entrySet();
      //Set set = requestContext.getFlowScope().get("options");
      
      // Get an iterator
      Iterator i = set.iterator();
      fieldOut = fieldOut + "test:::";
      // Display elements
      while(i.hasNext()) {
         Map.Entry me = (Map.Entry)i.next();
         fieldOut = fieldOut + me.getKey() + ": ";
         fieldOut = fieldOut + me.getValue();
      }
      return fieldOut;
   }


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

public String displayInput(boolean required, String css_class, String label, int label_column, int div_column, String field_name, String field_for, String field_value, boolean displayed,boolean disabled){
	String fieldOut = "";
	
	fieldOut = fieldOut + displayError(label,field_name);
	
	fieldOut = fieldOut + displaySectionStart(required,field_name,label,label_column,div_column,field_for,displayed);
	
	fieldOut = fieldOut + "<input id=\"" + field_name + "\" type=\"" + field_for + "\" class=\"form-control ";  
	if(required){
		fieldOut = fieldOut + " ccreq ";
	}	
	fieldOut = fieldOut + css_class + " \"";
	fieldOut = fieldOut + "\" name=\"" + field_name + "\" placeholder=\"" + label + "\"";
	if(disabled){
		fieldOut = fieldOut + " disabled=\"disabled\"";
	}
	
	fieldOut = fieldOut + ">";
	
	fieldOut = fieldOut + "</div>";
	fieldOut = fieldOut + "</div>"; 
	return fieldOut;
}

public String displayCheckbox(boolean required, String label, int label_column, int div_column, String field_name, String field_for, String field_value, String question, boolean bootstrap_switch, boolean checked, String help_title, String help_text){
	String fieldOut = "";	
	if(question.length() > 0){
	    fieldOut = fieldOut + "<p id=\"paragraph_" + field_name + "\" class=\"q_check\">" + question + "</p>";
	}	
	
	fieldOut = fieldOut + displayError(label,field_name);
		
	fieldOut = fieldOut + "<div id=\"group_" + field_name + "\" class=\"form-group\">";      
	fieldOut = fieldOut + "<div class=\"col-sm-offset-1 col-sm-10\">";
	fieldOut = fieldOut + "<div class=\"checkbox\">";
	fieldOut = fieldOut + "<label><input id=\"" + field_name + "\" type=\"checkbox\" name=\"" + field_name + "\" class=\"";
	if(required){
		fieldOut = fieldOut + " ccreq";
	}
	if(bootstrap_switch){
		fieldOut = fieldOut + " bootstrap-switch";
	}
	fieldOut = fieldOut + "\"";
	if(checked){
		fieldOut = fieldOut + " checked=\"checked\"";
	}
	fieldOut = fieldOut + ">";
	fieldOut = fieldOut + label + "</label>";
	if(help_text.length() > 0){
		//fieldOut = fieldOut + "<div class=\"input-group-btn\">	<button class=\"btn btn-default\" type=\"submit\" data-toggle=\"popover\" data-trigger=\"hover\" data-placement=\"right\" data-content=\"Hello popover content.\"><i class=\"glyphicon glyphicon-check\"></i></button></div>";
		//fieldOut = fieldOut + "<a tabindex=\"0\" class=\"btn btn-lg btn-danger\" role=\"button\" data-toggle=\"popover\" data-placement=\"left\" data-trigger=\"focus\" title=\"Dismissible popover\" data-content=\"And here's some amazing content. It's very engaging. Right?\">Dismissible popover</a>";
		fieldOut = fieldOut + "<a aria-hidden=\"true\" tabindex=\"0\" role=\"button\"  class=\"glyphicon glyphicon-question-sign\" data-html=\"true\" data-toggle=\"popover\" data-trigger=\"focus\" data-title=\"" + help_title + "\" data-placement=\"top\" data-content=\"" + help_text + "\"></a>";
	}
	fieldOut = fieldOut + "</div>";
	fieldOut = fieldOut + "</div>";
	fieldOut = fieldOut + "</div>";   
  return fieldOut;
	
}

public Object displayDropdown(boolean required, String css_class, String label, int label_column, int div_column, String field_name, String field_for, String field_value,boolean displayed,boolean disabled){
	String fieldOut = "";	
	//fieldOut = fieldOut + test(); 
	
	RequestContext requestContext = RequestContextHolder.getRequestContext();
    //requestContext.getFlowScope().get("options");    
    	
	fieldOut = fieldOut + displayError(label,field_name);
    
    fieldOut = fieldOut + displaySectionStart(required,field_name,label,label_column,div_column,field_for,displayed);
	fieldOut = fieldOut + "<select id=\"" + field_name + "\" name=\"" + field_name + "\" placeholder=\"" + label + "\" class=\"form-control";
	if(required){
		fieldOut = fieldOut + " ccreq";
	}	
	fieldOut = fieldOut + css_class + " \"";
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
  	ModalOut = ModalOut + displayInput(true,"","First Name",4,6,type + "_first_name","text","",true,false);
  	ModalOut = ModalOut + displayInput(false,"","Middle Name",4,6,type + "_middle_name","text","",true,false);
  	ModalOut = ModalOut + displayInput(true,"", "Last Name",4,6, type + "_last_name" , "text","", true, false);
  	ModalOut = ModalOut + displayInput(true,"", "Mobile Phone",4,6, type + "_mobile_phone" , "tel","", true, false);
  	ModalOut = ModalOut + displayDropdown(true,"","Phone Carrier",4,6,type + "_phone_carrier","","",true,false);
  	ModalOut = ModalOut + displayCheckbox(false,"This person does not have a mobile phone",4,6, type +"_mobile_phone_check", "", "", "",false,false,"","");
  	ModalOut = ModalOut + displayInput(true,"", "Additional Phone",4,6, type + "_addional_phone1" , "tel","", true, false);
  	ModalOut = ModalOut + displayDropdown(false,"","Phone Carrier",4,6,type + "_additional_phone1_carrier","","",true,false);	  	
  	ModalOut = ModalOut + displayInput(true,"","Preferred Email",4,6, type + "_preferred_email" , "email","", true, false);
  	ModalOut = ModalOut + displayDropdown(true,"","Relationship",4,6,type + "_relationship","","",true,false);
  	if(type == "emergency_contact"){
  		//address not required for emergency contact
	  	ModalOut = ModalOut + displayInput(false,"address_field","Address 1",4,6,type + "_address1","text","",true,false);
	  	ModalOut = ModalOut + displayInput(false,"address_field","Address 2",4,6,type + "_address2","text","",true,false);
  		//ModalOut = ModalOut + displayCountries();
	  	//ModalOut = ModalOut + displayDropdown(false,"Country",4,6,type + "_country","","",true,false);
	  	ModalOut = ModalOut + displayInput(true,"address_field","City",4,6,type + "_city","city","",true,false);
	  	ModalOut = ModalOut + displayDropdown(false,"address_field","State",4,6,type + "_state","","",true,false);
	  	ModalOut = ModalOut + displayInput(false,"address_field","Postal Code",4,6,type + "_student_postal_code","postal code","",true,false);	  	
  	}else{
	  	ModalOut = ModalOut + displayInput(true,"address_field","Address 1",4,6,type + "_address1","text","",true,false);
	  	ModalOut = ModalOut + displayInput(false,"address_field","Address 2",4,6,type + "_address2","text","",true,false);
	  	ModalOut = ModalOut + displayDropdown(true,"address_field","Country",4,6,type + "_country","","",true,false);
	  	ModalOut = ModalOut + displayDropdown(true,"address_field","City",4,6,type + "_city","","",true,false);
	  	ModalOut = ModalOut + displayDropdown(true,"address_field","State",4,6,type + "_state","","",true,false);
	  	ModalOut = ModalOut + displayInput(true,"address_field","Postal Code",4,6,type + "_student_postal_code","postal code","",true,false);
	  	ModalOut = ModalOut + displayCheckbox(false," This parent claims me as a dependent ",4,6, type +"_dependent_check", "", "", "",true,true,"U.S. Tax Dependence Status Info","Please indicate whether your parents claim you as a tax dependent for federal income tax purposes. This is turned on by default. <a href='http://www.conncoll.edu/academics/registrar/ferpa/' target='_blank'> FERPA Information</a>.");
  	}
  	//save and close buttons
	ModalOut = ModalOut + displayModalEnd(action);
  	return ModalOut;
}

/*public String displayCountries(){
	String ModalOut = "";
	ModalOut = ModalOut + "<div class=\"form-group\" id=\"group_student_country\">";
	ModalOut = ModalOut + "<label for=\"country\" class=\"control-label col-sm-2\"><span class=\"required\">* </span>Country</label>";
			ModalOut = ModalOut + "<div class=\"col-sm-10\">";
					ModalOut = ModalOut + "<select class=\"form-control ccreq\" placeholder=\"Country\" name=\"student_country\" id=\"student_country\">";
							ModalOut = ModalOut + "<option value=\"\">Choose Country</option>";
			<c:forEach items="${options['Countries']}" var=\"countries\">
				ModalOut = ModalOut + "<option value=" + ${countries.key} + "\">" + ${countries.value} + "</option>";
			</c:forEach>
			ModalOut = ModalOut + "</select>";
		ModalOut = ModalOut + "</div>";
	ModalOut = ModalOut + "</div>";
}*/ 

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
  <form class="form-horizontal" role="form" id="student" onsubmit="return formValidate(this.id)"> 
  <div id="step1" class="form_section">
	<h3>Step 1 Verify Your Permanent Mailing Address</h3>
	<p>Please do not enter your local or campus address. </p>

	<p><span class="required">* </span>Required Field</p>  
		
	<div class="form-group" id="group_student_firstname">
		<label for="country" class="control-label col-sm-2">First Name</label>
		<div class="col-sm-10">
				<input type="text" disabled="disabled" placeholder="First Name" name="student_first_name" class="form-control" id="student_first_name">
		</div>
	</div>
	<div class="form-group" id="group_student_middle_name">
		<label for="country" class="control-label col-sm-2">Middle Name</label>
		<div class="col-sm-10">
				<input type="text" disabled="disabled" placeholder="Middle Name" name="student_middle_name" class="form-control" id="student_middle_name">
		</div>
	</div>
	<div class="form-group" id="group_student_last_name">
		<label for="country" class="control-label col-sm-2">Last Name</label>
		<div class="col-sm-10">
				<input type="text" disabled="disabled" placeholder="Last Name" name="student_last_name" class="form-control" id="student_last_name">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_address1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address1">
		<label for="country" class="control-label col-sm-2"><span class="required">* </span>Address 1</label>
		<div class="col-sm-10 address_field">
				<input type="text" placeholder="Address 1" name="student_address1" class="form-control" id="student_address1">
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_address2_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_address2">
		<label for="country" class="control-label col-sm-2">Address 2</label>
		<div class="col-sm-10 address_field">
				<input type="text" placeholder="Address 2" name="student_address2" class="form-control" id="student_address2">
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
		<label for="country" class="control-label col-sm-2"><span class="required">* </span>Country</label>
		<div class="col-sm-10 address_field">
			<select class="form-control ccreq" placeholder="Country" name="student_country" id="student_country">
				<option value="">Choose Country</option>
				<c:forEach items="${options['Countries']}" var="countries">
					<option value="${countries.key}">${countries.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_city_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_city">
		<label for="country" class="control-label col-sm-2">City</label>
		<div class="col-sm-10 address_field">
				<input type="text" placeholder="City" name="student_city" class="form-control" id="student_city">
		</div>
	</div>  
	
	<% 
			/*out.print(displayInput(true,"address_field","City",2,10,"student_city","city","",true,false));*/
	%>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_state_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_state">
		<label for="state" class="control-label col-sm-2"><span class="required">* </span>State</label>
		<div class="col-sm-10 address_field">
			<select class="form-control ccreq" placeholder="State" name="student_state" id="student_state">
				<option value="">Choose State</option>
				<c:forEach items="${options['States']}" var="states">
					<option value="${states.key}">${states.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="student_postal_code_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_student_postal_code">
		<label for="Postal Code" class="control-label col-sm-2 address_field">Postal Code</label>
		<div class="col-sm-10 address_field">
				<input type="text" placeholder="City" name="student_postal_code" class="form-control" id="student_postal_code">
		</div>
	</div> 
	<div id='student_clnaddr_results' name='student_clnaddr_results'></div>
	<div id="suggestionListDiv" style="display: none;"></div>
	<div class="form-group" id="group_student_home_phone">
		<label for="Phone" class="control-label col-sm-2">Home Phone</label>
		<div class="col-sm-10">
				<input type="text" placeholder="Home Phone" name="student_home_phone" class="form-control" id="student_home_phone">
		</div>
	</div> 
	<div class="form-group" id="group_student_non_college_email">
		<label for="Email" class="control-label col-sm-2">Non-college email</label>
		<div class="col-sm-10">
				<input type="text" placeholder="Home Phone" name="student_non_college_email" class="form-control" id="student_non_college_email">
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
	<div class="form-group" id="group_student_mobile_phone">
		<label for="Phone" class="control-label col-sm-2">Mobile Phone</label>
		<div class="col-sm-10">
				<input type="text" placeholder="Home Phone" name="student_mobile_phone" class="form-control" id="student_mobile_phone">
		</div>
	</div> 		
		<%
			/*out.print(displayInput(true,"","Mobile Phone",2,10,"student_mobile_phone","tel","",true,false));*/
		%>
		
	<div class="form-group" id="group_student_phone_carrier">
		<label for="Phone Carrier" class="control-label col-sm-2">Phone Carrier</label>
		<div class="col-sm-10">
			<select class="form-control ccreq" placeholder="Phone Carrier" name="student_phone_carrier" id="student_phone_carrier">
				<option value="">Choose Phone Carrier</option>
				<c:forEach items="${options['Carriers']}" var="carriers">
					<option value="${carriers.key}">${carriers.value}</option>
				</c:forEach>
			</select>
		</div>
	</div>
	<div class="form-group" id="group_student_mobile_phone_check">
		<div class="col-sm-offset-1 col-sm-10">
			<div class="checkbox">
				<label><input type="checkbox" name="student_mobile_phone_check" id="student_mobile_phone_check">I don't have a mobile phone</label>
			</div>
		</div>
	</div>
	<p class="q_check" id="paragraph_alert_text_check">Connecticut College will contact this number in the case of a campus emergency. Do you wish to also receive a text message at this number in the case of a campus emergency?</p>
	<div class="form-group" id="group_alert_text_check">
		<div class="col-sm-offset-1 col-sm-10">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="alert_text_check" id="alert_text_check">Yes send me a text message in the event of an emergency</label>
			</div>
		</div>
	</div>
	<div style="display:none;" role="alert" class="alert alert-danger" id="tty_device_check_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<p class="q_check" id="paragraph_tty_device_check">If your mobile phone is a TTY device (for the hearing impaired) please indicate below:</p>
	<div class="form-group" id="group_tty_device_check">
		<div class="col-sm-offset-1 col-sm-10">
			<div class="checkbox">
				<label><input type="checkbox" class="" name="tty_device_check" id="tty_device_check">This phone is a TTY device</label>
			</div>
		</div>
	</div>
	<p class="q_check" id="paragraph_alert_home_email_check">If you do not wish to receive campus alerts beyond those to your campus email and voice mail, check the box below:</p>
	<div style="display:none;" role="alert" class="alert alert-danger" id="alert_home_email_check_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
	<div class="form-group" id="group_alert_home_email_check">
		<div class="col-sm-offset-1 col-sm-10">
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
	      <div class="col-sm-offset-1 col-sm-10">
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

  </form>
</div>


<form id="clnaddr_hidden_form">
	<input type="hidden"  name="statuscode"   id="statuscode">            
    <input type="hidden"  name="dpverrorcode" id="dpverrorcode">
    <input type="hidden"  name="message"      id="message">
    <input type="hidden"  name="clnaddrbypass" id="clnaddrbypass" value="0">
</form>

  
  	<div class="modal fade" id="parent_modal" role="dialog">
	  	<div class="modal-dialog">    
		  	<!-- Modal content-->
		  	<div class="modal-content">
			  	<form class="form-horizontal" role="form" id="parent"  onsubmit="return formValidate(this.id)">
				  	<div class="modal-header">
				  		<button type="button" class="close" data-dismiss="modal">&times;</button>
				  		<h4 class="modal-title">Enter Parent Information</h4>
				  	</div>
				  	<div class="modal-body">	
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="parent_first_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_parent_first_name">
				  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>First Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="First Name" name="parent_first_name" class="form-control  ccreq" id="parent_first_name">
				  			</div>
				  		</div>
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="parent_middle_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_parent_middle_name">
				  			<label for="text" class="control-label col-sm-4">Middle Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="Middle Name" name="parent_middle_name" class="form-control" id="parent_middle_name">
				  			</div>
				  		</div>	  	
				  		
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="parent_last_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_parent_last_name">
				  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>Last Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="Last Name" name="parent_last_name" class="form-control  ccreq " id="parent_last_name">
				  			</div>
				  		</div>
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="parent_mobile_phone_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_parent_mobile_phone">
			  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
			  				<div class="col-sm-6">
			  					<input type="tel" placeholder="Mobile Phone" name="parent_mobile_phone" class="form-control  ccreq  " id="parent_mobile_phone">
			  				</div>
			  			</div>
			  			<div style="display:none;" role="alert" class="alert alert-danger" id="parent_phone_carrier_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_phone_carrier">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Phone Carrier</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Phone Carrier" name="parent_phone_carrier" id="parent_phone_carrier">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group" id="group_parent_mobile_phone_check"><div class="col-sm-offset-1 col-sm-10"><div class="checkbox"><label><input type="checkbox" class="" name="parent_mobile_phone_check" id="parent_mobile_phone_check">This person does not have a mobile phone</label></div></div></div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_addional_phone1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_addional_phone1">
							<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Additional Phone</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone" name="parent_addional_phone1" class="form-control  ccreq  " id="parent_addional_phone1">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_preferred_email_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_preferred_email">
							<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
							<div class="col-sm-6">
								<input type="email" placeholder="Preferred Email" name="parent_preferred_email" class="form-control  ccreq" id="parent_preferred_email">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_relationship_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_relationship">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Relationship</label>
							<div class="col-sm-6">
								<select class="form-control ccreq " placeholder="Relationship" name="parent_relationship" id="parent_relationship">
									<option value="">Choose Relationship</option>
									<c:forEach items="${options['Relationships']}" var="relationships">
										<option value="${relationships.key}">${relationships.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_address1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_address1">
							<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address 1</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Address 1" name="parent_address1" class="form-control  ccreq address_field " id="parent_address1">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_address2_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_address2">
							<label for="text" class="control-label col-sm-4">Address 2</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Address 2" name="parent_address2" class="form-control address_field " id="parent_address2">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_country_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_country">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Country" name="parent_country" id="parent_country">
									<option value="">Choose Country</option>
									<c:forEach items="${options['Countries']}" var="countries">
										<option value="${countries.key}">${countries.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_city_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_city">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>City</label>
							<div class="col-sm-6">
								<input type="text" placeholder="City" name="parent_city" class="form-control ccreq address_field" id="parent_city">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_state_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_state">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>State</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="State" name="parent_state" id="parent_state">
									<option value="">Choose State</option>
									<c:forEach items="${options['States']}" var="states">
										<option value="${states.key}">${states.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_student_postal_code_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_student_postal_code">
							<label for="postal code" class="control-label col-sm-4"><span class="required">* </span>Postal Code</label>
							<div class="col-sm-6">
								<input type="postal code" placeholder="Postal Code" name="parent_student_postal_code" class="form-control  ccreq address_field " id="parent_student_postal_code">
							</div>
						</div>
						<div id='parent_clnaddr_results' name='parent_clnaddr_results'></div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="parent_dependent_check_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_parent_dependent_check">
							<div class="col-sm-offset-1 col-sm-10">
								<div class="checkbox">
									<label><span class="emergency_contact_switch">&nbsp;<input type="checkbox" name="parent1" checked="checked" class="bootstrap-switch"></span> This parent claims me as a dependent</label>
							
							<a data-content="Please indicate whether your parents claim you as a tax dependent for federal income tax purposes. This is turned on by default. &lt;a href='http://www.conncoll.edu/academics/registrar/ferpa/' target='_blank'&gt; FERPA Information&lt;/a&gt;." data-placement="top" data-title="U.S. Tax Dependence Status Info" data-trigger="focus" data-toggle="popover" data-html="true" class="glyphicon glyphicon-question-sign" role="button" tabindex="0" aria-hidden="true" data-original-title="" title=""></a>
								</div>
							</div>
						</div>					  		
				  		<div class="form-group">
	  						<div class="col-sm-offset-5 col-sm-10">
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
  	
  		<div class="modal fade" id="emergency_contact_modal" role="dialog">
	  	<div class="modal-dialog">    
		  	<!-- Modal content-->
		  	<div class="modal-content">
			  	<form class="form-horizontal" role="form" id="emergency_contact"  onsubmit="return formValidate(this.id)">
				  	<div class="modal-header">
				  		<button type="button" class="close" data-dismiss="modal">&times;</button>
				  		<h4 class="modal-title">Enter Emergency Contact Information</h4>
				  	</div>
				  	<div class="modal-body">	
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_first_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_emergency_contact_first_name">
				  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>First Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="First Name" name="emergency_contact_first_name" class="form-control  ccreq" id="emergency_contact_first_name">
				  			</div>
				  		</div>
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_middle_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_emergency_contact_middle_name">
				  			<label for="text" class="control-label col-sm-4">Middle Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="Middle Name" name="emergency_contact_middle_name" class="form-control" id="emergency_contact_middle_name">
				  			</div>
				  		</div>	  	
				  		
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_last_name_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_emergency_contact_last_name">
				  			<label for="text" class="control-label col-sm-4"><span class="required">* </span>Last Name</label>
				  			<div class="col-sm-6">
				  				<input type="text" placeholder="Last Name" name="emergency_contact_last_name" class="form-control  ccreq " id="emergency_contact_last_name">
				  			</div>
				  		</div>
				  		<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_mobile_phone_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
				  		<div class="form-group" id="group_emergency_contact_mobile_phone">
			  				<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Mobile Phone</label>
			  				<div class="col-sm-6">
			  					<input type="tel" placeholder="Mobile Phone" name="emergency_contact_mobile_phone" class="form-control  ccreq  " id="emergency_contact_mobile_phone">
			  				</div>
			  			</div>
			  			<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_phone_carrier_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_phone_carrier">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Phone Carrier</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Phone Carrier" name="emergency_contact_phone_carrier" id="emergency_contact_phone_carrier">
									<option value="">Choose Phone Carrier</option>
									<c:forEach items="${options['Carriers']}" var="carriers">
										<option value="${carriers.key}">${carriers.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group" id="group_emergency_contact_mobile_phone_check"><div class="col-sm-offset-1 col-sm-10"><div class="checkbox"><label><input type="checkbox" class="" name="emergency_contact_mobile_phone_check" id="emergency_contact_mobile_phone_check">This person does not have a mobile phone</label></div></div></div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_addional_phone1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_addional_phone1">
							<label for="tel" class="control-label col-sm-4"><span class="required">* </span>Additional Phone</label>
							<div class="col-sm-6">
								<input type="tel" placeholder="Additional Phone" name="emergency_contact_addional_phone1" class="form-control  ccreq  " id="emergency_contact_addional_phone1">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_preferred_email_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_preferred_email">
							<label for="email" class="control-label col-sm-4"><span class="required">* </span>Preferred Email</label>
							<div class="col-sm-6">
								<input type="email" placeholder="Preferred Email" name="emergency_contact_preferred_email" class="form-control  ccreq" id="emergency_contact_preferred_email">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_relationship_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_relationship">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Relationship</label>
							<div class="col-sm-6">
								<select class="form-control ccreq " placeholder="Relationship" name="emergency_contact_relationship" id="emergency_contact_relationship">
									<option value="">Choose Relationship</option>
									<c:forEach items="${options['Relationships']}" var="relationships">
										<option value="${relationships.key}">${relationships.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_address1_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_address1">
							<label for="text" class="control-label col-sm-4"><span class="required">* </span>Address 1</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Address 1" name="emergency_contact_address1" class="form-control  ccreq address_field " id="emergency_contact_address1">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_address2_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_address2">
							<label for="text" class="control-label col-sm-4">Address 2</label>
							<div class="col-sm-6">
								<input type="text" placeholder="Address 2" name="emergency_contact_address2" class="form-control address_field " id="emergency_contact_address2">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_country_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_country">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>Country</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="Country" name="emergency_contact_country" id="emergency_contact_country">
									<option value="">Choose Country</option>
									<c:forEach items="${options['Countries']}" var="countries">
										<option value="${countries.key}">${countries.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_city_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_city">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>City</label>
							<div class="col-sm-6">
								<input type="text" placeholder="City" name="emergency_contact_city" class="form-control ccreq address_field" id="emergency_contact_city">
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_state_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_state">
							<label for="" class="control-label col-sm-4"><span class="required">* </span>State</label>
							<div class="col-sm-6">
								<select class="form-control ccreq" placeholder="State" name="emergency_contact_state" id="emergency_contact_state">
									<option value="">Choose State</option>
									<c:forEach items="${options['States']}" var="states">
										<option value="${states.key}">${states.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div style="display:none;" role="alert" class="alert alert-danger" id="emergency_contact_student_postal_code_error"><span aria-hidden="true" class="glyphicon glyphicon-exclamation-sign"></span><span class="sr-only">Error:</span><span class="custom-error"></span></div>
						<div class="form-group" id="group_emergency_contact_student_postal_code">
							<label for="postal code" class="control-label col-sm-4"><span class="required">* </span>Postal Code</label>
							<div class="col-sm-6">
								<input type="postal code" placeholder="Postal Code" name="emergency_contact_student_postal_code" class="form-control  ccreq address_field " id="emergency_contact_student_postal_code">
							</div>
						</div>		
						<div id='emergency_contact_clnaddr_results' name='emergency_contact_clnaddr_results'></div>		  		
				  		<div class="form-group">
	  						<div class="col-sm-offset-5 col-sm-10">
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


 <script type="text/javascript" src="/clnaddr/js/clnaddr.js?version=10031"></script>   

 <script type="text/javascript">
 

 
 $(document).ready( function(){
	 
	 $("[data-toggle=popover]").popover();
	 $("[data-toggle=tooltip]").tooltip();
 
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
