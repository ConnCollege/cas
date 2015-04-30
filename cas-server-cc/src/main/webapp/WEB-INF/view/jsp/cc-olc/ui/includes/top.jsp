<!DOCTYPE html>
<!-- saved from url=(0048)http://dev.fastspot.com/clients/conn/dev/alumni/ -->

<html lang="en" class="js flexbox flexboxlegacy no-touch history rgba multiplebgs backgroundsize cssanimations csscolumns cssgradients csstransforms csstransforms3d csstransitions generatedcontent video audio svg pointerevents wf-chaparralpro-n4-active wf-chaparralpro-n7-active wf-chaparralpro-i4-active wf-chaparralpro-i7-active wf-active" data-useragent="Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36" data-platform="Win32">
	<script src="chrome-extension://hehijbfgiekmjfkfjpbkbammjbdenadd/js/ietabapi_wp.js"></script>
<!-- From contentarea100.html:  Start-End -->
<!-- For all pages -->
<!-- Related updates: 100, 101, 115 -->

<!-- File: 	loginform.html -->
<!-- NTV:	1.0 				-->

<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:theme code="mobile.custom.css.file" var="mobileCss" text="" />

<HEAD>
	<TITLE>Connecticut College Online Community - Login/Logout</TITLE>
	
<!-- From contentarea102.html:  START -->
<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="mobile-web-app-capable" content="yes">

		<!-- Page Attributes -->
		<title>Alumni (event photos) · Connecticut College</title>
		<meta name="description" content="">

		<!-- Favions / Touch Icons -->
		<link rel="apple-touch-icon" sizes="57x57" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-57x57.png">
		<link rel="apple-touch-icon" sizes="114x114" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-114x114.png">
		<link rel="apple-touch-icon" sizes="72x72" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-72x72.png">
		<link rel="apple-touch-icon" sizes="144x144" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-144x144.png">
		<link rel="apple-touch-icon" sizes="60x60" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-60x60.png">
		<link rel="apple-touch-icon" sizes="120x120" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-120x120.png">
		<link rel="apple-touch-icon" sizes="76x76" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-76x76.png">
		<link rel="apple-touch-icon" sizes="152x152" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-152x152.png">
		<link rel="apple-touch-icon" sizes="180x180" href="https://alumniconnections.com/olc/images/LV3/apple-touch-icon-180x180.png">
		<link rel="icon" type="image/png" href="https://alumniconnections.com/olc/images/LV3/favicon-192x192.png" sizes="192x192">
		<link rel="icon" type="image/png" href="https://alumniconnections.com/olc/images/LV3/favicon-160x160.png" sizes="160x160">
		<link rel="icon" type="image/png" href="https://alumniconnections.com/olc/images/LV3/favicon-96x96.png" sizes="96x96">
		<link rel="icon" type="image/png" href="https://alumniconnections.com/olc/images/LV3/favicon-16x16.png" sizes="16x16">
		<link rel="icon" type="image/png" href="https://alumniconnections.com/olc/images/LV3/favicon-32x32.png" sizes="32x32">
		<meta name="msapplication-TileColor" content="#00254d">
		<meta name="msapplication-TileImage" content="https://alumniconnections.com/olc/images/mstile-144x144.png">

		<!-- G+ & Facebook -->
		<meta property="og:title" content="Connecticut College">
		<meta property="og:url" content="http://www.conncoll.edu">
		<meta property="og:type" content="website">
		<meta property="og:image" content="//www.conncoll.edu/images/favicon/social.png">
		<meta property="og:description" content="Connecticut College educates students to put the liberal arts into action as citizens in a global society.">
		<meta property="og:site_name" content="Connecticut College">

		<!-- Twitter -->
		<meta name="twitter:card" content="summary">
		<meta name="twitter:site" content="@conncollege">
		<meta name="twitter:creator" content="@conncollege">
		<meta name="twitter:url" content="http://www.conncoll.edu">
		<meta name="twitter:title" content="Connecticut College">
		<meta name="twitter:description" content="Connecticut College educates students to put the liberal arts into action as citizens in a global society.">
		<meta name="twitter:image" content="http://www.conncoll.edu/images/favicon/social.png">

		<!-- Modernizer -->
		<script src="https://alumniconnections.com/olc/scripts/LV3/modernizr.custom.js"></script>

		<!-- Compiled CSS -->
		<!--[if gt IE 8]><!--><link rel="stylesheet" href="https://alumniconnections.com/olc/styles/LV3/site.css"><!--<![endif]-->

		<!--[if IE 8]>
			<script>var IE8 = true;</script>
			<script src="https://alumniconnections.com/olc/scripts/LV3/site-ie8.js"></script>
			<link rel="stylesheet" href="https://alumniconnections.com/olc/styles/LV3/ssite-ie8.css">
		<![endif]-->
		<!--[if IE 9]>
			<script>var IE9 = true;</script>
			<script src="https://alumniconnections.com/olc/scripts/LV3/ssite-ie9.js"></script>
			<link rel="stylesheet" href="https://alumniconnections.com/olc/styles/LV3/ssite-ie9.css">
		<![endif]--><style type="text/css">.tk-chaparral-pro{font-family:"chaparral-pro",sans-serif;}</style>
		<link rel="stylesheet" href="http://use.typekit.net/c/75f4df/1w;chaparral-pro,2,XXw:P:i4,XXn:P:i7,XY8:P:n4,XXk:P:n7/d?3bb2a6e53c9684ffdc9a9aff1d5b2a62de246c40fc2071e052ac61e333cceab3ecb7d24b91a4e781584b52c72264729ce43df1cf638a91700725b3204a6b4b127f98bddab448f6a970bb378e3f2c49dd7f39b88a959776399dc7c116e400bcc0cf">

