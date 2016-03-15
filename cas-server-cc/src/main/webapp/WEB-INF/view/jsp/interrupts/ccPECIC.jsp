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
  	<c:forEach var="i" items="Address 1,Address 2,Country,City,State,Zip,Home Phone">
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
  <div id="step2">
  	<h3>Step 2 Your Emergency Contact Information</h3>	
  	<c:forEach var="i" items="Mobile Phone, Phone Carrier, Send Text, TTY, Non-college email">
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
  
  <div id="step3">
  	<h3>Step 3 Parent/Guardian Information <small><a href="?interrupt=PECIE" class="edit_link">Edit Parent/Guardian Info</a></small></h3>	
  	<h4>Parent/Guardian 1</h4>
  	<div class="confirm_section">
	  	<c:forEach var="i" items="First Name, Middle Name, Last Name, Mobile Phone, Phone Carrier, Preferred Email, Relationship, Address 1, Address 2, Country, City, State, Zip, Claims me as dependent">
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

  	

</body>
</html>
