<jsp:directive.include file="includes/Top.jsp" />
<c:set var="hasForm" value="1" scope="page" />

<script type="text/javascript">
	jQuery(document).ready( function() {
                hidePIF();

		jQuery.ajax({
			url: '../../PersonalInformationForm/form/cas',
			type: "POST",
			data: {username: "${cwUserName}"},
			success: function(data) {
                                showPIF(data);
			},
                        error: function(xhr, status) {
				jQuery("#pifLoadFailure").fadeIn(2000);
			}
		});

	});

        function hidePIF(){
            jQuery("#pif").hide();
            jQuery("#casContinue").hide();
            jQuery("#spinner").show();
        }

        function showPIF(html){
            jQuery("#pif").append(html);
            jQuery("#spinner").hide();
            jQuery("#pif").show();
            jQuery("#casContinue").show();
        }
</script>

<style type="text/css">
    /* Override to prevent background from scrolling */
    body {
        position: relative;
    }
    
    #instructions {
        color: #6F1C31;
        font-weight: bold;
    }

    /* Override jquery-ui elements since they're not rendering properly through the ajax call */
    .ui-widget button {
        font-family: Verdana,'Arial Narrow',helvetica,sans-serif;
        font-size: 1em;
    }

    #tabs .ui-state-default a {    
        background: none;
        background-color: #FEFEFE;
    }
    
    #tabs li:not(.ui-state-active) a {
        border-bottom: solid 1pt #A5C7E0;
    }
</style>

<div id="pifInterrupt">
    <div>
        <h2>Personal Information Form</h2>
        <span id="instructions">Once you have finished verifing your information below, please click 'Changes Complete' below to continue with the login process.</span>        
    </div>

    <div id="spinner" style="margin: 0 auto;" >
        <h2>Your information is loading ...</h2>
        <img style="display: inline;" src="../../PersonalInformationForm/images/fedora-spinner.gif" />
    </div>
        
    <div id="pifLoadFailure" style="display: none;">
        <h2 style="color: red;">
            Unable to load your information from Banner!
            Please contact the helpdesk for assistance logging in.</h2>
    </div>

    <div id="pifWrapper" style="overflow: hidden;">
        <div id="pif"></div>
    </div>

    <div id="casContinue" align="center" style="margin-left: 35%;">
        <form:form commandName="${commandName}" htmlEscape="true" method="post">
            <input type="hidden" name="lt" value="${loginTicket}" />
            <input type="hidden" name="execution" value="${flowExecutionKey}" />
            <input type="hidden" name="_eventId" value="submit" />
            <input type="submit" value="Changes Complete" id="btnSubmit" /><br /><br />
        </form:form>
    </div>
</div>

<jsp:directive.include file="includes/Bottom.jsp" />