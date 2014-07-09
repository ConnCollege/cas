<jsp:directive.include file="includes/Top.jsp" />
<c:set var="hasForm" value="1" scope="page" />
<div class="info">
<style type="text/css"> 
<!--
.style1 {
	color: #2461AA;
	font-weight: bold;
}
.header1 {font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #666666; font-weight: bold;}
p.prodCont {margin-left:5px;}
.style4 {color: #666666}
.style3 {color: #FFFFFF;
	font-size: 14px;
}
.style5 {color: #999999}
#buttonTable{ background:#f5f5f5; margin-top:15px;}
.btn{margin-top:27px;}
.greyLine{margin:10px 0;}
.prodImg{margin-bottom:5px;}
#editionTbl{margin-right:20px;}
.freeText{color:#E44949; font-size:120%; font-weight:bold;}
.smallFreeText{color:#E44949;}
p.tblHeader{margin:0 0 0 5px; padding:0; font-weight:bold;}
p.tblheader2{margin:0 0 0 5px; padding:0; color:#444;}
p.tblheader3{margin:0 0 0 15px; padding:0}
.star{font-weight:bold;}
.strikeout{color:#999;}
.prodHeader{ color:#666; font-size:120%; font-weight:bold;}
 
.u{text-decoration: underline;}
.b{font-weight: bold;}
.i{font-style: italic;}
.indent{text-indent: 3.0em;}
.indent2{text-indent: 6.0em;}
#content ul{margin-bottom: 1.2em;}
#content ul li{margin: 0 0 1.3em 0; padding: 0; list-style: none outside;}
#content ul.bul li{list-style: disc; margin: 0 0 0.5em 0;}

-->
</style>
<strong>Please read through the terms and conditions and click accept at the bottom of the page to continue.</strong><br />
<h1>Connecticut College Alumni Online Community Appropriate Use Policy</h1>
<iframe height="400" width="100%" src="https://www.conncoll.edu/camelweb-cms/appropriate-use-policy/"></iframe>
<form:form commandName="${commandName}" htmlEscape="true" method="post">
<div align="center"><input type="checkbox" onclick="flipSubmit()" id="Accept" value="1" /> I Accept Appropriate Use Policy &amp; Terms of Service<br />
	<input type="hidden" name="lt" value="${loginTicket}" />
	<input type="hidden" name="execution" value="${flowExecutionKey}" />
	<input type="hidden" name="_eventId" value="submit" />
    <input type="submit" value="Continue" id="btnSubmit" style="visibility:hidden" /><br /><br />
 </div>
</form:form>
</div>
<script type="text/javascript">
	var btn=document.getElementById('btnSubmit');
	function flipSubmit() {
		var check = document.getElementById('Accept');
		if (check.checked){
			btn.style.visibility='visible';
		}else{
			btn.style.visibility='hidden';
		}
	}
</script>
<jsp:directive.include file="includes/Bottom.jsp" />