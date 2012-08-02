<jsp:directive.include file="includes/Top.jsp" />

<script type="text/javascript">
	jQuery(document).ready( function() {

		jQuery.ajaxSetup({
			beforeSend: function() {
				jQuery("#spinner").fadeIn(2000);
			},
            complete: function() {
            	jQuery("#spinner").fadeOut(2000);
            }
		});
		
	});
</script>

<div class="info" style="height: 900px; background-color: white;" >
	<h1>Personal Information Form</h1>
	
	<iframe src="../../PersonalInformationForm/form/cas" width="600" height="800">
		Your browser doesn't support iframes!
	</iframe>
	
</div>

<div>Once you have verified your information above, please click 'Continue' to login to the system.</div>
<jsp:directive.include file="includes/Bottom.jsp" />