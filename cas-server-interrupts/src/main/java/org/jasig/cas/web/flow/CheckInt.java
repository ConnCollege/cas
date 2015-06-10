package org.jasig.cas.web.flow;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.ticket.registry.TicketRegistry;
import org.jasig.cas.ticket.TicketGrantingTicket;
import org.jasig.cas.web.support.WebUtils;

import org.springframework.webflow.execution.RequestContext;

public final class CheckInt {
	
	private static final String CONST_PARAM_INTERRUPT = "interrupt";
	
	private List<String> NoLogReq;
	
	private TicketRegistry ticketRegistry;
	
	private Log log = LogFactory.getLog(this.getClass());
	
	public  String check( RequestContext context,  UsernamePasswordCredentials credentials) throws Exception {
			
		String interrupt = WebUtils.getHttpServletRequest(context).getParameter(CONST_PARAM_INTERRUPT);
		log.debug("CheckInt got Passed interrupt " + interrupt);
		context.getFlowScope().put("interrupt", interrupt);			
		String ticketGrantingTicketId = (String)context.getFlowScope().get("ticketGrantingTicketId");	
		log.debug("CheckInt got TGT " + ticketGrantingTicketId);
		TicketGrantingTicket ticketGrantingTicket = (TicketGrantingTicket) ticketRegistry.getTicket(ticketGrantingTicketId);
		
		if (interrupt == null) {
			return "noInterrupt";
		}	
		if (NoLogReq.indexOf(interrupt) == -1){
			if (!ticketGrantingTicket.isExpired()) {				
				String userName = ticketGrantingTicket.getAuthentication().getPrincipal().getId();				
				credentials.setUsername(userName);		
				log.debug("CheckInt setting username " + userName);
				return "LoginOk";
			} else {
				log.debug("CheckInt login required");
				return "LoginReq";
			}
		}
		log.debug("CheckInt No login required");
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