package org.jasig.cas.web.flow;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.net.util.SubnetUtils;
import org.springframework.webflow.execution.RequestContext;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.web.support.WebUtils;

public final class CheckInt {
	
	private List<String> reqLogin;
		
	
	private Log log = LogFactory.getLog(this.getClass());
	
	public final String check(final RequestContext context, final UsernamePasswordCredentials credentials, String interrupt) throws Exception {
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
	
	public final void setLocalIpRanges(final List<String> localIpRanges) {
	        this.localIpRanges = localIpRanges;
	        for(String subNet :  this.localIpRanges) {
	        	log.debug("CheckFlags adding local ip range " + subNet);
	        	this.localSubNets.add(new SubnetUtils(subNet));
	        }
	}
}