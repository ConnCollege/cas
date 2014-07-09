<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="hasForm" value="0" scope="page" />
<!DOCTYPE html> 

<html class="ltr" dir="ltr" lang="en-US"> 

<head> 
	<title>Connecticut College Intranet Login</title> 
	<meta content="text/html; charset=UTF-8" http-equiv="content-type" /> <meta http-equiv="X-UA-Compatible" content="IE=edge;" /> 
	<link href="https://camelweb.conncoll.edu/LP5-ellucian-theme/images/favicon.ico" rel="Shortcut Icon" /> 
	<link class="lfr-css-file" href="https://camelweb.conncoll.edu/LP5-ellucian-theme/css/main.css" rel="stylesheet" type="text/css" /> 
	<script type="text/javascript" src="https://camelweb.conncoll.edu/html/js/jquery/jquery-1.8.3.min.js"></script> 
	<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
	<script type="text/javascript" src="https://camelweb.conncoll.edu/LP5-ellucian-theme/js/tooltip/js/tooltip.js"></script>
	<link href="https://camelweb.conncoll.edu/LP5-ellucian-theme/js/tooltip/css/tooltip.css" rel="stylesheet"> 
	<script type="text/javascript" src="https://camelweb.conncoll.edu/LP5-ellucian-theme/js/modalPopLite/js/modalPopLite.min.js"></script> 
	<link href="https://camelweb.conncoll.edu/LP5-ellucian-theme/js/modalPopLite/css/modalPopLite.css" rel="stylesheet">
	<style type="text/css">
		body, b, strong, p, h1, h2, h3, h4, em{
			font-family: Arial, Helvetica, sans-serif;
		}
		
		b, strong{
			font-weight: bold !important;
		}
	</style>

</head> 

<body class="blue controls-visible private-page">

<div class="portlet-boundary portlet-boundary_145_ portlet-static portlet-static-end portlet-dockbar "
		id="p_p_id_145_">
		<span id="p_145"></span>
		<div class="portlet-body">
			<div class="dockbar" data-namespace="_145_" id="dockbar">
				
				<ul class="aui-toolbar user-toolbar" id="dockbarControlPanelArea">					
					<li class="user-avatar user-info" id="_145_userAvatar"><span
						class="user-links "> <a href="##"
							class="menu-button user-button"> <span
								cssClass='user-fullname use-dialog username'>&nbsp;</span>
						</a>
					</span></li>
				</ul>
				<div class="dockbar-messages" id="_145_dockbarMessages">
					<div class="aui-header"></div>
					<div class="aui-body"></div>
					<div class="aui-footer"></div>
				</div>
			</div>
			<script type="text/javascript">
				/*<![CDATA[*/AUI().use("liferay-dockbar", function(a) {
					(function() {
						Liferay.Dockbar.init();
						var b = a.all(".portlet-column-content.customizable");
						if (b.size() > 0) {
							b.get("parentNode").addClass("customizable")
						}
					})()
				});/*]]>*/
			</script>
		</div>
	</div>	

<div id="wrapper">
		<header id="banner" role="banner">
			<div id="heading" class="inside">

				<div class="row" id="ccQuickLinks" data-position="bottom"
					data-intro="Your links to Email, Moodle, ePortfolio, ConnQuest, and Self Service are at the top of every Camelweb page.  Click Next to continue or click Skip to stop the tour."
					data-step="1">
					<div class="logo">
						<a href="/web/home-community/"><span style="font-family: serif;"><strong>Camel</strong>Web</span></a>
					</div>
					<a href="http://mail.conncoll.edu" rel="tooltip" title="Email"><img
						class="icon"
						src="https://www.conncoll.edu/camelweb/camelweb5/images/mail.png" /></a>
					<a href="http://moodle.conncoll.edu" rel="tooltip" title="Moodle"><img
						class="icon"
						src="https://www.conncoll.edu/camelweb/camelweb5/images/moodle.png" /></a>
					<a href="http://camelweb.conncoll.edu/web/home-community/eportfolio" rel="tooltip"
						title="ePortfolio"><img class="icon"
						src="https://www.conncoll.edu/camelweb/camelweb5/images/eportfolio.png" /></a>
					<a href="http://connquest.conncoll.edu" rel="tooltip"
						title="ConnQuest"><img class="icon"
						src="https://www.conncoll.edu/camelweb/camelweb5/images/connquest.png" /></a>
					<a href="http://testssb.conncoll.edu" rel="tooltip"
						title="Self Service"><img class="icon"
						src="https://www.conncoll.edu/camelweb/camelweb5/images/selfservice.png" /></a>
					</form>
				</div>
				<h2 class="page-title">
					<span tabindex="0">My Students</span>
				</h2>
				<div id="menuToggle"></div>
				<nav class="sort-pages modify-pages" id="navigation">
					<h1>
						<span>Navigation</span>
					</h1>
					<!-- place the gradient in a div separate than the ul to fix menu issues in IE -->
					<div class="navigation-gradient"></div>
					<div class="row">
						
					</div>
					<script type="text/javascript">
						/*<![CDATA[*/
						
					</script>
				</nav>
			</div>
		</header>


<!--- main table --->
</cfif>



<div id="content">


	<div class="columns-1" id="main-content" role="main">
		<div class="portlet-layout">
			<div class="portlet-column portlet-column-only" id="column-1">
				<div class="portlet-dropzone portlet-column-content portlet-column-content-only" id="layout-column_column-1">


					<div class="portlet-boundary portlet-boundary_48_  portlet-iframe " id="p_p_id_48_INSTANCE_ITEB0VdVjtsy_" >
						<span id="p_48_INSTANCE_ITEB0VdVjtsy"></span>
				
						<div class="portlet-body">
				
				
							<section class="portlet" id="CAS" style="padding:0 20px 20px;">
								<header class="portlet-topper">
									<h1 class="portlet-title"></h1>
								</header>	
								
								
								