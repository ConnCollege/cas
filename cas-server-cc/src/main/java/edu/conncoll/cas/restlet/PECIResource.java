package edu.conncoll.cas.restlet;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import javax.sql.DataSource;
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
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;

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
	
	@NotNull
	private NamedParameterJdbcTemplate jdbcCAS;

    @NotNull
    private DataSource CASSource;
	
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
		DataSource cas = jdbc.getCASSource();
		this.jdbcCAS = new NamedParameterJdbcTemplate(cas);
		
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
				if ( !json.has("PIDM") ) {
					reasons.add("no student PDIM was provided");
				}
				if ( !json.has("PPID") ) {
					reasons.add("No Contact or Parent PPID was provided");
				}
				if ( !json.has("DATA") ) {
					reasons.add("DATA Type was not specified");
				}
				if ( !json.has("MODE") ) {
					reasons.add("Data MODE was not specified");
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
					//create the variables necessary for Action
					String pdim = json.getString("PIDM");
					String ppid = json.getString("PPID");
					String dataType = json.getString("DATA");
					String dataMode = json.getString("MODE");
					log.debug("Valid peci restlet request Data:" + dataType + " PDIM: " + pdim + " Mode: " + dataMode);
					
					Map<String,Object> namedParameters = new HashMap<String,Object>();
					namedParameters.put("STUDENT_PIDM", pdim);
					namedParameters.put("PARENT_PPID", ppid);
					
					String SQL;
					
					if (dataMode.equals("READ")) {
						if (dataType.equals("PARENT")) {
							log.debug ("Sending Parent data for PPID: " + ppid);
							if (ppid == ""){
								//new Parent response
								log.debug("New Temporaty Parent Record");
							} else {
								Map<String,Object> parentData = new HashMap<String,Object>();
								List<Map<String,Object>> phoneData = new ArrayList<Map<String,Object>>();
								List<Map<String,Object>> emailData = new ArrayList<Map<String,Object>>();
								List<Map<String,Object>> addressData = new ArrayList<Map<String,Object>>();
								
								
								//Parent Data
								SQL="select PARENT_PPID, PARENT_ORDER, PARENT_LEGAL_FIRST_NAME, PARENT_LEGAL_MIDDLE_NAME, PARENT_LEGAL_LAST_NAME, PARENT_PREF_FIRST_NAME, PARENT_PREF_MIDDLE_NAME, PARENT_PREF_LAST_NAME, PARENT_RELT_CODE, EMERG_CONTACT_PRIORITY, EMERG_NO_CELL_PHONE, EMERG_PHONE_NUMBER_TYPE_CODE, EMERG_CELL_PHONE_CARRIER, EMERG_PHONE_TTY_DEVICE, DEPENDENT, PARENT_GENDER, PARENT_DECEASED, PARENT_DECEASED_DATE, PECI_ROLE, CONTACT_TYPE, PARENT_CONFID_IND  from cc_adv_peci_parents_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
								parentData = jdbcCAS.queryForMap(SQL,namedParameters);
								
								//phones
								SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
								phoneData = jdbcCAS.queryForList(SQL,namedParameters);
								
								//email
								SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
								emailData = jdbcCAS.queryForList(SQL,namedParameters);
								
								//Address
								SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
								addressData = jdbcCAS.queryForList(SQL,namedParameters);
								
								jsonResponse.put("result", "success");
								jsonResponse.put("parent",parentData );
								jsonResponse.put("parent_phones",phoneData );
								jsonResponse.put("parent_email",emailData );
								jsonResponse.put("parent_address",addressData );
								
								getResponse().setStatus( Status.SUCCESS_OK );
								getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
							}
							
						} else {
							log.debug ("Sending Contact data for PPID: " + ppid);
						}
					} else {
						log.debug("Saving Record");
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