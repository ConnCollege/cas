package edu.conncoll.cas.jdbc;

import java.io.File;
import java.lang.Character;
import java.lang.Integer;
import java.math.BigDecimal;
import java.sql.Types;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.InternetAddress;
import javax.naming.InitialContext;
import javax.naming.Context;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.ldap.BasicControl;
import javax.naming.ldap.LdapContext;
import javax.sql.DataSource;
import javax.validation.constraints.NotNull;

import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.jdbc.core.SqlReturnResultSet;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.object.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.ldap.core.support.AbstractContextMapper;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.webflow.execution.RequestContext;

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.admin.directory.Directory;
import com.google.api.services.admin.directory.DirectoryScopes;
import com.google.api.services.admin.directory.model.User;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.util.LdapUtils;
import org.jasig.cas.web.support.IntData;

import edu.conncoll.cas.restlet.PECIResource;


public class jdbcCamel {
	@NotNull
    private NamedParameterJdbcTemplate jdbcTemplate;
	
	@NotNull
    private JdbcTemplate jdbcCensus;
	
	@NotNull
    private JdbcTemplate jdbcBlackB;
	
	@NotNull
    private NamedParameterJdbcTemplate jdbcCAS;
    
    @NotNull
    private DataSource dataSource;
    
    @NotNull
    private DataSource censusSource;
    
    @NotNull
    private DataSource BlackBSource;
    
    @NotNull
    private DataSource CASSource;
    
	@NotNull
	private LdapTemplate ldapTemplate;
    
	@NotNull
	private LdapTemplate vaultTemplate;
	
	@NotNull
    private String filter;	
	
	@NotNull
    private String vaultFilter;	
	
	@NotNull
    private String searchBase;
	
	@NotNull
    private String vaultSearchBase;
	
	@NotNull
    private String recaptchaPublic;
	
	@NotNull
    private String recaptchaPrivate;
	
	@NotNull
    private String mainUsername;
	
	@NotNull
    private String mainPassword;
	
	@NotNull
    private String nuVisionPath;
	
	@NotNull
    private String adVersion;
	
	@NotNull
    private Boolean gmSync;
	
	/* briley 7/20/2012 - added PIF to list */
	public enum Interrupts {
		AUP, OEM, QNA, ACT, PWD, EMR, AAUP, PIF, CNS, CHANGE, INIT, RESET, RST2, PECI, PECIC, PECIE, PECIBATCH, NOVALUE;    
		public static Interrupts toInt(String str) {
			try {
				return valueOf(str);
			} 
			catch (Exception ex) {
				return NOVALUE;
			}
		}
	}
	
	private RestfulResponse restfulResponse;
	
	private Log log = LogFactory.getLog(this.getClass());
	
	private static final String APPLICATION_NAME = "Conncoll-CAS/3.4.10";
	   
	/** E-mail address of the service account. */
	private static final String SERVICE_ACCOUNT_EMAIL = "46405817960-0j56j21hdlf08me03r8farnp4hvc0epa@developer.gserviceaccount.com";
	 
	/** Global instance of the HTTP transport. */
	private static HttpTransport httpTransport;
	 
	/** Global instance of the JSON factory. */
	private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
	
	public void readFlow (final String flag, final RequestContext context, final UsernamePasswordCredentials credentials) 
			throws Exception {
		String userName = credentials.getUsername();
		
		String SQL = "";
		
		SqlParameterSource namedParameters = new MapSqlParameterSource("user", userName + "@conncoll.edu");
		
		log.debug("readFlow Preparing data for " + flag + " user is " + userName);
		
		String searchFilter;
		List DN;
		DirContextOperations ldapcontext;
		String Attrib;
		
		
		switch (Interrupts.toInt(flag)) {
			case RST2:
				namedParameters = new MapSqlParameterSource("username", userName );
				SQL = "select QuestNum, question,Answer from cc_user_qnaPair cuqp inner join cc_user_questions cuq on cuqp.QuestionId=cuq.id where cuqp.UId=:username order by QuestNum";
				List<Map<String,Object>> UserQNA = jdbcTemplate.queryForList(SQL,namedParameters);
				context.getFlowScope().put("UserQNA", UserQNA);
				context.getFlowScope().put("recaptchaPublicKey", recaptchaPublic);
				context.getFlowScope().put("recaptchaPrivateKey", recaptchaPrivate);
				break;
			case AUP:
				SQL = "select count(*) ct from cc_user where email = :user and active=1";
				Map<String,Object> ChkUser = jdbcTemplate.queryForMap(SQL,namedParameters);
				
				context.getFlowScope().put("actcheck", ChkUser.get("ct"));
				break;
			case OEM:
				SQL = "select oemail, firstname from cc_user where email = :user and active=1";
		
				
				Map<String,Object> OEMData = jdbcTemplate.queryForMap(SQL,namedParameters);
				if (OEMData.get("oemail")==null){
					log.warn("readFlow: No outside mail for " + userName );
					// No OEM email in cc_user		
					context.getFlowScope().put("status", "no email");
					return;
				}
				if (OEMData.get("oemail").toString().length()<3){
					log.warn("readFlow: No outside mail for " + userName );
					// No OEM email in cc_user		
					context.getFlowScope().put("status", "no email");
					return;
				}
				try {
					log.debug("readFlow connecting to email for " + OEMData.get("oemail").toString());
					context.getFlowScope().put("oemail", OEMData.get("oemail").toString());
					Context initCtx = new InitialContext();
					Session session = (Session) initCtx.lookup("java:comp/env/mail/Session");
					log.debug("readFlow connected to email.");
					StringBuilder actMsg = new StringBuilder();
					
					actMsg.append("Welcome " + OEMData.get("firstname").toString() + ",\n\n");
					actMsg.append("This email is to alert you that your Connecticut College CamelWeb account has been activated.\n\n");
					actMsg.append("If you did not activate your account or believe you have otherwise received this email in error");
					actMsg.append(" please contact the Connecticut College IT Service Desk @ (860) 439 - HELP (4357).\n\n");
					actMsg.append("We are committed to delivering you quality service that is reliable and highly secure.");
					actMsg.append("  This email is one of many components designed to ensure your information is safeguarded at all times.\n\n"); 
					actMsg.append("Thank you,\nConnecticut College Information Services Staff");
					
					log.debug("readFlow sending email to " + OEMData.get("oemail").toString());
					
					Message message = new MimeMessage(session);
					Address address = new InternetAddress("help@conncoll.edu", "Connecticut College Helpdesk");
					Address toAddress = new InternetAddress(OEMData.get("oemail").toString());
					message.setSentDate(new Date());
					message.setFrom(address);
					message.addRecipient(Message.RecipientType.TO, toAddress);
					message.setSubject("CamelWeb Account Activation");
					message.setContent(actMsg.toString(), "text/plain");
					Transport.send(message);
					context.getFlowScope().put("status", "sent");
					context.getFlowScope().put("oemail", OEMData.get("oemail").toString());
					log.debug("readFlow  email sent");						
				} catch (Exception e){
					context.getFlowScope().put("status", "failed");
				}		
			break;
			case QNA:				
				namedParameters = new MapSqlParameterSource("username", userName );
				SQL = "select id, question qChoice, active, QuestNum, Answer from cc_user_questions cuq left join cc_user_qnaPair cuqp on cuq.id = cuqp.QuestionId and cuqp.UId = :username order by QuestNum";				
				List<Map<String,Object>> QNAData = jdbcTemplate.queryForList(SQL,namedParameters);	
				log.debug("readFlow sending questions");
				context.getFlowScope().put("questionList", QNAData);
			break;
			case ACT:
				SQL = "select firstname, lastname from cc_user where email = :user and active=1";
		
				Map<String,Object> ACTData = jdbcTemplate.queryForMap(SQL,namedParameters);
				
				try {
					context.getFlowScope().put("firstname", ACTData.get("firstname").toString());
					context.getFlowScope().put("lastname", ACTData.get("lastname").toString());
				} catch (Exception e) {
					// No CamelWeb account	
					context.getFlowScope().put("firstname","");
					context.getFlowScope().put("lastname","");
				}	
				
				context.getFlowScope().put("userName", userName);
			break;
			case EMR:
				SQL = "select Id, ccId from cc_user where email = :user and active=1";
				try {
					Map<String,Object> CWData = jdbcTemplate.queryForMap(SQL,namedParameters);
					EMRRead emrRead = new EMRRead(this.dataSource);
					Map<String,Object> readData = emrRead.execute(CWData.get("ccId").toString(),CWData.get("Id"),0);
					log.debug("proc size" + readData.size());
					log.debug("proc retun" + readData.toString());
					ArrayList temp = (ArrayList) readData.get("emrData");
					context.getFlowScope().put("emrData", (HashMap)temp.get(0));
					temp = (ArrayList) readData.get("ccData");
					context.getFlowScope().put("ccData", (HashMap)temp.get(0));
					temp = (ArrayList) readData.get("Phones");
					context.getFlowScope().put("Phones", temp);
					temp = (ArrayList) readData.get("Relations");
					context.getFlowScope().put("Relations", temp);
					temp = (ArrayList) readData.get("SMSVendors");
					context.getFlowScope().put("SMSVendors", temp);
					context.getFlowScope().put("ValidEmr", 1);
				} catch (Exception e){
					context.getFlowScope().put("ValidEmr", 0);
					log.warn("Invalid connect-ed data for " + userName);
				}
			break;
			
			/* briley 7/20/12 - Added User Name to the scope so its available on form */
			case PIF:
				context.getFlowScope().put("cwUserName", userName);
				
			break;
			
			case CNS:
				//Find Term Code
				SQL = "select param_value from cc_gen_census_settings where param_name = 'CURRENT TERM CODE' ";
				Map<String,Object> termData = jdbcCensus.queryForMap(SQL);
				log.debug("Termcode returned by query " + termData.get("param_value").toString());
				// term code termData.get("param_value").toString()
				// get banner id from ldap
				searchFilter = LdapUtils.getFilterWithValues(this.vaultFilter, userName);
				
				DN = this.vaultTemplate.search(
					this.vaultSearchBase, searchFilter, 
					new AbstractContextMapper(){
						protected Object doMapFromContext(DirContextOperations ctx) {
							return ctx.getNameInNamespace();
						}
					}
				);
				
				ldapcontext = vaultTemplate.lookupContext(DN.get(0).toString());
				
				Attrib = ldapcontext.getStringAttribute("employeeNumber");
				//Write to Census Table
				try {
					SQL = "insert INTO census.cc_gen_census_data (network_id, banner_id, term_code, login_date) values ( :userName, :bannerId, :termCode, SYSDATE) ";
					log.debug("SQL for insert" + SQL);
					log.debug("user " + userName);
					log.debug("banner id " + Attrib.toString());
					log.debug("Term Code " + termData.get("param_value").toString());
					int check = jdbcCensus.update(SQL, userName, Attrib.toString(), termData.get("param_value").toString());
					log.debug("insert rerutn" + Integer.toString(check));
				} catch (DataAccessException e){
					log.warn("SQL for Census insert failed " + e.getMessage());
				}
				//Write to Black Board Clone Table
				try {
					SQL = "update clone.clone_card set customfield8 = 'Y' , customfield12 = to_char(sysdate, 'mm/dd/yyyy hh:mi:ss AM') where person_number = :bannerId";
					log.debug("SQL for update " + SQL);
					log.debug("banner id " + Attrib.toString());
					int check = jdbcBlackB.update(SQL, Attrib.toString());
					log.debug("insert rerutn" + Integer.toString(check));
				} catch (DataAccessException e){
					log.warn("SQL for Clone Table update failed " + e.getMessage());
				}
			break;
			case PECIBATCH:
				Map<String,Object> studentTransCT = new HashMap<String,Object>();
				SQL="SELECT COUNT(*) ct FROM peci_trans_start";
				studentTransCT = jdbcCAS.queryForMap(SQL,new HashMap<String,Object>());
				context.getFlowScope().put("Users", studentTransCT.get("ct"));
			break;
			case PECI:
			case PECIE:
			case PECIC:	
				//Get PDIM and Name from Vault
				String vaultSearchFilter = LdapUtils.getFilterWithValues(this.vaultFilter, userName);
				log.debug("Vault search filter: " + vaultSearchFilter);
				
				if ( !flag.equals("PECIC")) context.getFlowScope().put("SourceFlag", flag);
				
				List vaultDN = this.vaultTemplate.search(
					this.vaultSearchBase, vaultSearchFilter, 
					new AbstractContextMapper(){
						protected Object doMapFromContext(DirContextOperations ctx) {
							return ctx.getNameInNamespace();
						}
					}
				);
				log.debug("DN: "+ vaultDN.get(0).toString());
				DirContextOperations vaultcontext = vaultTemplate.lookupContext(vaultDN.get(0).toString());
				
				String ccPDIM = vaultcontext.getStringAttribute("ccpidm");
				String givenName = vaultcontext.getStringAttribute("givenname");
				String surName = vaultcontext.getStringAttribute("sn");
				
				Map<String,Object> studentData = new HashMap<String,Object>();
				Map<String,Object> studentTrans = new HashMap<String,Object>();
				List<Map<String,Object>> parentData = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> addressData = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> emailData = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> phoneData = new ArrayList<Map<String,Object>>();
				List<Map<String,Object>> emergData = new ArrayList<Map<String,Object>>();
				 
				log.debug ("PDIM Attribute returned:" + ccPDIM);

				//Check if data already loaded in MySQL
				log.debug("Checking for eisting record in MySQL");
				SQL = "select count(STUDENT_PIDM) ct from peci_trans_start where STUDENT_PIDM=:STUDENT_PIDM";
				
				namedParameters = new MapSqlParameterSource("STUDENT_PIDM", ccPDIM.toString() );
				
				studentTrans = jdbcCAS.queryForMap(SQL,namedParameters);
				
				context.getFlowScope().put("Flag", "PECIE");
				
				if ( (Long)studentTrans.get("ct") == 0 ){
					//Check for data in Oracle
					log.debug("Checking for eisting record in Oracle");
					SQL = "select count(STUDENT_PIDM) ct from cc_stu_peci_students_v where STUDENT_PIDM=" + ccPDIM.toString();
					
					studentData = jdbcCensus.queryForMap(SQL);
					
					BigDecimal ct = (BigDecimal)studentData.get("ct");
					
					if ( ct.intValue() !=0 ){
						log.debug("Loading Data from Oracle to MySQL");
					
						//Pull PECI Data from Oracle and store in MySQL 
						
						//Enter transaction data in trans table
						SQL= "insert into peci_trans_start (STUDENT_PIDM, STUDENT_UUID, Trans_start) values ( :STUDENT_PIDM,uuid(), now())";
						log.debug("inserting transaction start");
						jdbcCAS.update(SQL,namedParameters);
						
						
						//Student Data
						SQL = "select STUDENT_PPID,STUDENT_PIDM,CAMEL_NUMBER,CAMEL_ID,LEGAL_PREFIX_NAME,LEGAL_FIRST_NAME,LEGAL_MIDDLE_NAME,LEGAL_LAST_NAME,LEGAL_SUFFIX_NAME,PREFERRED_FIRST_NAME,PREFERRED_MIDDLE_NAME,PREFERRED_LAST_NAME,EMERG_NO_CELL_PHONE,EMERG_PHONE_NUMBER_TYPE_CODE,EMERG_CELL_PHONE_CARRIER,EMERG_PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,LEGAL_DISCLAIMER_DATE,DEAN_EXCEPTION_DATE,GENDER,DECEASED,DECEASED_DATE  from cc_stu_peci_students_v where STUDENT_PIDM=" + ccPDIM.toString();
						studentData = jdbcCensus.queryForMap(SQL);
						
						copy2MySQL("cc_stu_peci_students_t",studentData);
						
						
						//Parent Data
						SQL="select STUDENT_PPID, PARENT_PPID, STUDENT_PIDM, PARENT_PIDM, PARENT_CAMEL_NUMBER, PARENT_CAMEL_ID, PARENT_ORDER, PARENT_LEGAL_PREFIX_NAME, PARENT_LEGAL_FIRST_NAME, PARENT_LEGAL_MIDDLE_NAME, PARENT_LEGAL_LAST_NAME, PARENT_LEGAL_SUFFIX_NAME, PARENT_PREF_FIRST_NAME, PARENT_PREF_MIDDLE_NAME, PARENT_PREF_LAST_NAME, PARENT_RELT_CODE, EMERG_CONTACT_PRIORITY, EMERG_NO_CELL_PHONE, EMERG_PHONE_NUMBER_TYPE_CODE, EMERG_CELL_PHONE_CARRIER, EMERG_PHONE_TTY_DEVICE, DEPENDENT, PARENT_GENDER, PARENT_DECEASED, PARENT_DECEASED_DATE, PECI_ROLE, CONTACT_TYPE, PARENT_CONFID_IND from cc_adv_peci_parents_v where PARENT_PPID > 0 and STUDENT_PIDM=" + ccPDIM.toString();
						parentData = jdbcCensus.queryForList(SQL);
						
						copy2MySQL("cc_adv_peci_parents_t",parentData);		
												
						//Address Data
						SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_v where (ADDR_STATUS_IND is null or  ADDR_STATUS_IND = 'A') and PECI_ADDR_CODE='H' and STUDENT_PIDM=" + ccPDIM.toString();
						addressData = jdbcCensus.queryForList(SQL);
						
						copy2MySQL("cc_gen_peci_addr_data_t",addressData);	
						
						//Email Data
						SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_v where (PECI_EMAIL_CODE='H' or PECI_EMAIL_CODE='P') and STUDENT_PIDM=" + ccPDIM.toString();
						emailData = jdbcCensus.queryForList(SQL);
						
						copy2MySQL("cc_gen_peci_email_data_t",emailData);	
						
						//Phone Data
						SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_v where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=" + ccPDIM.toString();
						phoneData = jdbcCensus.queryForList(SQL);
						
						copy2MySQL("cc_gen_peci_phone_data_t",phoneData);	
						
						//Emergency Contact Data
						SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,EMERG_LEGAL_PREFIX_NAME,EMERG_LEGAL_FIRST_NAME,EMERG_LEGAL_MIDDLE_NAME,EMERG_LEGAL_LAST_NAME,EMERG_LEGAL_SUFFIX_NAME,EMERG_PREF_FIRST_NAME,EMERG_PREF_MIDDLE_NAME,EMERG_PREF_LAST_NAME,EMERG_RELT_CODE,EMERG_CONTACT_PRIORITY,EMERG_NO_CELL_PHONE,EMERG_PHONE_NUMBER_TYPE_CODE,EMERG_CELL_PHONE_CARRIER,EMERG_PHONE_TTY_DEVICE,DEPENDENT,PARENT_GENDER,PARENT_DECEASED,PARENT_DECEASED_DATE,PARENT_CONFID_IND from cc_gen_peci_emergs_v where PARENT_PPID >0 and STUDENT_PIDM=" + ccPDIM.toString();
						emergData = jdbcCensus.queryForList(SQL);
						
						copy2MySQL("cc_gen_peci_emergs_t",emergData);	
					} else {
						//Brand new PECI record.		
						log.debug("Brand new PECI Record starting MySQL Base record");			
						SQL = "select SPRIDEN_PIDM as STUDENT_PIDM, SPRIDEN_FIRST_NAME as PREFERRED_FIRST_NAME, SPRIDEN_LAST_NAME as PREFERRED_LAST_NAME, SPRIDEN_MI as PREFERRED_MIDDLE_NAME, 'Y' as  EMERG_SEND_TEXT, 'NEW' as CHANGE_COLS from spriden where SPRIDEN_NTYP_CODE='PREF' and SPRIDEN_PIDM =" + ccPDIM.toString();
						studentData = jdbcCensus.queryForMap(SQL);
						
						copy2MySQL("cc_stu_peci_students_t",studentData);
						
						//Enter transaction data in trans table
						SQL= "insert into peci_trans_start (STUDENT_PIDM, STUDENT_UUID, Trans_start) values ( :STUDENT_PIDM, uuid(), now())";
						log.debug("inserting transaction start");
						jdbcCAS.update(SQL,namedParameters);
					}
				}
				
				loadPECIOptions(context);
				//Pull data from MySQL for the form.
				context.getFlowScope().put("StudentHomePhone", new HashMap<String,Object>());
				context.getFlowScope().put("StudentCellPhone", new HashMap<String,Object>());
				context.getFlowScope().put("StudentEmrPhone", new HashMap<String,Object>());
				log.debug("Populating form with MySQL data");
				try {
					//Update Pref Names in MySQL
					SQL = "Update cc_adv_peci_parents_t set PARENT_PREF_FIRST_NAME = PARENT_LEGAL_FIRST_NAME, PARENT_PREF_MIDDLE_NAME = PARENT_LEGAL_MIDDLE_NAME, PARENT_PREF_LAST_NAME = PARENT_LEGAL_LAST_NAME where PARENT_PREF_FIRST_NAME is null and PARENT_PREF_MIDDLE_NAME is null and PARENT_PREF_LAST_NAME is null";
					jdbcCAS.update(SQL, new HashMap<String,Object>());
					SQL = "Update cc_gen_peci_emergs_t set EMERG_PREF_FIRST_NAME = EMERG_LEGAL_FIRST_NAME, EMERG_PREF_MIDDLE_NAME = EMERG_LEGAL_MIDDLE_NAME, EMERG_PREF_LAST_NAME = EMERG_LEGAL_LAST_NAME where EMERG_PREF_FIRST_NAME is null and EMERG_PREF_MIDDLE_NAME is null and EMERG_PREF_LAST_NAME is null";
					jdbcCAS.update(SQL, new HashMap<String,Object>());

					//Student Data
					SQL = "select st.STUDENT_PPID, ts.STUDENT_UUID STUDENT_PIDM,CAMEL_NUMBER,CAMEL_ID,LEGAL_PREFIX_NAME,PREFERRED_FIRST_NAME,PREFERRED_MIDDLE_NAME,PREFERRED_LAST_NAME,LEGAL_SUFFIX_NAME,EMERG_NO_CELL_PHONE,EMERG_PHONE_NUMBER_TYPE_CODE,EMERG_CELL_PHONE_CARRIER,EMERG_PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,LEGAL_DISCLAIMER_DATE,DEAN_EXCEPTION_DATE,GENDER,DECEASED,DECEASED_DATE  from cc_stu_peci_students_t st inner join peci_trans_start ts on st.STUDENT_PIDM = ts.STUDENT_PIDM where st.STUDENT_PIDM=:STUDENT_PIDM";
					studentData = jdbcCAS.queryForMap(SQL,namedParameters);

					//Address Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0'";
					addressData = jdbcCAS.queryForList(SQL,namedParameters);
					
					//email Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PECI_EMAIL_CODE='H'";
					emailData = jdbcCAS.queryForList(SQL,namedParameters);
					
					//Phone Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and CHANGE_COLS != 'DELETE' and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PECI_PHONE_CODE='C'";
					phoneData = jdbcCAS.queryForList(SQL,namedParameters);

					if (phoneData.size() >0 ) context.getFlowScope().put("StudentCellPhone",phoneData.get(0));
					
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and CHANGE_COLS != 'DELETE' and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PECI_PHONE_CODE='H'";
					phoneData = jdbcCAS.queryForList(SQL,namedParameters);
					
					if (phoneData.size() >0 ) context.getFlowScope().put("StudentHomePhone",phoneData.get(0));
					
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and CHANGE_COLS != 'DELETE' and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PHONE_CODE='EP'";
					phoneData = jdbcCAS.queryForList(SQL,namedParameters);
					
					if (phoneData.size() >0 ) context.getFlowScope().put("StudentEmrPhone",phoneData.get(0));
					
					SQL="  CALL `cas`.`PECI_Phone_Names`(:STUDENT_PIDM)     ";
					phoneData = jdbcCAS.queryForList(SQL,namedParameters);
					
					context.getFlowScope().put("EmmrgPhones",phoneData);
					
					//Parents
					SQL="select PARENT_PPID, PARENT_ORDER, PARENT_LEGAL_PREFIX_NAME, PARENT_PREF_FIRST_NAME, PARENT_PREF_MIDDLE_NAME, PARENT_PREF_LAST_NAME, PARENT_LEGAL_SUFFIX_NAME from cc_adv_peci_parents_t where (CHANGE_COLS !='DELETE' or  CHANGE_COLS is null) and STUDENT_PIDM=:STUDENT_PIDM order by PARENT_ORDER";
					parentData = jdbcCAS.queryForList(SQL,namedParameters);
					
					//Emergency Contacts
					SQL="select PARENT_PPID, EMERG_CONTACT_PRIORITY, EMERG_LEGAL_PREFIX_NAME, EMERG_PREF_FIRST_NAME,EMERG_PREF_MIDDLE_NAME,EMERG_PREF_LAST_NAME, EMERG_LEGAL_SUFFIX_NAME from cc_gen_peci_emergs_t where (CHANGE_COLS !='DELETE' or  CHANGE_COLS is null) and STUDENT_PIDM=:STUDENT_PIDM order by EMERG_CONTACT_PRIORITY";
					emergData = jdbcCAS.queryForList(SQL,namedParameters);
				} catch(Exception e) {
					log.info("No Student data in MySQL");
				}
				
				// Send to PECIC if flag is PECI and record is sufficently complete
				log.debug ("Checking for PECIE complete");
				log.debug ("Flag: " + flag);
				log.debug ("emergData: " + emergData.size());
				log.debug ("parentData: " + parentData.size());
				log.debug ("addressData: " + !addressData.isEmpty());
				if ( !flag.equals("PECIE") ) {
					if ( (emergData.size() >0)  && (parentData.size() >0)  && (!addressData.isEmpty()) )  {
						context.getFlowScope().put("ContactCount", emergData.size());
						context.getFlowScope().put("ParentCount", emergData.size());
						context.getFlowScope().put("HasAddress", !addressData.isEmpty());
						context.getFlowScope().put("Flag", "PECIC");
					}
				}
				
				context.getFlowScope().put("StudentBio",studentData);
				if (addressData.size() >0 ){
					context.getFlowScope().put("StudentAddr",addressData.get(0));
				}
				if (emailData.size() >0 ){
					context.getFlowScope().put("StudentEmail",emailData.get(0));
				}
				context.getFlowScope().put("StudentParents",parentData);
				context.getFlowScope().put("StudentEMR",emergData);
				
			break;
			default:
				//No Special actions for interrupt
			break;
		}
	}
	
