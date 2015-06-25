package edu.conncoll.cas.restlet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.restlet.Filter;
import org.restlet.data.Form;
import org.restlet.data.Request;
import org.restlet.data.Response;

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
		log.debug("Access-Control-Allow-Origin header added to response");
		return super.beforeHandle(request, response);
	}
}
