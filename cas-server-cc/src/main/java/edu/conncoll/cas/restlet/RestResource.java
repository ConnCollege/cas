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
 * <p>A simple REST service built into CAS for password resets. No specific 
 * resources such as users, accounts, or otherwise are defined apart from the
 * restlet itself.</p>
 * 
 * <p>Account and user specific logic is provided by the <tt>jdbcCamel</tt> 
 * object whose intended usage is to be initialized within the restlet's servlet 
 * XML file and utilized for its existing functionality (i.e., password reset 
 * logic specific to active directory, the data vault, and other existing 
 * technologies has already been implemented within jdbCamel and will likewise 
 * be used).</p>
 * 
 * <p>Password resets are validated via unique records written to an external 
 * database by the client requesting the reset. For example, if a script were 
 * to issue a call to this restlet, it would first be required to create a 
 * record in the external database then pass along the universally unique 
 * ID stored in that database to the restlet . The restlet then takes the 
 * unique ID and queries the database to verify that a reset should take place 
 * at all. If no record is returned, then no reset is completed. The retrieval 
 * and deletion of the unique records is handled by the <tt>jdbcCamel</tt> 
 * object. </p>
 * 
 * @version 1.0 alpha 5/22/2015
 * @see org.json.JSONObject
 * @see org.restlet.resource.Resource
 * @see org.restlet.resource.Representation
 * @see org.restlet.ext.json.JsonRepresentation
 * @see edu.conncoll.cas.jdbc.jdbcCamel
 * @author Mike Matovic
 *
 */
public class RestResource extends Resource 
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
				if ( !json.has("sec") ) {
					reasons.add("no security token was provided");
				}
				
				if ( !json.has("uname") ) {
					reasons.add("no username was provided");
				}
				
				if ( !json.has("password") ) {
					reasons.add("no password was provided");
				}
				
				if ( !json.has("setAD") ) {
					reasons.add("AD flag was not provided");
				}
				
				if ( !json.has("enforce") ) {
					reasons.add("Password policy enforcement flag was not provided");
				}
				
				//check for invalid parameters sent to the rest api
				Iterator<?> keys = json.keys();
				while( keys.hasNext() ) {
					Object obj = keys.next();
					if ( ( !obj.equals("password") && !obj.equals("sec") && !obj.equals("uname") && !obj.equals("setAD") && !obj.equals("enforce") ) ) {
						reasons.add("Invalid parameter: " + obj.toString() );
					}
				}
				
				//if there are valid error reasons, then send back an error response
				if ( !reasons.isEmpty() ) {
					jsonResponse.put("result", "error");
					jsonResponse.put("message", "incomplete and/or invalid parameters");
					jsonResponse.put("reasons", reasons);
					getResponse().setStatus( Status.CLIENT_ERROR_BAD_REQUEST );
					getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
					log.debug("Bad request sent for password reset");
				} else {
					//create the variables necessary for password resets
					String sec = json.getString("sec");
					String uname = json.getString("uname");
					String password = json.getString("password");
					boolean setAD = json.getBoolean("setAD");
					boolean enforce = json.getBoolean("enforce");
					
					//authenticate security UUID
					Map<String,Object> uuidResponse = this.jdbc.getUUID(sec);
					ArrayList resetCheckData = (ArrayList) uuidResponse.get("resetCheckData");
					
					//if no security token is found, return an error
					if ( resetCheckData.isEmpty() ) {
						jsonResponse.put("result", "error");
						jsonResponse.put("message", "Invalid security token");
						getResponse().setStatus( Status.CLIENT_ERROR_BAD_REQUEST );
						getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
						log.debug("Invalid security token ( uid: " + sec + " )");
					} else {
						HashMap<String,String> resetCheckRecord = (HashMap)resetCheckData.get(0);
						String uid = resetCheckRecord.get("ResetUID");
						log.debug("Security token retrieved successfully ( uid: " + uid + " )");
						
						//remove used security token from db
						Map<String,Object> uuidRemoved = this.jdbc.removeUUID(uid);
						ArrayList resetRemoveData = (ArrayList) uuidRemoved.get("resetRemoveData");
						HashMap<String,Integer> resetRemoveRecord = (HashMap)resetRemoveData.get(0);
						int rowsRemoved = resetRemoveRecord.get("rows_deleted");
						if ( rowsRemoved < 1 ) {
							log.warn("Failed to remove security token from db ( uid: " + uid + " )");
						} else {
							log.debug("Security token removed from db successfully ( uid: " + uid + " )");
						}
						
						log.debug( "Password change issued ( uname: " + uname + " password: " + password + " setAD: " + Boolean.toString(setAD) + " )" );
						
						//reset password
						boolean resetSuccess = this.jdbc.setPassword( uname, password, setAD, enforce);
						
						//process the result of the password change
						ArrayList<String> restfulMessages = null;
						if ( resetSuccess ) {
							restfulMessages = this.jdbc.getRestfulResponse().getMessages();
							jsonResponse.put("result", "success");
							jsonResponse.put("message", "password for " + uname + " has been successfully changed.");
							jsonResponse.put("reset messages", restfulMessages);
							
							getResponse().setStatus( Status.SUCCESS_OK );
							getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
							
							log.debug("Password changed successfully for " + uname + "( uname: " + uname + " )");
						} else {
							restfulMessages = this.jdbc.getRestfulResponse().getMessages();
							jsonResponse.put("result", "error");
							jsonResponse.put("message", "There were errors when attempting to reset passwords for " + uname + ".");
							jsonResponse.put("reset messages", restfulMessages );
							
							getResponse().setStatus( Status.CLIENT_ERROR_NOT_FOUND, jsonResponse.toString() );
							getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
							
							log.debug("Password change failed for " + uname + " (uname: " + uname + " )");
							for ( String message : restfulMessages ) {
								log.debug("  Failure reason: " + message );
							}
						}
					}
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