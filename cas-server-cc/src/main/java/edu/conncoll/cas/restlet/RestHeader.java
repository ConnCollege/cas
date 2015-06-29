package edu.conncoll.cas.restlet;

import java.util.ArrayList;

import javax.validation.constraints.NotNull;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.restlet.Filter;
import org.restlet.data.Form;
import org.restlet.data.Parameter;
import org.restlet.data.Request;
import org.restlet.data.Response;


/**
 * <p>A simple filter used in conjunction with the <tt>RestResource</tt> to 
 * initialize Access-Control headers on the restlet response.</p>
 * 
 * <p>For any domains such as camelweb or cameldev, they will need to be added 
 * here to allow for resets to be processed.</p>
 * 
 * @version 1.0 beta (6/29/2015)
 * @see org.restlet.Filter
 * @author mmatovic
 *
 */
public class RestHeader extends Filter{
	
	@NotNull
	private ArrayList<String> acceptedDomains;
	
	private Log log = LogFactory.getLog(this.getClass());
	
	public final void setAcceptedDomains (final ArrayList<?> acceptedDomains ) {
		this.acceptedDomains = (ArrayList<String>) acceptedDomains;
		for ( String acceptedDomain : this.acceptedDomains ) {
			log.debug(acceptedDomain);
		}
	}
	
	public RestHeader() {
		super();
		log.debug("RestHeader filter was created");
	}
	
	@Override
	protected int beforeHandle(Request request, Response response) {
		Form headers = (Form)response.getAttributes().get("org.restlet.http.headers");
		Form requestHeaders = (Form)request.getAttributes().get("org.restlet.http.headers");
		String requestOrigin = requestHeaders.getFirst("Origin").getValue();
		boolean domainAccepted = false;
		
		log.debug(requestOrigin);
		
		if ( headers == null ) {
			headers = new Form();
			response.getAttributes().put("org.restlet.http.headers", headers);
		}
		
		for ( String acceptedDomain : this.acceptedDomains ) {
			if ( requestOrigin.equals("Origin: " + acceptedDomain) ) {
				headers.add("Access-Control-Allow-Origin",acceptedDomain);
				log.debug("Accepted domain. Access-Control-Allow-Origin header updated.");
				domainAccepted = true;
			}
		}
		
		if ( !domainAccepted ) {
			log.warn("Not an accepted domain origin: " + requestOrigin.toString());
		}
		
		headers.add("Access-Control-Allow-Headers","Content-Type, Accept, Origin, Accept-Language, Accept-Encoding, User-Agent, Referer, Host");
		log.debug("Access-Control-Allow headers added to response");
		return super.beforeHandle(request, response);
	}
}