<!-- OLC Global Stylesheet -->
<LINK REL="stylesheet" HREF="https://alumniconnections.com/olc/styles/LV3/olc_global_styles.css">
<!-- From contentarea102.html:  END -->


<style type="text/css">
	.errors{
		color: red;
	}
	.btn-submit {
	    border: 1px solid #ccc;
	}
</style>
	
	

</head>


<!-- From contentarea104.html:  START -->
<!-- Basic Body -->
<body class="gridlock  wallpaper-inititalized" onload="
">
<!-- Basic Body -->
<!-- From contentarea105.html: END -->



		<header class="site_header" id="header" role="banner">
			<div class="row">
				<div class="all-full branding">
					<!-- <div class="site_toggles">
						<button class="button color_white text_shadow no_margin site_toggle navigation_toggle takeover_toggle">Navigation</button>
						<button class="button color_white text_shadow no_margin site_toggle search_toggle">Search</button>
						<div class="search">
							<form action="http://www.conncoll.edu/search" method="get" class="search_form">
								<fieldset class="search_fields">
									<input type="text" class="text search_query" name="q" placeholder="" autocomplete="off">
									<input type="submit" class="submit search_submit" value="Search">
								</fieldset>
								</form>
						</div>
					</div> -->
					<a href="" class="logo">
						<span class="logo_text visually_hidden">Connecticut College</span>
					</a>
				</div>
			</div>
		</header>
		<div class="takeover_panel">
			<button class="button_close takeover_toggle">Close</button>
			<div class="row">
					<div class="mobile-full tablet-3 desktop-5 nav_primary_container">
											<div class="takeover_primary">
												<nav class="nav_primary" aria-label="site navigation">
										          	<ul class="plain_list">
										           		<li><a href="http://www.conncoll.edu/academics/">Academics</a></li>
										                <li><a href="http://www.conncoll.edu/campus-life/">Student Experience</a></li>
										                <li><a href="http://www.conncoll.edu/career/">Career Preparation</a></li>
										                <li><a href="http://www.conncoll.edu/admission/">Admission &amp; Financial Aid</a></li>
										                <li><a href="http://www.conncoll.edu/at-a-glance/">About Connecticut College</a></li>
										                <li><a href="http://www.conncoll.edu/community-visitors/">Campus &amp; Community</a></li>
										                <li><a href="http://www.conncoll.edu/alumni/">Alumni &amp; Life After Conn</a></li>
										                <li><a href="http://www.conncoll.edu/athletics/">Athletics</a></li>
										            </ul>

												</nav>

												<div style="float:right;">
										            <a class="button button_small button_border button_icon icon_right icon_right_white_sm button_gift" href="http://www.conncoll.edu/giving/">Make a gift</a>
										            <a style="clear:both;" class="button button_small button_border button_icon icon_right icon_right_white_sm button_gift" href="http://camelweb.conncoll.edu/">CamelWeb</a>

												</div>

												<nav class="nav_utility nav_utility_header" aria-label="utility navigation">
													<ul class="plain_list">
														<li><a href="http://www.conncoll.edu/events/">Calendar</a></li>
														<li><a href="http://www.conncoll.edu/news/">News</a></li>
														<li><a href="http://www.conncoll.edu/directories/">Directory</a></li>
														<li><a href="http://www.conncoll.edu/information-services/libraries/">Libraries</a></li>
														<li><a href="http://www.conncoll.edu/employment/">Employment</a></li>
														<li><a href="http://www.conncoll.edu/social-hub/">Social Media</a></li>
													</ul>
										       </nav>


											</div>
