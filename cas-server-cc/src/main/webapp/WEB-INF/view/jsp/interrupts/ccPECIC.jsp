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
	.edit_link{
		cursor: pointer;
		color: #337ab7;
	}
	
	.edit_link:hover{
		color: #23527c;
		text-decoration: underline;		
	}
	
	.info_box{
	   	border: 2px solid #d4e3fc;
    	border-radius: 10px;
    	margin: 0 0 10px;
    	padding: 10px 10px;
	}
	
	.info_box .row{
		padding: 0 0 5px;
	}
	
	.message {
		background: #D7EED7;
		border: 3px solid #99CC99;
		text-align:center;
		padding-bottom: 8px;
	}
	
	.errorMessage {
		background: #FFDAD9;
		border: 2px solid #FF9999;
		text-align:center;
		padding: 2px;
		/*padding-bottom: 8px;*/
		padding-top: 10px;
		clear:both;
	}
  </style>
</head>
<body>

<div class="container">
  <h2>Confirm Contact Information</h2>
  <div class="errorMessage">
  	<p>Please confirm your contact information, parent/guardian and emergency contact information by clicking the <strong>Confirm</strong> button below.</p>
  </div> 
  <%-- StudentAddr: ${StudentAddr} --%>
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
	     	<div><c:out value="${StudentAddr['ADDR_NAT_CODE'] == null ? 'U.S.' : StudentAddr['ADDR_NAT_CODE']}" /></div>
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
	    	<div>State </div>
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
	     	<div>${StudentHomePhone['PHONE_AREA_CODE']}&nbsp;${StudentHomePhone['PHONE_NUMBER']}</div>
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
  <%-- StudentCellPhone: ${StudentCellPhone} --%>
  <div id="step2">
  	<h3>Step 2 Your Emergency Contact Information</h3>	
	<div class="row">
		<div class="col-xs-3">
	    	<div>Mobile Phone </div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentCellPhone['PHONE_AREA_CODE']}&nbsp;${StudentCellPhone['PHONE_NUMBER']}</div>
	  	</div>
	</div>
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
	<div class="row">
		<div class="col-xs-3">
	    	<div>Opt Out of Campus Alerts</div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentBio['EMERG_AUTO_OPT_OUT']}</div>
	  	</div>
	</div>
  </div>
  
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
  	
  	<div class="confirm_section">
  		<c:set var="y" value="0" scope="page" />	
	  	 <c:forEach items="${StudentEMR}" var="contacts">
	  	 	<c:set var="y" value="${y + 1}" scope="page" />	
	    	<div class="contact_info info_box" id="CONTACT_${contacts.PARENT_PPID}" data-type-id="CONTACT" data-ppid="${contacts.PARENT_PPID}">
				<h4>Emergency Contact ${y}</h4>
		    </div>			        
	    </c:forEach> 
	    <c:if test="${y == 0 }">
	    	<p><em>None Entered</em></p>
	    </c:if>   
    </div>
  </div>
  
   <div id="step5">
  	<h3>Step 5 Campus Alert Phone Numbers <small><span class="edit_link">Edit Campus Alert Phone Numbers</span></small></h3>
  	<%-- EmmergPhones: ${EmmrgPhones} --%>
  	<div class="confirm_section">
  	<p id="doc_message">These numbers will be contacted in the case of a campus emergency.</p>
  		<ul>
		    <c:forEach items="${EmmrgPhones}" var="emmrg">
		    	 <c:if test="${fn:length(fn:substringAfter(emmrg.PHONE_CODE,'EP')) != 0 }">
		    	 	<li class="list-unstyled">&nbsp;${emmrg.PHONE_AREA_CODE}&nbsp;${emmrg.PHONE_NUMBER}&nbsp;(${emmrg.PREF_NAME })</li>
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

/*window.onbeforeunload = confirmExit;
function confirmExit() {
    return "You will need to click Confirm to save your information, otherwise all of your data will be lost. Are you sure you want to close this window?";
}*/