	public String writeFlow (final String flag,  RequestContext context, UsernamePasswordCredentials credentials, final IntData intData) 
		throws Exception {
		String userName = credentials.getUsername();
		String SQL = "";
		Map<String,Object> namedParameters = new HashMap<String,Object>();
		namedParameters.put("user", userName + "@conncoll.edu");
		namedParameters.put("username", userName );
		
		log.info("writeFlow Saving data for " + flag);
		log.debug("writeFlow got data " +intData.getFields().toString());
		context.getFlowScope().put("ErrorMsg", " ");
		
		if (flag.equals("QNA")) {
			//Clear QNAPairs for this user
			SQL="Delete from cc_user_qnaPair where UId = :username";
			int check = jdbcTemplate.update(SQL,namedParameters);
			log.debug("Delete result " + check);
			SQL="insert cc_user_qnaPair (UId, QuestNum, QuestionId, Answer) values(:username, :questnum, :questionId, :answer)";
			log.debug("QNA question #1: " + intData.getField(1));
			log.debug("QNA answer #1: " + intData.getField(2));
			namedParameters.put("questnum", 1);
			namedParameters.put("questionId", intData.getField(1));
			namedParameters.put("answer", intData.getField(2));
			check = jdbcTemplate.update(SQL,namedParameters);
			log.debug("Insert #1 result " + check);
			log.debug("QNA question #2: " + intData.getField(3));
			log.debug("QNA answer #2: " + intData.getField(4));
			namedParameters.put("questnum", 2);
			namedParameters.put("questionId", intData.getField(3));
			namedParameters.put("answer", intData.getField(4));
			check = jdbcTemplate.update(SQL,namedParameters);
			log.debug("Insert #2 result " + check);
		}
		
		if (flag.equals("INIT")){
			userName = intData.getField(1);
			log.info("Init Saving data for " + userName);
			String searchFilter = LdapUtils.getFilterWithValues(this.filter, userName);
			String vaultSearchFilter = LdapUtils.getFilterWithValues(this.vaultFilter, userName);
			
			List DN;
			DirContextOperations ldapcontext;
			
			log.debug("Finding user in AD");
			try {
				 DN = this.ldapTemplate.search(
					this.searchBase, searchFilter, 
					new AbstractContextMapper(){
						protected Object doMapFromContext(DirContextOperations ctx) {
							return ctx.getNameInNamespace();
						}
					}
				);
				ldapcontext = ldapTemplate.lookupContext(DN.get(0).toString());
			} catch (Exception e){
				log.warn("Account doesn't exisit in AD");
				context.getFlowScope().put("ErrorMsg", "Account doesn't exist. Please check the Camel Username and try again.");
				log.error("Account doesn't exist please check the camel username and try again.");
				return "Failed";
			}
			
			log.debug("Looking up user in vault");
			List vaultDN = this.vaultTemplate.search(
				this.vaultSearchBase, vaultSearchFilter, 
				new AbstractContextMapper(){
					protected Object doMapFromContext(DirContextOperations ctx) {
						return ctx.getNameInNamespace();
					}
				}
			);
			DirContextOperations vaultcontext = vaultTemplate.lookupContext(vaultDN.get(0).toString());
			
			log.debug("Checking that the account isn't already enabled");
			String Attrib = ldapcontext.getStringAttribute("UserAccountControl");
			if (!Attrib.equals("514")){
				context.getFlowScope().put("ErrorMsg", "Account already exists. For assistance please contact the IT Service Desk (860) 439-4357.");
				log.info("Returning Account has already been created, you can not set your password with this process.");
				return "Failed";
			}

			log.debug("Checking Banner Id");
			Attrib = vaultcontext.getStringAttribute("employeeNumber");
			if (!Attrib.equals(intData.getField(3))){
				context.getFlowScope().put("ErrorMsg", "Verification of information failed please check the data you entered.");
				log.info("Returning Verification of information failed please check the data you entered.");
				return "Failed";
			}
			
			log.debug("Checking Birthdate");
			Attrib = vaultcontext.getStringAttribute("ccBirthDate");
			DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
            Date vaultDate =  df.parse(Attrib);
            df = new SimpleDateFormat("MM/dd/yyyy");
            Date formDate = df.parse(intData.getField(2));
            log.debug ("comparing dates: " + vaultDate.toString() + " to " + formDate.toString());
			if (!vaultDate.equals(formDate)){
				context.getFlowScope().put("ErrorMsg", "Verification of information failed please check the data you entered.");
				log.info("Returning Verification of information failed please check the data you entered.");
				return "Failed";
			}

			log.debug("Updating Password");
			if (!setPassword ( context, userName,  intData.getField(4), true)){
				//context.getFlowScope().put("ErrorMsg", "Password was rejected by the server, please try again later.");
				log.error("Returning Password Set failed.");
				return "Failed";
			}
			
			ModificationItem[] mods = new ModificationItem[1];
			
			mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("userAccountControl", "512"));
			
			try {
				this.ldapTemplate.modifyAttributes(DN.get(0).toString(),mods);
			}catch( Exception e){
				log.warn("Acount enable failed in AD");
				context.getFlowScope().put("ErrorMsg", "Account enable rejected by server, please contact the IT service desk.");
				log.error("Returning Account enable failed.");
				return "Failed";
			}
			
			credentials.setUsername(intData.getField(1));
			credentials.setPassword(intData.getField(4));
		}
		if (flag.equals("RST2")) {
			//Check QNA Answers are correct
			SQL = "select id, question qChoice, active, QuestNum, Answer from cc_user_questions cuq inner join cc_user_qnaPair cuqp on cuq.id = cuqp.QuestionId and cuqp.UId = :username order by QuestNum";				
			List<Map<String,Object>> QNAData = jdbcTemplate.queryForList(SQL,namedParameters);	
			for (int i=0;i < QNAData.size();i++) {
				Map<String,Object> row = QNAData.get(i);
				int questNum = (Integer)row.get("QuestNum");
				String rstAnswer = (String)intData.getField( questNum + 2);
				String dbAnswer = (String)row.get("Answer");
				log.debug ("comparing :" + rstAnswer +" to " + dbAnswer);
				if (!rstAnswer.equalsIgnoreCase(dbAnswer)){
			    	context.getFlowScope().put("ErrorMsg", "Security Answer did not match.");
			    	return "Failed"; 
				}
			}
			if (!setPassword ( context, userName,  intData.getField(1), true)){
				log.error("Returning Password Set failed.");
				return "Failed";
			}
			String searchFilter = LdapUtils.getFilterWithValues(this.filter, userName);
			List DN = this.ldapTemplate.search(
				this.searchBase, searchFilter, 
				new AbstractContextMapper(){
					protected Object doMapFromContext(DirContextOperations ctx) {
						return ctx.getNameInNamespace();
					}
				}
			);
			
			DirContextOperations ldapcontext = ldapTemplate.lookupContext(DN.get(0).toString());
			
			String ldapAttrib="extensionAttribute8";
			
			log.debug("Writeflow Updating attribute " + ldapAttrib);
			String Attrib = ldapcontext.getStringAttribute(ldapAttrib);
			if (Attrib != null){
				DateFormat dfm = new SimpleDateFormat("MM/dd/yyyy");
				Attrib = Attrib.toString().replace("PWD=;","PWD="+dfm.format(new Date())+";");
				
				log.info("Writeflow writing update '"+ Attrib +"'to attribute " + ldapAttrib);
				ldapcontext.setAttributeValue(ldapAttrib, Attrib);
				ldapTemplate.modifyAttributes(ldapcontext);
			}
			try {	
				log.debug ("Updating user password in context");
				credentials.setPassword(intData.getField(1));
			}catch (Exception e){
				log.warn ("Error seting user's new password into flow: " + e.getMessage());
			}
		}
		if (flag.equals("RESET")) {
			log.debug ("Password reset for " + intData.getField(1));
			credentials.setUsername(intData.getField(1));
			context.getFlowScope().put("Flag","RST2");
			return "Failed";
		}
		if (flag.equals("PWD")) {
			if (!setPassword ( context, userName,  intData.getField(1), true)){
				log.error("Returning Password Set failed.");
				return "Failed";
			}
			credentials.setPassword(intData.getField(1));
		}
		if (flag.equals("EMR")) {
			log.debug("Opt Out Answer is: " + intData.getField(2));
			
			SQL = "select Id, ccId from cc_user where email = :user and active=1";
			Map<String,Object> CWData = jdbcTemplate.queryForMap(SQL,namedParameters);
			
			if (intData.getField(2) != null){
				SQL = "delete emr_main where bannerid = :bannerId ";
				namedParameters.put("bannerId", CWData.get("ccId"));				
				int check = jdbcTemplate.update(SQL,namedParameters);
				log.debug("Delete result " + check);
				SQL = "Update CC_user set EMR=2 where ccID= :bannerId ";
				namedParameters.put("bannerId", CWData.get("ccId"));
				check = jdbcTemplate.update(SQL,namedParameters);
				return "Saved";
			}else{
				//Check primary phone length
				if (intData.getField(6).replace("-","").length() != 7){
					//check if primary phone conatins any non-numeric characters
					if (intData.getField(6).replaceAll("\\d+","").length() > 0) {
						//Invalid Primary Phone number
						log.warn("Invalid Primary Phone number");
						context.getFlowScope().put("ErrorMsg", "Primary phone is not a valid phone number, please correct and submit again");
						return "Failed";
					}else{
						log.debug("Primary Phone number appears valid");
					}
				}
				FormSave formSave = new FormSave(this.dataSource);
				Integer smsVend = Integer.parseInt(intData.getField(41));
				if (intData.getField(11).length() <7) {
					smsVend=null;
				}
				log.debug("Writing primary connected record formSave banner id: " + CWData.get("ccId").toString() + " CCUser Id: " + CWData.get("Id").toString() );
				log.debug(" alt email: " + intData.getField(39) + " outside email: "+ intData.getField(42) + " Contact Type: " + intData.getField(40));
				log.debug(" Language: " + intData.getField(36) + " SMS Vendor: " + smsVend + " TTY: " + intData.getField(38).toCharArray()[0]);
				Map<String,Object> readData = formSave.execute(CWData.get("ccId").toString(),Integer.parseInt(CWData.get("Id").toString()),intData.getField(39),
					 intData.getField(42), intData.getField(40), intData.getField(36), smsVend, 
					 intData.getField(38).toCharArray()[0]
					 );
				int EMRID = Integer.parseInt(readData.get("EMRID").toString());
				log.info("EMR ID for user " + userName + " is " + EMRID );
				log.debug("starting phone save");
				PhoneSave phoneSave = new PhoneSave(this.dataSource);
				int[] PhonePos = {5,10,15,20,25,30};
				char PID = ' ';
				int AreaCode;
				int Phone;
				for (int x = 0; x < PhonePos.length;x++) {
					if (x == 0){
						PID = 'P';
					} else if (x == 1) {
						PID = 'C';
					} else {
						PID = Character.forDigit((x - 1), 10); 
					}
					if (intData.getField(PhonePos[x]).length() == 3) {
						AreaCode = Integer.parseInt(intData.getField(PhonePos[x]));
					}else {
						AreaCode = 860;
					}
					String sPhone = intData.getField(PhonePos[x]+1).replace("-","");
					if ((sPhone.length() == 7) && (sPhone.replaceAll("\\d+","").length() == 0)){		
						Phone = Integer.parseInt(sPhone);
						log.debug("Executing Phone save with: " + EMRID + "," + PID + "," + AreaCode + "," + Phone + "," + 
							intData.getField(PhonePos[x]+2).toCharArray()[0] + "," + intData.getField(PhonePos[x]+3) + "," + 
							Integer.parseInt(intData.getField(PhonePos[x]+4)));
						phoneSave.execute(EMRID, PID, AreaCode, Phone, 
							intData.getField(PhonePos[x]+2).toCharArray()[0], intData.getField(PhonePos[x]+3), 
							Integer.parseInt(intData.getField(PhonePos[x]+4)));
						
					}else{
						log.debug ("Phone number " + x + " not saved as number is not valid");	
						if (x==0){
							log.warn("Invalid Primary Phone number");
							context.getFlowScope().put("ErrorMsg", "Primary phone is not a valid phone number, please correct and submit again");
							return "Failed";
						}					
					}
				}
				SQL = "Update CC_user set EMR=1 where ccID= :bannerId ";
				namedParameters.put("bannerId", CWData.get("ccId"));
				int check = jdbcTemplate.update(SQL,namedParameters);
				log.debug("Update result " + check);
			}
		}
		if (flag.equals("PECIBATCH")) {
			List<Map<String,Object>> studentTransList = new ArrayList<Map<String,Object>>();
			SQL="SELECT STUDENT_PIDM FROM peci_trans_start";
			studentTransList = jdbcCAS.queryForList(SQL,new HashMap<String,Object>());
			for (int i=0; i< studentTransList.size();i++){
				String ccPIDM = studentTransList.get(i).get("STUDENT_PIDM").toString();
				String vaultSearchFilter = LdapUtils.getFilterWithValues("ccPIDM", ccPIDM);
				
				List vaultDN = this.vaultTemplate.search(
					this.vaultSearchBase, vaultSearchFilter, 
					new AbstractContextMapper(){
						protected Object doMapFromContext(DirContextOperations ctx) {
							return ctx.getNameInNamespace();
						}
					}
				);
				
				DirContextOperations vaultcontext = vaultTemplate.lookupContext(vaultDN.get(0).toString());
				
				userName = vaultcontext.getStringAttribute("UID");
				String eduPersonPrimaryAffiliation = vaultcontext.getStringAttribute("eduPersonPrimaryAffiliation");
				if (eduPersonPrimaryAffiliation.equals("STUDENT")){
					PECI2Banner(userName, ccPIDM, "C");
				}
			}
		}

