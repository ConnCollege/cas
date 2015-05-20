package edu.conncoll.cas.restlet;

import java.util.ArrayList;
import java.util.Map;

import javax.sql.DataSource;
import javax.validation.constraints.NotNull;

import org.apache.commons.lang.builder.ToStringBuilder;
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

public class RestResource extends Resource 
{
	@NotNull
    private DataSource dataSource;
	
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
	
	public final void setDataSource(final DataSource dataSource) {
        this.dataSource = dataSource;
    }
	
	private Log log = LogFactory.getLog(this.getClass());
	
	@Override
	public void acceptRepresentation( Representation resetEntity ) {
		
		//create a json object
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
				
				if ( !reasons.isEmpty() ) {
					getResponse().setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
					jsonResponse.put("result", "error");
					jsonResponse.put("message", "incomplete parameters");
					jsonResponse.put("reasons", reasons);
					getResponse().setStatus( Status.CLIENT_ERROR_BAD_REQUEST );
					getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
				} else {
					//create the variables necessary for password resets
					String sec = json.getString("sec");
					String uname = json.getString("uname");
					String password = json.getString("password");
					
					//authenticate security UUID
					jdbcCamel jdbc = new jdbcCamel();
					String connectionString = ToStringBuilder.reflectionToString(this.dataSource);
					log.debug(connectionString);
					jdbc.setDataSource(this.dataSource);
					Map<String,Object> uuidResponse = jdbc.getUUID(sec);
					
					//if no security token is found, return an error
					if ( uuidResponse.isEmpty() ) {
						jsonResponse.put("result", "error");
						jsonResponse.put("message", "Invalid security token");
						getResponse().setStatus( Status.CLIENT_ERROR_BAD_REQUEST );
						getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
						log.debug("Invalid security token ( uid: " + sec + " )");
					} else {
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
							getResponse().setStatus( Status.SUCCESS_OK );
							getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
							log.debug("Password changed successfully for " + uname + "( uname: " + uname + " )");
						} else {
							jsonResponse.put("result", "error");
							jsonResponse.put("message", jdbc.getRestfulResponse().getErrMessage());
							getResponse().setStatus( Status.CLIENT_ERROR_NOT_FOUND, jsonResponse.toString() );
							log.debug("Password change failed for " + uname + " (uname: " + uname + " )");
							log.debug("  Failure reason: " + jdbc.getRestfulResponse().getErrMessage() );
						}
					}
				}
			}
			
			
		} catch (JSONException e) {
			getResponse().setStatus( Status.CLIENT_ERROR_BAD_REQUEST, e.getMessage() );
			getResponse().setEntity( "JSON Error: ", MediaType.APPLICATION_JSON );
			log.error(e);
		} catch (Exception e) {
			log.error( "Restlet Internal Server Error: " + e.getMessage() );
			getResponse().setEntity( "Internal Server Error: ", MediaType.APPLICATION_JSON );
			getResponse().setStatus( Status.SERVER_ERROR_INTERNAL, e.getMessage() );
			log.error(e);
		}
	}
}