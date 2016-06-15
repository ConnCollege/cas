$(document).ready(function() {	
	$('.contact_info').each(function(){
		var ppid = $(this).attr("data-ppid");
		var type_id = $(this).attr("data-type-id");
		if(ppid != ''){
			$.ajax({
			       type: "POST",
			       url: '/cas/cas-rest-api/peci/',
			       data: JSON.stringify({"PIDM": $student_PIDM, "PPID": ppid, "DATA": type_id, "MODE": "READ"}),
			       datatype: "json",
			       contentType: "application/json",
			       success: function(data)           
			       {  
						var output = '';
			    	   	if(type_id == 'CONTACT'){
				    	   	$.each(data.contact, function(index, element){				       		
				       			var output = displayOutput(index,element);					       		
				       			$('#' + type_id + '_' + ppid).append(output);
				       	  	});
			    	   }else{
			    		   $.each(data.parent, function(index, element){
					       	 	var output = displayOutput(index,element);					       		
					       	 	$('#' + type_id + '_' + ppid).append(output);
					       	 });
			    	   }			    	   			    	    
	
				       if (data.email != undefined && data.email != null && data.email.length != 0){
				       		$.each(data.email, function(index,element){
				       			var output = displayOutput(index,element);					       		
			       				$('#' + type_id + '_' + ppid).append(output);
				       	  	});
				       	}	
	
				       	$.each(data.address, function(index,element){
				       		var output = displayOutput(index,element);					       		
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
			       			}else if(phone_code == 'EP'){
			       				phone_type = 'Emergency';
			       			}
			        		output += '<div class="row"><div class="col-xs-3"><div>' + phone_type + ' Phone</div></div><div class="col-xs-9">' + phone_display + '<div>';
			        		output += '</div></div></div>';
					       	$('#' + type_id + '_' + ppid).append(output);
				       	}
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

function displayOutput(index, element){
	var output = '';
	if(index.indexOf('RELT_CODE') > -1){	
		output = displayRelationship(index,element);		
	}else if(index.indexOf('ADDR_STAT_CODE') > -1){
		output = displayState(index,element);
	}else if(index.indexOf('ADDR_NATN_CODE') > -1){
		output = displayCountry(index,element);
	}else{
   		output = displayField(index,element);	
	}
	return output;
}

function displayRelationship(index, element){
	var output = '';
	var loc1 = relationshipCodes.indexOf(element); 					       		
	if(loc1 != -1){		   			
		output += '<div class="row"><div class="col-xs-3"><div>Relationship</div></div><div class="col-xs-9"><div>';	
		if(element != null){
			output += relationshipValues[loc1];
		}
		output += '</div></div></div>';
	}	
	return output
}

function displayState(index, element){
	var output = '';
	var loc1 = stateCodes.indexOf(element); 					       		
	if(loc1 != -1){		   			
		output += '<div class="row"><div class="col-xs-3"><div>State</div></div><div class="col-xs-9"><div>';	
		if(element != null){
			output += stateValues[loc1];
		}
		output += '</div></div></div>';
	}else{
		var loc2 = regionCodes.indexOf(element);
		if(loc2 != -1){
			output += '<div class="row"><div class="col-xs-3"><div>Province/Region</div></div><div class="col-xs-9"><div>';	
			if(element != null){
				output += regionValues[loc2];
			}
			output += '</div></div></div>';
		}
	}
	return output
} 

function displayCountry(index, element){
	var output = '';
	var loc1 = countryCodes.indexOf(element); 					       		
	if(loc1 != -1){		   			
		output += '<div class="row"><div class="col-xs-3"><div>Country</div></div><div class="col-xs-9"><div>';	
		if(element != null){
			output += countryValues[loc1];
		}
		output += '</div></div></div>';
	}	
	return output
}

function displayField(index, element){
	var output = '';
	var loc = demoFields.indexOf(index); 					       		
	if(loc != -1){
		
		output += '<div class="row"><div class="col-xs-3"><div>' + demoValues[loc] + '</div></div><div class="col-xs-9"><div>';	
		if(element != null){
			output += element;
		}
		output += '</div></div></div>';
	}	
	return output;
}
