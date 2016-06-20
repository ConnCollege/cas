function checkNum(e){var t=$("."+e+"-LISTED:visible").length
return t}function totalAllowed(e){return"PARENT"==e?5:6}function entryCheck(){checkNum("PARENT")>=totalAllowed("PARENT")?disableModalEnter("PARENT"):enableModalEnter("PARENT"),checkNum("CONTACT")>=totalAllowed("CONTACT")?disableModalEnter("CONTACT"):enableModalEnter("CONTACT")}function disableModalEnter(e){$("#ADD_"+e).attr("disabled","disabled"),$("#"+e+"_MAX_ENTERED").show()}function enableModalEnter(e){$("#ADD_"+e).removeAttr("disabled","disabled"),$("#"+e+"_MAX_ENTERED").hide()}function showDeleteModal(e,t,a){$("#DELETE_MODAL").modal(),$("#delete_form").find("#type").html(e.toLowerCase()),$("#delete_form").find(".name_block").html(a),$("#delete_form").find("#ppid_to_delete").val(t),$("#delete_form").find("#type_to_delete").val(e),"PARENT"==e&&$("#delete_form").find("#note").html("Please Note: this will also remove this parent from your emergency contacts if applicable")}function deleteIndividual(){ppid_to_delete=$("#delete_form #ppid_to_delete").val(),type=$("#delete_form  #type_to_delete").val(),(type="PARENT")?(performDelete(ppid_to_delete,"PARENT"),performDelete(ppid_to_delete,"CONTACT")):performDelete(ppid_to_delete,type)}function alertNumberReview(e){var t=5,a=$(e).val()
$("input[name='fields[25]']:checked").length
$("input[name='fields[25]']:checked").length>t?($(e).prop("checked",!1),$("#ALERT_NUMBER_MODAL").modal()):$(e).is(":checked")?-1==$.inArray(a,checked_phone_numbers)&&checked_phone_numbers.push(a):-1!=$.inArray(a,checked_phone_numbers)&&checked_phone_numbers.splice($.inArray(a,checked_phone_numbers),1)}function performDelete(e,t){return $.ajax({type:"POST",url:ajaxurl,data:JSON.stringify({PIDM:student_PIDM,PPID:e,DATA:t,MODE:"DELETE"}),datatype:"json",contentType:"application/json",success:function(a){$(".parent-bootstrap-switch:checked").length
$("#DELETE_MODAL").modal("hide"),"CONTACT"==t?$("#emr_contact_"+e).remove():$("#parent_"+e).remove(),getAlertNumbers(),setEmrOrder(),entryCheck()},error:function(e,t,a){}}),!1}function countryProvinceDisplay(e,t){var a="#GROUP_"+e+"_INTL_REGION",_=a+" #"+e+"_ADDR_PROV_REGION",o="#GROUP_"+e+"_ADDR_STAT_CODE",r=o+" #"+e+"_ADDR_STAT_CODE",E="#GROUP_"+e+"_ADDR_CITY",n="#GROUP_"+e+"_ADDR_ZIP",i="#"+e+"_ADDR_ZIP"
"United States"==t||"US"==t?($(o).show(),$(r).addClass("ccreq"),$(r).removeProp("disabled"),$(i).addClass("ccreq"),$(n).show(),$(n+" .required").show(),$(E+" .city").html("City"),$(a).hide(),$(_).prop("disabled","disabled")):"Canada"==t||"CA"==t?($(o).hide(),$(r).removeClass("ccreq"),$(r).prop("disabled","disabled"),$(i).addClass("ccreq"),$(n).show(),$(n+" .required").show(),$(E+" .city").html("City"),$(a).show(),$(_).removeProp("disabled")):($(o).hide(),$(r).removeClass("ccreq"),$(r).prop("disabled","disabled"),$(i).removeClass("ccreq"),$(i).val(""),$(n).hide(),$(n+" .required").hide(),$(E+" .city").html("Postal Code & City"),$(a).show(),$(_).removeProp("disabled"))}function formValidate(e){showMainError=0,$(".alert").hide(),$("#"+e+" .ccreq:visible").each(function(){var e=$(this).val(),t=$(this).attr("id"),a=($(this).attr("type"),$(this).attr("placeholder"))
0==e.length?($("#"+t+"_ERROR .custom-error").html("Please Enter "+a),$("#"+t+"_ERROR").show(),$("#group_"+t).addClass("has-error"),showMainError=1):($("#"+t+"_ERROR").hide(),$("#group_"+t).removeClass("has-error"))}),$("#"+e+" input[type=email]").each(function(){var e=$(this).val(),t=$(this).attr("id")
if($("#"+t).hasClass("ccreq")||0!=e.length){var a=($(this).attr("type"),$(this).attr("placeholder")),_=/^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
valid_email=_.test(e),valid_email?$("#group_"+t).removeClass("has-error"):($("#"+t+"_ERROR .custom-error").html("The "+a+" you entered is invalid. Please enter a valid "+a),$("#"+t+"_ERROR").show(),$("#group_"+t).addClass("has-error"),showMainError=1)}else $("#group_"+t).removeClass("has-error")}),$("#"+e+" input[type=tel]:visible").each(function(){var e=$(this).val(),t=$(this).attr("id"),a=($(this).attr("type"),$(this).attr("placeholder")),_=$(this).attr("size")
e.length!=_&&e.length>0||0==e.length&&$(this).hasClass("ccreq")?($("#"+t+"_ERROR .custom-error").html("The "+a+" you entered is the incorrect length. Please enter a valid "+a),$("#"+t+"_ERROR").show(),$("#group_"+t).addClass("has-error"),showMainError=1):($("#"+t+"_ERROR").hide(),$("#group_"+t).removeClass("has-error"))})
var t=$("#"+e+"_ADDR_STREET_LINE1").val(),a=$("#"+e+"_ADDR_CITY").val();-1!=t.indexOf("270 Mohegan Ave")&&-1!=a.indexOf("New London")&&($("#"+e+"_CAMPUS_ADDR_ERROR").html("Please do not enter your campus address").show(),showMainError=1),"STUDENT"==e&&(0==checkNum("PARENT")?($("#PARENT_NUM_ERROR").show(),showMainError=1):$("#PARENT_NUM_ERROR").hide(),0==checkNum("CONTACT")?($("#CONTACT_NUM_ERROR").show(),showMainError=1):$("#CONTACT_NUM_ERROR").hide())}function submitMainForm(e){return formValidate(e),showMainError?(window.scrollTo(0,0),$("#"+e+"_MODAL").animate({scrollTop:0},"fast"),$("#STUDENT_FORM_ERROR").show(),!1):($("#STUDENT_FORM_ERROR").hide(),!0)}function populateModal(e,t){$.ajax({type:"POST",url:ajaxurl,data:JSON.stringify({PIDM:student_PIDM,PPID:t,DATA:e,MODE:"READ"}),datatype:"json",contentType:"application/json",success:function(a){$("#"+e+"_STUDENT_PIDM").val(student_PIDM),$("#"+e+"_PARENT_PPID").val(t)
var _=0
for("PARENT"==e?$.each(a.parent,function(t,a){if($("form#"+e+" #"+t).val(a),"EMERG_NO_CELL_PHONE"==t&&"Y"==a){$(".modal_mobile_phone_check").prop("checked",!0).change()
emergencyNumberToggle(e,1)}}):$.each(a.contact,function(t,a){var _=t,_=_.replace("EMERG","CONTACT")
if($("form#"+e+" #"+_).val(a),"EMERG_NO_CELL_PHONE"==t&&"Y"==a){$(".modal_mobile_phone_check").prop("checked",!0).change()
emergencyNumberToggle(e,1)}}),$.each(a.email,function(t,a){$("form#"+e+" #"+e+"_"+t).val(a)}),$.each(a.address,function(t,_){"ADDR_NATN_CODE"==t&&null==_?$("form#"+e+" #"+e+"_"+t).val("US"):"ADDR_NATN_CODE"==t&&"US"!=_?(countryProvinceDisplay(e,a.address.ADDR_NATN_CODE),$("form#"+e+" #"+e+"_"+t).val(_),$("form#"+e+" #"+e+"_ADDR_PROV_REGION").val(a.address.ADDR_STAT_CODE)):$("form#"+e+" #"+e+"_"+t).val(_)}),""==$("#STUDENT_ADDR_STREET_LINE1").val()&&$("form#"+e+" #GROUP_"+e+"_ADDRESS_TO_USE").hide(),i=0;i<a.phones.length;i++)$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_CODE").val(a.phones[i].PHONE_CODE),"EP"==a.phones[i].PHONE_CODE?(_=1)&&(""!=a.phones[i].PHONE_NUMBER_INTL&&null!=a.phones[i].PHONE_NUMBER_INTL?($("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER").hide(),$("#"+e+"_PHONE_EMERGENCY_NUMBER_INTL").val(a.phones[i].PHONE_NUMBER_INTL),$("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL").show(),$("#"+e+"_PHONE_EMERGENCY_NUMBER_INTL").addClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_AREA_CODE").removeClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_NUMBER").removeClass("ccreq"),$("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL_SWITCH .intl_number_switch").html("Enter U.S. Number")):($("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL").hide(),$("#"+e+"_PHONE_EMERGENCY_AREA_CODE").val(a.phones[i].PHONE_AREA_CODE),$("#"+e+"_PHONE_EMERGENCY_NUMBER").val(a.phones[i].PHONE_NUMBER),$("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER").show(),$("#"+e+"_PHONE_EMERGENCY_NUMBER_INTL").removeClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_AREA_CODE").addClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_NUMBER").addClass("ccreq"),$("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL_SWITCH .intl_number_switch").html("Enter International Number"))):"CP"==a.phones[i].PHONE_CODE?""!=a.phones[i].PHONE_NUMBER_INTL&&null!=a.phones[i].PHONE_NUMBER_INTL?($("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").hide(),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL").val(a.phones[i].PHONE_NUMBER_INTL),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_AREA_CODE").removeClass("ccreq"),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").removeClass("ccreq"),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL").show(),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL_SWITCH .intl_number_switch").html("Enter U.S. Number")):($("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_AREA_CODE").val(a.phones[i].PHONE_AREA_CODE),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL").hide(),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").val(a.phones[i].PHONE_NUMBER),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_AREA_CODE").addClass("ccreq"),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").addClass("ccreq"),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").show(),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL_SWITCH .intl_number_switch").html("Enter International Number")):""!=a.phones[i].PHONE_NUMBER_INTL&&null!=a.phones[i].PHONE_NUMBER_INTL?($("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").hide(),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL").val(a.phones[i].PHONE_NUMBER_INTL),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL").show(),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL_SWITCH .intl_number_switch").html("Enter U.S. Number")):($("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_AREA_CODE").val(a.phones[i].PHONE_AREA_CODE),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL").hide(),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").val(a.phones[i].PHONE_NUMBER),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER").show(),$("#GROUP_"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_NUMBER_INTL_SWITCH .intl_number_switch").html("Enter International Number")),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_SEQUENCE_NO").val(a.phones[i].PHONE_SEQUENCE_NO),$("#"+e+"_PHONE_"+a.phones[i].PHONE_CODE+"_CARRIER").val(a.phones[i].PHONE_CARRIER)},error:function(e,t,a){}}),$("#"+e+"_MODAL").modal("show")}function submitModal(e,t){if(formValidate(e),showMainError)return window.scrollTo(0,0),$("#"+e+"_MODAL").animate({scrollTop:0},"fast"),$("#"+e+"_MODAL_ERROR").show(),!1
if(0==t.length)$("#"+e+"_MODAL").hide(),$("#"+e+"_CLOSE_BUTTON").trigger("click"),$("#ERROR_MODAL").modal("show")
else{if(!(checkNum(e)>=totalAllowed(e))){$("#"+e+"_MODAL_ERROR").hide(),$(".alert_danger").hide()
var a=$("#"+e+"_PARENT_PPID").val(),_=$("#"+e+"_PREF_FIRST_NAME").val()+" "+$("#"+e+"_PREF_LAST_NAME").val()
formData='{"PIDM" : "'+t+'",',0==a?formData+='"PPID" : null,':formData=formData+'"PPID" :  "'+a+'",',formData=formData+'"DATA" : "'+e+'","MODE" : "WRITE",'
for(var o=["DEMO","EMAIL","ADDRESS"],r=0;r<o.length;r++)"DEMO"==o[r]?"PARENT"==e?formData+='"parent" : {':formData+='"contact" : {':formData=formData+'"'+o[r].toLowerCase()+'": {',x=0,$("."+e+"_"+o[r]+"_FIELD").each(function(){if($(this).is(":visible")||$(this).attr("name","PECI_EMAIL_CODE")&&"EMAIL"==o[r]){var t=$(this).val(),a=$(this).attr("name")
if("DEMO"!=o[r])var a=a.replace("PARENT_",""),a=a.replace("EMERG_",""),a=a.replace("CONTACT_","")
else var a=a.replace("CONTACT","EMERG")
if("DEPENDENT"==a)if(dependent_field="form#"+e+" #DEPENDENT",$(dependent_field).is(":checked"))var t="Y"
else var t="N"
if("EMERG_NO_CELL_PHONE"==a.substr(a.length-19))if(a="EMERG_NO_CELL_PHONE",$(this).is(":checked"))var t="Y"
else var t="N"
0==x?x+=1:formData+=",",addToFormData(t,a)}}),formData+="},"
formData+='"phones": [ {'
for(var E=["CP","EP","MA","BU"],n=0;n<E.length;n++){"CP"!=E[n]&&(formData+="},{")
var i=$("#"+e+"_PHONE_"+E[n]+"_SEQUENCE_NO").val(),s=$("#"+e+"_PHONE_"+E[n]+"_CODE").val()
if("EP"==E[n])if($("#"+e+"_EMERG_NO_CELL_PHONE").is(":checked"))if($("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL").is(":visible"))var l="",c="",N=$("#"+e+"_PHONE_EMERGENCY_NUMBER_INTL").val()
else var l=$("#"+e+"_PHONE_EMERGENCY_AREA_CODE").val(),c=$("#"+e+"_PHONE_EMERGENCY_NUMBER").val(),N=""
else var l="",c="",N="",h=""
else if("CP"==E[n])if($("#"+e+"_EMERG_NO_CELL_PHONE").is(":checked"))var l="",c="",N="",h=""
else if($("#GROUP_"+e+"_PHONE_"+E[n]+"_NUMBER_INTL").is(":visible"))var l="",c="",N=$("#"+e+"_PHONE_"+E[n]+"_NUMBER_INTL").val()
else var l=$("#"+e+"_PHONE_"+E[n]+"_AREA_CODE").val(),c=$("#"+e+"_PHONE_"+E[n]+"_NUMBER").val(),N=""
else if($("#GROUP_"+e+"_PHONE_"+E[n]+"_NUMBER_INTL").is(":visible"))var l="",c="",N=$("#"+e+"_PHONE_"+E[n]+"_NUMBER_INTL").val()
else var l=$("#"+e+"_PHONE_"+E[n]+"_AREA_CODE").val(),c=$("#"+e+"_PHONE_"+E[n]+"_NUMBER").val(),N=""
var h=$("#"+e+"_PHONE_"+E[n]+"_CARRIER").val()
0==i.length?formData+='"PHONE_SEQUENCE_NO" : null,':formData=formData+'"PHONE_SEQUENCE_NO" : "'+i+'",',formData=formData+'"PHONE_AREA_CODE" : "'+l+'",',formData=formData+'"PHONE_NUMBER" : "'+c+'",',formData=formData+'"PHONE_CODE" : "'+s+'",',formData=formData+'"PHONE_NUMBER_INTL" : "'+N+'",',void 0==h||0==i.length?formData+='"CELL_PHONE_CARRIER" : null':formData=formData+'"CELL_PHONE_CARRIER" : "'+h+'"',$("#"+e+"_PHONE_"+E[n]+"_SEQUENCE_NO").val("")}return $("#"+e+"_PHONE_EMR_SEQUENCE_NO").val(""),formData+="}]",formData+="}",_.length>1&&0!=t.length?$.ajax({type:"POST",url:ajaxurl,data:formData,dataType:"json",contentType:"application/json",success:function(t){0==a?(checkNum("CONTACT")<totalAllowed("CONTACT")?addToList(e,_,t.PARENT_PPID,1):addToList(e,_,t.PARENT_PPID,0),"PARENT"==e&&checkNum("CONTACT")<totalAllowed("CONTACT")&&promoteParent(t.PARENT_PPID,_)):($("#PARENT_LIST #parent_"+a+" .contact-name").html("<strong>"+_+"</strong>"),$("#CONTACT_LIST #emr_contact_"+a+" .contact-name").html("<strong>"+_+"</strong>")),$("#PARENT_PARENT_PPID").val(0),$("#CONTACT_PARENT_PPID").val(0),resetIntlModalNumbers(),getAlertNumbers(),$("form#PARENT #GROUP_PARENT_ADDRESS_TO_USE").show(),$("form#CONTACT #GROUP_CONTACT_ADDRESS_TO_USE").show(),$(".modal_mobile_phone_check").is(":checked")&&$(".modal_mobile_phone_check").prop("checked",!1).change(),document.getElementById(e).reset(),$("#"+e+"_CLNADDR_RESULTS").hide(),$("#"+e+"_MODAL").hide(),$("#"+e+"_CLOSE_BUTTON").trigger("click"),$("#CONFIRMATION_MODAL").modal("show"),setEmrOrder(),setTimeout(function(){entryCheck()},1500)},error:function(t){return $("#"+e+"_MODAL").hide(),$("#"+e+"_CLOSE_BUTTON").trigger("click"),$("#ERROR_MODAL").modal("show"),!1}}):($("#"+e+"_MODAL").hide(),$("#"+e+"_CLOSE_BUTTON").trigger("click"),$("#ERROR_MODAL").modal("show")),!1}$("#"+e+"_MODAL").hide(),$("#"+e+"_CLOSE_BUTTON").trigger("click"),$("#MAX_"+e+"S_ALLOWED_MODAL").modal()}}function resetIntlModalNumbers(){$(".modal_intl_form_group").each(function(){thisID=$(this).attr("id"),thisHTML=$("#"+thisID+"_SWITCH .modal_intl_number_switch").html(),"Enter U.S. Number"==thisHTML&&$("#"+thisID+"_SWITCH .modal_intl_number_switch").trigger("click")})}function resetPhoneSequenceNo(){for(var e=["PARENT","CONTACT"],t=["CP","EP","MA","BU"],a=0;a<e.length;a++){for(var _=0;_<t.length;_++)$("#"+e[a]+"_PHONE_"+t[_]+"_SEQUENCE_NO").val("")
$("#"+e+"_PARENT_PPID").val(0)}}function addToFormData(e,t){return formData=formData+'"'+t+'" : ',0!=e.length?formData=formData+'"'+e+'"':formData+="null",formData}function addToList(e,t,a,_){"PARENT"==e?addParent(e,a,t,_):addContact(e,a,t)}function addParent(e,t,a,_){var o='<div class="panel panel-default PARENT-LISTED" id="parent_'+t+'"><div class="panel-body"><span class="contact-name"><strong>'+a+'</strong></span><a href="#" title="Edit" class="showModal" data-ppid="'+t+'" data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="'+a+'" data-ppid="'+t+'"  data-modal-type="PARENT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a><span class="emergency_contact_switch">&nbsp;Emergency Contact: <input type="checkbox" name="PARENT" checked="checked" class="bootstrap-switch parent-bootstrap-switch" data-ppid="'+t+'" data-off-text="No" data-on-text="Yes"></span></div></div>'
$("#PARENT_LIST").append(o)
var r=$(".parent-bootstrap-switch:checked").length
1==r?$("#PARENT_LIST #parent_"+t+" .bootstrap-switch").bootstrapSwitch("disabled",!0):r>1&&$(".parent-bootstrap-switch:checked").each(function(){$(this).bootstrapSwitch("disabled",!1)}),_||$("#PARENT_LIST #parent_"+t+" .parent-bootstrap-switch").bootstrapSwitch("state",!1),$("#PARENT_LIST #parent_"+t+" .bootstrap-switch").on("switchChange.bootstrapSwitch",function(e,_){emergencySwitchToggle(t,a,e,_)}),$("#PARENT_LIST #parent_"+t).on("click",".showModal",function(){populateModal("PARENT",t)}),$("#PARENT_LIST #parent_"+t).on("click",".deleteModal",function(){showDeleteModal("PARENT",t,a)})}function addParentAsContact(e,t,a){var _='<li class="panel panel-info CONTACT-LISTED" id="emr_contact_'+t+'"><div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div><div class="panel-body"><span class="contact-name"><strong>'+a+'</strong></span> &nbsp; <a href="#" title="Edit"  class="showModal" data-ppid="'+t+'" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a></div></li>'
$("#CONTACT_LIST").append(_),$("#CONTACT_LIST #emr_contact_"+t).on("click",".showModal",function(){populateModal("CONTACT",t)})}function addContact(e,t,a){var _='<li class="panel panel-info CONTACT-LISTED" id="emr_contact_'+t+'"><div class="panel-heading"><span aria-hidden="true" class="glyphicon glyphicon-move" ></span> Emergency Contact - Drag to reorder</div><div class="panel-body"><span class="contact-name"><strong>'+a+'</strong></span> &nbsp; <a href="#" title="Edit"  class="showModal" data-ppid="'+t+'" data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-pencil" ></span></a>&nbsp;<a href="#" title="Delete" class="deleteModal" data-name="'+a+'" data-ppid="'+t+'"  data-modal-type="CONTACT"><span aria-hidden="true" class="glyphicon glyphicon-trash"></span></a></div></li>'
$("#CONTACT_LIST").append(_),$("#CONTACT_LIST #emr_contact_"+t).on("click",".showModal",function(){populateModal("CONTACT",t)}),$("#CONTACT_LIST #emr_contact_"+t).on("click",".deleteModal",function(){showDeleteModal("CONTACT",t,a)})}function addCampusAlertNumber(e,t,a){if("STUDENT"==a)if($("#STUDENT_EP_NUMBER").length)$("#STUDENT_EP_NUMBER").val(e),$("#STUDENT_EP_NUMBER_TEXT").html("&nbsp;"+e+"&nbsp;("+t+" - Your phone number will always be contacted)")
else{var _='<li class="list-unstyled grayed-out alert_phone_number"><input type="checkbox" value="'+e+'" name="fields[25]" checked="checked" disabled="disabled" id="STUDENT_EP_NUMBER"><span id="STUDENT_EP_NUMBER_TEXT">&nbsp;&nbsp;'+e+"&nbsp;("+t+" - Your phone number will always be contacted)</span></li>"
$("#CAMPUS_ALERT_NUMBERS").prepend(_)}else{var _='<li class="list-unstyled alert_phone_number"><input type="checkbox" value="'+e+'" name="fields[25]">&nbsp;'+e+"&nbsp;("+t+")</li>"
$("#CAMPUS_ALERT_NUMBERS").append(_)}}function emergencyNumberToggle(e,t){t?($("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER").show(),$("#"+e+"_EMERGENCY_PHONE").addClass("ccreq"),$("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL_SWITCH").show(),$("form#"+e+" PHONE_CP_NUMBER_ERROR").hide(),$("#GROUP_"+e+"_PHONE_CP_NUMBER .required").hide(),$("#GROUP_"+e+"_PHONE_CP_NUMBER_INTL .required").hide(),$("#"+e+"_PHONE_CP_AREA_CODE").removeClass("ccreq"),$("#"+e+"_PHONE_CP_NUMBER").removeClass("ccreq"),$("#"+e+"_PHONE_CP_NUMBER_INTL").removeClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_AREA_CODE").addClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_NUMBER").addClass("ccreq"),$("#GROUP_"+e+"_PHONE_CARRIER .required").hide(),"STUDENT"==e&&($("#paragraph_alert_text_check").hide(),$("#group_alert_text_check").hide(),$("#paragraph_tty_device_check").html("If your emergency phone is a TTY device (for the hearing impaired) please indicate below:"))):($("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER").hide(),$("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL").hide(),$("#"+e+"_EMERGENCY_PHONE").removeClass("ccreq"),$("#GROUP_"+e+"_PHONE_EMERGENCY_NUMBER_INTL_SWITCH").hide(),$("#GROUP_"+e+"_PHONE_CP_NUMBER .required").show(),$("#"+e+"_PHONE_CP_AREA_CODE").addClass("ccreq"),$("#"+e+"_PHONE_CP_NUMBER").addClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_AREA_CODE").removeClass("ccreq"),$("#"+e+"_PHONE_EMERGENCY_NUMBER").removeClass("ccreq"),$("form#"+e+" #GROUP_PHONE_CARRIER .required").show(),"STUDENT"==e&&($("#paragraph_alert_text_check").show(),$("#group_alert_text_check").show(),$("#paragraph_tty_device_check").html("If your mobile phone is a TTY device (for the hearing impaired) please indicate below:")))}function emergencySwitchToggle(e,t,a,_){var o=!1,r=$(".parent-bootstrap-switch:checked").length
0==_?(1>r?0==deanExceptionDate.length?$(this).bootstrapSwitch("state",!0):o=!0:1==r?0==deanExceptionDate.length?($(".parent-bootstrap-switch:checked").bootstrapSwitch("disabled",!0),o=!0):o=!0:($(".parent-bootstrap-switch").bootstrapSwitch("disabled",!1),o=!0),o&&($("#emr_contact_"+e).hide(),performDelete(e,"CONTACT")),setEmrOrder()):0==$("#emr_contact_"+e).length&&(1>r?0==deanExceptionDate.length&&$(this).bootstrapSwitch("state",!0):1==r?0==deanExceptionDate.length&&$(".parent-bootstrap-switch:checked").bootstrapSwitch("disabled",!0):$(".parent-bootstrap-switch").bootstrapSwitch("disabled",!1),checkNum("CONTACT")>=totalAllowed("CONTACT")&&($("#parent_"+e+" .parent-bootstrap-switch").bootstrapSwitch("state",!1),$("#MAX_CONTACTS_ALLOWED_MODAL").modal()),promoteParent(e,t))}function promoteParent(e,t){$.ajax({type:"POST",url:ajaxurl,data:JSON.stringify({PIDM:student_PIDM,PPID:e,DATA:"PARENT",MODE:"PROMOTE"}),datatype:"json",contentType:"application/json",success:function(a){0==$("#emr_contact_"+e).length&&addParentAsContact("PARENT",e,t),getAlertNumbers(),setEmrOrder()},error:function(e,t,a){}})}function getAlertNumbers(){$.ajax({type:"POST",url:ajaxurl,data:JSON.stringify({PIDM:student_PIDM,PPID:null,DATA:"PHONES",MODE:"READ"}),datatype:"json",contentType:"application/json",success:function(e){for(e.phones.length>0&&$(".NON-STUDENT-EP-NUMBER").remove(),i=0;i<e.phones.length;i++){var t=e.phones[i].PHONE_CODE
if("EP"!=t){var a=e.phones[i].PHONE_AREA_CODE,_=e.phones[i].PHONE_NUMBER,o=e.phones[i].PHONE_NUMBER_INTL,r=(e.phones[i].PHONE_SEQUENCE_NO,e.phones[i].Pref_Name)
if(null!=o)if(o.length>0)var E=o
else var E=""+a+_
else var E=""+a+_
if(-1==$.inArray(E,checked_phone_numbers))var n='<li class="list-unstyled NON-STUDENT-EP-NUMBER alert_phone_number"><input type="checkbox" value="'+E+'" name="fields[25]" onchange="alertNumberReview(this)">&nbsp;'+E+"&nbsp;("+r+")</li>"
else var n='<li class="list-unstyled NON-STUDENT-EP-NUMBER alert_phone_number"><input type="checkbox" checked="checked" value="'+E+'" name="fields[25]" onchange="alertNumberReview(this)">&nbsp;'+E+"&nbsp;("+r+")</li>"
$("#CAMPUS_ALERT_NUMBERS").append(n)}}},error:function(e,t,a){}})}function setEmrOrder(){var e=$(".draggablePanelList"),t="",a=0
$(".panel",e).each(function(e,_){var o=$(_)
if(o.is(":visible")){var r=(o.index(),o.attr("id").replace("emr_contact_",""))
r=r.replace("parent_",""),0!=a&&(t+=","),t+=r,a+=1}}),$("#emr_order").val(t)}$(document).ready(function(){$("#noscriptmsg").hide(),checked_phone_numbers=$("input[name=checked_phone_numbers]").map(function(e,t){return t.value}),entryCheck(),$("[data-toggle=popover]").popover(),$("[data-toggle=tooltip]").tooltip(),$("#CONTACT_LIST li").each(function(){var e=$(this).attr("id")
shortenedID=e.replace("emr_contact_",""),$("#PARENT_LIST #parent_"+shortenedID).length&&($("#parent_"+shortenedID+" .parent-bootstrap-switch").bootstrapSwitch("state",!0),$("#"+e+" .deleteModal").remove())}),emr_switch_count=$(".parent-bootstrap-switch:checked").length,1==emr_switch_count&&0==deanExceptionDate.length&&$(".parent-bootstrap-switch:checked").bootstrapSwitch("disabled",!0),$("mobile_phone_check").each(function(){if(this.checked){var e=$(this).closest("form").attr("id")
emergencyNumberToggle(e,1)}}),$(".mobile_phone_check").change(function(){var e=$(this).closest("form").attr("id"),t=this.checked?1:0
emergencyNumberToggle(e,t)}),$(".intl_number_switch").click(function(){var e=$(this).closest("form").attr("id"),t=$(this).attr("data-type"),a="#GROUP_"+e+"_PHONE_"+t+"_NUMBER_INTL",_="#GROUP_"+e+"_PHONE_"+t+"_NUMBER"
"none"==$(a).css("display")?($(_).hide(),$(a).show(),"STUDENT"==e&&($("#"+e+"_PHONE_"+t+"_AREA_CODE").val(""),$("#"+e+"_PHONE_"+t+"_NUMBER").val("")),$(this).html("Enter U.S. Number"),("CP"==t||"EMERGENCY"==t)&&($("#"+e+"_PHONE_"+t+"_NUMBER_INTL").addClass("ccreq"),$("#"+e+"_PHONE_"+t+"_AREA_CODE").removeClass("ccreq"),$("#"+e+"_PHONE_"+t+"_NUMBER").removeClass("ccreq"))):($(_).show(),$(a).hide(),"STUDENT"==e&&$("#"+e+"_PHONE_"+t+"_NUMBER_INTL").val(""),$(this).html("Enter International Number"),("CP"==t||"EMERGENCY"==t)&&($("#"+e+"_PHONE_"+t+"_NUMBER_INTL").removeClass("ccreq"),$("#"+e+"_PHONE_"+t+"_AREA_CODE").addClass("ccreq"),$("#"+e+"_PHONE_"+t+"_NUMBER").addClass("ccreq"))),"STUDENT"==e&&addCampusAlertNumber($(this).val(),student_name,"STUDENT")}),$(".student_phone_field").focusout(function(){var e=$(this).attr("data-phone-type"),t=$(this).attr("data-phone-intl")
if(1==t)var a=$("#STUDENT_PHONE_"+e+"_NUMBER_INTL").val()
else{var a=$("#STUDENT_PHONE_"+e+"_AREA_CODE").val()+""+$("#STUDENT_PHONE_"+e+"_NUMBER").val()
addCampusAlertNumber(a,student_name,"STUDENT")}}),$('input[name="PARENT"]').on("switchChange.bootstrapSwitch",function(e,t){var a=$(this).attr("data-ppid"),_=$("#parent_"+a+" .contact-name").html()
emergencySwitchToggle(a,_,e,t)}),$(".country_field").change(function(){var e=$(this).closest("form").attr("id"),t=$(this).val()
countryProvinceDisplay(e,t)}),$(".showModal").click(function(){modal_type=$(this).attr("data-modal-type"),ppid=$(this).attr("data-ppid"),populateModal(modal_type,ppid)}),$(".deleteModal").click(function(){var e=$(this).attr("data-modal-type"),t=$(this).attr("data-ppid"),a=$(this).attr("data-name")
showDeleteModal(e,t,a)}),$(".num_only").keypress(function(e){if(/^\d+$/.test(e.key));else{var t=e.which?e.which:e.keyCode
if("Delete"==e.key);else if(t>31&&(48>t||t>57))return!1}}),$(".area_code").on("input",function(){if($(this).val().length==$(this).attr("maxlength")){var e=$(this).closest("form").find(":input")
e.eq(e.index(this)+1).focus()}}),$("#CONTACT_MODAL").on("hidden.bs.modal",function(){document.getElementById("CONTACT").reset(),$(".modal_mobile_phone_check").is(":checked")&&$(".modal_mobile_phone_check").prop("checked",!1).change(),resetIntlModalNumbers(),resetPhoneSequenceNo(),$("#CONTACT_PARENT_PPID").val(0),$("form#CONTACT #GROUP_CONTACT_ADDRESS_TO_USE").show(),$("#CONTACT_CLNADDR_RESULTS").hide()}),$("#PARENT_MODAL").on("hidden.bs.modal",function(){document.getElementById("PARENT").reset(),$(".modal_mobile_phone_check").is(":checked")&&$(".modal_mobile_phone_check").prop("checked",!1).change(),resetIntlModalNumbers(),resetPhoneSequenceNo(),$("#PARENT_PARENT_PPID").val(0),$("form#PARENT #GROUP_PARENT_ADDRESS_TO_USE").show(),$("#PARENT_CLNADDR_RESULTS").hide()}),$("#CONTACT_MODAL, #PARENT_MODAL").on("shown.bs.modal",function(){""==$("#STUDENT_ADDR_STREET_LINE1").val()&&($("form#PARENT #GROUP_PARENT_ADDRESS_TO_USE").hide(),$("form#CONTACT #GROUP_CONTACT_ADDRESS_TO_USE").hide())}),$("#ADD_PARENT,#ADD_CONTACT").click(function(){resetPhoneSequenceNo()}),$("#PARENT_MODAL, #CONTACT_MODAL, #DELETE_MODAL").on("hidden.bs.modal",function(){$("#PARENT_MODAL .alert-danger, #CONTACT_MODAL .alert-danger, #DELETE_MODAL .alert-danger").hide(),$("#PARENT_MODAL .form-group, #CONTACT_MODAL .form-group, #DELETE_MODAL .form-group").removeClass("has-error")}),$("input.alert_phone_number").on("change",function(){alertNumberReview($(this))}),$(".address_to_use_checkbox").change(function(){var e=$(this).attr("name"),t=$(this).attr("data-type"),a=$("#SELECT_"+e).val(),_=$("#STUDENT_ADDR_NATN_CODE").val()
$(this).prop("checked")?"STUDENT"==a&&(countryProvinceDisplay(t,_),$(".STUDENT_ADDRESS_FIELD").each(function(){if($(this).is(":visible")){var e=$(this).attr("id"),e=e.replace("STUDENT",""),a=$(this).val()
$("#"+t+e).val(a)}})):"STUDENT"==a&&(countryProvinceDisplay(t,"US"),$(".STUDENT_ADDRESS_FIELD").each(function(){if($(this).is(":visible")){var e=$(this).attr("id"),e=e.replace("STUDENT","")
$(this).val()
$("#"+t+e).val("")}}))})})