$(document).ready(function() {	
	
	var demoFields = ["PARENT_LEGAL_PREFIX_NAME","PARENT_PREF_FIRST_NAME","PARENT_PREF_MIDDLE_NAME","PARENT_PREF_LAST_NAME","PARENT_LEGAL_SUFFIX_NAME","DEPENDENT","ADDR_STREET_LINE1","ADDR_STREET_LINE2","ADDR_CITY","ADDR_STAT_CODE","ADDR_ZIP","ADDR_NATN_CODE","EMAIL_ADDRESS","EMERG_LEGAL_PREFIX_NAME","EMERG_PREF_FIRST_NAME","EMERG_PREF_MIDDLE_NAME","EMERG_PREF_LAST_NAME","EMERG_LEGAL_SUFFIX_NAME","DEPENDENT","ADDR_STREET_LINE1","ADDR_STREET_LINE2","ADDR_CITY","ADDR_STAT_CODE","ADDR_ZIP","ADDR_NATN_CODE","EMAIL_ADDRESS"];
	var demoValues = ["Prefix","First Name","Middle Name","Last Name","Suffix","Dependent","Address 1","Address 2","City","State","Zip/Postal","Country","Email Address","Prefix","First Name","Middle Name","Last Name","Suffix","Dependent","Address 1","Address 2","City","State","Zip/Postal","Country","Email Address"]
	var contactFields = ["EMERG_LEGAL_PREFIX_NAME","EMERG_PREF_FIRST_NAME","EMERG_PREF_MIDDLE_NAME","EMERG_PREF_LAST_NAME","EMERG_LEGAL_SUFFIX_NAME","DEPENDENT","ADDR_STREET_LINE1","ADDR_STREET_LINE2","ADDR_CITY","ADDR_STAT_CODE","ADDR_ZIP","ADDR_NATN_CODE","EMAIL_ADDRESS"];
	var contactValues = ["Prefix","First Name","Middle Name","Last Name","Suffix","Dependent","Address 1","Address 2","City","State","Zip/Postal","Country","Email Address"]
	var phoneFields = ["PECI_PHONE_CODE","PHONE_AREA_CODE","PHONE_NUMBER","CELL_PHONE_CARRIER"];
	var phoneValues= ["Phone Type","Area Code","Phone Number","Phone Carrier"]
	
	$student_PIDM = ${StudentBio['STUDENT_PIDM']};	
	var x = 0;
	var y= 0;
			
	$('.contact_info').each(function(){
		var ppid = $(this).attr("data-ppid");
		var type_id = $(this).attr("data-type-id");
		console.log('ppid: ' + ppid);
		if(ppid != ''){
			//console.log('ppid2: ' + ppid);
			$.ajax({
			       type: "POST",
			       url: '/cas/cas-rest-api/peci/',
			       data: JSON.stringify({"PIDM": $student_PIDM, "PPID": ppid, "DATA": type_id, "MODE": "READ"}),
			       datatype: "json",
			       contentType: "application/json",
			       success: function(data)           
			       {  
			    	   var output = '';
			    	   //y ++;
			    	   //$('#contact_' + ppid).append('<h4>Emergency Contact ' + y + '</h4>');
			    	   if(type_id == 'CONTACT'){
				    	   $.each(data.contact, function(index, element){				       		
				       		var output = '';				       		
				       		var loc = demoFields.indexOf(index); 					       		
				       		if(loc != -1){
				       			
				       			output += '<div class="row"><div class="col-xs-3"><div>' + demoValues[loc] + '</div></div><div class="col-xs-9"><div>';
				       			if(element != null){
				       				output += element;
				       			}
				       			output += '</div></div></div>';
				       		}	
				       		$('#' + type_id + '_' + ppid).append(output);
				       	  });
			    	   }else{
			    		   $.each(data.parent, function(index, element){
					       		//console.log("-parent- index: " + index + " element:" + element);
					       	 	var output = '';					       		
					       		var loc = demoFields.indexOf(index); 		       		
					       		if(loc != -1){
					       			output += '<div class="row"><div class="col-xs-3"><div>' + demoValues[loc] + '</div></div><div class="col-xs-9"><div>';
					       			if(element != null){
					       				output += element;
					       			}
					       			output += '</div></div></div>';
					       		}	
					       		$('#' + type_id + '_' + ppid).append(output);
					       	  });
			    	   }
			    	   
			    	   
			       	  //use first email: data.parent_email[0]?
			       	if (data.email[0] != undefined && data.email[0] != null && data.email[0].length != 0){
			       	  $.each(data.email[0], function(index,element){
			       		//console.log("-parent- index: " + index + " element:" + element);
				       		var output = '';			       		
				       		var loc = demoFields.indexOf(index); 	
				       		//console.log("loc: " + loc + "ppid: " + ppid);
				       		if(loc != -1){
				       			output += '<div class="row"><div class="col-xs-3"><div>' + demoValues[loc] + '</div></div><div class="col-xs-9"><div>';
				       			if(element != null){
				       				output += element;
				       			}
				       			output += '</div></div></div>';	 
				       		}
				       		$('#' + type_id + '_' + ppid).append(output);
			       	  });
			       	}
			       	  
			       	  
			       	  //use first address: data.parent_address[0]?

			       	  $.each(data.address, function(index,element){
			       		//console.log("-contact- index: " + index + " element:" + element);
				       		var output = '';			       		
				       		var loc = demoFields.indexOf(index); 
				       		//console.log("Address: loc: " + loc + "ppid: " + ppid);
				       		if(loc != -1){
				       			//console.log("Address: loc: " + loc);
				       			output += '<div class="row"><div class="col-xs-3"><div>' + demoValues[loc] + '</div></div><div class="col-xs-9"><div>';
				       			if(element != null){
				       				output += element;
				       			}
				       			output += '</div></div></div>';
				       		}      	
	
				       		$('#' + type_id + '_' + ppid).append(output);
		
			          });

			       	
			       	//phones
			       	for(i=0;i<data.phones.length;i++){
			       		var phone_code = data.phones[i].PHONE_CODE;
		        		//var phone_number = data.phones[i].PHONE_AREA_CODE + data.phones[i].PHONE_NUMBER;
		        		var phone_area_code = data.phones[i].PHONE_AREA_CODE;
		        		var phone_number = data.phones[i].PHONE_NUMBER;
		        		var phone_number_intl = data.phones[i].PHONE_NUMBER_INTL;
		        		if(phone_number_intl.length > 0){
		        			phone_display = phone_number_intl;
		        		}else{
		        			phone_display =  phone_area_code + ' ' + phone_number;
		        		}
		        		var phone_sequence_no = data.phones[i].PHONE_SEQUENCE_NO;
		        		var phone_carrier = data.phones[i].CELL_PHONE_CARRIER;
		        		var output = '';
		        		if(phone_code == 'CP'){
		       				phone_type = 'Mobile';
		       			}else if(phone_code == 'MA'){
		       				phone_type = 'Home';
		       			}else if(phone_code == 'BU'){
		       				phone_type = 'Office';					       			
		       			}
		        		output += '<div class="row"><div class="col-xs-3"><div>' + phone_type + ' Phone</div></div><div class="col-xs-9">' + phone_display + '<div>';
		        		output += '</div></div></div>';
				       	$('#' + type_id + '_' + ppid).append(output);
			       	}
			       	
			       	  
/* 			       	$.each(data.phones, function(index1,element1){
							//console.log("index1: " + index1); 
			    		  $.each(this, function(index2,element2){  
			    			  console.log(index2['PHONE_CODE']);
					       		var output = '';			       		
					       		var loc = phoneFields.indexOf(index2);
					       		var thisTitle = phoneValues[loc];
					       		if(index1 == 1){
					       			var thisTitle = "Additional " + thisTitle;
					       		}else if(index1 != 0){
					       			var thisTitle = "Additional " + thisTitle + " " + index1;
					       		}
					       		if(loc != -1){
					       			output += '<div class="row"><div class="col-xs-3"><div>' + thisTitle + '</div></div><div class="col-xs-9"><div>';
					       			if(index2 == 'PHONE_CODE'){
						       			if(element2 == 'CP'){
						       				output += 'Mobile';
						       			}else if(element2 == 'MA'){
						       				output += 'Home';
						       			}else if(element2 == 'BU'){
						       				output += 'Office';					       			
						       			}
					       			}else if(element2 != null){
					       				output += element2;
					       			}
					       			output += '</div></div></div>';	
					       		}
					       		$('#' + type_id + '_' + ppid).append(output);
			        		  
			      			  //console.log(peci_phone_code);
			      			  //console.log(peci_phone_code);
			    			  //console.log("peci phone code" +  index[element]);        			  
			    		  });
			    		  //console.log("-parent_phones-index: " + index + " element:" + element['PHONE_NUMBER']);
			      	  	//$('#' + $modal_type + "_" + index).val(element); 		   
			      	  }); */
			       	  
		
			       },
			 		error: function (request, status, error) {
		           console.log("ERROR: " + request.responseText);
		       }
			});
		}
			
	});
	
	$('.edit_link').click(function(){
		$('#editForm').submit();
	});	
	
	$('#confirm_button').click(function(){
		$('#confirmForm').submit();
	});
	
});

</script>
  	

</body>
</html>
