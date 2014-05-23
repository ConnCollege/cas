<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="en">

	<head>
		<meta charset="utf-8" />
	    <meta name="author" content="Teagan Atwater and Connecticut College ES" />
	    <link rel="stylesheet" type="text/css" href="css/default.css" />
	    <link rel="stylesheet" type="text/css" href="css/login.css" />
	    <link rel="stylesheet" type="text/css" href="css/slideshow.css" />
	    <link rel="icon" href="<%= request.getContextPath() %>/favicon.ico" type="image/x-icon" />
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta name="apple-mobile-web-app-capable" content="yes" />
	    <!--[if lt IE 9]><script src="https://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
	    <title>Connecticut College Login</title>
	    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
	    <script>window.jQuery || document.write('<script src="//www.conncoll.edu/scripts/jquery/jquery.js"><\/script>')</script>
	    <script src="https://www.conncoll.edu/scripts/jquery/placeholder/Placeholders.min.js"></script>
	    <script type="text/javascript">
			jQuery(document).ready(function() {		
				jQuery('.errors').hide();
				jQuery('.errors').fadeIn(300).delay(4000).animate({opacity:0,height:0}, 'slow', function() {
	        		jQuery(this).remove();
	    		});
				//init placeholders (for non html5 browsers to display placeholders within fields)
				Placeholders.init({
    				live: true
				});
			});
		</script>
    
  	</head>
	

	<body id="cas">
		<div id="wave">
	    <div id="login">