		if (flag.equals("PECIC") || flag.equals("PECI") || flag.equals("PECIE")) {
			
			String vaultSearchFilter = LdapUtils.getFilterWithValues(this.vaultFilter, userName);
			
			List vaultDN = this.vaultTemplate.search(
				this.vaultSearchBase, vaultSearchFilter, 
				new AbstractContextMapper(){
					protected Object doMapFromContext(DirContextOperations ctx) {
						return ctx.getNameInNamespace();
					}
				}
			);
			
			DirContextOperations vaultcontext = vaultTemplate.lookupContext(vaultDN.get(0).toString());
			
			String ccPDIM = vaultcontext.getStringAttribute("ccpidm");

			Map<String,Object> PECIParameters = new HashMap<String,Object>();
			
			PECIParameters.put("STUDENT_PIDM",ccPDIM);
			PECIParameters.put("PARENT_PPID","0");
			
			
			Map<String,Object> studentData = new HashMap<String,Object>();
			Map<String,Object> studentTrans = new HashMap<String,Object>();
			Map<String,Object> addressData = new HashMap<String,Object>();
			Map<String,Object> emailData = new HashMap<String,Object>();
			List<Map<String,Object>> phoneData = new ArrayList<Map<String,Object>>();
			List<Map<String,Object>> parentData = new ArrayList<Map<String,Object>>();
			
			
			
			log.debug ("intData: " + intData.toString());	
			if ( intData.getField(1).equals("edit"))	{
				context.getFlowScope().put("Flag","PECIE");
				return "Failed";
			}
			if ( intData.getField(1).equals("confirm"))	{	
				/* commented for production until Storage solution is ready for upload
				//Save PECI Data from MySQL to Banner
				Map<String,Object> PECIData = new HashMap<String,Object>();
				
				SQL = "select STUDENT_PPID,STUDENT_PIDM,CAMEL_NUMBER,CAMEL_ID,LEGAL_PREFIX_NAME,PREFERRED_FIRST_NAME,PREFERRED_MIDDLE_NAME,PREFERRED_LAST_NAME,LEGAL_SUFFIX_NAME,EMERG_NO_CELL_PHONE,EMERG_PHONE_NUMBER_TYPE_CODE,EMERG_CELL_PHONE_CARRIER,EMERG_PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,LEGAL_DISCLAIMER_DATE,DEAN_EXCEPTION_DATE,GENDER,DECEASED,DECEASED_DATE  from cc_stu_peci_students_t where STUDENT_PIDM=:STUDENT_PIDM";
				studentData = jdbcCAS.queryForMap(SQL,PECIParameters);
				
				if (Integer.parseInt(studentData.get("STUDENT_PPID").toString())==0){
					log.debug("Performing Create to banner");
					PECI2Banner(userName,ccPDIM,"C");
					
				} else {
					//Run PECI Update statements

					log.debug("Performing Update to banner");
					
					PECI2Banner(userName,ccPDIM,"U");
				}
				*/
				context.getFlowScope().put("Flag","PECI");
				return "Saved";
			}
			if ( intData.getField(1).equals("update"))	{
				//Save PECI Main Form data to MySQL
				
				SQL = "select STUDENT_PPID,STUDENT_PIDM,CAMEL_NUMBER,CAMEL_ID,LEGAL_PREFIX_NAME,PREFERRED_FIRST_NAME,PREFERRED_MIDDLE_NAME,PREFERRED_LAST_NAME,LEGAL_SUFFIX_NAME,EMERG_NO_CELL_PHONE,EMERG_PHONE_NUMBER_TYPE_CODE,EMERG_CELL_PHONE_CARRIER,EMERG_PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,LEGAL_DISCLAIMER_DATE,DEAN_EXCEPTION_DATE,GENDER,DECEASED,DECEASED_DATE  from cc_stu_peci_students_t where STUDENT_PIDM=:STUDENT_PIDM";
				studentData = jdbcCAS.queryForMap(SQL,PECIParameters);
				
				try {
					//Address Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PECI_ADDR_CODE='H'";
					addressData = jdbcCAS.queryForMap(SQL,PECIParameters);
				} catch (EmptyResultDataAccessException e){
					// dataset empty 
				}
				
				try {					
					//email Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PECI_EMAIL_CODE='H'";
					emailData = jdbcCAS.queryForMap(SQL,PECIParameters);
				} catch (EmptyResultDataAccessException e){
					// dataset empty 
				}
				
				try {					
					//Phone Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0'";
					phoneData = jdbcCAS.queryForList(SQL,PECIParameters);
				} catch (EmptyResultDataAccessException e){
					// dataset empty 
				}
							
				Map<String,Object> studentDataIn = new HashMap<String,Object>();
				Map<String,Object> addressDataIn = new HashMap<String,Object>();
				Map<String,Object> emailDataIn = new HashMap<String,Object>();
				List<Map<String,Object>> phoneDataIn = new ArrayList<Map<String,Object>>();
				
				
				Map<String,Object> phoneRecord = new HashMap<String,Object>();
				Map<String,Object> updates = new HashMap<String,Object>();
				
				addressDataIn.put("PECI_ADDR_CODE","H");
				addressDataIn.put("ADDR_CODE","MA");
				addressDataIn.put("ADDR_STREET_LINE1",intData.getField(4));
				addressDataIn.put("ADDR_STREET_LINE2",intData.getField(5));
				addressDataIn.put("ADDR_NATN_CODE",intData.getField(6));
				addressDataIn.put("ADDR_CITY",intData.getField(7));
				if (intData.getField(8).toString().length() > 2 ) {
					addressDataIn.put("ADDR_STAT_CODE",intData.getField(8).toString().substring(0,2));
				} else {
					addressDataIn.put("ADDR_STAT_CODE",intData.getField(8));
				}
				addressDataIn.put("ADDR_ZIP",intData.getField(10));	
				
				updates = compareMap(addressDataIn,addressData);
				PECIResource.writeUpdates(PECIParameters,updates,"cc_gen_peci_addr_data_t", jdbcCAS);
				
				//Home email
				if (intData.getField(12) != ""){
					emailDataIn.put("PECI_EMAIL_CODE","H");
					emailDataIn.put("EMAIL_ADDRESS",intData.getField(12));
				}				
				
				updates = compareMap(emailDataIn,emailData);
				PECIResource.writeUpdates(PECIParameters,updates,"cc_gen_peci_email_data_t", jdbcCAS);
				
				

				//Home Phone
				if (intData.getField(11) != "" || intData.getField(28) != "") {		
					phoneRecord.put("PECI_PHONE_CODE","H");
					phoneRecord.put("PHONE_CODE","MA");
					phoneRecord.put("PHONE_STATUS_IND","A");
					phoneRecord.put("PHONE_NUMBER",intData.getField(11));
					phoneRecord.put("PHONE_AREA_CODE",intData.getField(27));
					phoneRecord.put("PHONE_NUMBER_INTL",intData.getField(28));
					if (intData.getField(31).equals("null")) {
						phoneRecord.put("PHONE_SEQUENCE_NO","");
					}else {
						phoneRecord.put("PHONE_SEQUENCE_NO",intData.getField(31));
					}
					log.debug("Home: " + phoneRecord);
					phoneDataIn.add(new HashMap<String,Object>(phoneRecord));
					phoneRecord.clear();
				}
				
				if (intData.getField(15) != null){
					SQL="Update  cc_gen_peci_phone_data_t set CHANGE_COLS = 'DELETE' where STUDENT_PIDM=:STUDENT_PIDM and PECI_PHONE_CODE='C' and PARENT_PPID='0'";
					jdbcCAS.update(SQL,PECIParameters);
					intData.setField(13,"");
					intData.setField(24,"");
				}
				
				//Mobile Phone
				if (intData.getField(13) != "" || intData.getField(24) != "") {		
					phoneRecord.put("PECI_PHONE_CODE","C");
					phoneRecord.put("PHONE_CODE","CP");
					phoneRecord.put("PHONE_STATUS_IND","A");
					phoneRecord.put("PHONE_NUMBER",intData.getField(13));
					phoneRecord.put("PHONE_AREA_CODE",intData.getField(23));
					phoneRecord.put("PHONE_NUMBER_INTL",intData.getField(24));
					phoneRecord.put("CELL_PHONE_CARRIER",intData.getField(14));
					if (intData.getField(32).equals("null")) {
						phoneRecord.put("PHONE_SEQUENCE_NO","");
					}else {
						phoneRecord.put("PHONE_SEQUENCE_NO",intData.getField(32));
					}
					log.debug("Mobile: " + phoneRecord);
					phoneDataIn.add(new HashMap<String,Object>(phoneRecord));
					phoneRecord.clear();
				}	

				//Emergency Phone
				if (intData.getField(16) != "" || intData.getField(30) != "") {		
					phoneRecord.put("PECI_PHONE_CODE","E");
					phoneRecord.put("PHONE_CODE","EP");
					phoneRecord.put("PHONE_STATUS_IND","A");
					phoneRecord.put("PHONE_NUMBER",intData.getField(16));
					phoneRecord.put("PHONE_AREA_CODE",intData.getField(29));
					phoneRecord.put("PHONE_NUMBER_INTL",intData.getField(30));
					if (intData.getField(34).equals("null")) {
						phoneRecord.put("PHONE_SEQUENCE_NO","");
					}else {
						phoneRecord.put("PHONE_SEQUENCE_NO",intData.getField(34));
					}
					log.debug("Emergency: " + phoneRecord);
					phoneDataIn.add(new HashMap<String,Object>(phoneRecord));
					phoneRecord.clear();
				} else if (intData.getField(13) != "" || intData.getField(24) != "") {
					phoneRecord.put("PECI_PHONE_CODE","E");
					phoneRecord.put("PHONE_CODE","EP");
					phoneRecord.put("PHONE_STATUS_IND","A");
					phoneRecord.put("PHONE_NUMBER",intData.getField(13));
					phoneRecord.put("PHONE_AREA_CODE",intData.getField(23));
					phoneRecord.put("PHONE_NUMBER_INTL",intData.getField(24));
					phoneRecord.put("CELL_PHONE_CARRIER",intData.getField(14));
					if (intData.getField(32).equals("null")) {
						phoneRecord.put("PHONE_SEQUENCE_NO","");
					}else {
						phoneRecord.put("PHONE_SEQUENCE_NO",intData.getField(32));
					}
					log.debug("Mobile as EP: " + phoneRecord);
					phoneDataIn.add(new HashMap<String,Object>(phoneRecord));
					phoneRecord.clear();
				}
				
				try {
					log.debug("Phones: " + phoneDataIn);
					PECIResource.phoneUpdate(phoneDataIn,phoneData,PECIParameters, jdbcCAS);
				} catch (Exception e){
					log.warn ("Student Phone save failed.");
				}
				
				if (intData.getField(15) == null){
					studentDataIn.put("EMERG_NO_CELL_PHONE","N");
				}else {
					studentDataIn.put("EMERG_NO_CELL_PHONE","Y");
				}
				if (intData.getField(17) == null){
					studentDataIn.put("EMERG_SEND_TEXT","N");
				}else {
					studentDataIn.put("EMERG_SEND_TEXT","Y");
				}	
				if (intData.getField(18) == null){
					studentDataIn.put("EMERG_PHONE_TTY_DEVICE","N");
				}else {
					studentDataIn.put("EMERG_PHONE_TTY_DEVICE","Y");
				}
				
				updates = compareMap(studentDataIn,studentData);
				Map<String, Object> sourceData = new HashMap<String, Object>();
				SQL="select CHANGE_COLS from cc_stu_peci_students_t where STUDENT_PIDM=:STUDENT_PIDM";
				sourceData = jdbcCAS.queryForMap(SQL,PECIParameters);
				String changeCol = (String) sourceData.get("CHANGE_COLS");
				if (changeCol == null) changeCol="";
				SQL = "UPDATE cc_stu_peci_students_t SET ";
				List<String> columns = new ArrayList(updates.keySet());
				for(int i=0; i<columns.size(); i++) { 
			        String key = columns.get(i);
			        Object newValue = updates.get(key);
			        SQL = SQL + key +" = '" +  newValue + "', ";
			        changeCol = changeCol + key + ",";
			    } 
				SQL = SQL + "CHANGE_COLS = '" + changeCol +"'";
				SQL = SQL + " where STUDENT_PIDM=:STUDENT_PIDM";
				jdbcCAS.update(SQL,PECIParameters);
				
				
				String EMERG_ORDER = intData.getField(26);
				log.debug ("EMERG_ORDER: " + EMERG_ORDER);
				
				if (EMERG_ORDER != null) {
					String[] eOrder = EMERG_ORDER.toString().split(",");
					
					Map<String,Object> emergData = new HashMap<String,Object>();
					Map<String,Object> emergDataIn = new HashMap<String,Object>();
					for(int i=0; i< eOrder.length; i++) {
						PECIParameters.put("PARENT_PPID", eOrder[i]);

						log.debug ("Contact Priority: " + eOrder[i] + " is " + i);
						try {
						//Emergency Contacts
							SQL="select PARENT_PPID, EMERG_CONTACT_PRIORITY, EMERG_LEGAL_PREFIX_NAME, EMERG_PREF_FIRST_NAME,EMERG_PREF_MIDDLE_NAME,EMERG_PREF_LAST_NAME, EMERG_LEGAL_SUFFIX_NAME from cc_gen_peci_emergs_t where (CHANGE_COLS !='DELETE' or  CHANGE_COLS is null) and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID=:PARENT_PPID order by EMERG_CONTACT_PRIORITY";
							emergData = jdbcCAS.queryForMap(SQL,PECIParameters);
						} catch (EmptyResultDataAccessException e){
							// dataset empty 
						}
						emergDataIn.put("EMERG_CONTACT_PRIORITY", i+1);

						log.debug ("emergDataIn: " + emergDataIn);
						updates = compareMap(emergDataIn,emergData);
						log.debug ("updates: " + updates);
						PECIResource.writeUpdates(PECIParameters,updates,"cc_gen_peci_emergs_t", jdbcCAS);
						
					}
				}
				
				
				String PHONE_ORDER = intData.getField(25);
				
				SQL= "DELETE FROM cc_gen_peci_phone_data_t where PHONE_CODE Like 'EP_' and STUDENT_PIDM=:STUDENT_PIDM";
				jdbcCAS.update(SQL,PECIParameters);
				
				if (PHONE_ORDER != null) {
					String[] pOrder = PHONE_ORDER.toString().split(",");
					for(int i=0; i< pOrder.length; i++) {
						int e = i+1;
						PECIParameters.put("Phone_Num", pOrder[i]);
						SQL="insert into cas.cc_gen_peci_phone_data_t (STUDENT_PIDM, PARENT_PPID, PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL)"
							+"	select distinct STUDENT_PIDM, '0' PARENT_PPID, 'E' PECI_PHONE_CODE, 'EP" + e + "' PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL from cc_gen_peci_phone_data_t phone"
							+"	where concat_ws('', phone.PHONE_AREA_CODE, phone.PHONE_NUMBER, phone.PHONE_NUMBER_INTL)=:Phone_Num"
							+"	and STUDENT_PIDM = :STUDENT_PIDM";
						jdbcCAS.update(SQL,PECIParameters);
					}
				}	
				
				
				context.getFlowScope().put("Flag","PECIC");
			}
			
			return "Failed";
			
		}
		log.debug("Writeflow completed successfully, returning saved.");
		return "Saved";
	}

	void copy2MySQL(String tableName, List<Map<String,Object>> sourceData) 
			throws Exception{
		//Cycle through the rows and send to MySQL
		for (int i=0; i< sourceData.size(); i++){
			Map<String,Object> row = sourceData.get(i);
			copy2MySQL(tableName,row);
		}
		
	}
	
	void copy2MySQL(String tableName, Map<String,Object> sourceData) 
			throws Exception{
		//log.debug("Source data to copy to MySQL" + sourceData.toString());
		String sql = "insert into " + tableName + "(" + sourceData.keySet().toString().replace('[',' ').replace(']',' ') + ") values (";
		List<String> columns = new ArrayList(sourceData.keySet());
		for(int i=0; i<sourceData.size(); i++){
			
			sql = sql +":"+columns.get(i);
			if (i < sourceData.size() - 1 ){
				sql = sql + ", ";
			}
		}
		sql = sql + ")";
		//log.debug(sql);
		Map<String,Object> namedParameters = new HashMap<String,Object>();
		for(int i=0; i<columns.size(); i++){
			if (columns.get(i).equals("PARENT_PPID") && (sourceData.get(columns.get(i)) == null)) {
				sourceData.put(columns.get(i),0);
			}
			if (sourceData.get(columns.get(i)) != null){
				//log.debug ("Passing "+ columns.get(i).toString() + " = " + sourceData.get(columns.get(i)).toString());
				namedParameters.put(columns.get(i).toString(), sourceData.get(columns.get(i)).toString());
			} else {
				//log.debug ("Passing "+ columns.get(i).toString() + " is null ");
				namedParameters.put(columns.get(i).toString(), null);
			}
		}
		//log.debug("inserting");
		jdbcCAS.update(sql,namedParameters);
	}
	
	public void loadPECIOptions(RequestContext context)
			throws Exception {
		String SQL;
		Map<String,Map<String,Object>> options = new LinkedHashMap<String,Map<String,Object>>();
		List<Map<String,Object>> rows;
		//Countries
		SQL = "select stvnatn_code key, stvnatn_nation value from saturn.stvnatn where stvnatn_nation not like '%DONOT USE%' order by value";
		rows = jdbcCensus.queryForList(SQL);
		options.put ("Countries",new LinkedHashMap<String,Object>());
		options.get("Countries").put("US","United States");
		for (Map<String,Object> row : rows){
			options.get("Countries").put(row.get("key").toString(),row.get("value"));
		}
		
		//States
		SQL = "select stvstat_code key, stvstat_desc value ,"
			+ " CASE WHEN stvstat_code in ('AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY','AS','GU','MP','PR','VI') THEN 1  ELSE 0 END US "
			+ " from saturn.stvstat  order by value";
		rows = jdbcCensus.queryForList(SQL);
		options.put ("States",new LinkedHashMap<String,Object>());
		options.put ("Regions",new LinkedHashMap<String,Object>());
		for (Map<String,Object> row : rows){
			if (row.get("US").toString().equals("1")) {
				options.get("States").put(row.get("key").toString(),row.get("value"));
			}else{
				options.get("Regions").put(row.get("key").toString(),row.get("value"));
			}
		}
		
		//Carriers
		SQL = "select vendor_code key, vendor_desc value from peci.cc_gen_peci_phone_carriers where PECI_ENABLED = 'Y' order by display_order";
		rows = jdbcCensus.queryForList(SQL);
		options.put ("Carriers",new LinkedHashMap<String,Object>());
		for (Map<String,Object> row : rows){
			options.get("Carriers").put(row.get("key").toString(),row.get("value"));
		}
		
		//Relationships
		SQL = "select peci_relt_code key, peci_relt_desc value from cc_gen_peci_relt_val_codes where peci_enabled = 'Y' order by peci_display_order";
		rows = jdbcCensus.queryForList(SQL);
		options.put ("Relationships",new LinkedHashMap<String,Object>());
		for (Map<String,Object> row : rows){
			options.get("Relationships").put(row.get("key").toString(),row.get("value"));
		}
		
		context.getFlowScope().put("options", options);
	}
	
	public boolean setPassword (final RequestContext context, String userName, String newPass, boolean setAD)
			throws Exception{
		return setPassword (context,userName,newPass,setAD, true);
	}
	public boolean setPassword( String userName, String newPass, boolean setAD, boolean enforce ) 
			throws Exception {
		return this.setPassword(null, userName, newPass, setAD, enforce);
	}
	public boolean setPassword (final RequestContext context, String userName, String newPass, boolean setAD, boolean enforce)
			throws Exception{
		String searchFilter = LdapUtils.getFilterWithValues(this.filter, userName);
		String vaultSearchFilter = LdapUtils.getFilterWithValues(this.vaultFilter, userName);
		
		this.restfulResponse = new RestfulResponse();
		


		boolean inVault = false;
		boolean inAD = false;
		List vaultDN = Collections.emptyList(); 
		List DN = Collections.emptyList();
		
		log.debug("Finding user in Vault");
		try {
			vaultDN = this.vaultTemplate.search(
				this.vaultSearchBase, vaultSearchFilter, 
				new AbstractContextMapper(){
					protected Object doMapFromContext(DirContextOperations ctx) {
						return ctx.getNameInNamespace();
					}
				}
			);
		} catch (Exception e){
			log.error("Error finding user in vault: " + e.getMessage());
			vaultDN = Collections.emptyList();
		}

		log.debug("Finding user in AD");
		try {
			DN= this.ldapTemplate.search(
				this.searchBase, searchFilter, 
				new AbstractContextMapper(){
					protected Object doMapFromContext(DirContextOperations ctx) {
						return ctx.getNameInNamespace();
					}
				}
			);
		} catch (Exception e){
			log.error("Error finding user in AD: " + e.getMessage());
			DN = Collections.emptyList();
		}
		
		
		if ( !vaultDN.isEmpty() ) {
			log.debug( "User was found in vault (username: " + userName + ")" );
			inVault = true;
		}else{
			log.debug( "User was NOT found in vault (username: " + userName + ")" );
		}
		
		if ( !DN.isEmpty() ) {
			log.debug( "User was found in AD (username: " + userName + ")" );
			inAD = true;
		}else{
			log.debug( "User was NOT found in AD (username: " + userName + ")" );
		}
		
		DirContextOperations ldapcontext = null;
		DirContextOperations vaultcontext = null;
		
		String Attrib = "";
		if ( !inAD && !inVault ) {
			log.debug("User not in AD or vault. Defaults used for mail domain.");
			this.restfulResponse.addMessage("User was not in AD or the Vault.");
			return false;
		} else if ( inVault ) {
			log.debug( "User found in vault. Mail domain pulled from ccMailDom attribute." );
			vaultcontext = vaultTemplate.lookupContext( vaultDN.get(0).toString() );
			Attrib = vaultcontext.getStringAttribute("ccMailDom");
		} else if ( inAD ) {
			log.debug( "User was not found in the vault but exists in AD. Mail domain pulled from extensionAttribute14.");
			ldapcontext = ldapTemplate.lookupContext( DN.get(0).toString() );
			Attrib = ldapcontext.getStringAttribute("extensionAttribute14");
		}
		
		
		String domain;
		if ( Attrib != null ){
			if (Attrib.equals("alumni")) {
				domain = "alumni.conncoll.edu";
			} else {
				domain  = "conncoll.edu";
			} 
		}else{
			domain  = "conncoll.edu";
		}
		
		if ( setAD && inAD ){
			log.debug("Setting AD Password");
			ModificationItem[] mods = new ModificationItem[1];
			
			String newQuotedPassword = "\"" + newPass + "\"";
			byte[] newUnicodePassword = newQuotedPassword.getBytes("UTF-16LE");
	
			mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("unicodePwd", newUnicodePassword));

			// Set password history enforcement hint
			LdapContext dctx = (LdapContext)ldapTemplate.getContextSource().getReadWriteContext();
			if (enforce) {
				final byte[] controlData = {48,(byte)132,0,0,0,3,2,1,1};
				BasicControl[] controls = new BasicControl[1];
				String LDAP_SERVER_POLICY_HINTS_OID;
				if (this.adVersion.equals("2008")) {
					log.debug ("Setting the 2008 password enfocement hint");
					LDAP_SERVER_POLICY_HINTS_OID = "1.2.840.113556.1.4.2066";
				} else {
					log.debug ("Setting the 2012 password enfocement hint");
					LDAP_SERVER_POLICY_HINTS_OID = "1.2.840.113556.1.4.2239";
				}
				controls[0] = new BasicControl(LDAP_SERVER_POLICY_HINTS_OID, true, controlData);
				dctx.setRequestControls(controls);
			}
			
			try {
				// Change password
				log.debug ("Performing the password change");
				log.debug("Context environment: "+dctx.getEnvironment());
				dctx.modifyAttributes(DN.get(0).toString(),mods);
				this.restfulResponse.addMessage("AD password successfully changed.");
			}catch( Exception e){
				log.warn("Password reset failed at AD");
				log.warn(e.getMessage());
				if ( context != null ) {
					context.getFlowScope().put("ErrorMsg", "Password rejected by server, please ensure your password meets all the listed criteria.");
				} else {
					this.restfulResponse.addMessage("Password rejected by server, please ensure your password meets all the listed criteria.");
				}
				dctx.close();
				return false;
			}
			dctx.close();
		} else if ( setAD && !inAD) {
			this.restfulResponse.addMessage("Password not set in AD. User not found.");
		//} else if ( !setAD && inAD ) {
		//	this.restfulResponse.addMessage("Password not set in AD per user request.");
		} else if (!setAD) {
			this.restfulResponse.addMessage("Password not set in AD per user request.");
	
			ModificationItem[] mods = new ModificationItem[1];
			
			mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("userPassword", newPass));
	
			if ( inVault ) {
				log.debug("Setting Vault Password");
				try {
					vaultTemplate.modifyAttributes(vaultDN.get(0).toString(),mods);
					this.restfulResponse.addMessage("Vault password successfully changed.");
				}catch( Exception e){
					log.warn("Password reset failed at Vault");
					if ( context != null ) {
						context.getFlowScope().put("ErrorMsg", "Password rejected by server, please ensure your password meets all the listed criteria.");
					} else {
						this.restfulResponse.addMessage("Password rejected by server, please ensure your password meets all the listed criteria.");
					}
					return false;
				}
			} else {
				this.restfulResponse.addMessage("Password not set in vault. User not found.");
			}
			if (this.gmSync != false) {
	
				log.debug("Setting gMail Password");
				log.debug("Connecting to google with user: " + this.mainUsername + " Password: " + this.mainPassword + " domain: " + domain);
	
				
				httpTransport = GoogleNetHttpTransport.newTrustedTransport();
				
				
				// service account credential
				GoogleCredential credential = new GoogleCredential.Builder().setTransport(httpTransport)
					.setJsonFactory(JSON_FACTORY)
					.setServiceAccountId(SERVICE_ACCOUNT_EMAIL)
					.setServiceAccountScopes(Collections.singleton(DirectoryScopes.ADMIN_DIRECTORY_USER))
					.setServiceAccountPrivateKeyFromP12File(new File("/home/tomcat/CASCfg/GoogleAPI-key.p12"))
					.setServiceAccountUser( "atilling@conncoll.edu" )
					.build();
				
				// Directory Connection
				Directory directory = new Directory.Builder(httpTransport, JSON_FACTORY, credential)
					.setApplicationName(APPLICATION_NAME)
					.build();
				
				try {
					Directory.Users.List request = directory.users().list();
					request.setDomain("conncoll.edu");
					request.setQuery("email:" + userName + "@conncoll.edu");
					
					List<User> users = request.execute().getUsers();
					User user = users.get(0);
					user = user.setAgreedToTerms(true);
					user = user.setChangePasswordAtNextLogin(false);
					user = user.setPassword(newPass);
					directory.users().update(user.getId(),user).execute();
					this.restfulResponse.addMessage("Gmail password successfully changed.");
				} catch (Exception e) {
					log.info("Password reset failed at google");
					this.restfulResponse.addMessage("Password reset failed at google");
					// No Google account					 
				}		
			}	
				
			log.debug("Saving Aduit trail");
			String SQL = "insert cc_user_password_history (date,uid,ip,adminid) (select getdate() date, id uid, 'CAS Services' ip, id adminid from cc_user where email=:user) ";
	
			SqlParameterSource namedParameters = new MapSqlParameterSource("user", userName + "@conncoll.edu");
			int check = jdbcTemplate.update(SQL,namedParameters);
			log.debug("Insert result " + check);
		}
		return true;
	}	
	
	
	public Map<String,Object> getUUID( String uuid ) {
		UUIDRead uuidRead  = new UUIDRead(this.dataSource);
		return uuidRead.execute(uuid);
	}
	
	public Map<String,Object> removeUUID( String uuid ) {
		UUIDRemove uuidRemove = new UUIDRemove(this.dataSource);
		return uuidRemove.execute(uuid);
	}
	
	public final String setPWD(){
		return "PWD";
	}

    public final void setDataSource(final DataSource dataSource) {
        this.jdbcTemplate = new NamedParameterJdbcTemplate(dataSource);
        this.dataSource = dataSource;
    }

    public final void setCensusSource(final DataSource dataSource) {
        this.jdbcCensus = new JdbcTemplate(dataSource);
        this.censusSource = dataSource;
    }

    public final void setBlackBSource(final DataSource dataSource) {
        this.jdbcBlackB = new JdbcTemplate(dataSource);
        this.BlackBSource = dataSource;
    }

    public final void setCASSource(final DataSource dataSource) {
        this.jdbcCAS = new NamedParameterJdbcTemplate(dataSource);
        this.CASSource = dataSource;
    }
    
    protected final NamedParameterJdbcTemplate getJdbcTemplate() {
        return this.jdbcTemplate;
    }
    
    protected final DataSource getDataSource() {
        return this.dataSource;
    }
    
    protected final DataSource getCensusSource() {
        return this.censusSource;
    }
    
    protected final DataSource getBlackBSource() {
        return this.BlackBSource;
    }	
    
    public final DataSource getCASSource() {
        return this.CASSource;
    }
		
	public void setsearchBase (final String searchBase) {
		this.searchBase = searchBase;
	}
	
	public void setVaultSearchBase (final String vaultSearchBase) {
		this.vaultSearchBase = vaultSearchBase;
	}
	
	public void setrecaptchaPublic (final String recaptchaPublic) {
		this.recaptchaPublic = recaptchaPublic;
	}
	
	public void setrecaptchaPrivate (final String recaptchaPrivate) {
		this.recaptchaPrivate = recaptchaPrivate	;
	}
		
	public void setMainUsername (final String mainUsername) {
		this.mainUsername = mainUsername;
	}
		
	public void setMainPassword (final String mainPassword) {
		this.mainPassword = mainPassword;
	}
	
	public void setNuVisionPath (final String nuVisionPath) {
		this.nuVisionPath = nuVisionPath;
	}
	
	public void setldapTemplate(final LdapTemplate ldapTemplate){
		this.ldapTemplate=ldapTemplate;	
	}
	
	public void setVaultTemplate(final LdapTemplate vaultTemplate){
		this.vaultTemplate=vaultTemplate;	
	}
	
	public void setFilter (final String filter) {
		this.filter = filter;
	}
	
	public void setGmSync (final Boolean gmsync) {
		this.gmSync = gmsync;
	}
	
	public void setAdVersion (final String adVersion) {
		this.adVersion = adVersion;
		log.debug ("ADVersion: " + this.adVersion);
	}
	
	public void setVaultFilter (final String vaultFilter) {
		this.vaultFilter = vaultFilter;
	}
	
	/**
	 * added to handle password reset error messages outside of a webflow
	 * @author mmatovic
	 */
	public class RestfulResponse {
		@Deprecated
		private String ErrMessage;
		private ArrayList<String> Messages;
		
		protected RestfulResponse(){
			this.ErrMessage = "";
			this.Messages = new ArrayList<String>();
		}
		@Deprecated
		protected RestfulResponse(String ErrMessage) {
			this.ErrMessage = ErrMessage;
		}
		
		protected void addMessage(String Message) {
			this.Messages.add(Message);
		}
		
		public ArrayList<String> getMessages() {
			return this.Messages;
		}
		@Deprecated
		public String getErrMessage() {
			return this.ErrMessage;
		}
	}
	
	@Deprecated
	private void setRestfulResponse( String ErrMessage ) {
		this.restfulResponse = new RestfulResponse(ErrMessage);
	}
	
	public RestfulResponse getRestfulResponse() {
		return this.restfulResponse;
	}
	
	private class EMRRead extends StoredProcedure{
		public EMRRead(DataSource dataSource) {
			super(dataSource, "EMR_FormRead");
			declareParameter(new SqlParameter("BannerID", Types.VARCHAR));
			declareParameter(new SqlParameter("CCUserID", Types.INTEGER ));
			declareParameter(new SqlOutParameter("Admin", Types.BIT));
			declareParameter(new SqlReturnResultSet("emrData", new RowMapper() {
				public Map<String,Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map<String,Object> emrData = new HashMap<String,Object>();
					emrData.put("EmrId",rs.getInt(1));
					emrData.put("ContactType",rs.getString(2));
					emrData.put("toEmail",rs.getString(3));
					emrData.put("AltEmail",rs.getString(4));
					emrData.put("Language",rs.getString(5));
					emrData.put("SmsVendor",rs.getInt(6));
					emrData.put("Tty",rs.getString(7));
					// add more mappings here
					return emrData;
				}
			}));
        	declareParameter(new SqlReturnResultSet("ccData", new RowMapper() {
				public Map<String,Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map<String,Object> ccData = new HashMap<String,Object>();
					ccData.put("FirstName",rs.getString(1));
					ccData.put("LastName",rs.getString(2));
					ccData.put("CollegePhone",rs.getString(3));
					ccData.put("Email",rs.getString(4));
					ccData.put("CcId",rs.getString(5));
					// add more mappings here
					return ccData;
				}
			}));
        	declareParameter(new SqlReturnResultSet("Phones", new RowMapper() {
				public Map<String,Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map<String,Object> Phones = new HashMap<String,Object>();
					Phones.put("PhoneCode",rs.getString(1));
					Phones.put("AreaCode",rs.getInt(2));
					Phones.put("PhoneNum",rs.getString(3));
					Phones.put("phoneType",rs.getString(4));
					Phones.put("ContactName",rs.getString(5));
					Phones.put("ContactRelation",rs.getString(6));
					// add more mappings here
					return Phones;
				}
			}));
        	declareParameter(new SqlReturnResultSet("Relations", new RowMapper() {
				public Map<String,Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map<String,Object> Relations = new HashMap<String,Object>();
					Relations.put("ContactRelation",rs.getInt(1));
					Relations.put("Relationship",rs.getString(2));
					// add more mappings here
					return Relations;
				}
			}));
        	declareParameter(new SqlReturnResultSet("SMSVendors", new RowMapper() {
				public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map<String,Object> SMSVendors = new HashMap<String,Object>();
					SMSVendors.put("SMSVendor",rs.getInt(1));
					SMSVendors.put("VendorName",rs.getString(2));
					// add more mappings here
					return SMSVendors;
				}
			}));
        	declareParameter(new SqlReturnResultSet("ListAddresses", new RowMapper() {
				public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map <String,Object>ListAddresses = new HashMap<String,Object>();
					ListAddresses.put("emailnum",rs.getInt(1));
					ListAddresses.put("emailaddress",rs.getString(2));
					// add more mappings here
					return ListAddresses;
				}
			}));
			compile();
		}
		public Map<String,Object> execute(String bannerId, int ccUserId, int admin) {        
			Map<String,Object> inputs = new HashMap<String,Object>();
        	inputs.put("BannerID", bannerId);
        	inputs.put("CCUserID", ccUserId);
        	inputs.put("Admin", admin);
            return super.execute(inputs);
        }
	}
	
	private class FormSave extends StoredProcedure{
		public FormSave(DataSource dataSource) {
			super(dataSource, "EMR_FormSave");
			declareParameter(new SqlParameter("BannerID", Types.VARCHAR));
			declareParameter(new SqlParameter("CCUserID", Types.INTEGER ));
			declareParameter(new SqlParameter("AltEmail", Types.VARCHAR));
			declareParameter(new SqlParameter("OEMail", Types.VARCHAR));
			declareParameter(new SqlParameter("ContactType", Types.VARCHAR));
			declareParameter(new SqlParameter("Language", Types.VARCHAR));
			declareParameter(new SqlParameter("SMSVendor", Types.INTEGER));
			declareParameter(new SqlParameter("TTY", Types.VARCHAR));
			declareParameter(new SqlOutParameter("EMRID", Types.INTEGER));
			compile();
		}
		public Map<String,Object> execute(String bannerId, int ccUserId, String AltEmail, String OEMail, String ContactType, String Language, Integer SMSVendor, char TTY) {
			Map<String,Object> inputs = new HashMap<String,Object>();
        	inputs.put("BannerID", bannerId);
        	inputs.put("CCUserID", ccUserId);
        	inputs.put("AltEmail", AltEmail);
        	inputs.put("OEMail", OEMail);
        	inputs.put("ContactType", ContactType);
        	inputs.put("Language", Language);
        	inputs.put("SMSVendor", SMSVendor);
        	inputs.put("TTY", TTY);
        	inputs.put("EMRID", 0);
            return super.execute(inputs);
        }
	}
	
	private class PhoneSave extends StoredProcedure{
		public PhoneSave(DataSource dataSource) {
			super(dataSource, "EMR_PhoneSave");
			declareParameter(new SqlParameter("EMRID", Types.INTEGER));
			declareParameter(new SqlParameter("PhoneCode", Types.VARCHAR ));
			declareParameter(new SqlParameter("AreaCode", Types.INTEGER ));
			declareParameter(new SqlParameter("PhoneNum", Types.VARCHAR ));
			declareParameter(new SqlParameter("PhoneType", Types.VARCHAR ));
			declareParameter(new SqlParameter("ContactName", Types.NVARCHAR ));
			declareParameter(new SqlParameter("ContactRelation", Types.INTEGER ));
			compile();
		}
		public Map<String,Object> execute(int EMRID, char PID, int AreaCode, String Phone, char pType, String Name, int Rela) {
			Map<String,Object> inputs = new HashMap<String,Object>();
        	inputs.put("EMRID", EMRID);
        	inputs.put("PhoneCode", PID);
        	inputs.put("AreaCode", AreaCode);
        	inputs.put("PhoneNum", Phone);
        	inputs.put("PhoneType", pType);
        	inputs.put("ContactName", Name);
        	inputs.put("ContactRelation", Rela);
            return super.execute(inputs);
        }
	}
	
	private class UUIDRead extends StoredProcedure {
		public UUIDRead( DataSource dataSource ) {
			super(dataSource, "CAS_UUIDRead");
			declareParameter(new SqlParameter("uid", Types.VARCHAR) );
			declareParameter(new SqlReturnResultSet("resetCheckData", new RowMapper(){
				public Map<String,Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map<String,Object> resetCheckData = new HashMap<String,Object>();
					resetCheckData.put("ResetUID", rs.getObject(1));
					resetCheckData.put("AdminUser", rs.getObject(2));
					return resetCheckData;
				}
			}));
			compile();
		}
		public Map<String,Object> execute(String uuid) {
			Map<String,Object> inputs = new HashMap<String,Object>();
			inputs.put("uid", uuid);
			return super.execute(inputs);
		}
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
			        if ( origValue.getClass().getName().equals("java.lang.String") || origValue.getClass().getName().equals("java.lang.Integer")) {
		        		if (!(origValue.equals(testValue))){
		    	        	map.put(key,testValue);
		        		}
		        	}
        		} else if ( testValue != null) {
	        		map.put(key,testValue);
	        	} 
	        }
	    }    
	    return map;   
	}
	
	
	private class UUIDRemove extends StoredProcedure {
		public UUIDRemove( DataSource dataSource ) {
			super(dataSource, "CAS_UUIDRemove");
			declareParameter(new SqlParameter("uid", Types.VARCHAR));
			declareParameter(new SqlReturnResultSet("resetRemoveData", new RowMapper(){
				public Map<String,Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
					Map<String,Object> resetRemoveData = new HashMap<String,Object>();
					resetRemoveData.put("rows_deleted", rs.getObject(1));
					return resetRemoveData;
				}
			}));
			compile();
		}
		public Map<String,Object> execute(String uuid) {
			Map<String,Object> inputs = new HashMap<String,Object>();
			inputs.put("uid", uuid);
			return super.execute(inputs);
		}
	}
	
	public static boolean isInteger(String s) {
	    try { 
	        Integer.parseInt(s); 
	    } catch(NumberFormatException e) { 
	        return false; 
	    } catch(NullPointerException e) {
	        return false;
	    }
	    // only got here if we didn't return false
	    return true;
	}
	
	public void PECI2Banner(String userName, String ccPDIM, String mode){

		Map out;
		String error;
		String SQL;
		MapSqlParameterSource in;
		
		Map<String,Object> PECIParameters = new HashMap<String,Object>();
		
		Map<String,Object> studentData = new HashMap<String,Object>();
		Map<String,Object> addressData = new HashMap<String,Object>();
		Map<String,Object> emailData = new HashMap<String,Object>();
		List<Map<String,Object>> parentData = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> phoneData = new ArrayList<Map<String,Object>>();
		
		SimpleJdbcCall f_cc_generate_trans_id = new SimpleJdbcCall(this.censusSource)
			.withFunctionName("f_cc_generate_trans_id");
		f_cc_generate_trans_id.setAccessCallParameterMetaData(false);
		f_cc_generate_trans_id.declareParameters(
			new SqlOutParameter("RETURN", Types.INTEGER),
			new SqlParameter("p_peciUserId", Types.VARCHAR));
		
		SimpleJdbcCall p_student_main = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_crud_student_pkg")
			.withProcedureName("p_student_main");
		p_student_main.setAccessCallParameterMetaData(false);
		p_student_main.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),
			new SqlParameter("p_peciRole", Types.VARCHAR),
			new SqlParameter("p_pidm", Types.NUMERIC),
			new SqlParameter("p_ppid", Types.NUMERIC),
			new SqlParameter("p_peciLegalDisc", Types.DATE),
			new SqlParameter("p_peciDeanExcept", Types.DATE),
			new SqlParameter("p_noCellPhone", Types.VARCHAR),
			new SqlParameter("p_emergAutoOptout", Types.VARCHAR),
			new SqlParameter("p_emergSendText", Types.VARCHAR),
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),
			new SqlOutParameter("p_peciStudentPpidOut", Types.INTEGER),
			new SqlOutParameter("p_peciStudentPidmOut", Types.INTEGER),
			new SqlOutParameter("p_peciLegalDiscOut", Types.DATE),
			new SqlOutParameter("p_peciDeanExceptOut", Types.DATE),
			new SqlOutParameter("p_noCellPhoneOut", Types.VARCHAR),
			new SqlOutParameter("p_emergAutoOptoutOut", Types.VARCHAR),
			new SqlOutParameter("p_emergSendTextOut", Types.VARCHAR),
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR));	
		
		SimpleJdbcCall p_email_main = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_crud_email_pkg")
			.withProcedureName("p_email_main");
		p_email_main.setAccessCallParameterMetaData(false);
		p_email_main.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),
			new SqlParameter("p_peciRole", Types.VARCHAR),
			
			new SqlParameter("p_peciEmailCode", Types.VARCHAR),
			
			new SqlParameter("p_pidm", Types.NUMERIC),
			new SqlParameter("p_ppid", Types.NUMERIC),
			
			new SqlParameter("p_peciEmailAddr", Types.VARCHAR),
			
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),
			
			new SqlOutParameter("p_peciEmailAddrOut", Types.VARCHAR),
			new SqlOutParameter("p_peciEmailAddrStatusOut", Types.VARCHAR),
			new SqlOutParameter("p_peciEmailAddrPrefOut", Types.VARCHAR),
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR));
		
		SimpleJdbcCall p_address_main = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_crud_address_pkg")
			.withProcedureName("p_address_main");
		p_address_main.setAccessCallParameterMetaData(false);
		p_address_main.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),
			new SqlParameter("p_peciRole", Types.VARCHAR),
			
			new SqlParameter("p_peciAddCode", Types.VARCHAR),
			
			new SqlParameter("p_pidm", Types.NUMERIC),
			new SqlParameter("p_ppid", Types.NUMERIC),

			new SqlParameter("p_banAddrSeqno", Types.NUMERIC),
			new SqlParameter("p_peciAddrStreetLine1", Types.VARCHAR),
			new SqlParameter("p_peciAddrStreetLine2", Types.VARCHAR),
			new SqlParameter("p_peciAddrStreetLine3", Types.VARCHAR),
			new SqlParameter("p_peciAddrCity", Types.VARCHAR),
			new SqlParameter("p_peciAddrStateCode", Types.VARCHAR),
			new SqlParameter("p_peciAddrZipCode", Types.VARCHAR),
			new SqlParameter("p_peciAddrNatnCode", Types.VARCHAR),
			
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),
			
			new SqlOutParameter("p_peciAddrStreetLine1Out", Types.VARCHAR),
			new SqlOutParameter("p_peciAddrStreetLine2Out", Types.VARCHAR),
			new SqlOutParameter("p_peciAddrStreetLine3Out", Types.VARCHAR),
			new SqlOutParameter("p_peciAddrCityOut", Types.VARCHAR),
			new SqlOutParameter("p_peciAddrStateCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_peciAddrZipCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_peciAddrNatnCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_peciAddrStatusOut", Types.VARCHAR),
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR));

		SimpleJdbcCall p_phone_main = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_crud_phone_pkg")
			.withProcedureName("p_phone_main");
		p_phone_main.setAccessCallParameterMetaData(false);
		p_phone_main.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),
			new SqlParameter("p_peciRole", Types.VARCHAR),
			
			new SqlParameter("p_peciPhoneCode", Types.VARCHAR),
			
			new SqlParameter("p_pidm", Types.NUMERIC),
			new SqlParameter("p_ppid", Types.NUMERIC),
			
			new SqlParameter("p_banTeleSeqno", Types.NUMERIC),
			new SqlParameter("p_peciPhoneArea", Types.VARCHAR),
			new SqlParameter("p_peciPhoneNumber", Types.VARCHAR),
			new SqlParameter("p_peciPhoneIntl", Types.VARCHAR),
			new SqlParameter("p_peciPhoneStatus", Types.VARCHAR),
			new SqlParameter("p_peciPhonePrimary", Types.VARCHAR),
			new SqlParameter("p_peciCellPhoneCarrier", Types.VARCHAR),
			new SqlParameter("p_peciPhoneTtyDevice", Types.VARCHAR),
			new SqlParameter("p_banComment", Types.VARCHAR),
			new SqlParameter("p_peciEmergPriority", Types.NUMERIC),
			
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),
			
			new SqlOutParameter("p_peciPhoneAreaOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhoneNumberOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhoneIntlOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhoneStatusOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhonePrimaryOut", Types.VARCHAR),
			new SqlOutParameter("p_peciCellPhoneCarrierOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhoneTtyDeviceOut", Types.VARCHAR),
			new SqlOutParameter("p_banCommentOut", Types.VARCHAR),
			new SqlOutParameter("p_banTeleCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_banTeleSeqnoOut", Types.NUMERIC),
			new SqlOutParameter("p_banEmergTextEmailOut", Types.VARCHAR),
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR));
		
		SimpleJdbcCall p_parent_main = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_crud_parent_pkg")
			.withProcedureName("p_parent_main");
		p_parent_main.setAccessCallParameterMetaData(false);
		p_parent_main.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),								
			new SqlParameter("p_duplicateStatus", Types.VARCHAR),
			new SqlParameter("p_peciRole", Types.VARCHAR),								
			new SqlParameter("p_stuPidm", Types.NUMERIC),
			new SqlParameter("p_stuPpid", Types.NUMERIC),
			
			new SqlParameter("p_peciParLastName", Types.VARCHAR),
			new SqlParameter("p_peciParFirstName", Types.VARCHAR),
			new SqlParameter("p_peciParMiddleName", Types.VARCHAR),
			new SqlParameter("p_peciParPrefixName", Types.VARCHAR),
			new SqlParameter("p_peciParSuffixName", Types.VARCHAR),
			new SqlParameter("p_parPidm", Types.NUMERIC),
			new SqlParameter("p_parPpid", Types.NUMERIC),
			new SqlParameter("p_reltCode", Types.VARCHAR),
			new SqlParameter("p_emergPriority", Types.NUMERIC),
			new SqlParameter("p_noCellPhone", Types.VARCHAR),
			new SqlParameter("p_dependent", Types.VARCHAR),
			
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),
			
			new SqlOutParameter("p_peciParentPpidOut", Types.NUMERIC),
			new SqlOutParameter("p_peciParentPidmOut", Types.NUMERIC),
			new SqlOutParameter("p_peciParentOrderOut", Types.NUMERIC),
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR));
		
		SimpleJdbcCall p_exe_cm_singleparent = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_commonmatching_pkg")
			.withProcedureName("p_exe_cm_singleparent");
		p_exe_cm_singleparent.setAccessCallParameterMetaData(false);
		p_exe_cm_singleparent.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),			
			new SqlParameter("p_peciRole", Types.VARCHAR),								
			new SqlParameter("p_stuPidm", Types.NUMERIC),
			new SqlParameter("p_stuPpid", Types.NUMERIC),

			new SqlParameter("p_peciParPrefixName", Types.VARCHAR),
			new SqlParameter("p_peciParFirstName", Types.VARCHAR),
			new SqlParameter("p_peciParMiddleName", Types.VARCHAR),
			new SqlParameter("p_peciParLastName", Types.VARCHAR),
			new SqlParameter("p_peciParSuffixName", Types.VARCHAR),
			new SqlParameter("p_reltCode", Types.VARCHAR),
			new SqlParameter("p_dependent", Types.VARCHAR),
			new SqlParameter("p_parEmailAddr", Types.VARCHAR),
			new SqlParameter("p_peciAddCode", Types.VARCHAR),
			new SqlParameter("p_peciAddrStreetLine1", Types.VARCHAR),
			new SqlParameter("p_peciAddrStreetLine2", Types.VARCHAR),
			new SqlParameter("p_peciAddrStreetLine3", Types.VARCHAR),
			new SqlParameter("p_peciAddrCity", Types.VARCHAR),
			new SqlParameter("p_peciAddrStateCode", Types.VARCHAR),
			new SqlParameter("p_peciAddrZipCode", Types.VARCHAR),
			new SqlParameter("p_peciAddrNatnCode", Types.VARCHAR),
			new SqlParameter("p_peciPhoneCode", Types.VARCHAR),
			new SqlParameter("p_peciPhoneArea", Types.VARCHAR),
			new SqlParameter("p_peciPhoneNumber", Types.VARCHAR),
			new SqlParameter("p_peciPhoneIntl", Types.VARCHAR),
			new SqlParameter("p_peciCellPhoneCarrier", Types.VARCHAR),
			new SqlParameter("p_peciPhoneTtyDevice", Types.VARCHAR),
			new SqlParameter("p_peciNoCellPhone", Types.VARCHAR),
			new SqlParameter("p_peciEmergPriority", Types.NUMERIC),
			
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),
			
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_newPidmErrorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_new XrefErrorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_new CameldErrorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_new BioErrorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_new SorfolkErrorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_parEmailErrorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_parAddrICodeOut", Types.VARCHAR),
			new SqlOutParameter("p_newPhoneErrorCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_matchStatusOut", Types.VARCHAR),
			new SqlOutParameter("p_parPidmOut", Types.NUMERIC),
			new SqlOutParameter("p_parPpidOut", Types.NUMERIC),
			new SqlOutParameter("p_parCamelIdOut", Types.VARCHAR),
			new SqlOutParameter("p_parOrderOut", Types.NUMERIC),
			new SqlOutParameter("p_parEmailAddrIOut", Types.VARCHAR));
		
		SimpleJdbcCall p_emerg_main = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_crud_emerg_pkg")
			.withProcedureName("p_emerg_main");
		p_emerg_main.setAccessCallParameterMetaData(false);
		p_emerg_main.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),			
			new SqlParameter("p_peciRole", Types.VARCHAR),								
			new SqlParameter("p_stuPidm", Types.NUMERIC),
			new SqlParameter("p_stuPpid", Types.NUMERIC),
			
			new SqlParameter("p_parPidm", Types.NUMERIC),
			new SqlParameter("p_parPpid", Types.NUMERIC),
			new SqlParameter("p_reltCode", Types.VARCHAR),
			
			new SqlParameter("p_emergPrefixName", Types.VARCHAR),
			new SqlParameter("p_emergFirstName", Types.VARCHAR),
			new SqlParameter("p_emergMiddleName", Types.VARCHAR),
			new SqlParameter("p_emergLastName", Types.VARCHAR),
			new SqlParameter("p_emergSuffixName", Types.VARCHAR),
			new SqlParameter("p_emergPriority", Types.NUMERIC),
			new SqlParameter("p_noCellPhone", Types.VARCHAR),
			new SqlParameter("p_dependent", Types.VARCHAR),
			
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),

			new SqlOutParameter("p_peciParentPpidOut", Types.NUMERIC),
			new SqlOutParameter("p_peciParentPidmOut", Types.NUMERIC),
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR));

		SimpleJdbcCall p_phone_create_temp = new SimpleJdbcCall(this.censusSource)
			.withCatalogName("cc_gen_peci_crud_phone_pkg")
			.withProcedureName("p_phone_create_temp");
		p_phone_create_temp.setAccessCallParameterMetaData(false);
		p_phone_create_temp.declareParameters(
			new SqlParameter("p_changeType", Types.VARCHAR),
			new SqlParameter("p_trans_id", Types.NUMERIC),
			new SqlParameter("p_peciRole", Types.VARCHAR),
			
			new SqlParameter("p_peciPhoneCode", Types.VARCHAR),
			
			new SqlParameter("p_stuPidm", Types.NUMERIC),
			new SqlParameter("p_stuPpid", Types.NUMERIC),
			new SqlParameter("p_parPpid", Types.NUMERIC),
			
			new SqlParameter("p_peciPhoneArea", Types.VARCHAR),
			new SqlParameter("p_peciPhoneNumber", Types.VARCHAR),
			new SqlParameter("p_peciPhoneIntl", Types.VARCHAR),
			new SqlParameter("p_peciCellPhoneCarrier", Types.VARCHAR),
			new SqlParameter("p_peciPhoneTtyDevice", Types.VARCHAR),
			
			new SqlParameter("p_peciUserId", Types.VARCHAR),
			new SqlParameter("p_peciDataOrigin", Types.VARCHAR),
			
			new SqlOutParameter("p_peciPhoneAreaOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhoneNumberOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhoneIntlOut", Types.VARCHAR),
			new SqlOutParameter("p_peciCellPhoneCarrierOut", Types.VARCHAR),
			new SqlOutParameter("p_peciPhoneTtyDeviceOut", Types.VARCHAR),
			new SqlOutParameter("p_banTeleCodeOut", Types.VARCHAR),
			new SqlOutParameter("p_errorCodeOut", Types.VARCHAR));
		
		//Update the PECI Phone Codes to match banenr codes
		SQL="update cas.cc_gen_peci_phone_data_t set PECI_PHONE_CODE='H' where PHONE_CODE='MA' and PECI_PHONE_CODE is null";
		jdbcCAS.update(SQL, new HashMap<String,Object>());
		
		SQL="update cas.cc_gen_peci_phone_data_t set PECI_PHONE_CODE='C' where PHONE_CODE='CP' and PECI_PHONE_CODE is null";
		jdbcCAS.update(SQL, new HashMap<String,Object>());
		
		SQL="update cas.cc_gen_peci_phone_data_t set PECI_PHONE_CODE='E' where PHONE_CODE='EP' and PECI_PHONE_CODE is null";
		jdbcCAS.update(SQL, new HashMap<String,Object>());
		
		SQL="update cas.cc_gen_peci_phone_data_t set PHONE_SEQUENCE_NO=1 where PHONE_SEQUENCE_NO is null";
		jdbcCAS.update(SQL, new HashMap<String,Object>());
		
		
		
		PECIParameters.put("STUDENT_PIDM",ccPDIM);
		PECIParameters.put("PARENT_PPID","0");
		
		SQL = "select STUDENT_PPID,STUDENT_PIDM,CAMEL_NUMBER,CAMEL_ID,LEGAL_PREFIX_NAME,PREFERRED_FIRST_NAME,PREFERRED_MIDDLE_NAME,PREFERRED_LAST_NAME,LEGAL_SUFFIX_NAME,EMERG_NO_CELL_PHONE,EMERG_PHONE_NUMBER_TYPE_CODE,EMERG_CELL_PHONE_CARRIER,EMERG_PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,LEGAL_DISCLAIMER_DATE,DEAN_EXCEPTION_DATE,GENDER,DECEASED,DECEASED_DATE  from cc_stu_peci_students_t where STUDENT_PIDM=:STUDENT_PIDM";
		studentData = jdbcCAS.queryForMap(SQL,PECIParameters);	
		
		//Start with transaction ID
		
		in = new MapSqlParameterSource();
		in.addValue("p_peciUserId", userName);
		int transId = f_cc_generate_trans_id.executeFunction(Integer.class,in);
		
		//int transId = 2000000;
		
		log.debug("Transaction id is " + transId);
		//Save Student Record	
		in = new MapSqlParameterSource();
		in.addValue("p_changeType","C");
		in.addValue("p_trans_id",transId);
		in.addValue("p_peciRole","STU");
		in.addValue("p_pidm",ccPDIM);
		in.addValue("p_ppid",null);
		
		in.addValue("p_peciLegalDisc",new Date());
		in.addValue("p_peciDeanExcept",null);
		in.addValue("p_noCellPhone",studentData.get("EMERG_NO_CELL_PHONE"));
		in.addValue("p_emergAutoOptout",studentData.get("EMERG_AUTO_OPT_OUT"));
		in.addValue("p_emergSendText",studentData.get("EMERG_SEND_TEXT"));
		
		in.addValue("p_peciUserId",userName);
		in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");
		
		
		out = p_student_main.execute(in);
		
		int ppId = Integer.parseInt(out.get("p_peciStudentPpidOut").toString()); 
		error = (String)out.get("p_errorCodeOut"); 
		
		log.debug("New Student procedure return is " + error);

		log.debug("New Student PPID is " + ppId);
		try {					
			//Student email Data
			SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PECI_EMAIL_CODE='H'";
			emailData = jdbcCAS.queryForMap(SQL,PECIParameters);
			
			//Studemt email
			in = new MapSqlParameterSource();
			in.addValue("p_changeType","C");
			in.addValue("p_trans_id",transId);
			in.addValue("p_ppid",ppId);
			in.addValue("p_peciRole","STU");
			in.addValue("p_pidm",ccPDIM);
			in.addValue("p_peciUserId",userName);
			in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");
			
			in.addValue("p_peciEmailCode",emailData.get("PECI_EMAIL_CODE").toString());
			in.addValue("p_peciEmailAddr",emailData.get("EMAIL_ADDRESS").toString());

			out = p_email_main.execute(in);
			
			error = (String)out.get("p_errorCodeOut"); 
			
			log.debug("New Student email procedure return is " + error);
			
		} catch (EmptyResultDataAccessException e){
			// dataset empty no email
		}
		try {					
			//Student Address Data
			SQL="select STUDENT_PPID,STUDENT_PIDM,EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0' and PECI_ADDR_CODE='H'";
			addressData = jdbcCAS.queryForMap(SQL,PECIParameters);

			//Studemt Address
			in = new MapSqlParameterSource();
			in.addValue("p_changeType","C");
			in.addValue("p_trans_id",transId);
			in.addValue("p_ppid",ppId);
			in.addValue("p_peciRole","STU");
			in.addValue("p_pidm",ccPDIM);
			in.addValue("p_peciUserId",userName);
			in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");
			
			in.addValue("p_banAddrSeqno",null);
			in.addValue("p_peciAddCode",addressData.get("PECI_ADDR_CODE").toString());
			in.addValue("p_peciAddrStreetLine1",addressData.get("ADDR_STREET_LINE1"));
			in.addValue("p_peciAddrStreetLine2",addressData.get("ADDR_STREET_LINE2"));
			in.addValue("p_peciAddrStreetLine3",addressData.get("ADDR_STREET_LINE3"));
			in.addValue("p_peciAddrCity",addressData.get("ADDR_CITY"));
			in.addValue("p_peciAddrStateCode",addressData.get("ADDR_STAT_CODE"));
			in.addValue("p_peciAddrZipCode",addressData.get("ADDR_ZIP"));
			in.addValue("p_peciAddrNatnCode",addressData.get("ADDR_NATN_CODE"));
			
			out = p_address_main.execute(in);
			
			error = (String)out.get("p_errorCodeOut"); 
			
			log.debug("New Student address procedure return is " + error);
			
		} catch (EmptyResultDataAccessException e){
			// dataset empty no email
		}
		try {					
			//Student Phone Data
			SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = '0'";
			phoneData = jdbcCAS.queryForList(SQL,PECIParameters);
			
			for(int i=0; i<phoneData.size();i++){
				Map<String,Object> phone = phoneData.get(i);
				//Studemt Phone
				in = new MapSqlParameterSource();
				in.addValue("p_changeType","C");
				in.addValue("p_trans_id",transId);
				in.addValue("p_ppid",ppId);
				in.addValue("p_peciRole","STU");
				in.addValue("p_pidm",ccPDIM);
				in.addValue("p_peciUserId",userName);
				in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");

				in.addValue("p_banTeleSeqno",1);
				in.addValue("p_peciPhoneCode",phone.get("PECI_PHONE_CODE"));
				in.addValue("p_peciPhoneArea",phone.get("PHONE_AREA_CODE"));
				in.addValue("p_peciPhoneNumber",phone.get("PHONE_NUMBER"));
				in.addValue("p_peciPhoneIntl",phone.get("PHONE_NUMBER_INTL"));
				in.addValue("p_peciPhoneStatus","A");
				in.addValue("p_peciPhonePrimary",null);
				in.addValue("p_peciCellPhoneCarrier",phone.get("CELL_PHONE_CARRIER"));
				in.addValue("p_peciPhoneTtyDevice",phone.get("PHONE_TTY_DEVICE"));
				in.addValue("p_banComment",null);
				in.addValue("p_peciEmergPriority",null);
				
				out = p_phone_main.execute(in);
				
				error = (String)out.get("p_errorCodeOut"); 
				
				log.debug("New Student phone procedure return is " + error);
			}
		} catch (EmptyResultDataAccessException e){
			log.debug("New Student phone is empty");
			// dataset empty 
		}
		try {
			//Parent Data
			SQL="select STUDENT_PPID, PARENT_PPID, STUDENT_PIDM, PARENT_PIDM, PARENT_CAMEL_NUMBER, PARENT_CAMEL_ID, PARENT_ORDER, PARENT_LEGAL_PREFIX_NAME, PARENT_LEGAL_FIRST_NAME, PARENT_LEGAL_MIDDLE_NAME, PARENT_LEGAL_LAST_NAME, PARENT_LEGAL_SUFFIX_NAME, PARENT_PREF_FIRST_NAME, PARENT_PREF_MIDDLE_NAME, PARENT_PREF_LAST_NAME, PARENT_RELT_CODE, EMERG_CONTACT_PRIORITY, EMERG_NO_CELL_PHONE, EMERG_PHONE_NUMBER_TYPE_CODE, EMERG_CELL_PHONE_CARRIER, EMERG_PHONE_TTY_DEVICE, DEPENDENT, PARENT_GENDER, PARENT_DECEASED, PARENT_DECEASED_DATE, PECI_ROLE, CONTACT_TYPE, PARENT_CONFID_IND from cc_adv_peci_parents_t where STUDENT_PIDM=:STUDENT_PIDM";
			parentData = jdbcCAS.queryForList(SQL,PECIParameters);
			
			for(int i=0; i<parentData.size();i++){
				Map<String,Object> parent = parentData.get(i);
				String tp_ppid = parent.get("PARENT_PPID").toString();
				Map<String,Object> parentParameters = new HashMap<String,Object>();
				parentParameters.put("STUDENT_PIDM", ccPDIM);
				parentParameters.put("PARENT_PPID", tp_ppid);
				
				//Parent
				in = new MapSqlParameterSource();
				in.addValue("p_changeType","C");
				in.addValue("p_trans_id",transId);
				in.addValue("p_stuPpid",ppId);
				in.addValue("p_peciRole","PAR");
				in.addValue("p_stuPidm",ccPDIM);
				in.addValue("p_peciUserId",userName);
				in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");

				in.addValue("p_peciParPrefixName",parent.get("PARENT_LEGAL_PREFIX_NAME"));
				in.addValue("p_peciParFirstName",parent.get("PARENT_PREF_FIRST_NAME"));
				in.addValue("p_peciParMiddleName",parent.get("PARENT_PREF_MIDDLE_NAME"));
				in.addValue("p_peciParLastName",parent.get("PARENT_PREF_LAST_NAME"));
				in.addValue("p_peciParSuffixName",parent.get("PARENT_LEGAL_SUFFIX_NAME"));
				in.addValue("p_reltCode",parent.get("PARENT_RELT_CODE"));
				in.addValue("p_peciNoCellPhone",parent.get("EMERG_NO_CELL_PHONE"));
				in.addValue("p_dependent",parent.get("DEPENDENT"));
				
				try {					
					//parent email Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID";
					emailData = jdbcCAS.queryForMap(SQL,parentParameters);

					//email
					in.addValue("p_parEmailAddr",emailData.get("EMAIL_ADDRESS"));
					
				} catch (EmptyResultDataAccessException e){
					log.debug("New parent email is empty");
					// dataset empty no email
					in.addValue("p_parEmailAddr",null);
				}
				try {					
					//Parent Address Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID";
					addressData = jdbcCAS.queryForMap(SQL,parentParameters);

					//Address
					in.addValue("p_peciAddCode","H");
					in.addValue("p_peciAddrStreetLine1",addressData.get("ADDR_STREET_LINE1"));
					in.addValue("p_peciAddrStreetLine2",addressData.get("ADDR_STREET_LINE2"));
					in.addValue("p_peciAddrStreetLine3",addressData.get("ADDR_STREET_LINE3"));
					in.addValue("p_peciAddrCity",addressData.get("ADDR_CITY"));
					in.addValue("p_peciAddrStateCode",addressData.get("ADDR_STAT_CODE"));
					in.addValue("p_peciAddrZipCode",addressData.get("ADDR_ZIP"));
					in.addValue("p_peciAddrNatnCode",addressData.get("ADDR_NATN_CODE"));
				} catch (EmptyResultDataAccessException e){
					log.debug("New parent address is empty");
					// dataset empty no address
				}

				try {					
					//Parent Phone Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID limit 0,1";
					Map<String,Object> phone = jdbcCAS.queryForMap(SQL,parentParameters);
					in.addValue("p_peciPhoneCode",phone.get("PECI_PHONE_CODE"));
					in.addValue("p_peciPhoneArea",phone.get("PHONE_AREA_CODE"));
					in.addValue("p_peciPhoneNumber",phone.get("PHONE_NUMBER"));
					in.addValue("p_peciPhoneIntl",phone.get("PHONE_NUMBER_INTL"));
					in.addValue("p_peciCellPhoneCarrier",phone.get("CELL_PHONE_CARRIER"));
					in.addValue("p_peciPhoneTtyDevice",phone.get("PHONE_TTY_DEVICE"));
					in.addValue("p_peciEmergPriority",null);
					log.debug ("Parent BCM insert returned " + error);
				} catch (EmptyResultDataAccessException e){
					log.debug("New parent phone is empty");
					// dataset empty 
				}		
				
				out = p_exe_cm_singleparent.execute(in);
				
				int p_ppid = Integer.parseInt(out.get("p_parPpidOut").toString()); 
				
				error = (String)out.get("p_errorCodeOut");
				
				log.debug("New Parent procedure return is " + error);
				
				//Update emergency contacts ppid.
				SQL="update cc_gen_peci_emergs_t set PARENT_PPID=" + p_ppid + " where PARENT_PPID='" + tp_ppid + "'";
				jdbcCAS.update(SQL, new HashMap<String,Object>());
				
				if (out.get("p_parPidmOut") != null){
					int p_ppidm = Integer.parseInt(out.get("p_parPidmOut").toString()); 
					//Handle the rest of the Phone Records
					try {
						SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID limit 1, 30";
						phoneData = jdbcCAS.queryForList(SQL,parentParameters);
						
						for(int x=0; x<phoneData.size();x++){
							Map<String,Object> phone = phoneData.get(x);
							//Phone
							in = new MapSqlParameterSource();
							in.addValue("p_changeType","C");
							in.addValue("p_trans_id",transId);
							in.addValue("p_ppid",p_ppid);
							in.addValue("p_peciRole","PAR");
							in.addValue("p_pidm",p_ppidm);
							in.addValue("p_peciUserId",userName);
							in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");

							in.addValue("p_banTeleSeqno",1);
							in.addValue("p_peciPhoneCode",phone.get("PECI_PHONE_CODE"));
							in.addValue("p_peciPhoneArea",phone.get("PHONE_AREA_CODE"));
							in.addValue("p_peciPhoneNumber",phone.get("PHONE_NUMBER"));
							in.addValue("p_peciPhoneIntl",phone.get("PHONE_NUMBER_INTL"));
							in.addValue("p_peciCellPhoneCarrier",phone.get("CELL_PHONE_CARRIER"));
							in.addValue("p_peciPhoneTtyDevice",phone.get("PHONE_TTY_DEVICE"));
							in.addValue("p_banComment",null);
							in.addValue("p_peciEmergPriority",null);
							
							out = p_phone_main.execute(in);
							
							error = (String)out.get("p_errorCodeOut"); 
							
							log.debug("New Parent phone procedure return is " + error);
						}
					} catch (EmptyResultDataAccessException e){
						log.debug("New parent additional phone is empty");
						// dataset empty No addition phones
					}
				}else{
					//Handle the rest of the Phone Records
					try {
						SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID limit 1, 30";
						phoneData = jdbcCAS.queryForList(SQL,parentParameters);
						
						for(int x=0; x<phoneData.size();x++){
							Map<String,Object> phone = phoneData.get(x);
							//Phone
							in = new MapSqlParameterSource();
							in.addValue("p_changeType","C");
							in.addValue("p_trans_id",transId);
							in.addValue("p_stuPpid",ppId);
							in.addValue("p_peciRole","PAR");
							in.addValue("p_stuPidm",ccPDIM);
							in.addValue("p_parPpid",p_ppid);
							in.addValue("p_peciUserId",userName);
							in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");

							in.addValue("p_peciPhoneCode",phone.get("PECI_PHONE_CODE"));
							in.addValue("p_peciPhoneArea",phone.get("PHONE_AREA_CODE"));
							in.addValue("p_peciPhoneNumber",phone.get("PHONE_NUMBER"));
							in.addValue("p_peciPhoneIntl",phone.get("PHONE_NUMBER_INTL"));
							in.addValue("p_peciCellPhoneCarrier",phone.get("CELL_PHONE_CARRIER"));
							in.addValue("p_peciPhoneTtyDevice",phone.get("PHONE_TTY_DEVICE"));
							
							out = p_phone_create_temp.execute(in);
							
							error = (String)out.get("p_errorCodeOut"); 
							
							log.debug("New Parent Temp phone procedure return is " + error);
						}
					} catch (EmptyResultDataAccessException e){
						log.debug("New parent additional phone is empty");
						// dataset empty No addition phones
					}
				}
				
			}
		} catch (EmptyResultDataAccessException e){
			log.debug("New student parents is empty");
			// dataset empty No Parents
		}
		//Emergency Contacts
		try {					
			//Emergency Contacts
			SQL="select PARENT_PPID, PARENT_PIDM, EMERG_CONTACT_PRIORITY, EMERG_LEGAL_PREFIX_NAME, EMERG_PREF_FIRST_NAME,EMERG_PREF_MIDDLE_NAME,EMERG_PREF_LAST_NAME, EMERG_LEGAL_SUFFIX_NAME from cc_gen_peci_emergs_t where (CHANGE_COLS !='DELETE' or  CHANGE_COLS is null) and STUDENT_PIDM=:STUDENT_PIDM order by EMERG_CONTACT_PRIORITY";
			parentData = jdbcCAS.queryForList(SQL,PECIParameters);
			
			for(int i=0; i<parentData.size();i++){
				Map<String,Object> parent = parentData.get(i);
				String tp_ppid = parent.get("PARENT_PPID").toString();
				Map<String,Object> parentParameters = new HashMap<String,Object>();
				parentParameters.put("STUDENT_PIDM", ccPDIM);
				parentParameters.put("PARENT_PPID", tp_ppid);
				
				//Contact
				in = new MapSqlParameterSource();
				in.addValue("p_changeType","C");
				in.addValue("p_trans_id",transId);
				in.addValue("p_peciRole","EMERG");
				in.addValue("p_stuPidm",ccPDIM);
				in.addValue("p_stuPpid",ppId);
				in.addValue("p_parPidm",null);
				
				if (isInteger(parent.get("PARENT_PPID").toString())){
					in.addValue("p_parPpid",parent.get("PARENT_PPID"));
				} else{
					in.addValue("p_parPpid",null);
				}

				in.addValue("p_emergPrefixName",parent.get("EMERG_LEGAL_PREFIX_NAME"));
				in.addValue("p_emergFirstName",parent.get("EMERG_PREF_FIRST_NAME"));
				in.addValue("p_emergMiddleName",parent.get("EMERG_PREF_MIDDLE_NAME"));
				in.addValue("p_emergLastName",parent.get("EMERG_PREF_LAST_NAME"));
				in.addValue("p_emergSuffixName",parent.get("EMERG_LEGAL_SUFFIX_NAME"));
				in.addValue("p_emergPriority",parent.get("EMERG_CONTACT_PRIORITY"));
				in.addValue("p_reltCode",parent.get("EMERG_RELT_CODE"));
				in.addValue("p_noCellPhone",parent.get("EMERG_NO_CELL_PHONE"));
				in.addValue("p_dependent",parent.get("DEPENDENT"));
				

				in.addValue("p_peciUserId",userName);
				in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");
				
				out = p_emerg_main.execute(in);
				
				int p_ppid = Integer.parseInt(out.get("p_peciParentPpidOut").toString());  
				
				error = (String)out.get("p_errorCodeOut"); 
				
				log.debug("New Contact procedure return is " + error);

				log.debug("New contact PPID is " + p_ppid);
				
				try {					
					//Contqct email Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_EMAIL_CODE,EMAIL_ADDRESS from cc_gen_peci_email_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID and PECI_EMAIL_CODE='H'";
					emailData = jdbcCAS.queryForMap(SQL,parentParameters);

					//email
					in = new MapSqlParameterSource();
					in.addValue("p_changeType","C");
					in.addValue("p_trans_id",transId);
					in.addValue("p_ppid",p_ppid);
					in.addValue("p_peciRole","EMERG");
					in.addValue("p_pidm",null);
					in.addValue("p_peciUserId",userName);
					in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");
					
					in.addValue("p_peciEmailCode",emailData.get("PECI_EMAIL_CODE"));
					in.addValue("p_peciEmailAddr",emailData.get("EMAIL_ADDRESS"));

					out = p_email_main.execute(in);
					
					error = (String)out.get("p_errorCodeOut"); 
					
					log.debug("New contact email procedure return is " + error);
					
				} catch (EmptyResultDataAccessException e){
					log.debug("New contact email is empty");
					// dataset empty no email
				}
				try {					
					//Contact Address Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,EMERG_CONTACT_PRIORITY,PERSON_ROLE,PECI_ADDR_CODE,ADDR_CODE,ADDR_SEQUENCE_NO,ADDR_STREET_LINE1,ADDR_STREET_LINE2,ADDR_STREET_LINE3,ADDR_CITY,ADDR_STAT_CODE,ADDR_ZIP,ADDR_NATN_CODE,ADDR_STATUS_IND from cc_gen_peci_addr_data_t where STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID and PECI_ADDR_CODE='H'";
					addressData = jdbcCAS.queryForMap(SQL,parentParameters);

					//Address
					in = new MapSqlParameterSource();
					in.addValue("p_changeType","C");
					in.addValue("p_trans_id",transId);
					in.addValue("p_ppid",p_ppid);
					in.addValue("p_peciRole","EMERG");
					in.addValue("p_pidm",null);
					in.addValue("p_peciUserId",userName);
					in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");

					in.addValue("p_banAddrSeqno",null);
					in.addValue("p_peciAddCode",addressData.get("PECI_ADDR_CODE"));
					in.addValue("p_peciAddrStreetLine1",addressData.get("ADDR_STREET_LINE1"));
					in.addValue("p_peciAddrStreetLine2",addressData.get("ADDR_STREET_LINE2"));
					in.addValue("p_peciAddrStreetLine3",addressData.get("ADDR_STREET_LINE3"));
					in.addValue("p_peciAddrCity",addressData.get("ADDR_CITY"));
					in.addValue("p_peciAddrStateCode",addressData.get("ADDR_STAT_CODE"));
					in.addValue("p_peciAddrZipCode",addressData.get("ADDR_ZIP"));
					in.addValue("p_peciAddrNatnCode",addressData.get("ADDR_NATN_CODE"));
					
					out = p_address_main.execute(in);
					
					error = (String)out.get("p_errorCodeOut"); 
					
					log.debug("New contact adress procedure return is " + error);
					
				} catch (EmptyResultDataAccessException e){
					log.debug("New contact address is empty");
					// dataset empty no address
				}
				try {					
					//Contact Phone Data
					SQL="select STUDENT_PPID,STUDENT_PIDM,PARENT_PPID,PARENT_PIDM,PECI_PHONE_CODE,PHONE_CODE,PHONE_AREA_CODE,PHONE_NUMBER,PHONE_NUMBER_INTL,PHONE_SEQUENCE_NO,PHONE_STATUS_IND,PHONE_PRIMARY_IND,CELL_PHONE_CARRIER,PHONE_TTY_DEVICE,EMERG_AUTO_OPT_OUT,EMERG_SEND_TEXT,EMERG_NO_CELL_PHONE from cc_gen_peci_phone_data_t where (PHONE_STATUS_IND is null or  PHONE_STATUS_IND = 'A') and STUDENT_PIDM=:STUDENT_PIDM and PARENT_PPID = :PARENT_PPID";
					phoneData = jdbcCAS.queryForList(SQL,parentParameters);
					
					for(int x=0; x<phoneData.size();x++){
						Map<String,Object> phone = phoneData.get(x);
						//Phone
						in = new MapSqlParameterSource();
						in.addValue("p_changeType","C");
						in.addValue("p_trans_id",transId);
						in.addValue("p_ppid",p_ppid);
						in.addValue("p_peciRole","EMERG");
						in.addValue("p_pidm",null);
						in.addValue("p_peciUserId",userName);
						in.addValue("p_peciDataOrigin","PECI Entry Pt - Student data");

						in.addValue("p_banTeleSeqno",1);
						in.addValue("p_peciPhoneCode",phone.get("PECI_PHONE_CODE"));
						in.addValue("p_peciPhoneArea",phone.get("PHONE_AREA_CODE"));
						in.addValue("p_peciPhoneNumber",phone.get("PHONE_NUMBER"));
						in.addValue("p_peciPhoneIntl",phone.get("PHONE_NUMBER_INTL"));
						in.addValue("p_peciCellPhoneCarrier",phone.get("CELL_PHONE_CARRIER"));
						in.addValue("p_peciPhoneTtyDevice",phone.get("PHONE_TTY_DEVICE"));
						in.addValue("p_banComment",null);
						in.addValue("p_peciEmergPriority",null);
						
						out = p_phone_main.execute(in);
						
						error = (String)out.get("p_errorCodeOut"); 
						
						log.debug("New contact phone procedure return is " + error);
					}
				} catch (EmptyResultDataAccessException e){
					log.debug("New contact phone is empty");
					// dataset empty no Phone
				}
			}
		} catch (EmptyResultDataAccessException e){
			log.debug("New Student contacts is empty");
			// dataset empty no Emergency contacts
		}
		//Clear Student's data from CAS
		SQL="call PECI_Clear_Student(:STUDENT_PIDM) ";
		jdbcCAS.update(SQL, PECIParameters);
	}
}
