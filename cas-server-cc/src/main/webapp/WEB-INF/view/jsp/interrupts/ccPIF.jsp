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

		jQuery.ajax({
			url: '../../PersonalInformationForm/form/cas',
			type: "POST",
			data: {username: "${cwUserName}"},
			success: function(data) {
				jQuery("#pif").append(data);
			},
            error: function(xhr, status) {
				jQuery("#pifLoadFailure").fadeIn(2000);
			}
		});

	});
</script>

<style type="text/css">
	/* Override the default position: absolute for the logo */
    #banner h1.logo {
    	position: relative;
    }
</style>

<div class="info" style="height: 900px; background-color: white;" >
	<h1>Personal Information Form</h1>

	<form:form commandName="${commandName}" htmlEscape="true" method="post">
    	<form:errors path="*" cssClass="errors" id="status" element="div" />

        <div id="spinner" style="display: none; position: absolute; top: 250px; left: 400px; height: 100px;">
            <h2>Your information is loading ...</h2>
            <img style="display: inline;" src="../../PersonalInformationForm/images/fedora-spinner.gif" />
        </div>
        <div id="pifLoadFailure" style="display: none;">
            <h2 style="color: red;">
                Unable to load your information from Banner!
                Please contact the helpdesk for assistance logging in.</h2>
        </div>

        <div id="pif"></div>

        <input type="hidden" name="lt" value="${loginTicket}" />
        <input type="hidden" name="execution" value="${flowExecutionKey}" />
        <input type="hidden" name="_eventId" value="submit" />

	</form:form>

</div>

<div>Once you have verified your information above, please click 'Continue' to login to the system.</div>
<jsp:directive.include file="includes/Bottom.jsp" />