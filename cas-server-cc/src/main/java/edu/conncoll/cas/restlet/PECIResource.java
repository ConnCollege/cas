package edu.conncoll.cas.restlet;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;

import javax.validation.constraints.NotNull;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONException;
import org.json.JSONObject;
import org.restlet.data.MediaType;
import org.restlet.data.Status;
import org.restlet.ext.json.JsonRepresentation;
import org.restlet.resource.Representation;
import org.restlet.resource.Resource;

import edu.conncoll.cas.jdbc.jdbcCamel;


/**
 * <p>Reset services for PECI - Better description soon</p>
 * 
 * @version 1.0 RC1 3/22/2016
 * @see org.json.JSONObject
 * @see org.restlet.resource.Resource
 * @see org.restlet.resource.Representation
 * @see org.restlet.ext.json.JsonRepresentation
 * @see edu.conncoll.cas.jdbc.jdbcCamel
 * @author Andrew Tillinghast
 *
 */
public class PECIResource extends Resource 
{
	@NotNull
	private jdbcCamel jdbc;
	
	public final boolean allowGet() {
		return false;
	}
	
	public final boolean allowPost() {
		return true;
	}
	
	public final boolean allowPut() {
		return false;
	}
	
	public final boolean allowDelete() {
		return false;
	}
	
	public final boolean allowOptions(){
		return true;
	}
	
	public final void setCamelJdbc(final jdbcCamel jdbc) {
		this.jdbc = jdbc;
	}
	
	private Log log = LogFactory.getLog(this.getClass());
	
	@Override
	public void acceptRepresentation( Representation resetEntity ) {
		
		//create json objects (one for response and one for incoming request)
		//and an array list for errors
		JSONObject json = null;
		JSONObject jsonResponse = new JSONObject();
		ArrayList<String> reasons = new ArrayList<String>();
		
		try {
			
			//ensure the incoming information is valid JSON data
			if ( !resetEntity.getMediaType().isCompatible(MediaType.APPLICATION_JSON) ) {
				jsonResponse.put("result", "error");
				jsonResponse.put("message", "not a valid json string");
				getResponse().setStatus( Status.CLIENT_ERROR_UNSUPPORTED_MEDIA_TYPE, jsonResponse.toString() );
			} else {
				
				//get a JSON object from our incoming data
				JsonRepresentation jsonRep = new JsonRepresentation(resetEntity);
				json = jsonRep.toJsonObject();
				
				//validate that the required parameters were passed with the request
				
				
				//if there are valid error reasons, then send back an error response
				if ( !reasons.isEmpty() ) {
					jsonResponse.put("result", "error");
					jsonResponse.put("message", "incomplete and/or invalid parameters");
					jsonResponse.put("reasons", reasons);
					getResponse().setStatus( Status.CLIENT_ERROR_BAD_REQUEST );
					getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
					log.debug("Bad request sent for password reset");
				} else {
					log.debug(jsonRep);
				}
			}
			
			
		} catch (JSONException e) {
			getResponse().setStatus( Status.CLIENT_ERROR_BAD_REQUEST, e.getMessage() );
			getResponse().setEntity( "{ \"JSON Error\": \"" + e.getMessage() + "\"}", MediaType.APPLICATION_JSON );
			log.error( "JSON Error", e );
		} catch (Exception e) {
			e.printStackTrace();
			getResponse().setEntity( "{ \"Internal Server Error\": \"" + e.getMessage() + "\"}", MediaType.APPLICATION_JSON );
			getResponse().setStatus( Status.SERVER_ERROR_INTERNAL, e.getMessage() );
			log.error( "Restlet Error ", e );
		}
	}
}