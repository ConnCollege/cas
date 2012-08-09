<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
    <c:when test="${'${cwUserName}' == 'offCampus'}">
	<script type="text/javascript">
            <html dir="ltr" xmlns="http://www.w3.org/1999/xhtml">
                <head>	
                    <title>Connecticut College Intranet Login</title>
                    <meta content="text/html; charset=UTF-8" http-equiv="content-type" />
                    <link rel="Shortcut Icon" href="https://www.conncoll.edu/cw40/html/themes/classic/images/favicon.ico" />
                </head>
                <body>
                    <form:form method="post" id="fm1" cssClass="fm-v clearfix" htmlEscape="true">

                        <input type="hidden" name="lt" value="${loginTicket}" />
                        <input type="hidden" name="execution" value="${flowExecutionKey}" />
                        <input type="hidden" name="_eventId" value="submit" />
                    </form:form>
                    <script  type="text/javascript">
	                document.getElementById('fm1').submit();
                    </script>
                </body>
             </html>
        </script>
    </c:when>
    <c:otherwise>
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
	                jQuery("#pif").append(data);
		    },
	            complete: function() {
	                showPIF();
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

            function showPIF(){
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

            #instructions, #casContinue input {
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

User is: '${cwUserName}'

        <div id="pifInterrupt">
            <div>
                <h2>Personal Information Form</h2>
                <span id="instructions">Once you have finished verifing your information on each tab, please click 'Verification Complete' below to continue with the login process.</span>        
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
                <form:form id="fm1" commandName="${commandName}" htmlEscape="true" method="post">
                    <input type="hidden" name="lt" value="${loginTicket}" />
                    <input type="hidden" name="execution" value="${flowExecutionKey}" />
                    <input type="hidden" name="_eventId" value="submit" />
                    <input type="submit" value="Verification Complete" id="btnSubmit" /><br /><br />
                </form:form>
            </div>
        </div>

        <jsp:directive.include file="includes/Bottom.jsp" />
    </c:otherwise>
</c:choose>