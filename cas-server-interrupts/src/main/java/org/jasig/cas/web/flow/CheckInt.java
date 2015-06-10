package org.jasig.cas.web.flow;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.webflow.execution.RequestContext;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.ticket.registry.TicketRegistry;
import org.jasig.cas.ticket.TicketGrantingTicket;
import org.jasig.cas.web.support.WebUtils;

public final class CheckInt {
	
	private static final String CONST_PARAM_INTERRUPT = "interrupt";
	
	private List<String> NoLogReq;
	
	private TicketRegistry ticketRegistry;
	
	public  String check( RequestContext context,  UsernamePasswordCredentials credentials) throws Exception {
		
		HttpServletRequest request = WebUtils.getHttpServletRequest(context);		
		String interrupt = request.getParameter(CONST_PARAM_INTERRUPT);		
		context.getFlowScope().put("interrupt", interrupt);			
		final String ticketGrantingTicketId = WebUtils.getTicketGrantingTicketId(context);		
		TicketGrantingTicket ticketGrantingTicket = (TicketGrantingTicket) ticketRegistry.getTicket(ticketGrantingTicketId);
		
		if (interrupt == null) {
			return "noInterrupt";
		}	
		if (NoLogReq.indexOf(interrupt) == -1){
			if (!ticketGrantingTicket.isExpired()) {				
				String userName = ticketGrantingTicket.getAuthentication().getPrincipal().getId();				
				credentials.setUsername(userName);				
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
	
	
	public final void setNoLogReq(final List<String> NoLogReq) {
	        this.NoLogReq = NoLogReq;
	}
}