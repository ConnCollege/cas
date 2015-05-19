package edu.conncoll.cas.restlet;

import java.util.ArrayList;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;
import org.json.JSONObject;
import org.restlet.Context;
import org.restlet.data.Request;
import org.restlet.data.Response;
import org.restlet.data.MediaType;
import org.restlet.data.Status;
import org.restlet.ext.json.JsonRepresentation;
import org.restlet.representation.Representation;
import org.restlet.resource.Post;
import org.restlet.resource.ServerResource;

import com.db4o.ObjectContainer;

import edu.conncoll.cas.jdbc.jdbcCamel;

public class RestResource extends ServerResource 
{
	
	private ObjectContainer container;
	
	public RestResource() { }
	
	@Override
	public void init( Context context, Request request, Response response ) {
		super.init(context, request, response);
	}
	
	public RestResource( Context context, Request request, Response response ) {
		init(context, request, response);
	}
	
	public ObjectContainer getContainer() {
		return container;
	}
	
	public void setContainer(ObjectContainer container) {
		this.container = container;
	}
	
	private Log log = LogFactory.getLog(this.getClass());
	
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
				log.debug("Invalid security token ( uid: " + sec + " )");
				return new JsonRepresentation(jsonResponse);
			}
			
			String uid = uuidResponse.get("ResetUID").toString();
			log.debug("Security token retrieved successfully ( uid: " + uid + " )");
			
			//remove used security token from db
			Map<String,Object> uuidRemoved = jdbc.removeUUID(uid);
			if ( uuidRemoved.size() < 1 ) {
				log.debug("Failed to remove security token from db");
			} else {
				log.debug("Security token removed from db successfully ( uid: " + uid + " )");
			}
			
			//reset password
			boolean resetSuccess = jdbc.setPassword( uname, password, false);
			
			//process the result of the password change
			if ( resetSuccess ) {
				jsonResponse.put("result", "success");
				jsonResponse.put("message", "password for " + uname + " has been successfully changed.");
				log.debug("Password changed successfully for " + uname + "( uname: " + uname + " )");
			} else {
				jsonResponse.put("result", "error");
				jsonResponse.put("message", jdbc.getRestfulResponse().getErrMessage());
				log.debug("Password change failed for " + uname + " (uname: " + uname + " )");
				log.debug("  Failure reason: " + jdbc.getRestfulResponse().getErrMessage() );
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