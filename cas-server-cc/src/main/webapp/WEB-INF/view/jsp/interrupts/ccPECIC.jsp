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
  </style>
</head>
<body>

<div class="container">
  <h2>Confirm Contact Information</h2>
  <p>Please confirm your contact information, parent/guardian and emergency contact information below.</p> 
  
  <div id="step1">
  	<h3>Step 1 Verify Your Permanent Mailing Address <small><a href="?interrupt=PECIE" class="edit_link">Edit My Info</a></small></h3>	
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
	     	<div>${StudentAddr['ADDR_NAT_CODE']}</div>
	  	</div>
	</div>
	<div class="row">
		<div class="col-xs-3">
	    	<div>City </div>
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
	     	<div>(${StudentHomePhone['PHONE_AREA_CODE']}) ${StudentHomePhone['PHONE_NUMBER']}</div>
	  	</div>
	</div>
  </div>
  <div id="step2">
  	<h3>Step 2 Your Emergency Contact Information</h3>	
	<div class="row">
		<div class="col-xs-3">
	    	<div>Mobile Phone </div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>(${StudentCellPhone['PHONE_AREA_CODE']}) ${StudentCellPhone['PHONE_NUMBER']}</div>
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
	     	<div>${StudentCellPhone['EMERG_SEND_TEXT']}</div>
	  	</div>
	</div>
		<div class="row">
		<div class="col-xs-3">
	    	<div>TTY Device</div>
	 	</div>
	 	<div class="col-xs-9">
	     	<div>${StudentCellPhone['PHONE_TTY_DEVICE']}</div>
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
  
  <div id="step3">
  	<h3>Step 3 Parent/Guardian Information <small><a href="?interrupt=PECIE" class="edit_link">Edit Parent/Guardian Info</a></small></h3>	
  	<h4>Parent/Guardian 1</h4>
  	<div class="confirm_section">
	  	<!--<c:forEach var="i" items="First Name, Middle Name, Last Name, Mobile Phone, Phone Carrier, Preferred Email, Relationship, Address 1, Address 2, Country, City, State, Zip, Claims me as dependent">
		  	<div class="row">
		      <div class="col-xs-3">
		          <div><c:out value="${i}" /></div>
		      </div>
		      <div class="col-xs-9">
		          <div><c:out value="${i}" /></div>
		      </div> 
		    </div>
	    </c:forEach>-->
	    
	    <c:forEach items="${StudentParents}" var="parents">
	    	<div class="parent_info" id="${parents.PARENT_PPID}">
		    	<div class="row">
			      <div class="col-xs-3">
			          <div>First Name</div>
			      </div>
			      <div class="col-xs-9">
			          <div>${parents.PARENT_PREF_FIRST_NAME }</div>
			      </div> 
			    </div>
			    <div class="row">
			      <div class="col-xs-3">
			          <div>Middle Name</div>
			      </div>
			      <div class="col-xs-9">
			          <div>${parents.PARENT_PREF_MIDDLE_NAME }</div>
			      </div> 
			    </div>
			    <div class="row">
			      <div class="col-xs-3">
			          <div>Last Name</div>
			      </div>
			      <div class="col-xs-9">
			          <div>${parents.PARENT_PREF_LAST_NAME }</div>
			      </div> 
			    </div>	
		    </div>	    
	    </c:forEach>    
	    
    </div>
  </div>
  
    <div id="step4">
  	<h3>Step 4 Emergency Contacts <small><a href="?interrupt=PECIE" class="edit_link">Edit or Reorder Contacts</a></small></h3>
  	<h4>Emergency Contact 1</h4>	
  	<div class="confirm_section">
	  	<c:forEach var="i" items="First Name, Middle Name, Last Name, Mobile Phone, Phone Carrier, Preferred Email, Relationship, Address 1, Address 2, Country, City, State, Zip">
		  	<div class="row">
		      <div class="col-xs-3">
		          <div><c:out value="${i}" /></div>
		      </div>
		      <div class="col-xs-9">
		          <div><c:out value="${i}" /></div>
		      </div>
		    </div>
	    </c:forEach>
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

