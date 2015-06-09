package org.jasig.cas.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;


import org.springframework.webflow.execution.RequestContext;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.web.support.WebUtils;

public final class CheckInt {
	
	private static final String CONST_PARAM_INTERRUPT = "interrupt";
	
	private List<String> reqLogin;
	
	public  String check( RequestContext context,  UsernamePasswordCredentials credentials) throws Exception {
		
		 HttpServletRequest request = WebUtils.getHttpServletRequest(context);
		
		String interrupt = request.getParameter(CONST_PARAM_INTERRUPT);
		
		context.getFlowScope().put("interrupt", interrupt);	
		
		if (interrupt == null) {
			return "noInterrupt";
		}	
		if (reqLogin.indexOf(interrupt) != -1){
			if (credentials != null && credentials.getUsername() != null) {
				return "LoginOk";
			} else {
				return "LoginReq";
			}
		}
		return "LoginOk";

	}
	
	public final void setReqLogin(final List<String> reqLogin) {
	        this.reqLogin = reqLogin;
	}
}