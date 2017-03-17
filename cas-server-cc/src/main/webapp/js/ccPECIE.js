$(document).ready( function(){	 
	 
	 $('#noscriptmsg').hide();
	 checked_phone_numbers = $("input[name=checked_phone_numbers]").map(function(i,c){ return c.value; });	 
	 
	 /*check parent and contact numbers on page load and disable any new entries if 5 or over entered*/
	 entryCheck();
	 		 
	 $("[data-toggle=popover]").popover();
	 $("[data-toggle=tooltip]").tooltip(); 
	 
	 /*only select Yes on parents that are listed as emergency contacts on page load*/
	 $('#CONTACT_LIST li').each(function(){
		 var thisID = $(this).attr("id");
		 shortenedID = thisID.replace('emr_contact_','');
		 if($('#PARENT_LIST #parent_' + shortenedID).length){
			 /*this contact is also a parent, flip emr switch on*/
			 $('#parent_' + shortenedID + ' .parent-bootstrap-switch').bootstrapSwitch('state',true);
			 /*remove the delete icon for this contact*/
			 $('#' + thisID + ' .deleteModal').remove(); 
		 }		 
	 });	 
	
	/*get count of number of emr switches that are "On". If only 1, make it read-only since at least 1 parent needs to be checked*/
	emr_switch_count = $('.parent-bootstrap-switch:checked').length;
	if(emr_switch_count == 1 && deanExceptionDate.length == 0){
		$('.parent-bootstrap-switch:checked').bootstrapSwitch('disabled',true);
	}	
	 	 
	$('mobile_phone_check').each(function(){
		if(this.checked){
			var form_id = $(this).closest('form').attr("id"); 
			emergencyNumberToggle(form_id, 1);
		}
	});	
 
	$('.mobile_phone_check').change(function(){
		var form_id = $(this).closest('form').attr("id");
		var checked = this.checked ? 1 : 0;
		emergencyNumberToggle(form_id, checked);
	}); 
	
	$('.modal_mobile_phone_check').each(function(){
		if(this.checked){
			var form_id = $(this).closest('form').attr("id");
			modalMobilePhoneWarning(form_id,1);
		}		
	});
	
	$('.modal_mobile_phone_check').change(function(){
		var form_id = $(this).closest('form').attr("id");
		var checked = this.checked ? 1 : 0;
		modalMobilePhoneWarning(form_id,checked);
	});	

	/*switch to international phone*/
	$('.intl_number_switch').click(function (){		
		var form_id = $(this).closest('form').attr("id");
		var phone_type = $(this).attr("data-type");
		var intl_group = '#GROUP_' + form_id + '_PHONE_' + phone_type + '_NUMBER_INTL';
		var phone_group = '#GROUP_' + form_id + '_PHONE_' + phone_type + '_NUMBER';		
		if($(intl_group).css('display') == 'none'){
			$(phone_group).hide();		
			/*show international number*/
			$(intl_group).show();
			if(form_id == 'STUDENT'){
				/*wipe out fields for student form (modal handled separatenly in submitModal function)*/
				$('#' + form_id + '_PHONE_' + phone_type + '_AREA_CODE').val('');
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER').val('');
			}
			/*change text of link*/
			$(this).html('Enter U.S. Number');
			if(phone_type == 'CP' || phone_type == 'EMERGENCY'){
				/*intl number now showing, change required fields*/
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER_INTL').addClass("ccreq");
				$('#' + form_id + '_PHONE_' + phone_type + '_AREA_CODE').removeClass('ccreq');
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER').removeClass('ccreq');			
			}			
		}else{
			$(phone_group).show();			
			$(intl_group).hide();
			if(form_id == 'STUDENT'){
				/*wipe out intl field for student form (modal handled separately in submitModal function)*/
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER_INTL').val('');
			}
 			$(this).html('Enter International Number');
			if(phone_type == 'CP' || phone_type == 'EMERGENCY'){
				/*change required fields*/
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER_INTL').removeClass("ccreq");
				$('#' + form_id + '_PHONE_' + phone_type + '_AREA_CODE').addClass('ccreq');
				$('#' + form_id + '_PHONE_' + phone_type + '_NUMBER').addClass('ccreq');			
			}			
		}	
		if(form_id == 'STUDENT'){
			addCampusAlertNumber($(this).val(), student_name, "STUDENT");
		}

	});	

	$('.student_phone_field').focusout(function(){
		var thisType = $(this).attr('data-phone-type');
		var thisIntl = $(this).attr('data-phone-intl');
		if(thisIntl == 1){
			var phone_number = $('#STUDENT_PHONE_' + thisType + '_NUMBER_INTL').val();
		}else{
			var phone_number = $('#STUDENT_PHONE_' + thisType + '_AREA_CODE').val() + '' + $('#STUDENT_PHONE_' + thisType + '_NUMBER').val();	
			addCampusAlertNumber(phone_number, student_name, "STUDENT");
		}		
		
	});
	
	/*switching off emergency contacts*/
	$('input[name="PARENT"]').on('switchChange.bootstrapSwitch', function(event, state) {
		var ppid = $(this).attr("data-ppid");
		var thisName = $('#parent_' + ppid + ' .contact-name').html();
		emergencySwitchToggle(ppid,thisName,event,state);
	});
	
	/*state/province drop-down toggle based on country chosen*/
	$('.country_field').change(function(){		
		var form_id = $(this).closest('form').attr("id");
		var thisValue = $(this).val();
		countryProvinceDisplay(form_id,thisValue);		
	});
	
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
	
	/*don't allow any special characters in phone number fields, only 0-9, backspace, delete*/
	$(".num_only").keypress(function (e) {
		if (/^\d+$/.test(e.key) ){
			/*console.log("character accepted: " + e.key)*/
		} else {
			var charCode = (e.which) ? e.which : e.keyCode
			if (e.key == 'Delete'){
				
			}else if (charCode > 31 && (charCode < 48 || charCode > 57)){
				return false;
			}
		}
	});
	
	/*don't allow any special characters in zip code, only 0-9, backspace, delete*/
	$(".zip_code").keypress(function (e) {
		if (/^[\d -]+$/.test(e.key) ){
			/*console.log("character accepted: " + e.key);*/
		} else {
			var charCode = (e.which) ? e.which : e.keyCode
			if (e.key == 'Delete'){
				
			}else if (charCode > 31 && (charCode < 48 || charCode > 57)){
				/*console.log("NOT accepted: " + e.key);*/
				return false;
				
			}
		}
	});
	
	/*don't allow foreign characters in any fields*/	
	/*addresses allow slashes, #, :, @ */
	var addressCharRegex = /[\w\s\.\d\t\'\r\@\,x16\-\#\:\+]/;
	/*all other fields don't allow slashes*/
	var textCharRegex = /[\w\s\.\d\t\'\r\,x16\-\']/;
	$("input").keypress(function(e) {
		thisID = $(this).attr("id");
		if($(this).hasClass('num_only') || $(this).attr('type') == 'email'){
			/*do nothing, these fields have their own validation*/
			/*console.log("has class num only or type=email");*/
		}else if($(this).hasClass('address_field') || $(this).hasClass('intl_number')){			
			if (addressCharRegex.test(e.key) ){
				/*console.log("character accepted: " + e.key);*/
				$('#' + thisID + '_foreign').remove();				
			} else {
				/*console.log("character not accepted: " + e.key);*/
				if(!$('#' + thisID + '_foreign').length){
					$(this).parent().append('<span id="' + thisID + '_foreign" class="text-danger">Please do not enter foreign or special characters</span>');
				}
				e.preventDefault();
		        return false;
			}		
		}else{
			if (textCharRegex.test(e.key) ){
				/*console.log("character accepted: " + e.key)*/
				$('#' + thisID + '_foreign').remove();				
			} else {				
				if(!$('#' + thisID + '_foreign').length){
					$(this).parent().append('<span id="' + thisID + '_foreign" class="text-danger">Please do not enter foreign or special characters</span>');
				}
				e.preventDefault();
		        return false;
			}		

		}
	});
	
	//jump to next form field
	$(".area_code").on('input',function () {
	    if($(this).val().length == $(this).attr('maxlength')) {
	    	/*move on to phone_number field*/
	    	var inputs = $(this).closest('form').find(':input');
	    	inputs.eq( inputs.index(this)+ 1 ).focus();
	    	//hide the error message
/* 	    	var thisID = $(this).attr("id");
	    	$('#' + thisID + '_ERROR').hide(); */
	    }
	});
	
/* 	$(".phone_number").on('input',function () {
	    if($(this).val().length == $(this).attr('maxlength')) {
	    	//hide the error message
	    	var thisID = $(this).attr("id");
	    	$('#' + thisID + '_ERROR').hide();
	    }
	}); */
	
	/*reset the modal form fields if modal is closed*/
	  $('#CONTACT_MODAL').on('hidden.bs.modal', function () {			  
		 document.getElementById("CONTACT").reset();
		 if($('.modal_mobile_phone_check').is(':checked')){
			 $('.modal_mobile_phone_check').prop('checked',false).change();
		 }
		 resetIntlModalNumbers();	
		 resetPhoneSequenceNo();
  	   	$('#CONTACT_PARENT_PPID').val(0);
  	  	$('form#CONTACT #GROUP_CONTACT_ADDRESS_TO_USE').show();
  	    $('#CONTACT_CLNADDR_RESULTS').hide();
	 });
	 $('#PARENT_MODAL').on('hidden.bs.modal', function () {			 
		 document.getElementById("PARENT").reset();
		 if($('.modal_mobile_phone_check').is(':checked')){
			 $('.modal_mobile_phone_check').prop('checked',false).change();
		 }
		 resetIntlModalNumbers();
		 resetPhoneSequenceNo();
		 $('#PARENT_PARENT_PPID').val(0);	
		 $('form#PARENT #GROUP_PARENT_ADDRESS_TO_USE').show();
		 $('#PARENT_CLNADDR_RESULTS').hide();
	 });
	 
	 $('#CONTACT_MODAL, #PARENT_MODAL').on('shown.bs.modal',function(){
	  	  /*address to use checkbox, show if student address line 1 is not blank*/
	  	  if($('#STUDENT_ADDR_STREET_LINE1').val() == ''){	        		  
	  		  $('form#PARENT #GROUP_PARENT_ADDRESS_TO_USE').hide();
	  		  $('form#CONTACT #GROUP_CONTACT_ADDRESS_TO_USE').hide();
	  	  } 	  	  
	 });
	 
	 $('#ADD_PARENT,#ADD_CONTACT').click( function(){
		resetPhoneSequenceNo();
	 });
	 
	/*hide all modal error messages if modal is closed */
	$('#PARENT_MODAL, #CONTACT_MODAL, #DELETE_MODAL').on('hidden.bs.modal', function () {		
	    $('#PARENT_MODAL .alert-danger, #CONTACT_MODAL .alert-danger, #DELETE_MODAL .alert-danger, #PARENT_MODAL .alert-warning, #CONTACT_MODAL .alert-warning').hide();
		$('#PARENT_MODAL .form-group, #CONTACT_MODAL .form-group, #DELETE_MODAL .form-group').removeClass('has-error');
	});
 
	/*only allow 5 alert numbers to be checked	*/
	$('input.alert_phone_number').on('change', function() {
		alertNumberReview($(this));		
	});
	
	$('.address_to_use_checkbox').change(function(){
		var thisName = $(this).attr('name');
		var thisType = $(this).attr('data-type');
		var typeToSteal = $('#SELECT_' + thisName).val();
		var studentCountry = $('#STUDENT_ADDR_NATN_CODE').val();		
		if($(this).prop('checked')){			
			if(typeToSteal == 'STUDENT'){
				countryProvinceDisplay(thisType,studentCountry);
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
				countryProvinceDisplay(thisType,'US');
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
	return num;
}

function totalAllowed(type){
	if(type == 'PARENT'){
		return 5;
	}else{
		return 6;
	}
}

function entryCheck(){
   /*check num on both parents and contacts*/
   if(checkNum('PARENT') >= totalAllowed('PARENT')){
   disableModalEnter('PARENT');
   }else{
	   enableModalEnter('PARENT');
   }
   if(checkNum('CONTACT') >= totalAllowed('CONTACT')){
   disableModalEnter('CONTACT');
   }else{
	   enableModalEnter('CONTACT');
   }	   
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
$('#delete_form').find('#type').html(type.toLowerCase());
$('#delete_form').find('.name_block').html(name);
$('#delete_form').find('#ppid_to_delete').val(ppid);
$('#delete_form').find('#type_to_delete').val(type);	
if(type == 'PARENT'){
	$('#delete_form').find('#note').html('Please Note: this will also remove this parent from your emergency contacts if applicable');
	}
}

 function deleteIndividual(){
	 ppid_to_delete = $('#delete_form #ppid_to_delete').val();
 type = $('#delete_form  #type_to_delete').val();
 if(type = 'PARENT'){
	 performDelete(ppid_to_delete,'PARENT');
	 performDelete(ppid_to_delete,'CONTACT');
	 }else{
		 performDelete(ppid_to_delete,type);
	 }
	 	 
 } 
 
 function alertNumberReview(thisObj){
	 var alert_number_limit = 5;
	 var thisVal = $(thisObj).val();
		var alertNum = $("input[name='fields[25]']:checked").length;
   	if($("input[name='fields[25]']:checked").length > alert_number_limit) {
   		$(thisObj).prop('checked',false);
      	$('#ALERT_NUMBER_MODAL').modal();
   	}else if($(thisObj).is(':checked')){
		/*add to array if not already there*/
			if($.inArray(thisVal,checked_phone_numbers) == -1){
	 			checked_phone_numbers.push(thisVal);
	 		}
		}else if($.inArray(thisVal,checked_phone_numbers) != -1){
			checked_phone_numbers.splice( $.inArray(thisVal, checked_phone_numbers), 1 );
		}
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
    		 $('#emr_contact_'+ppid_to_delete).remove();
    	 }else{
    		 $('#parent_'+ppid_to_delete).remove();
    	 }    
		 

    	 getAlertNumbers();
		setEmrOrder();
    	entryCheck();
     },
     error: function (request, status, error) {
         /*console.log("ERROR: " + request.responseText);*/
         }
	    });			 
	 return false;
 }
 
 function countryProvinceDisplay(form_id,value){
	var intlFieldGroup = '#GROUP_' + form_id + '_INTL_REGION';
var intlField = intlFieldGroup + ' #' + form_id + '_ADDR_PROV_REGION';
var stateFieldGroup = '#GROUP_' + form_id + '_ADDR_STAT_CODE';
var stateField = stateFieldGroup + ' #' + form_id + '_ADDR_STAT_CODE';
var cityFieldGroup = '#GROUP_' + form_id + '_ADDR_CITY';
var zipFieldGroup = '#GROUP_' + form_id + '_ADDR_ZIP';		
var zipField = '#' + form_id + '_ADDR_ZIP';
if(value == 'United States' || value == "US"){
	$(stateFieldGroup).show();
	$(stateField).addClass('ccreq');
	$(stateField).removeProp('disabled');
	$(zipField).addClass('ccreq');
	$(zipField).addClass('zip_code');
	$(zipFieldGroup).show();
	$(zipFieldGroup + ' .required').show();
	$(cityFieldGroup + ' .city').html('City');
	$(intlFieldGroup).hide();
	$(intlField).prop('disabled','disabled');
}else if(value == 'Canada' || value == 'CA'){
	$(stateFieldGroup).hide();
	$(stateField).removeClass('ccreq');
	$(stateField).prop('disabled','disabled');
	$(zipField).addClass('ccreq');
	$(zipField).removeClass('zip_code');
	$(zipFieldGroup).show();
	$(zipFieldGroup + ' .required').show();
	$(cityFieldGroup + ' .city').html('City');
	$(intlFieldGroup).show();
	$(intlField).removeProp('disabled');
}else{
	$(stateFieldGroup).hide();
	$(stateField).removeClass('ccreq');
	$(stateField).prop('disabled','disabled');
	$(zipField).removeClass('ccreq');
	$(zipField).removeClass('zip_code');
	$(zipField).val('');
	$(zipFieldGroup).hide();
	$(zipFieldGroup + ' .required').hide();
	$(cityFieldGroup + ' .city').html('Postal Code & City');
	$(intlFieldGroup).show();
	$(intlField).removeProp('disabled');
	}
 }
 
 function formValidate(form_id){
	 showMainError = 0;
	 $('.alert').hide();	 
 /*strip html tags*/
 $("#" + form_id + " input").each(function(){
	 var regex = /(<([^>]+)>)/ig;
	 var thisVal = $(this).val();
	 var thisInput = thisVal.replace(regex, "");
	 $(this).val(thisInput);
 });
 /*required fields*/
 $("#" + form_id + " .ccreq:visible").each(function(){
	 var field_value = $(this).val();
	 var field_id = $(this).attr("id");
	 var field_type = $(this).attr("type");
	 var field_label = $(this).attr("placeholder");
	 if(field_value.trim().length == 0){		 
		 $("#" + field_id + "_ERROR" + " .custom-error").html('Please Enter ' + field_label);	
		 $("#" + field_id + "_ERROR").show();		
		 $("#group_" + field_id).addClass("has-error");		 
		 showMainError = 1
	 }else{
		 $("#" + field_id + "_ERROR").hide();		
		 $("#group_" + field_id).removeClass("has-error");
	 }		 
 });
 /*email validation*/
 $("#" + form_id + " input[type=email]").each(function(){
	 var field_value = $(this).val();
	 var field_id = $(this).attr("id");
	 if($('#' + field_id).hasClass('ccreq') || field_value.length != 0){ 
		 var field_type = $(this).attr("type");
		 var field_label = $(this).attr("placeholder");
		 var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		 valid_email = regex.test(field_value);
		 if(!valid_email){
			 $("#" + field_id + "_ERROR" + " .custom-error").html('The ' + field_label + ' you entered is invalid. Please enter a valid ' + field_label);	
			 $("#" + field_id + "_ERROR").show();		
			 $("#group_" + field_id).addClass("has-error");
			 showMainError = 1;
		 }else{
			 if(field_id == 'STUDENT_EMAIL_ADDRESS' && field_value.indexOf("@conncoll") >= 0){
				 $("#" + field_id + "_ERROR" + " .custom-error").html('Please do not enter your @conncoll email address for your ' + field_label + '. Please use a non-college email account.');	
				 $("#" + field_id + "_ERROR").show();		
				 $("#group_" + field_id).addClass("has-error");
				 showMainError = 1;
			 }else{
				 $("#group_" + field_id).removeClass("has-error");
			 }
		 }
	 }else{
		 if(field_id == 'STUDENT_EMAIL_ADDRESS' && field_value.indexOf("@conncoll") >= 0){
			 $("#" + field_id + "_ERROR" + " .custom-error").html('Please do not enter your @conncoll email address for your ' + field_label + '. Please use a non-college email account.');	
			 $("#" + field_id + "_ERROR").show();		
			 $("#group_" + field_id).addClass("has-error");
			 showMainError = 1;
		 }else{
			 $("#group_" + field_id).removeClass("has-error");
		 }
	 }
 });
 /*telephone validation*/
 $("#" + form_id + " input[type=tel]:visible").each(function(){
	 var field_value = $(this).val();
	 var field_id = $(this).attr("id");
	 var field_type = $(this).attr("type");
	 var field_label = $(this).attr("placeholder");
	 var field_size = $(this).attr("size");
	 if((field_value.length != field_size && field_value.length > 0) || (field_value.length == 0 && $(this).hasClass("ccreq"))){
		 $("#" + field_id + "_ERROR" + " .custom-error").html('The ' + field_label + ' you entered is the incorrect length. Please enter a valid ' + field_label);	
		 $("#" + field_id + "_ERROR").show();		
		 $("#group_" + field_id).addClass("has-error");
		 showMainError = 1;
	 }else{
		 $("#" + field_id + "_ERROR").hide();
		 $("#group_" + field_id).removeClass("has-error");  
	 }
 });
 /*foreign characters not allowed in any fields*/	
 /*addresses allow slashes, #, :, @ */
 var addressCharRegex = /[^\w\s\.\d\t\'\r\@\,x16\-\#\:\+]/;
 /*all other fields don't allow slashes*/
 var textCharRegex = /[^\w\s\.\d\t\'\r\,x16\-]/; 
 $('#' + form_id + " input:visible").each(function(){
	 var field_value = $(this).val();
	 var field_id = $(this).attr("id");
	 var field_label = $(this).attr("placeholder"); 
	 if($(this).hasClass('num_only') || $(this).attr('type') == 'email' || $(this).hasClass('alert_phone_number') || $(this).hasClass('intl_number')){
			/*do nothing, these fields have their own validation*/
			/*console.log("has class num only or type=email");*/
	 }else if($(this).hasClass('address_field') || $(this).hasClass('intl_number')){
		 if (addressCharRegex.test(field_value)){
				$("#" + field_id + "_ERROR" + " .custom-error").html("The" + field_label + ' you entered has foreign or special characters. Please enter Latin characters only.');	
				 $("#" + field_id + "_ERROR").show();		
				 $("#group_" + field_id).addClass("has-error");
				 showMainError = 1;		
			} else {
				var errorString = $("#" + field_id + "_ERROR" + " .custom-error").html();	
				/*only remove error if it is a foreign character error*/		
				if(typeof(errorString) != 'undefined'){
					if(errorString.indexOf("foreign") >= 0){
						$("#" + field_id + "_ERROR").hide();
						$("#group_" + field_id).removeClass("has-error");
					}
				}		
			}	 
	 }else{
		 if (textCharRegex.test(field_value)){
				$("#" + field_id + "_ERROR" + " .custom-error").html("The" + field_label + ' you entered has foreign or special characters. Please enter Latin characters only.');	
				 $("#" + field_id + "_ERROR").show();		
				 $("#group_" + field_id).addClass("has-error");
				 showMainError = 1;	
				 console.log('8 error: field_label: ' + field_label + ', field_id: ' + field_id + ', field_value: ' + field_value);
			} else {
				var errorString = $("#" + field_id + "_ERROR" + " .custom-error").html();	
				/*only remove error if it is a foreign character error*/		
				if(typeof(errorString) != 'undefined'){
					if(errorString.indexOf("foreign") >= 0){
						$("#" + field_id + "_ERROR").hide();
						$("#group_" + field_id).removeClass("has-error");
					}
				}		
			}	 
	 }		 	 
 });
 

 /*campus address check*/
 var addr_line1 = $('#' + form_id + '_ADDR_STREET_LINE1').val();
 var addr_city = $('#' + form_id + '_ADDR_CITY').val();
 if(addr_line1.indexOf('270 Mohegan Ave') != -1 && addr_city.indexOf('New London') != -1){
	$('#' + form_id + '_CAMPUS_ADDR_ERROR').html('Please do not enter your campus address').show();
 	showMainError = 1;
}
 
 if(form_id == 'STUDENT' && duplicate == false){
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
 
 	/*home or business phone is required if no mobile phone*/
 	if(form_id =='PARENT' || form_id == 'CONTACT'){
 	 	var homePhoneCheck = 1;
 	 	var businessPhoneCheck = 1;
 		if($('#' + form_id + '_EMERG_NO_CELL_PHONE').is(':checked')){
 			if($('#' + form_id + '_PHONE_MA_NUMBER_INTL').is(':visible')){
 				if($('#' + form_id + '_PHONE_MA_NUMBER_INTL').val().length == 0){
 					var homePhoneCheck = 0;
 				}
 			}else if($('#' + form_id + '_PHONE_MA_AREA_CODE').val().length == 0 || $('#' + form_id + '_PHONE_MA_NUMBER').val().length == 0){
 				var homePhoneCheck = 0; 				
 			}
 				
 			if($('#' + form_id + '_PHONE_BU_NUMBER_INTL').is(':visible')){
 				if($('#' + form_id + '_PHONE_BU_NUMBER_INTL').val().length == 0){
 					var businessPhoneCheck = 0;
 				}
 			}else if($('#' + form_id + '_PHONE_BU_AREA_CODE').val().length == 0 || $('#' + form_id + '_PHONE_BU_NUMBER').val().length == 0){
 				var businessPhoneCheck = 0;
 			} 	 		
 			
 			if(homePhoneCheck == 0 && businessPhoneCheck == 0){
 	 			showMainError = 1;
 	 			$('#' + form_id + '_HOME_PHONE_OFFICE_PHONE_ERROR').show();
 	 		}else{
 	 			$('#' + form_id + '_HOME_PHONE_OFFICE_PHONE_ERROR').hide();
 	 		}
 		}
 	 	/*check for Mr., Mrs., Ms. or all numbers in prefix*/
 	 	var prefixVal = $('#' + form_id + '_LEGAL_PREFIX_NAME').val();
 	 	var prefixRegex = /(?!^\d+$)^.+$/;
 	 	valid_prefix = prefixRegex.test(prefixVal);
 	 	if(prefixVal.toLowerCase().substring(0,2) == 'mr' || prefixVal.toLowerCase().substring(0,2) == 'ms'){
 	 		$("#" + form_id + "_LEGAL_PREFIX_NAME_ERROR" + " .custom-error").html('Please do not enter Mr., Mrs. or Ms. in the prefix field. Examples of valid prefixes include Attny., Rev., Dr. etc.');	
 			$("#" + form_id + "_LEGAL_PREFIX_NAME_ERROR").show();		
 			$("#group" + form_id + "_LEGAL_PREFIX_NAME").addClass("has-error");
 			showMainError = 1;
 	 	}else if(!valid_prefix && prefixVal.length != 0){
 	 		$("#" + form_id + "_LEGAL_PREFIX_NAME_ERROR" + " .custom-error").html('This is not a valid prefix. Examples of valid prefixes include Attny., Rev., Dr., etc.');	
 			$("#" + form_id + "_LEGAL_PREFIX_NAME_ERROR").show();		
 			$("#group" + form_id + "_LEGAL_PREFIX_NAME").addClass("has-error");
 			showMainError = 1;
 	 	}else{
 	 		$("#" + form_id + "_LEGAL_PREFIX_NAME_ERROR").hide();
 	 		$("#group" + form_id + "_LEGAL_PREFIX_NAME").removeClass("has-error");
 	 	}
 	 	/*check for valid suffix, don't allow all numbers*/
 	 	var suffixVal = $('#' + form_id + '_LEGAL_SUFFIX_NAME').val();
 	 	var suffixRegex = /(?!^\d+$)^.+$/;
 	 	valid_suffix = suffixRegex.test(suffixVal);
 	 	if(!valid_suffix && suffixVal.length != 0){
 	 		$("#" + form_id + "_LEGAL_SUFFIX_NAME_ERROR" + " .custom-error").html('This is not a valid suffix. Examples of valid suffixes include Jr., Sr., IV, etc.');	
 			$("#" + form_id + "_LEGAL_SUFFIX_NAME_ERROR").show();		
 			$("#group" + form_id + "_LEGAL_SUFFIX_NAME").addClass("has-error");
 			showMainError = 1;
 	 	}else{
 	 		$("#" + form_id + "_LEGAL_SUFFIX_NAME_ERROR").hide();
 	 		$("#group" + form_id + "_LEGAL_SUFFIX_NAME").removeClass("has-error");
 	 	}
 	}

}
 
 /*save main form*/
 function submitMainForm(form_id){
	 formValidate(form_id);
	 if(showMainError){
		 window.scrollTo(0,0);
		 $('#' + form_id + '_MODAL').animate({ scrollTop: 0 }, 'fast'); 
	 $('#STUDENT_FORM_ERROR').show();
	 return false;	
 }else{
	 $('#STUDENT_FORM_ERROR').hide();
		 return true;
	 }
 }
 
 function populateModal(modal_type,ppid){
		$.ajax({
	           type: "POST",
           url: ajaxurl,
           data: JSON.stringify({"PIDM": student_PIDM, "PPID": ppid, "DATA": modal_type, "MODE": "READ"}),
           datatype: "json",
           contentType: "application/json",
           success: function(data)           
           {   
        	  $('#' + modal_type + '_STUDENT_PIDM').val(student_PIDM);
        	  $('#' + modal_type + '_PARENT_PPID').val(ppid);
        	  var showEmerNumber = 0;
        	  if(modal_type == 'PARENT'){
	        	  $.each(data.parent, function(index, element){	       
	        		  $('form#' + modal_type + ' #' + index).val(element);	 
	        		  if(index == 'EMERG_NO_CELL_PHONE'){
	        			  if(element == 'Y'){
	        				  $('.modal_mobile_phone_check').prop('checked',true).change();
	        				  var showEmerNumber = 1;
	        				  emergencyNumberToggle(modal_type, 1);
	        			  }
	        		  }else if(index == 'PARENT_PIDM'){
	        			  if($.isNumeric(element)){
	        				  $('.' + modal_type + '_NAME_FIELD').prop('disabled',true);
	        				  $('#' + modal_type + '_NAME_FIELD_NOTE').show();
	        			  }
	        		  }else{
	        			  $('.' + modal_type + '_NAME_FIELD').prop('disabled',false);
	        			  $('.' + modal_type + '_NAME_FIELD_NOTE').hide();
	        		  }
	        	  });
        	  }else{
        		  $.each(data.contact, function(index, element){
        			  var new_index = index;
        			  var new_index = new_index.replace('EMERG','CONTACT')
        			  $('form#' + modal_type + ' #' + new_index).val(element);
        			  if(index == 'EMERG_NO_CELL_PHONE'){
	        			  if(element == 'Y'){
	        				  $('.modal_mobile_phone_check').prop('checked',true).change();
	        				  var showEmerNumber = 1;
	        				  emergencyNumberToggle(modal_type, 1);
	        			  }
	        		  }else if(index == 'PARENT_PIDM'){
	        			  if($.isNumeric(element)){
	        				  $('.' + modal_type + '_NAME_FIELD').prop('disabled',true);
	        				  $('#' + modal_type + '_NAME_FIELD_NOTE').show();
	        			  }
	        		  }else{
	        			  $('.' + modal_type + '_NAME_FIELD').prop('disabled',false);
	        			  $('#' + modal_type + '_NAME_FIELD_NOTE').hide();
	        		  }
  	        	  });
        	  }

        	  $.each(data.email, function(index,element){        
        		 $('form#' + modal_type + ' #' + modal_type + '_' + index).val(element);
        	  });

        	  $.each(data.address, function(index,element){        		 
        		  if(index == 'ADDR_NATN_CODE' && element == null){
        			  $('form#' + modal_type + ' #' + modal_type + '_' + index).val('US');
        		  }else if(index == 'ADDR_NATN_CODE' && element != 'US'){
        			  countryProvinceDisplay(modal_type,data.address['ADDR_NATN_CODE']);
        			  $('form#' + modal_type + ' #' + modal_type + '_' + index).val(element);
        			  $('form#' + modal_type + ' #' + modal_type + '_ADDR_PROV_REGION').val(data.address['ADDR_STAT_CODE']);
        		  }else{
        			  $('form#' + modal_type + ' #' + modal_type + '_' + index).val(element);
         		  }
          	  });
        	  
    	  	  /*address to use checkbox, hide if student address is blank*/
    	  	  if($('#STUDENT_ADDR_STREET_LINE1').val() == ''){	        		  
    	  		  $('form#' + modal_type + ' #GROUP_' + modal_type + '_ADDRESS_TO_USE').hide();
    	  	  }
       	  
    	  	  /*phones*/
        	  for(i=0;i<data.phones.length;i++){
        		  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_CODE').val(data.phones[i].PHONE_CODE);
        		  if(data.phones[i].PHONE_CODE == 'EP'){
        			  if(showEmerNumber = 1){
	        			  if(data.phones[i].PHONE_NUMBER_INTL != "" && data.phones[i].PHONE_NUMBER_INTL != null){
	   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER').hide();
	   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').val(data.phones[i].PHONE_NUMBER_INTL);
	   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').show();   
	   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').addClass('ccreq');
							  $('#' + modal_type + '_PHONE_EMERGENCY_AREA_CODE').removeClass('ccreq');
							  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER').removeClass('ccreq');
							  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL_SWITCH .intl_number_switch').html('Enter U.S. Number');
	   	        		  }else{
	   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').hide();
	   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_AREA_CODE').val(data.phones[i].PHONE_AREA_CODE);
	   	        			  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER').val(data.phones[i].PHONE_NUMBER);
	   	        			  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER').show();  
	  						  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL').removeClass('ccreq');
							  $('#' + modal_type + '_PHONE_EMERGENCY_AREA_CODE').addClass('ccreq');
							  $('#' + modal_type + '_PHONE_EMERGENCY_NUMBER').addClass('ccreq');	
							  $('#GROUP_' + modal_type + '_PHONE_EMERGENCY_NUMBER_INTL_SWITCH .intl_number_switch').html('Enter International Number');
	   	        		  } 
        			  }
        		  }else if(data.phones[i].PHONE_CODE == 'CP'){
        			  if(data.phones[i].PHONE_NUMBER_INTL != "" && data.phones[i].PHONE_NUMBER_INTL != null){
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').hide();
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL').val(data.phones[i].PHONE_NUMBER_INTL);
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_AREA_CODE').removeClass('ccreq');
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').removeClass('ccreq');
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL').show();   
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL_SWITCH .intl_number_switch').html('Enter U.S. Number');
	        		  }else{
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_AREA_CODE').val(data.phones[i].PHONE_AREA_CODE);
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL').hide();		        			  
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').val(data.phones[i].PHONE_NUMBER);
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_AREA_CODE').addClass('ccreq');
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').addClass('ccreq');
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').show(); 
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL_SWITCH .intl_number_switch').html('Enter International Number');
	        		  } 
        		  }else{
	        		  if(data.phones[i].PHONE_NUMBER_INTL != "" && data.phones[i].PHONE_NUMBER_INTL != null){
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').hide();
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL').val(data.phones[i].PHONE_NUMBER_INTL);
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL').show();   
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL_SWITCH .intl_number_switch').html('Enter U.S. Number');
	        		  }else{
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_AREA_CODE').val(data.phones[i].PHONE_AREA_CODE);
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL').hide();		        			  
	        			  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').val(data.phones[i].PHONE_NUMBER);
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER').show(); 
	        			  $('#GROUP_' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_NUMBER_INTL_SWITCH .intl_number_switch').html('Enter International Number');
	        		  }   
        		  }
        		  
        		  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_SEQUENCE_NO').val(data.phones[i].PHONE_SEQUENCE_NO);
        		  $('#' + modal_type + '_PHONE_' + data.phones[i].PHONE_CODE + '_CARRIER').val(data.phones[i].PHONE_CARRIER);   
          		   
        	  }
        	  
           },
           error: function (request, status, error) {

           }
	    });		    
		
		$('#' + modal_type + "_MODAL").modal('show');
	}
 
 /*save modal*/
 function submitModal(form_id,student_pidm) { 	  
	 formValidate(form_id);
	 if(showMainError){
		 window.scrollTo(0,0);
		 $('#' + form_id + '_MODAL').animate({ scrollTop: 0 }, 'fast');
	 $('#' + form_id + '_MODAL_ERROR').show();
	 return false;	
 }else if(student_pidm.length == 0){
	/*student_pidm required, close modal, show error modal	*/ 
	$('#' + form_id + '_MODAL').hide();
	$('#' + form_id + '_CLOSE_BUTTON').trigger('click');
 	$('#ERROR_MODAL').modal('show');
 }else if( checkNum(form_id) >= totalAllowed(form_id) ){
	 $('#' + form_id + '_MODAL').hide();
	 $('#' + form_id + '_CLOSE_BUTTON').trigger('click');
	 $('#MAX_' + form_id + 'S_ALLOWED_MODAL').modal();
 }else{ 
	 /*continue with modal save*/
	 $('#' + form_id + '_MODAL_ERROR').hide();
	 /*close any former error messages*/
	 $(".alert_danger").hide();
	 var parent_ppid = $('#' + form_id + '_PARENT_PPID').val();
	 var new_contact_name = $('#' + form_id + '_PREF_FIRST_NAME').val() + ' ' + $('#' + form_id + '_PREF_LAST_NAME').val();
	 /*submit via ajax*/
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
				 if(x == 0){						
					x = x + 1;						
				 }else{
					 formData = formData + ",";
				 }
				 addToFormData(val.trim(),name);
			}
		 });

		formData = formData + "},";			
	 }

	/*loop phones separately as array*/
	formData = formData + '"phones": [ {';
	var phoneCodeArray = ["CP","MA","BU"];			
	 for (var j = 0; j < phoneCodeArray.length; j++) {
		if(phoneCodeArray[j] != "CP"){
			formData = formData + "},{";
		}
		var phone_sequence_no = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_SEQUENCE_NO').val();
		console.log("phone_sequence_no: " + phone_sequence_no);
		var phone_code = $('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_CODE').val();
		if(phoneCodeArray[j] == "EP"){
			if($('#' + form_id + '_EMERG_NO_CELL_PHONE').is(':checked')){		
				if($('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL').is(':visible')){					
					var phone_area_code = '';
					var phone_number = '';
					var phone_intl = $('#' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL').val();
				}else{					
					var phone_area_code = $('#' + form_id + '_PHONE_EMERGENCY_AREA_CODE').val();
					var phone_number = $('#' + form_id + '_PHONE_EMERGENCY_NUMBER').val();
					var phone_intl = '';	
				}				
				
			}else{
				/*emerg_no_cell_phone not checked, don't send any EP number, wipe out whats there*/
				/*wipe out current number	*/				
				var phone_area_code = '';
				var phone_number = '';						
				var phone_intl = '';
				var phone_carrier = '';					
			}
		}else if(phoneCodeArray[j] == "CP"){
			if($('#' + form_id + '_EMERG_NO_CELL_PHONE').is(':checked')){					
				/*wipe out current number*/					
				var phone_area_code = '';
				var phone_number = '';				 		
				var phone_intl = '';
				var phone_carrier = '';						
			}else{				
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
		}else{		
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
		
		if(phone_sequence_no.length == 0){
			formData = formData + '"PHONE_SEQUENCE_NO" : null,';
		}else{
			formData = formData + '"PHONE_SEQUENCE_NO" : "' + phone_sequence_no + '",';
		}
		formData = formData + '"PHONE_AREA_CODE" : "' + phone_area_code + '",';
		formData = formData + '"PHONE_NUMBER" : "' + phone_number + '",';
		formData = formData + '"PHONE_CODE" : "' + phone_code + '",';
		formData = formData + '"PHONE_NUMBER_INTL" : "' + phone_intl + '",';
		if(phone_carrier == undefined || phone_sequence_no.length == 0){
			formData = formData + '"CELL_PHONE_CARRIER" : null';
		}else{
			formData = formData + '"CELL_PHONE_CARRIER" : "' + phone_carrier + '"';
		}	

 	   /*reset hidden form fields on modal manually because Safari is old and cranky and can't reset fields it can't see*/	
		$('#' + form_id + '_PHONE_' + phoneCodeArray[j] + '_SEQUENCE_NO').val('');
	 }	
	 
	 /*set emr separately*/
	 $('#' + form_id + '_PHONE_EMR_SEQUENCE_NO').val('');

	formData = formData + "}]";					
	formData = formData + "}";		 		 
	/* console.log(formData); */
	 
	if(new_contact_name.length > 1 && student_pidm.length != 0){
		$.ajax({
	           type: "POST",
	           url: ajaxurl,
	           data: formData,
	           dataType: "json",
	           contentType: "application/json",
	           success: function(data)
	           {   
	        	   if(parent_ppid == 0){		        			
	        	   		if(checkNum('CONTACT') < totalAllowed('CONTACT')){
	        	   			addToList(form_id,new_contact_name,data.PARENT_PPID,1);
	        	   		}else{
	        	   			addToList(form_id,new_contact_name,data.PARENT_PPID,0);
	        	   		}
	        	   		
	        	   		if(form_id == 'PARENT'){			        	   		
		        	   		if(checkNum('CONTACT') < totalAllowed('CONTACT')){	        	   		
		        				promoteParent(data.PARENT_PPID,new_contact_name);
		        	   		}
	        	   		}
	        	   }else{
	        			$('#PARENT_LIST #parent_' + parent_ppid + ' .contact-name').html('<strong>' + new_contact_name + '</strong>');  
	        	   		$('#CONTACT_LIST #emr_contact_' + parent_ppid + ' .contact-name').html('<strong>' + new_contact_name + '</strong>');  
	        	   }
	        	   $('#PARENT_PARENT_PPID').val(0);	
	        	   $('#CONTACT_PARENT_PPID').val(0);	
	        	   resetIntlModalNumbers();
	        	   getAlertNumbers();
	        	   $('form#PARENT #GROUP_PARENT_ADDRESS_TO_USE').show();
	        	   $('form#CONTACT #GROUP_CONTACT_ADDRESS_TO_USE').show();
	        	   if($('.modal_mobile_phone_check').is(':checked')){
	        			$('.modal_mobile_phone_check').prop('checked',false).change();
	      		   }
	        	   document.getElementById(form_id).reset();
	        	   //hide clean address
	        	   $('#' + form_id + '_CLNADDR_RESULTS').hide();
	        	   $('#'+ form_id + '_MODAL').hide();
	        	   $('#' + form_id + '_CLOSE_BUTTON').trigger('click');
	        	   $('#CONFIRMATION_MODAL').modal('show');		        	   
	        	   /*add to emr_order*/
	        	   setEmrOrder();		        	   
	        	   setTimeout(function(){ entryCheck(); }, 1500);
	           },
	           error: function(e){
	        	 	/*close modal, show error modal*/
	        	    $('#' + form_id + '_MODAL').hide();
		        	$('#' + form_id + '_CLOSE_BUTTON').trigger('click');
		        	$('#ERROR_MODAL').modal('show');
	        	   return false;
	        	   
	           }
		    });	 
		}else{
			$('#' + form_id + '_MODAL').hide();
        	$('#' + form_id + '_CLOSE_BUTTON').trigger('click');
        	$('#ERROR_MODAL').modal('show');
		}
	 return false;
	 
 }	 
}

 function resetIntlModalNumbers(){
     /*reset all international numbers in modal back to US numbers after modal submission*/
	 $('.modal_intl_form_group').each(function(){		
		thisID = $(this).attr('id');
		thisHTML = $('#' + thisID + '_SWITCH .modal_intl_number_switch').html();
		if(thisHTML == 'Enter U.S. Number'){
			$('#' + thisID + '_SWITCH .modal_intl_number_switch').trigger('click');   	   			
   		}
	 });
 }	 
 
 function resetPhoneSequenceNo(){
	 /*make sure edit sequence numbers and parent ppids are wiped out on new entries*/
  	 var typeArray = ["PARENT","CONTACT"];
	 var phoneCodeArray = ["CP","EP","MA","BU"];	
	 for (var i = 0; i < typeArray.length; i++) {
		 for (var j = 0; j < phoneCodeArray.length; j++) {
			 $('#' + typeArray[i] + '_PHONE_' + phoneCodeArray[j] + '_SEQUENCE_NO').val('');
		 }
		 $('#' + typeArray + '_PARENT_PPID').val(0);
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

function addToList(type,new_contact_name,ppid,switchedOn){
	if(type == 'PARENT'){
		/*always add parents as emergency contacts*/
		addParent(type,ppid,new_contact_name,switchedOn);
		/*addContact(type,ppid,new_contact_name);*/
	}else{
		addContact(type,ppid,new_contact_name);
	}		
} 

function addParent(type,ppid,new_contact_name,switchedOn){
	var parent_info = '<div class="panel panel-default PARENT-LISTED" id="parent_' + ppid + '"><div class="panel-body"><span class="contact-name"><strong>' + new_contact_name + '</strong></span><a href="#" title="Edit" class="showModal" data-ppid="' + ppid + '" data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="' + new_contact_name + '" data-ppid="' + ppid + '"  data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a><span class="emergency_contact_switch">&nbsp;Emergency Contact: <input type="checkbox" name="PARENT" checked="checked" class="bootstrap-switch parent-bootstrap-switch" data-ppid="' + ppid + '" data-off-text="No" data-on-text="Yes"></span></div></div>';
	$('#PARENT_LIST').append(parent_info);
	
	var emr_switch_count = $('.parent-bootstrap-switch:checked').length;
	if(emr_switch_count == 1){
		$('#PARENT_LIST #parent_' + ppid + ' .bootstrap-switch').bootstrapSwitch('disabled',true);
	}else if(emr_switch_count > 1){
		$('.parent-bootstrap-switch:checked').each(function(){
			$(this).bootstrapSwitch('disabled',false);
		});

	}	
	if(!switchedOn){
		$('#PARENT_LIST #parent_' + ppid + ' .parent-bootstrap-switch').bootstrapSwitch('state',false);
	}
	
	/*attach click event to bootstrap switch for new contact*/
	$('#PARENT_LIST #parent_' + ppid + ' .bootstrap-switch').on('switchChange.bootstrapSwitch', function(event, state) {
		emergencySwitchToggle(ppid,new_contact_name,event,state);
	});
	/*attach click event for Edit icon on new contact*/
	$('#PARENT_LIST #parent_' + ppid).on('click','.showModal',function(){
		populateModal('PARENT',ppid);
	});
	/*attach click event for Delete icon on new contact*/
	$('#PARENT_LIST #parent_' + ppid).on('click','.deleteModal',function(){
		showDeleteModal('PARENT',ppid,new_contact_name);
	});
}

function addParentAsContact(type,ppid,new_contact_name){
	/*don't show delete icon for parents in contact list	*/		
	var contact_info = '<li class="panel panel-info CONTACT-LISTED" id="emr_contact_' + ppid + '"><div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div><div class="panel-body"><span class="contact-name"><strong>' + new_contact_name + '</strong></span> &nbsp; <a href="#" title="Edit"  class="showModal" data-ppid="' + ppid + '" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a></div></li>'
	$('#CONTACT_LIST').append(contact_info);
	$('#CONTACT_LIST #emr_contact_' + ppid).on('click','.showModal',function(){
		populateModal('CONTACT',ppid);
	});
}

function addContact(type, ppid,new_contact_name){	

	var contact_info = '<li class="panel panel-info CONTACT-LISTED" id="emr_contact_' + ppid + '"><div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div><div class="panel-body"><span class="contact-name"><strong>' + new_contact_name + '</strong></span> &nbsp; <a href="#" title="Edit"  class="showModal" data-ppid="' + ppid + '" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="' + new_contact_name + '" data-ppid="' + ppid + '"  data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div></li>'
	$('#CONTACT_LIST').append(contact_info);
	$('#CONTACT_LIST #emr_contact_' + ppid).on('click','.showModal',function(){
		populateModal('CONTACT',ppid);
	});
	$('#CONTACT_LIST #emr_contact_' + ppid).on('click','.deleteModal',function(){
		showDeleteModal('CONTACT',ppid,new_contact_name);
	});
}

function addCampusAlertNumber(alert_phone_number, new_contact_name, type){		
	/*just for student numbers	*/
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

} 

function emergencyNumberToggle(form_id, checked){
	if(checked) {
		$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER').show();
		$('#' + form_id + '_EMERGENCY_PHONE').addClass('ccreq');
		$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL_SWITCH').show();
		/*remove error if it is already displaying*/
		$('form#' + form_id + ' PHONE_CP_NUMBER_ERROR').hide();
		/*remove requirement for mobile phone*/
		$('#GROUP_' + form_id + '_PHONE_CP_NUMBER .required').hide();
		$('#GROUP_' + form_id + '_PHONE_CP_NUMBER_INTL .required').hide();	
		$('#' + form_id + '_PHONE_CP_AREA_CODE').removeClass('ccreq');
		$('#' + form_id + '_PHONE_CP_NUMBER').removeClass('ccreq');
		$('#' + form_id + '_PHONE_CP_NUMBER_INTL').removeClass('ccreq');
		/*add requirement for emergency phone*/
		$('#' + form_id + '_PHONE_EMERGENCY_AREA_CODE').addClass('ccreq');
		$('#' + form_id + '_PHONE_EMERGENCY_NUMBER').addClass('ccreq');
		/*remove requirement for phone carrier*/
		$('#GROUP_' + form_id + '_PHONE_CARRIER .required').hide();	
		if(form_id == 'STUDENT'){
			/*remove text alerts checkbox*/
			$('#paragraph_alert_text_check').hide();
			$('#group_alert_text_check').hide();	
			$('#paragraph_tty_device_check').html('If your emergency phone is a TTY device (for the hearing impaired) please indicate below:');
		}
    }else{
    	$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER').hide();
    	$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL').hide();	
    	$('#' + form_id + '_EMERGENCY_PHONE').removeClass('ccreq');
    	$('#GROUP_' + form_id + '_PHONE_EMERGENCY_NUMBER_INTL_SWITCH').hide();
    	/*add requirement for mobile phone*/
    	$('#GROUP_' + form_id + '_PHONE_CP_NUMBER .required').show();	
    	$('#' + form_id + '_PHONE_CP_AREA_CODE').addClass('ccreq');
		$('#' + form_id + '_PHONE_CP_NUMBER').addClass('ccreq');
		/*add requirement for emergency phone*/
		$('#' + form_id + '_PHONE_EMERGENCY_AREA_CODE').removeClass('ccreq');
		$('#' + form_id + '_PHONE_EMERGENCY_NUMBER').removeClass('ccreq');
    	/*add requirement for phone carrier*/
		$('form#' + form_id + ' #GROUP_PHONE_CARRIER .required').show();	
		if(form_id == 'STUDENT'){
			/*show text alerts checkbox*/
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
	if(state == false){
		/*turning parent off*/
		if(emr_switch_count < 1){
			if(deanExceptionDate.length == 0){	
				/*turn back on*/
				$(this).bootstrapSwitch('state',true);
			}else{
				removeParentFromContact = true;
			}
		}else if(emr_switch_count == 1){
			if(deanExceptionDate.length == 0){			
				$('.parent-bootstrap-switch:checked').bootstrapSwitch('disabled',true);					
				removeParentFromContact = true;
			}else{
				/*don't disable the last remaining switch*/
				removeParentFromContact = true;
			}
		}else{
			$('.parent-bootstrap-switch').bootstrapSwitch('disabled',false);
			removeParentFromContact = true;
		}			
		if(removeParentFromContact){
			$('#emr_contact_'+ppid).hide();
			performDelete(ppid,'CONTACT');
		}
		setEmrOrder();
	}else{
		/*turning parent on*/
		if($('#emr_contact_' + ppid).length == 0){
			if(emr_switch_count < 1){
				if(deanExceptionDate.length == 0){	
					/*turn back on*/
					$(this).bootstrapSwitch('state',true);
				}
			}else if(emr_switch_count == 1){
				if(deanExceptionDate.length == 0){		
					$('.parent-bootstrap-switch:checked').bootstrapSwitch('disabled',true);					
				}
			}else{
				$('.parent-bootstrap-switch').bootstrapSwitch('disabled',false);
			}	
			if(checkNum('CONTACT') >= totalAllowed('CONTACT')){
				/*turn back on*/
				$('#parent_' + ppid + ' .parent-bootstrap-switch').bootstrapSwitch('state',false);
				$('#MAX_CONTACTS_ALLOWED_MODAL').modal();
			} 
			/*create contact by promoting through restlet*/
			promoteParent(ppid,name);
		}
					
	}		
	  
}

function modalMobilePhoneWarning(form_id,checked){
	if(checked){
		$('#' + form_id + '_PHONE_MOBILE_PHONE_WARNING').show();
		/*remove requirement for mobile phone*/
		$('#GROUP_' + form_id + '_PHONE_CP_NUMBER .required').hide();
		$('#GROUP_' + form_id + '_PHONE_CP_NUMBER_INTL .required').hide();
		$('#' + form_id + '_PHONE_CP_AREA_CODE').removeClass('ccreq');
		$('#' + form_id + '_PHONE_CP_NUMBER').removeClass('ccreq');
		$('#' + form_id + '_PHONE_CP_NUMBER_INTL').removeClass('ccreq');
	}else{
		$('#' + form_id + '_PHONE_MOBILE_PHONE_WARNING').hide();
		/*add requirement for mobile phone*/
    	$('#GROUP_' + form_id + '_PHONE_CP_NUMBER .required').show();	
    	$('#' + form_id + '_PHONE_CP_AREA_CODE').addClass('ccreq');
    	$('#' + form_id + '_PHONE_CP_NUMBER').addClass('ccreq');
	}
}

function promoteParent(ppid,name){

	$.ajax({
           type: "POST",
           url: ajaxurl,
           data: JSON.stringify({"PIDM": student_PIDM, "PPID": ppid, "DATA": "PARENT", "MODE": "PROMOTE"}),
           datatype: "json",
           contentType: "application/json",
           success: function(data)           
           {  
        	   if($('#emr_contact_' + ppid).length == 0){
        	   	addParentAsContact('PARENT',ppid,name);
        	   }
        	   getAlertNumbers();
        	   setEmrOrder();
           },
           error: function (request, status, error) {
               
           }
	 });
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
        	 /*phones*/
        	 if(data.phones.length > 0){
        		 $('.NON-STUDENT-EP-NUMBER').remove();	        		 
        	 }
        	  for(i=0;i<data.phones.length;i++){
          		  var phone_code = data.phones[i].PHONE_CODE;
        		  if(phone_code != 'EP'){
	        		  var phone_area_code = data.phones[i].PHONE_AREA_CODE;
	        		  var phone_number = data.phones[i].PHONE_NUMBER;
	        		  var phone_number_intl = data.phones[i].PHONE_NUMBER_INTL;
	        		  var phone_sequence_no = data.phones[i].PHONE_SEQUENCE_NO;
	        		  var contact_name = data.phones[i].Pref_Name;
	        		  if(phone_number_intl != null){
	        			  if(phone_number_intl.length > 0){
		        			  var alert_phone_number = phone_number_intl;
		        		  }else{
		        			  var alert_phone_number = '' + phone_area_code + phone_number;
		        		  } 
	        		  }else{
	        			  var alert_phone_number = '' + phone_area_code + phone_number;
	        		  }
	        		  
	        		  if($.inArray(alert_phone_number,checked_phone_numbers) == -1){
	        			  var newAlertNumber = '<li class="list-unstyled NON-STUDENT-EP-NUMBER alert_phone_number"><input type="checkbox" value="' + alert_phone_number + '" name="fields[25]" onchange="alertNumberReview(this)">&nbsp;' + alert_phone_number + '&nbsp;(' + contact_name + ')</li>';
		      			}else{
		      				var newAlertNumber = '<li class="list-unstyled NON-STUDENT-EP-NUMBER alert_phone_number"><input type="checkbox" checked="checked" value="' + alert_phone_number + '" name="fields[25]" onchange="alertNumberReview(this)">&nbsp;' + alert_phone_number + '&nbsp;(' + contact_name + ')</li>';
		      			}
	      			  $('#CAMPUS_ALERT_NUMBERS').append(newAlertNumber);   
        		  }
        	  }		        		  
           },
           error: function (request, status, error) {
               
           }
	 });		 
}

function setEmrOrder(){
	var panelList = $('.draggablePanelList');
	var contact_order_list = '';
	var x = 0;
	$('.panel',panelList).each(function(index, elem) {
        var $listItem = $(elem);
        	if($listItem.is(':visible')){
                 var newIndex = $listItem.index();
            		var ppid = $listItem.attr("id").replace('emr_contact_','');
            		ppid = ppid.replace('parent_','');
            		if(x != 0){
            			contact_order_list += ',';
            		}
            		contact_order_list += ppid
            	x=x+1;
        	}
        /* Persist the new indices. */
   }); 
   $('#emr_order').val(contact_order_list);          
}