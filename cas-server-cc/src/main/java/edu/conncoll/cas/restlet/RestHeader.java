package edu.conncoll.cas.restlet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.restlet.Filter;
import org.restlet.data.Form;
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
	
	private Log log = LogFactory.getLog(this.getClass());
	
	public RestHeader() {
		super();
		log.debug("RestHeader filter was created");
	}
	
	@Override
	protected int beforeHandle(Request request, Response response) {
		Form headers = (Form)response.getAttributes().get("org.restlet.http.headers");
		
		if ( headers == null ) {
			headers = new Form();
			response.getAttributes().put("org.restlet.http.headers", headers);
		}
		headers.add("Access-Control-Allow-Origin","https://cameldev.conncoll.edu");
		headers.add("Access-Control-Allow-Headers","Content-Type, Accept, Origin, Accept-Language, Accept-Encoding, User-Agent, Referer, Host");
		log.debug("Access-Control-Allow headers added to response");
		return super.beforeHandle(request, response);
	}
}
