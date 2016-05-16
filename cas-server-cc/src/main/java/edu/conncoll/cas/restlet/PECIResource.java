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
import org.json.JSONArray;
import org.restlet.data.MediaType;
import org.restlet.data.Status;
import org.restlet.ext.json.JsonRepresentation;
import org.restlet.resource.Representation;
import org.restlet.resource.Resource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.dao.EmptyResultDataAccessException;

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
					
					Map<String,Object> parentData = new HashMap<String,Object>();
					Map<String,Object> emrgData = new HashMap<String,Object>();
					List<Map<String,Object>> phoneData = new ArrayList<Map<String,Object>>();
					Map<String,Object> emailData =new HashMap<String,Object>();
					Map<String,Object> addressData = new HashMap<String,Object>();
					if (dataType.equals("PARENT")) {
						if (dataMode.equals("DELETE")){
							SQL="update cc_adv_peci_parents_t set CHANGE_COLS='DELETE' where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
							jdbcCAS.update(SQL,namedParameters);
						}else{
							if (ppid == ""){
								//new Parent response
								log.debug("New Temporaty Parent Record");
							} else {
								try {
									//Parent Data
									SQL="select  PARENT_LEGAL_PREFIX_NAME, PARENT_PREF_FIRST_NAME, PARENT_PREF_MIDDLE_NAME, PARENT_PREF_LAST_NAME, PARENT_LEGAL_SUFFIX_NAME, PARENT_RELT_CODE, EMERG_CONTACT_PRIORITY, EMERG_NO_CELL_PHONE, EMERG_PHONE_NUMBER_TYPE_CODE, EMERG_CELL_PHONE_CARRIER, EMERG_PHONE_TTY_DEVICE, DEPENDENT, PECI_ROLE, CONTACT_TYPE  from cc_adv_peci_parents_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									parentData = jdbcCAS.queryForMap(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
								
								try {
									//phones
									SQL="select PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									phoneData = jdbcCAS.queryForList(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
								
								try {
									//email
									SQL="select PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									emailData = jdbcCAS.queryForMap(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
								try {
									//Address
									SQL="select EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where (ADDR_STATUS_IND is null or  ADDR_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									addressData = jdbcCAS.queryForMap(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
								
								if (dataMode.equals("READ")) {
								
									jsonResponse.put("result", "success");
									jsonResponse.put("parent",parentData );
									jsonResponse.put("phones",phoneData );
									jsonResponse.put("email",emailData );
									jsonResponse.put("address",addressData );
									
									getResponse().setStatus( Status.SUCCESS_OK );
									getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
								} else{
									Map<String,Object> parentDataIn = toMap(json.getJSONObject("parent"));
									Map<String,Object> emailDataIn = toMap(json.getJSONObject("email"));
									Map<String,Object> addressDataIn = toMap(json.getJSONObject("address"));
									
									List<Object> phoneDataList = toList(json.getJSONArray("phones"));
									List<Map<String,Object>> phoneDataIn = new ArrayList<Map<String,Object>>();
									for (Object phone : phoneDataList){
										if (phone.getClass().getName() == "java.util.HashMap") {
											phoneDataIn.add((Map<String,Object>)phone);
										}
									}
									
									//Find the values that have been updated
									Map<String,Object> updates =  new HashMap<String,Object>();
	
									if (ppid.equals("null")){
										log.debug("Creating new parent record.");
										//Add a parent 
										//Find an Alpha Seq No
										char seqNo = Parent_PPID(namedParameters);
										log.debug ("New parent record to create PPID: " + Character.toString(seqNo));
										SQL = "INSERT cc_adv_peci_parents_t SET ";
										List<String> columns = new ArrayList(parentDataIn.keySet());
										for(int y=0; y<columns.size(); y++) { 
									        String key = columns.get(y);
									        if (!key.equals("PARENT_PPID")) {
										        Object newValue = parentDataIn.get(key);
										        if (newValue.getClass().getName().equals("java.lang.String")) {
										        	SQL = SQL + key +" = '" +  newValue + "', ";
										        } else {
										        	SQL = SQL + key +" = " +  newValue + ", ";
										        }
									        }
									    } 
										SQL = SQL + "CHANGE_COLS = 'NEW', ";
										
										SQL = SQL + "STUDENT_PIDM=:STUDENT_PIDM, ";
										SQL = SQL + "PARENT_PPID=:PARENT_PPID";
										namedParameters.put("PARENT_PPID",String.valueOf(seqNo));
										jdbcCAS.update(SQL,namedParameters);
										jsonResponse.put("PARENT_PPID",String.valueOf(seqNo));
										//Per Tonm's requst on 5/6/2016 adding a new parent automatically adds them as an emergency Contact
										SQL = "INSERT cc_gen_peci_emergs_t SET ";
										for(int y=0; y<columns.size(); y++) { 
									        String key = columns.get(y);
									        if (!key.equals("PARENT_PPID")) {
										        Object newValue = parentDataIn.get(key);
										        key = key.replace("PARENT_","EMERG_");
										        if (newValue.getClass().getName().equals("java.lang.String")) {
										        	SQL = SQL + key +" = '" +  newValue + "', ";
										        } else {
										        	SQL = SQL + key +" = " +  newValue + ", ";
										        }
									        }
									    } 
										SQL = SQL + "CHANGE_COLS = 'NEW', ";
										
										SQL = SQL + "STUDENT_PIDM=:STUDENT_PIDM, ";
										SQL = SQL + "PARENT_PPID=:PARENT_PPID";
										namedParameters.put("PARENT_PPID",String.valueOf(seqNo));
										jdbcCAS.update(SQL,namedParameters);
																				
									} else {
										//Parent Data
										updates = compareMap(parentDataIn, parentData);
										writeUpdates(namedParameters,updates,"cc_adv_peci_parents_t");
										//ensure that Contact data i.e. name is updated in sync with Parent
										SQL="UPDATE cc_gen_peci_emergs_t e ";
										SQL = SQL + " INNER JOIN cc_adv_peci_parents_t p ";
										SQL = SQL + "  ON p.STUDENT_PIDM = e.STUDENT_PIDM ";
										SQL = SQL + " AND p.PARENT_PPID = e.PARENT_PPID ";
										SQL = SQL + " SET EMERG_LEGAL_PREFIX_NAME = PARENT_LEGAL_PREFIX_NAME, ";
										SQL = SQL + " EMERG_LEGAL_FIRST_NAME = PARENT_LEGAL_FIRST_NAME, ";
										SQL = SQL + " EMERG_LEGAL_MIDDLE_NAME = PARENT_LEGAL_MIDDLE_NAME, ";
										SQL = SQL + " EMERG_LEGAL_LAST_NAME = PARENT_LEGAL_LAST_NAME, ";
										SQL = SQL + " EMERG_LEGAL_SUFFIX_NAME = PARENT_LEGAL_SUFFIX_NAME, ";
										SQL = SQL + " EMERG_PREF_FIRST_NAME = PARENT_PREF_FIRST_NAME, ";
										SQL = SQL + " EMERG_PREF_MIDDLE_NAME  = PARENT_PREF_MIDDLE_NAME, ";
										SQL = SQL + " EMERG_PREF_LAST_NAME = PARENT_PREF_LAST_NAME,";
										SQL = SQL + " EMERG_RELT_CODE = PARENT_RELT_CODE";
										SQL = SQL + " WHERE p.STUDENT_PIDM=:STUDENT_PIDM ";
										SQL = SQL + " AND p.PARENT_PPID=:PARENT_PPID";
										jdbcCAS.update(SQL,namedParameters);
									}
									//email
									updates = compareMap(emailDataIn, emailData);
									writeUpdates(namedParameters,updates,"cc_gen_peci_email_data_t");
									
									//adresses
									updates = compareMap(addressDataIn, addressData);
									writeUpdates(namedParameters,updates,"cc_gen_peci_addr_data_t");
	
									//phones
									phoneUpdate (phoneDataIn, phoneData, namedParameters);
									
									
									getResponse().setStatus( Status.SUCCESS_OK );
									getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
								}
							}
						}
					} else {
						if (dataMode.equals("DELETE")){
							SQL="update cc_gen_peci_emergs_t set CHANGE_COLS='DELETE' where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
							jdbcCAS.update(SQL,namedParameters);
							
						}else{
							if (ppid == ""){
								//new Contact response
								log.debug("New Temporaty Contact Record");
							} else {
								try {
									//Contact Data
									SQL="select EMERG_LEGAL_PREFIX_NAME,EMERG_LEGAL_PREFIX_NAME,EMERG_PREF_FIRST_NAME,EMERG_PREF_MIDDLE_NAME,EMERG_PREF_LAST_NAME,EMERG_LEGAL_SUFFIX_NAME,EMERG_RELT_CODE,EMERG_CONTACT_PRIORITY,EMERG_NO_CELL_PHONE,EMERG_PHONE_NUMBER_TYPE_CODE,EMERG_CELL_PHONE_CARRIER,EMERG_PHONE_TTY_DEVICE from cc_gen_peci_emergs_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									emrgData = jdbcCAS.queryForMap(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
								
								try {
									//phones
									SQL="select PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									phoneData = jdbcCAS.queryForList(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
								
								try {
									//email
									SQL="select PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									emailData = jdbcCAS.queryForMap(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
								
								try{
									//Address
									SQL="select EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where (ADDR_STATUS_IND is null or  ADDR_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
									addressData = jdbcCAS.queryForMap(SQL,namedParameters);
								} catch (EmptyResultDataAccessException e){
									// dataset empty 
								}
							}
							if (dataMode.equals("READ")) {
							
								jsonResponse.put("result", "success");
								jsonResponse.put("contact",emrgData );
								jsonResponse.put("phones",phoneData );
								jsonResponse.put("email",emailData );
								jsonResponse.put("address",addressData );
								
								getResponse().setStatus( Status.SUCCESS_OK );
								getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
							} else {
								Map<String,Object> emrgDataIn = toMap(json.getJSONObject("contact"));
								Map<String,Object> emailDataIn = toMap(json.getJSONObject("email"));
								Map<String,Object> addressDataIn = toMap(json.getJSONObject("address"));
								
								List<Object> phoneDataList = toList(json.getJSONArray("phones"));
								List<Map<String,Object>> phoneDataIn = new ArrayList<Map<String,Object>>();
								for (Object phone : phoneDataList){
									if (phone.getClass().getName() == "java.util.HashMap") {
										phoneDataIn.add((Map<String,Object>)phone);
									}
								}
								
								//Find the values that have been updated
								Map<String,Object> updates =  new HashMap<String,Object>();
								//contact Data
								if (ppid.equals("null")){
									log.debug("Creating new parent record.");
									//Add a contact 
									//Find an Alpha Seq No
									Map<String,Object> maxData = new HashMap<String, Object>();
									char seqNo = Parent_PPID(namedParameters);
									log.debug ("New contact record to create PPID: " + Character.toString(seqNo));
									SQL = "INSERT cc_gen_peci_emergs_t SET ";
									List<String> columns = new ArrayList(emrgDataIn.keySet());
									for(int y=0; y<columns.size(); y++) { 
								        String key = columns.get(y);
								        if (!key.equals("PARENT_PPID")) {
									        Object newValue = emrgDataIn.get(key);
									        if (newValue.getClass().getName().equals("java.lang.String")) {
									        	SQL = SQL + key +" = '" +  newValue + "', ";
									        } else {
									        	SQL = SQL + key +" = " +  newValue + ", ";
									        }
								        }
								    } 
									SQL = SQL + "CHANGE_COLS = 'NEW', ";
									
									SQL = SQL + "STUDENT_PIDM=:STUDENT_PIDM, ";
									SQL = SQL + "PARENT_PPID=:PARENT_PPID";
									namedParameters.put("PARENT_PPID",String.valueOf(seqNo));
									jdbcCAS.update(SQL,namedParameters);
									jsonResponse.put("PARENT_PPID",String.valueOf(seqNo));
								} else {
									updates = compareMap(emrgDataIn, emrgData);
									writeUpdates(namedParameters,updates,"cc_gen_peci_emergs_t");
									//ensure that Parent data i.e. name is updated in sync with contact
									SQL="UPDATE cc_adv_peci_parents_t p ";
									SQL = SQL + " INNER JOIN cc_gen_peci_emergs_t e";
									SQL = SQL + "  ON p.STUDENT_PIDM = e.STUDENT_PIDM";
									SQL = SQL + " AND p.PARENT_PPID = e.PARENT_PPID";
									SQL = SQL + " SET PARENT_LEGAL_PREFIX_NAME=EMERG_LEGAL_PREFIX_NAME, ";
									SQL = SQL + " PARENT_LEGAL_FIRST_NAME=EMERG_LEGAL_FIRST_NAME, ";
									SQL = SQL + " PARENT_LEGAL_MIDDLE_NAME=EMERG_LEGAL_MIDDLE_NAME, ";
									SQL = SQL + " PARENT_LEGAL_LAST_NAME=EMERG_LEGAL_LAST_NAME, ";
									SQL = SQL + " PARENT_LEGAL_SUFFIX_NAME=EMERG_LEGAL_SUFFIX_NAME, ";
									SQL = SQL + " PARENT_PREF_FIRST_NAME=EMERG_PREF_FIRST_NAME, ";
									SQL = SQL + " PARENT_PREF_MIDDLE_NAME=EMERG_PREF_MIDDLE_NAME, ";
									SQL = SQL + " PARENT_PREF_LAST_NAME=EMERG_PREF_LAST_NAME,";
									SQL = SQL + " PARENT_RELT_CODE=EMERG_RELT_CODE";
									SQL = SQL + " WHERE p.STUDENT_PIDM=:STUDENT_PIDM ";
									SQL = SQL + " AND p.PARENT_PPID=:PARENT_PPID";
									jdbcCAS.update(SQL,namedParameters);		   		
								}
								
								//email
								updates = compareMap(emailDataIn, emailData);
								writeUpdates(namedParameters,updates,"cc_gen_peci_email_data_t");
								
								//adresses
								updates = compareMap(addressDataIn, addressData);
								writeUpdates(namedParameters,updates,"cc_gen_peci_addr_data_t");
	
								//phones
								phoneUpdate (phoneDataIn, phoneData, namedParameters);
								
								getResponse().setStatus( Status.SUCCESS_OK );
								getResponse().setEntity( jsonResponse.toString(), MediaType.APPLICATION_JSON );
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
	
	public void writeUpdates (Map<String,Object> namedParameters, Map<String, Object> updates, String tableName) {
		writeUpdates (namedParameters, updates,  tableName,  jdbcCAS);
	}
	
	
	public static void writeUpdates (Map<String,Object> namedParameters, Map<String, Object> updates, String tableName, NamedParameterJdbcTemplate jdbcCAS) {
		Map<String, Object> sourceData = new HashMap<String, Object>();
		
		if (updates.size() > 0 ) {
			//Write Data changes
			String SQL="select count(*) ct from "+ tableName +" where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
			sourceData = jdbcCAS.queryForMap(SQL,namedParameters);
			int ct = Integer.valueOf(sourceData.get("ct").toString());
			if (ct == 0){
				SQL = "Insert "+ tableName +" SET ";
				List<String> columns = new ArrayList(updates.keySet());
				for(int i=0; i<columns.size(); i++) { 
			        String key = columns.get(i);
			        Object newValue = updates.get(key);
			        if (newValue.getClass().getName().equals("java.lang.String")) {
			        	SQL = SQL + key +" = '" +  newValue + "', ";
			        } else {
			        	SQL = SQL + key +" = " +  newValue + ", ";
			        }
			    } 
				SQL = SQL + "CHANGE_COLS = 'NEW', ";
				SQL = SQL + "STUDENT_PIDM=:STUDENT_PIDM, ";
				SQL = SQL + "PARENT_PPID=:PARENT_PPID";
				jdbcCAS.update(SQL,namedParameters);
			} else{
				SQL="select CHANGE_COLS from "+ tableName +" where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
				sourceData = jdbcCAS.queryForMap(SQL,namedParameters);
				String changeCol = (String) sourceData.get("CHANGE_COLS");
				if (changeCol == null) changeCol="";
				SQL = "UPDATE "+ tableName +" SET ";
				List<String> columns = new ArrayList(updates.keySet());
				for(int i=0; i<columns.size(); i++) { 
			        String key = columns.get(i);
			        Object newValue = updates.get(key);
			        if (newValue.getClass().getName().equals("java.lang.String")) {
			        	SQL = SQL + key +" = '" +  newValue + "', ";
			        } else {
			        	SQL = SQL + key +" = " +  newValue + ", ";
			        }
			        changeCol = changeCol + key + ",";
			    } 
				SQL = SQL + "CHANGE_COLS = '" + changeCol +"'";
				SQL = SQL + " where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
				jdbcCAS.update(SQL,namedParameters);
				
			}
		}
	}
	
	public static Map<String, Object> toMap(JSONObject object) throws JSONException {
	    Map<String, Object> map = new HashMap<String, Object>();

	    Iterator<String> keysItr = object.keys();
	    while(keysItr.hasNext()) {
	        String key = keysItr.next();
	        Object value = object.get(key);

	        if(value instanceof JSONArray) {
	            value = toList((JSONArray) value);
	        }

	        else if(value instanceof JSONObject) {
	            value = toMap((JSONObject) value);
	        }
	        map.put(key, value);
	    }
	    return map;
	}

	public static List<Object> toList(JSONArray array) throws JSONException {
	    List<Object> list = new ArrayList<Object>();
	    for(int i = 0; i < array.length(); i++) {
	        Object value = array.get(i);
	        if(value instanceof JSONArray) {
	            value = toList((JSONArray) value);
	        }

	        else if(value instanceof JSONObject) {
	            value = toMap((JSONObject) value);
	        }
	        list.add(value);
	    }
	    return list;
	}
	
	public char Parent_PPID (Map<String, Object> namedParameters){		
		Map<String,Object> maxData = new HashMap<String, Object>();
		String SQL;
		char seqNo;
		try{
			SQL="select max(PARENT_PPID)  seq from cc_adv_peci_parents_t where STUDENT_PIDM=:STUDENT_PIDM ";
			maxData = jdbcCAS.queryForMap(SQL,namedParameters);
		} catch (EmptyResultDataAccessException e){
			// dataset empty 
		}
		if ((maxData.get("seq") == null) || (maxData.get("seq").toString().matches("^-?\\d+$")) ){
			seqNo = 'A';
		} else {
			seqNo = maxData.get("seq").toString().charAt(0);
			seqNo = (char)((int)seqNo + 1);
		}
		try{
			SQL="select max(PARENT_PPID)  seq from cc_gen_peci_emergs_t where STUDENT_PIDM=:STUDENT_PIDM ";
			maxData = jdbcCAS.queryForMap(SQL,namedParameters);
		} catch (EmptyResultDataAccessException e){
			// dataset empty 
		}
		if (!((maxData.get("seq") == null) || (maxData.get("seq").toString().matches("^-?\\d+$")) )){
			if (maxData.get("seq").toString().charAt(0) >= seqNo){
				seqNo = maxData.get("seq").toString().charAt(0);
				seqNo = (char)((int)seqNo + 1);
			}
		}
		return seqNo;
	}
	
	public static Map<String, Object> compareMap(Map<String, Object> testMap, Map<String, Object> origMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		List<String> columns = new ArrayList(testMap.keySet());
		for(int i=0; i<columns.size(); i++) { 
	        String key = columns.get(i);
	        Object testValue = testMap.get(key);
	        if (origMap.containsKey(key) || origMap.size() == 0) {
	        	Object origValue = origMap.get(key);
        		if (origValue != null) {
			        if (origValue.getClass().getName().equals("java.lang.String") || origValue.getClass().getName().equals("java.lang.Integer")) {
		        		if (!(origValue.equals(testValue))){
		    	        	map.put(key,testValue);
		    	        }
		        	}
        		} else if (!(testValue.getClass().getName().equals("org.json.JSONObject$Null"))) {
	        		map.put(key,testValue);
	        	} 
	        }
	    }    
	    return map;   
	}
	
	public void phoneUpdate (List<Map<String,Object>> phoneDataIn, List<Map<String,Object>> phoneData, Map<String,Object> namedParameters) throws Exception {
		phoneUpdate (phoneDataIn, phoneData, namedParameters, jdbcCAS);
	}
	
	public static void phoneUpdate (List<Map<String,Object>> phoneDataIn, List<Map<String,Object>> phoneData, Map<String,Object> namedParameters, NamedParameterJdbcTemplate jdbcCAS) throws Exception {
		String SQL;
		for (int i=0;i<phoneDataIn.size();i++){
			Map<String,Object> phoneRecordIn = phoneDataIn.get(i);
			
			if (( phoneRecordIn.get("PHONE_SEQUENCE_NO").getClass().getName().equals("org.json.JSONObject$Null") ) || phoneRecordIn.get("PHONE_SEQUENCE_NO")=="") {
				//Add a phone to the parent 
				//Find an Alpha Seq No
				Map<String,Object> maxData = new HashMap<String, Object>();
				char seqNo;
				try{
					SQL="select max(PHONE_SEQUENCE_NO)  seq from cc_gen_peci_phone_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
					maxData = jdbcCAS.queryForMap(SQL,namedParameters);
				} catch (EmptyResultDataAccessException e){
					// dataset empty 
				}
				if ((maxData.get("seq") == null) || (maxData.get("seq").toString().matches("^-?\\d+$")) ){
					seqNo = 'A';
				} else {
					seqNo = maxData.get("seq").toString().charAt(0);
					seqNo = (char)((int)seqNo + 1);
				}
				SQL = "INSERT cc_gen_peci_phone_data_t SET ";
				List<String> columns = new ArrayList(phoneRecordIn.keySet());
				for(int y=0; y<columns.size(); y++) { 
			        String key = columns.get(y);
			        if (!key.equals("PHONE_SEQUENCE_NO")) {
				        Object newValue = phoneRecordIn.get(key);
				        if (newValue.getClass().getName().equals("java.lang.String")) {
				        	SQL = SQL + key +" = '" +  newValue + "', ";
				        } else {
				        	SQL = SQL + key +" = " +  newValue + ", ";
				        }
			        }
			    } 
				SQL = SQL + "CHANGE_COLS = 'NEW', ";
				
				SQL = SQL + "STUDENT_PIDM=:STUDENT_PIDM, ";
				SQL = SQL + "PARENT_PPID=:PARENT_PPID, "; 
				SQL = SQL + "PHONE_SEQUENCE_NO='" + seqNo + "'";
				
				jdbcCAS.update(SQL,namedParameters);
			} else {
				for (int x=0;x<phoneData.size();x++) {
				
					Map<String,Object> phoneRecord = phoneData.get(x);
					if ( (phoneRecordIn.get("PHONE_CODE").equals(phoneRecord.get("PHONE_CODE"))) &&
						 (phoneRecordIn.get("PHONE_SEQUENCE_NO").equals(phoneRecord.get("PHONE_SEQUENCE_NO")))	){
						Map<String,Object> phoneParameters = namedParameters;
						phoneParameters.put("PHONE_SEQUENCE_NO", phoneRecordIn.get("PHONE_SEQUENCE_NO"));
						phoneParameters.put("PHONE_CODE", phoneRecordIn.get("PHONE_CODE"));
						
						String phoneNumber = "";
						if (phoneRecordIn.containsKey("PHONE_NUMBER")){
							if (!(phoneRecordIn.get("PHONE_NUMBER").getClass().getName().equals("org.json.JSONObject$Null")))
								phoneNumber=(String)phoneRecordIn.get("PHONE_NUMBER");
						}
						
						String phoneNumberIntl = "";
						if (phoneRecordIn.containsKey("PHONE_NUMBER_INTL")) {
							if (!(phoneRecordIn.get("PHONE_NUMBER_INTL").getClass().getName().equals("org.json.JSONObject$Null")))
								phoneNumberIntl = (String)phoneRecordIn.get("PHONE_NUMBER_INTL");
						}
						
						if ((phoneNumber.isEmpty()) && (phoneNumberIntl.isEmpty())){
							//Inactivate the phone record
							SQL = "UPDATE cc_gen_peci_phone_data_t SET ";
							SQL = SQL + " CHANGE_COLS = 'DELETE', ";
							SQL = SQL + " PHONE_STATUS_IND = 'I' ";
							SQL = SQL + " where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
							SQL = SQL + " and PHONE_CODE=:PHONE_CODE and PHONE_SEQUENCE_NO=:PHONE_SEQUENCE_NO";
							jdbcCAS.update(SQL,phoneParameters);
						}else{
							// compare
							Map<String,Object> updates = compareMap(phoneRecordIn, phoneRecord);
							if (updates.size() > 0 ) {
								//Write Parent Data changes
								SQL="select CHANGE_COLS from cc_gen_peci_phone_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID and PHONE_CODE=:PHONE_CODE and PHONE_SEQUENCE_NO=:PHONE_SEQUENCE_NO";
								Map<String,Object> sourceData = jdbcCAS.queryForMap(SQL,phoneParameters);
								String changeCol = (String) sourceData.get("CHANGE_COLS");
								if (changeCol == null) changeCol="";
								SQL = "UPDATE cc_gen_peci_phone_data_t SET ";
								List<String> columns = new ArrayList(updates.keySet());
								for(int y=0; y<columns.size(); y++) { 
							        String key = columns.get(y);
							        Object newValue = updates.get(key);
							        if (newValue.getClass().getName().equals("java.lang.String")) {
							        	SQL = SQL + key +" = '" +  newValue + "', ";
							        } else {
							        	SQL = SQL + key +" = " +  newValue + ", ";
							        }
							        changeCol = changeCol + key + ",";
							    } 
								SQL = SQL + "CHANGE_COLS = '" + changeCol +"'";
								SQL = SQL + " where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID";
								SQL = SQL + " and PHONE_CODE=:PHONE_CODE and PHONE_SEQUENCE_NO=:PHONE_SEQUENCE_NO";
								jdbcCAS.update(SQL,phoneParameters);
							}
						}
					}
				}
			}
		}
	}
}