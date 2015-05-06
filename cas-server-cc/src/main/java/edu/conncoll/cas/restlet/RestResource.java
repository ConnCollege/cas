package edu.conncoll.cas.restlet;

import java.util.ArrayList;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;
import org.restlet.data.MediaType;
import org.restlet.data.Status;
import org.restlet.ext.json.JsonRepresentation;
import org.restlet.ext.servlet.ServletAdapter;
import org.restlet.representation.Representation;
import org.restlet.resource.Post;
import org.restlet.resource.ServerResource;
import org.springframework.webflow.execution.RequestContext;

import edu.conncoll.cas.jdbc.jdbcCamel;

public class RestResource extends ServerResource 
{
	@Post
	public JsonRepresentation resetPassword( Representation resetEntity ) throws Exception {
		
		//create a json object
		JSONObject json = null;
		JSONObject jsonResponse = new JSONObject();
		ArrayList<String> reasons = new ArrayList<String>();
		
		try {
			
			//ensure the incoming information is valid JSON data
			if ( !resetEntity.getMediaType().isCompatible(MediaType.APPLICATION_JSON) ) {
				setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
				jsonResponse.put("result", "error");
				jsonResponse.put("message", "not a valid json string");
				return new JsonRepresentation(jsonResponse);
			}
			
			//get a JSON object from our incoming data
			JsonRepresentation jsonRep = new JsonRepresentation(resetEntity);
			json = jsonRep.getJsonObject();

			//validate that the required parameters were passed with the request
			if ( !json.has("sec") ) {
				reasons.add("no security token was provided");
			}
			
			if ( !json.has("uname") ) {
				reasons.add("no username was provided");
			}
			
			if ( !json.has("password") ) {
				reasons.add("no password was provided");
			}
			
			if ( !reasons.isEmpty() ) {
				setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
				jsonResponse.put("result", "error");
				jsonResponse.put("message", "incomplete parameters");
				jsonResponse.put("reasons", reasons);
				return new JsonRepresentation(jsonResponse);
			}
			
			//create the variables necessary for password resets
			String sec = json.getString("sec");
			String uname = json.getString("uname");
			String password = json.getString("password");
			
			//authenticate security UUID
			jdbcCamel jdbc = new jdbcCamel();
			Map<String,Object> uuidResponse = jdbc.getUUID(sec);
			
			//if no security token is found, return an error
			if ( uuidResponse.isEmpty() ) {
				jsonResponse.put("result", "error");
				jsonResponse.put("message", "Invalid security token");
				return new JsonRepresentation(jsonResponse);
			}
			
			String uid = uuidResponse.get("ResetUID").toString();
			
			//reset password
			RequestContext context = null;
			boolean resetSuccess = jdbc.setPassword(context, uname, password, false);//propose boolean for rest calls
			
			//process the result of the password change
			if ( resetSuccess ) {
				jsonResponse.put("result", "success");
				jsonResponse.put("message", "password for " + uname + " has been successfully changed.");
			} else {
				jsonResponse.put("result", "error");
				jsonResponse.put("message", "there was an error changing the password for " + uname + ".");//would be nice to get a useful error message here.
			}
			
			//return the results
			return new JsonRepresentation(jsonResponse);
			
		} catch (JSONException e) {
			throw new Exception("JSONException: " + e.getMessage() );
		} catch (Exception e) {
			throw new Exception("Exception: " + e.getMessage() );
		}
	}
}