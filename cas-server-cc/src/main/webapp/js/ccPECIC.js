function displayOutput(i,d){var s=""
return s=i.indexOf("RELT_CODE")>-1?displayRelationship(i,d):i.indexOf("ADDR_STAT_CODE")>-1?displayState(i,d):i.indexOf("ADDR_NATN_CODE")>-1?displayCountry(i,d):displayField(i,d)}function displayRelationship(i,d){var s="",e=relationshipCodes.indexOf(d)
return-1!=e&&(s+='<div class="row"><div class="col-xs-3"><div>Relationship</div></div><div class="col-xs-9"><div>',null!=d&&(s+=relationshipValues[e]),s+="</div></div></div>"),s}function displayState(i,d){var s="",e=stateCodes.indexOf(d)
if(-1!=e)s+='<div class="row"><div class="col-xs-3"><div>State</div></div><div class="col-xs-9"><div>',null!=d&&(s+=stateValues[e]),s+="</div></div></div>"
else{var n=regionCodes.indexOf(d);-1!=n&&(s+='<div class="row"><div class="col-xs-3"><div>Province/Region</div></div><div class="col-xs-9"><div>',null!=d&&(s+=regionValues[n]),s+="</div></div></div>")}return s}function displayCountry(i,d){var s="",e=countryCodes.indexOf(d)
return-1!=e&&(s+='<div class="row"><div class="col-xs-3"><div>Country</div></div><div class="col-xs-9"><div>',null!=d&&(s+=countryValues[e]),s+="</div></div></div>"),s}function displayField(i,d){var s="",e=demoFields.indexOf(i)
return-1!=e&&(s+='<div class="row"><div class="col-xs-3"><div>'+demoValues[e]+'</div></div><div class="col-xs-9"><div>',null!=d&&(s+=d),s+="</div></div></div>"),s}$(document).ready(function(){$(".contact_info").each(function(){var d=$(this).attr("data-ppid"),s=$(this).attr("data-type-id")
""!=d&&$.ajax({type:"POST",url:"/cas/cas-rest-api/peci/",data:JSON.stringify({PIDM:$student_PIDM,PPID:d,DATA:s,MODE:"READ"}),datatype:"json",contentType:"application/json",success:function(e){var n=""
for("CONTACT"==s?$.each(e.contact,function(i,e){var n=displayOutput(i,e)
$("#"+s+"_"+d).append(n)}):$.each(e.parent,function(i,e){var n=displayOutput(i,e)
$("#"+s+"_"+d).append(n)}),void 0!=e.email&&null!=e.email&&0!=e.email.length&&$.each(e.email,function(i,e){var n=displayOutput(i,e)
$("#"+s+"_"+d).append(n)}),$.each(e.address,function(i,e){var n=displayOutput(i,e)
$("#"+s+"_"+d).append(n)}),i=0;i<e.phones.length;i++){var a=e.phones[i].PHONE_CODE,o=e.phones[i].PHONE_AREA_CODE,t=e.phones[i].PHONE_NUMBER,l=e.phones[i].PHONE_NUMBER_INTL
l.length>0?phone_display=l:phone_display=o+" "+t
var n=(e.phones[i].PHONE_SEQUENCE_NO,e.phones[i].CELL_PHONE_CARRIER,"")
"CP"==a?phone_type="Mobile":"MA"==a?phone_type="Home":"BU"==a?phone_type="Office":"EP"==a&&(phone_type="Emergency"),n+='<div class="row"><div class="col-xs-3"><div>'+phone_type+' Phone</div></div><div class="col-xs-9">'+phone_display+"<div>",n+="</div></div></div>",$("#"+s+"_"+d).append(n)}},error:function(i,d,s){console.log("ERROR: "+i.responseText)}})}),$(".edit_link").click(function(){$("#editForm").submit()}),$("#confirm_button").click(function(){$("#confirmForm").submit()})})
