package edu.conncoll.cas.restlet;

import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;
import org.restlet.Context;
import org.restlet.data.Status;
import org.restlet.ext.json.JsonRepresentation;
import org.restlet.representation.Representation;
import org.restlet.resource.Post;
import org.restlet.resource.ServerResource;

import edu.conncoll.cas.jdbc.jdbcCamel;

public class RestResource extends ServerResource 
{
	@Post
	public String resetPassword( JsonRepresentation resetEntity ) {
		
		//create a json object
		JSONObject json = null;
		
		try {
			//attempt to retrieve the json data
			json = resetEntity.getJsonObject();

			//create the variables necessary for password resets
			String sec = json.getString("sec");
			String uname = json.getString("uname");
			String password = json.getString("password");
			
			//authenticate security UUID
			jdbcCamel jdbc = new jdbcCamel();
			Map<String,Object> uuidResponse = jdbc.getUUID(sec);
			
			//if no security token is found, return an error
			if ( uuidResponse.isEmpty() ) {
				json.put("result", "error");
				json.put("message", "Invalid token");
				return json.toString();
			}
			
			String uid = uuidResponse.get("ResetUID").toString();
			
			Context context = Context.getCurrent();
			
			//reset password
			
		} catch (JSONException e) {
			setStatus( Status.CLIENT_ERROR_BAD_REQUEST );
		}
		return null;
	}
}