</div>
				<div class="mobile-full tablet-3 desktop-6 desktop-push-1 nav_role_container">
					<div class="takeover_secondary">
						<p class="label color_blue_6">Specialized Resources</p>
						<form action="#" method="GET">
													<select name="selecter_resources" id="selecter_resources" class="js-select selecter_resources" data-selecter-options="{&quot;customClass&quot;:&quot;resource_handle&quot;}">

														<option value="parent">Resources for alumni</option>
													</select>
												</form>
												<div class="nav_roles">
													<nav class="nav_role nav_role_student js-active" aria-label="student navigation">
													<ul class="plain_list">
													<li><a href="http://alumniconnections.com/olc/pub/LV3/oldintro/oldintro.cgi">Alumni Directory</a></li>
													<li><a href="http://alumniconnections.com/olc/pub/LV3/geventcal/showListView.jsp">Alumni Events</a></li>
													<li><a href="http://www.conncoll.edu/alumni/alumni-association/">Alumni Association</a></li>
													<li><a href="http://www.conncoll.edu/at-a-glance/connecticut-college-bookshop/">Bookshop</a></li>
													<li><a href="http://www.conncoll.edu/map/">Campus Map</a></li>
													<li><a href="http://www.conncoll.edu/alumni/ccnow/">CC:Now Newsetter</a></li>
													<li><a href="http://www.conncoll.edu/alumni/conn-in-a-box/">Conn in a Box</a></li>
													<li><a href="http://www.conncoll.edu/at-a-glance/directions-to-the-college/">Directions</a></li>
													<li><a href="http://www.conncoll.edu/equity-inclusion/">Equity and Inclusion</a></li>
													<li><a href="http://www.conncoll.edu/fall-weekend/">Fall Weekend</a></li>
													<li><a href="http://alumniconnections.com/olc/membersonly/LV3/library.html">Library Databases</a></li>
													<li><a href="http://www.conncoll.edu/alumni/alumni-association/notable-alumni/">Notable Alumni</a></li>
													<li><a href="http://www.conncoll.edu/alumni/online-community-help/alumni-login-help/">Password Help</a></li>
													<li><a href="http://www.conncoll.edu/reunion/">Reunion</a></li>
													<li><a href="http://www.conncoll.edu/giving/">Support the College</a></li>
													<li><a href="http://www.conncoll.edu/title-ix/">Title IX: Sexual Respect</a></li>
													<li><a href="http://alumniconnections.com/olc/membersonly/LV3/memberupdate/memberupdate.cgi">Update Your Info</a></li>
													<li><a href="http://www.conncoll.edu/alumni/volunteer/">Volunteer</a></li>

														</ul>

													</nav>
													<nav class="nav_role nav_role_parent" aria-label="parent navigation">



							</nav>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="mobile_search">
			<button class="button_close mobile_search_toggle">Close</button>
			<div class="row">
				<form action="http://www.conncoll.edu/search" method="get" class="mobile_search_form">
					<fieldset class="mobile_search_fields">
						<input type="text" class="text mobile_search_query mobile-2" name="q" placeholder="" autocomplete="off">
						<input type="submit" class="submit mobile_search_submit mobile-1" value="Search">
					</fieldset>
				</form>
			</div>
		</div>
		<div class="page" id="page">
<header class="page_header bg_color  margined_bottom_medium">
	<div class="row">
		<!-- Breadcrumbs -->
		<div class="all-full breadcrumbs no_margin">
			<ul>
				<li class="first_child"><a href="http://www.conncoll.edu" class="home-btn">Home</a><span class="separator">&nbsp;</span></li>
				<li class="last_child"><a href="http://www.conncoll.edu/alumni">Alumni &amp; Life After Conn</a></li>
			</ul>
		</div>
		<!-- END: Breadcrumbs -->
	</div>
	<div class="row">

	</div>

</header>
<div class="row margined_bottom_large">
	<div class="min-full mobile-full tablet-full desktop-3 right">
		<!-- Subnavigation -->
		<nav class="subnavigation margined naver"><span class="naver-handle">Additional Navigation</span><div class=""><div class="naver-container">
			<ul>
				<li><a href="http://www.conncoll.edu/alumni ">Alumni Home</a></li>
									<li><a href="http://alumniconnections.com/olc/membersonly/LV3/old/directory.cgi?FNC=basicsearch">Find Alumni</a></li>
									<li><a href="http://alumniconnections.com/olc/membersonly/LV3/mypage.jsp">My Profile</https://alumniconnections.com/olc/i>
									<li><a href="http://alumniconnections.com/olc/membersonly/LV3/hsearch/showSearch.jsp">Keyword Search</a></li>
									<li><a href="http://www.conncoll.edu/alumni/networking-careers/">Networking & Careers</a></li>
									<li><a href="http://www.conncoll.edu/alumni/volunteer/">Volunteer</a></li>
									<li><a href="http://alumniconnections.com/olc/pub/LV3/geventcal/showListView.jsp">Alumni Calendar</a></li>
									<li><a href="http://www.conncoll.edu/alumni/programs-events/">Programs &amp; Events</a></li>
									<li><a href="http://alumniconnections.com/olc/membersonly/LV3/library.html">Library Databases</a></li>
									<li><a href="http://www.conncoll.edu/alumni/alumni-association/">Alumni Association</a></li>
									<li><a href="http://www.conncoll.edu/alumni/online-community-help/">Online Community Help</a></li>
					<li><a href="http://www.conncoll.edu/alumni/support-the-college/">Support the College</a></li>
			</ul>
		</div></div></nav>
		<!-- END: Subnavigation -->
	</div>