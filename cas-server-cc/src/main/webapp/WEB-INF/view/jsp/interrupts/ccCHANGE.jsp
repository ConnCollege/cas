<jsp:directive.include file="includes/Top.jsp" />
<div class="info">
	<style type="text/css">
		#MainErrorHead,#MainErrorFoot {
			background: #FF9999;
			padding: 5px;
			border: 3px solid #840000;
			text-align: center;
			font-weight: bold;
			width: 97%;
			margin: 2px 0 2px 0;
			color: #fff;
		}
		
		.message {
			background: #D7EED7;
			border: 3px solid #99CC99;
			text-align: center;
			clear: both;
			margin-top: 100px;
			margin-bottom: -20px;
		}
		
		.errorMessage {
			background: #FFDAD9;
			border: 2px solid #FF9999;
			text-align: center;
			padding: 2px;
			margin-bottom: 2px;
			clear: both;
		}
	</style>

	<div id="SuccessMessage" style="display: none;" class="message">
		<strong>Your password has been successfully updated</strong>
	</div>
	<br /> <a id="d.en.21322"></a>

	<h1>How to Change Your Password</h1>
	<br clear="all" />
	<!-- navigation object : Admission - Thumbnail-->
	<br />
	<p>&nbsp;</p>
	<div id="HowToText">
		<div id="MainErrorHead" style="display: none; background: #f00;">
			<strong>There was an error with your form. Please fix all
				fields as noted below in pink.</strong>
		</div>
		<p>The criteria for passwords are:</p>
		<ul>
			<li>It must be at least eight characters in length.</li>
			<li>It may not contain any part of your CC User Id.</li>
			<li>It must contain characters from three of the following
				categories:
				<ul>
					<li>English uppercase characters (A through Z)</li>
					<li>English lower case characters (a through z)</li>
					<li>Numbers (0 through 9)</li>
					<li>Non-alphabetic characters (for example, ! $,#, %).</li>
				</ul>
			</li>
		</ul>
		<p>If you are unable to log in to your email account after
			changing your password, contact the IT Service Desk at x4357. You can
			also stop by the Service Desk in the lower level of Hamilton House
			(during the Shain renovation).</p>
		<p>Below are some examples of passwords that would follow the
			necessary criteria:</p>
		<ul>
			<li>&amp;Ez2dooo</li>
			<li>Suce$$ful</li>
			<li>2S!ncere</li>
			<li>Etc&amp;etc</li>
			<li>Came12oo4</li>
		</ul>
		<p>
			Passwords will now need to be changed every 180 days. Please choose a
			password that meets the above requirements but is easy enough to
			remember that you do not have to write it down. The three previous
			passwords cannot be used. (If you do feel the need to write your
			password down, please store it in a secure location!)<br />
			<em>Do not use the example passwords above.</em>
		</p>
	</div>
	<div id="SuccessText" style="display: none;">
		<p>
			<strong>You may also need to change your password in other
				places as well.</strong>
		</p>
		<p>
			<strong>CCFacStaff or CCStudent</strong> - <em>Our encrypted
				wireless networks</em>.<br /> If the CCFacStaff or CCStudent wireless
			network does not ask for a new password when you reconnect, you will
			have to go through CCReg to re-register your machine. In your Wi-Fi
			network list select CCReg. Follow the on-screen instructions to
			reconfigure your profile with your new password.
		</p>
		<p>
			<strong>Email Client</strong> - <em>If you use something other
				than your browser to check email</em>.<br /> This is just another name
			for a standalone email program. This may be on your computer, tablet
			or smartphone. Go to the Preferences or Settings for the program and
			change the password to your new password.
		</p>
		<p>
			<strong>Calendar</strong> - <em>If you use something other than
				your browser to view your calendar</em>.<br /> This is just another name
			for a standalone calendar program. This may be on your computer,
			tablet or smartphone. Go to the Preferences or Settings for the
			program and change the password to your new password.
		</p>
		<p>
			<strong>Google Notifier</strong> - <em>If you use this app to
				augment your CC mail</em>.<br /> Click on the Google Mail icon on the
			top menu in the upper right of the app and select Preferences. Then
			click on the "Accounts" tab and then click the "Change Account"
			button and enter your new password.
		</p>
	</div>


	<script type="text/javascript">
		if (document.location.protocol != "https:") {
			document.location.href = "https://" + document.domain
					+ location.pathname;
		}
		var ccPopUp = 0;
		var ccPassMin = 8;
		var ErrorColor = "#FFDAD9";
		var ccFuncOnInvalid = true;
		ccHTMLHead = '<strong>';
		ccHTMLFoot = '</strong>';

		function InLineValid() {
			bvalid = true;
			var p1 = document.getElementById("newpass1");
			var p2 = document.getElementById("newpass2");
			var uid = document.getElementById("uname").value;
			var pe = document.getElementById("newpass1Error");
			if (p1.value != p2.value) {
				bvalid = false;
				pe.innerHTML = pe.innerHTML
						+ '<strong> New password and confirm new password must match.</strong>';
				pe.style.display = '';
				p1.style.backgroundColor = ErrorColor;
				p2.style.backgroundColor = ErrorColor;
				document.getElementById("MainErrorHead").style.display = '';
				document.getElementById("MainErrorFoot").style.display = '';
			}
			if (p1.value.indexOf(uid) != -1 && uid != '') {
				bvalid = false;
				pe.innerHTML = pe.innerHTML
						+ '<strong> Password can not contain your user name.</strong>';
				pe.style.display = '';
				objElement.style.backgroundColor = ErrorColor;
				document.getElementById("MainErrorHead").style.display = '';
				document.getElementById("MainErrorFoot").style.display = '';
			}
			return bvalid;
		}
	</script>
	<style type="text/css">
		input {
			color: #01376E;
			border: 1px solid #2F5989;
		}
		
		select {
			color: #01376E;
		}
	</style>
	<form action="" method="post" onSubmit="return InLineValid();">
		<table width="535" border="0" cellspacing="0" cellpadding="2"
			bgcolor="#D9CBB5"
			style="background: #D9CBB5; border: 2px solid #9E8967;">
			<tr>
				<td colspan="2">
					<div id="unameError" style="display: none;" class="errorMessage">

					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div id="oldpassError" style="display: none;" class="errorMessage"></div>
				</td>
			</tr>
			<tr>
				<td align="center"><strong>User ID</strong><br /> <input
					type="text" name="uname" id="uname" title="User ID" ccreq="true"
					size="25" value="" /></td>
				<td align="center"><strong>Old Password</strong><br /> <input
					type="Password" name="oldpass" title="Old Password" ccreq="true"
					size="25" value="" /></td>
			</tr>
			<tr>
				<td colspan="2">
					<div id="newpass1Error" style="display: none;" class="errorMessage"></div>
				</td>
			</tr>
			<tr>
				<td align="center"><strong>New Password</strong><br /> <input
					type="Password" name="newpass1" id="newpass1" size="25"
					title="New Password" ccvalid="password" value="" /></td>
				<td align="center"><strong>Confirm New Password</strong><br />
					<input type="Password" name="newpass2" id="newpass2" size="25"
					value="" /></td>
			</tr>
			<tr>
				<td align="center" colspan="2"><input type="Submit"
					value="Submit Password Change" name="submit"
					style="background: #F3F3F3; border-color: #9E8967; font-family: Arial, Verdana, Helvetica, sans-serif; font-size: 12px; color: black;" />
				</td>
			</tr>
		</table>
	</form>
	<div id="MainErrorFoot" style="display: none; background: #F00;">
		<strong>There was an error with your form. Please fix all
			fields as noted above in pink.</strong>
	</div>
	<script src="https://www.conncoll.edu/scripts/ccValidator.js"></script>
	<EM>Note: </EM>Changing your password on this page will change the
	password you use to log in to the college network and your email
	account.
</div>
<jsp:directive.include file="includes/Bottom.jsp" />