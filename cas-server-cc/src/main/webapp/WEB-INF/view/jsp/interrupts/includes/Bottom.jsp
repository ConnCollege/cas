<c:if test="${hasForm == 0}">
<form:form method="post" id="fm1" cssClass="fm-v clearfix" htmlEscape="true">
<input type="hidden" name="lt" value="${loginTicket}" />
<input type="hidden" name="execution" value="${flowExecutionKey}" />
<input type="hidden" name="_eventId" value="submit" />
<div align="center"><input type="submit" value="Continue" id="btnSubmit" /></div>
</form:form>
</c:if>

</section>
						</div><!-- //close .portlet-body -->
					</div><!-- //close .portlet-boundary -->
				</div><!-- //close .portlet-dropzone -->
			</div><!-- //close .portlet-column -->
		</div><!-- //close .portlet-layout -->
	</div><!-- //close .columns-1 -->
 	
</div><!-- //close #content -->

<footer id="footer" role="contentinfo"> 
	<p class="ellucian-copyright"> CamelWeb is maintained by <a href="mailto:webteam@conncoll.edu?subject=Question%20Regarding%20CamelWeb" data-position="left" data-intro="Email webteam@conncoll.edu with any comments, suggestions or feedback" data-step="10">The CC Web Team</span></a>
	<br>
	Use of computer and information resources is governed by the <a href="http://www.conncoll.edu/information-services/technology-services/it-service-desk/policies/general/appropriate-use-policy/" target="_blank">Connecticut College Appropriate Use Policy</a>
	&nbsp;|&nbsp;
	<a href="https://www.conncoll.edu/information-services/libraries/copyright-resources/" target="_blank">Copyright &copy; <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %></a>
	<br> 
	&copy; 2000 - <%= new java.text.SimpleDateFormat("yyyy").format(new java.util.Date()) %> Ellucian. All rights reserved<br> </p> 
</footer>

</div>

</body></html>