$(document).ready(function() {	
	
	var demoFields = ["PARENT_LEGAL_PREFIX_NAME","PARENT_PREF_FIRST_NAME","PARENT_PREF_MIDDLE_NAME","PARENT_PREF_LAST_NAME","PARENT_LEGAL_SUFFIX_NAME","DEPENDENT","ADDR_STREET_LINE1","ADDR_STREET_LINE2","ADDR_CITY","ADDR_STAT_CODE","ADDR_ZIP","ADDR_NATN_CODE","EMAIL_ADDRESS"];
	var demoValues = ["Prefix","First Name","Middle Name","Last Name","Suffix","Dependent","Address 1","Address 2","City","State","Zip/Postal","Country","Email Address"]
	var phoneFields = ["PECI_PHONE_CODE","PHONE_AREA_CODE","PHONE_NUMBER","CELL_PHONE_CARRIER"];
	var phoneValues= ["Phone Type","Area Code","Phone Number","Phone Carrier"]
	


	var fruits = ["Banana", "Orange", "Apple", "Mango"];
	var a = demoFields.indexOf("PARENT_PREF_FIRST_NAME"); 
	console.log('a: ' + a);
	console.log('value: ' + demoValues[a]);
	
	$student_PIDM = ${StudentBio['STUDENT_PIDM']};	
	
	$('.parent_info').each(function(){
		$ppid = $(this).attr("id");
		$.ajax({
		       type: "POST",
		       url: '/cas/cas-rest-api/peci/',
		       data: JSON.stringify({"PIDM": $student_PIDM, "PPID": $ppid, "DATA": "PARENT", "MODE": "READ"}),
		       datatype: "json",
		       contentType: "application/json",
		       success: function(data)           
		       {  
		    	   var output = '';
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
		       	  });
		    	   $('#' + $ppid).append(output);
		    	   
		       	  //use first email: data.parent_email[0]?
		       	  $.each(data.email[0], function(index,element){
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
		       	  });
		       	  $('#' + $ppid).append(output);
		       	  
		       	  //use first address: data.parent_address[0]?
		       	  $.each(data.address[0], function(index,element){
		       		
			       		var output = '';			       		
			       		var loc = demoFields.indexOf(index); 		       		
			       		if(loc != -1){
			       			output += '<div class="row"><div class="col-xs-3"><div>' + demoValues[loc] + '</div></div><div class="col-xs-9"><div>';
			       			if(element != null){
			       				output += element;
			       			}
			       			output += '</div></div></div>';
			       		}      	

		       		$('#' + $ppid).append(output);
	
		          });
		       	  
		       	$.each(data.phones, function(index1,element1){
						console.log("index1: " + index1); 
		    		  $.each(this, function(index2,element2){  
		    			  
				       		var output = '';			       		
				       		var loc = phoneFields.indexOf(index2);
				       		console.log("loc: " + loc); 
				       		var thisTitle = phoneValues[loc];
				       		if(index1 == 1){
				       			var thisTitle = "Additional " + thisTitle;
				       		}else if(index1 != 0){
				       			var thisTitle = "Additional " + thisTitle + " " + index1;
				       		}
				       		if(loc != -1){
				       			output += '<div class="row"><div class="col-xs-3"><div>' + thisTitle + '</div></div><div class="col-xs-9"><div>';
				       			if(index2 == 'PECI_PHONE_CODE'){
					       			if(element2 == 'C'){
					       				output += 'Mobile';
					       			}else if(element2 == 'H'){
					       				output += 'Home';
					       			}else if(element2 == 'O'){
					       				output += 'Office';					       			
					       			}
				       			}else if(element2 != null){
				       				output += element2;
				       			}
				       			output += '</div></div></div>';	
				       		}
				       		$('#' + $ppid).append(output);
		        		  
		      			  //console.log(peci_phone_code);
		    			  //console.log("peci phone code" +  index[element]);        			  
		    		  });
		    		  //console.log("-parent_phones-index: " + index + " element:" + element['PHONE_NUMBER']);
		      	  	//$('#' + $modal_type + "_" + index).val(element); 		   
		      	  });
		       	  
	
		       },
		 		error: function (request, status, error) {
	           console.log("ERROR: " + request.responseText);
	       }
	    });
		
		$('.edit_link').click(function{
			$('#editForm').submit();
		});
	});
	
	
	
	
	/*$.ajax({
       type: "POST",
       url: '/cas/cas-rest-api/peci/',
       data: JSON.stringify({"PIDM": $student_PIDM, "PPID": $PPID, "DATA": $modal_type, "MODE": "READ"}),
       datatype: "json",
       contentType: "application/json",
       success: function(data)           
       {           	   
    	  $.each(data.parent, function(index, element){
    		//console.log("-parent- index: " + index + " element:" + element);
    	   	$('#' + index).val(element);
    	  });
    	  //use first email: data.parent_email[0]?
    	  $.each(data.parent_email[0], function(index,element){
    		 //console.log("-parent_email-index: " + index + " element:" + element);
    	  	$('#' + $modal_type + "_" + index).val(element); 		   
    	  });
    	  //use first address: data.parent_address[0]?
    	  $.each(data.parent_address[0], function(index,element){
    		  //console.log("index: " + index + " element:" + element);
    		  if(index == 'ADDR_NATN_CODE' && element == null){
    			$('#' + $modal_type + "_" + index).val('US');
    		  }else{
      	  		$('#' + $modal_type + "_" + index).val(element);
    		  }
      	  });
    	  $.each(data.parent_phones, function(index1,element1){
    		  //console.log("index: " + index1);
    		  $('#group_parent_phone' + index1 + '_section').show();
    		  
    		  $.each(this, function(index2,element2){        			  
        		  if(index2 == 'PECI_PHONE_CODE'){
        			  $('#' + $modal_type + '_PHONE_' + index1 + '_TYPE').val(element2);
        			  //peci_phone_code[index1] = element2;
        			  //console.log("peci_phone_code [" + index1 + "]:" + peci_phone_code[index1]);
        		  }else if(index2 == 'PHONE_AREA_CODE'){
        			  $('#' + $modal_type + '_PHONE_' + index1 + '_NUMBER').val(element2);
        			  //phone_area_code[index1] = element2;
        			  //console.log("phone area code: " + phone_area_code[index1]);
        		  }else if(index2 == 'PHONE_NUMBER'){
        			  $('#' + $modal_type + '_PHONE_' + index1 + '_NUMBER').val($('#' + $modal_type + '_PHONE_' + index1 + '_NUMBER').val() + element2);
        			  //phone_number[index1] = element2;
        			  //console.log("phone number:" + phone_number[index1]);
        		  } 		
      			  //console.log(peci_phone_code);
    			  //console.log("peci phone code" +  index[element]);        			  
    		  });
    		  //console.log("-parent_phones-index: " + index + " element:" + element['PHONE_NUMBER']);
      	  	//$('#' + $modal_type + "_" + index).val(element); 		   
      	  });
       },
       error: function (request, status, error) {
           console.log("ERROR: " + request.responseText);
       }
    });		    
	
	$('#' + $modal_type + "_MODAL").modal('show');*/
});

</script>
  	

</body>
</html>
