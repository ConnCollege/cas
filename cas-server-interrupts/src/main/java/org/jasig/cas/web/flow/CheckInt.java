package org.jasig.cas.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;

import org.springframework.webflow.execution.RequestContext;
import org.jasig.cas.CentralAuthenticationService;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.web.support.WebUtils;
import org.jasig.cas.ticket.registry.TicketRegistry;
import org.jasig.cas.ticket.Ticket;

public final class CheckInt {
	
	private static final String CONST_PARAM_INTERRUPT = "interrupt";
	
	private List<String> reqLogin;
	
	private TicketRegistry ticketRegistry;
	
	public  String check( RequestContext context,  UsernamePasswordCredentials credentials) throws Exception {
		
		HttpServletRequest request = WebUtils.getHttpServletRequest(context);
		
		String interrupt = request.getParameter(CONST_PARAM_INTERRUPT);
		
		context.getFlowScope().put("interrupt", interrupt);	
		
		final String ticketGrantingTicketId = WebUtils.getTicketGrantingTicketId(context);
		
		Ticket ticketGrantingTicket = ticketRegistry.getTicket(ticketGrantingTicketId);
		
		if (interrupt == null) {
			return "noInterrupt";
		}	
		if (reqLogin.indexOf(interrupt) != -1){
			if (!ticketGrantingTicket.isExpired()) {
				return "LoginOk";
			} else {
				return "LoginReq";
			}
		}
		return "LoginOk";

	}
	
	public void setTicketRegistry(
        final TicketRegistry ticketRegistry) {
        this.ticketRegistry = ticketRegistry;
    }
	
	
	public final void setReqLogin(final List<String> reqLogin) {
	        this.reqLogin = reqLogin;
	}
}