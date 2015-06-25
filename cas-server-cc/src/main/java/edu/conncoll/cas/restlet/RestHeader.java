package edu.conncoll.cas.restlet;

import org.restlet.Filter;
import org.restlet.data.Form;
import org.restlet.data.Request;
import org.restlet.data.Response;

public class RestHeader extends Filter{
	@Override
	protected int beforeHandle(Request request, Response response) {
		Form headers = (Form)response.getAttributes().get("org.restlet.http.headers");
		
		if (headers == null) {
			headers = new Form();
			response.getAttributes().put("org.restlet.http.headers", headers);
		}
		headers.add("Access-Control-Allow-Origin","https://cameldev.conncoll.edu");
		return super.beforeHandle(request, response);
	}
}
