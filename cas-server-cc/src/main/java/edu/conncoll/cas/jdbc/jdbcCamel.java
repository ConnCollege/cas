package edu.conncoll.cas.jdbc;

import java.util.Map;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import java.lang.Character;
import java.lang.Integer;

import java.sql.Types;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.HashMap;

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

import javax.sql.DataSource;
import javax.validation.constraints.NotNull;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.SqlReturnResultSet;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.SqlOutParameter;
import org.springframework.jdbc.object.StoredProcedure;
import org.springframework.jdbc.core.RowMapper;

import org.springframework.ldap.core.support.AbstractContextMapper;
import org.springframework.ldap.core.LdapTemplate;
import org.springframework.ldap.core.DirContextOperations;

import org.springframework.webflow.execution.RequestContext;

import sample.appsforyourdomain.AppsForYourDomainClient;

import com.google.gdata.data.appsforyourdomain.provisioning.UserEntry;
import com.google.gdata.data.appsforyourdomain.provisioning.NicknameEntry;
import com.google.gdata.data.appsforyourdomain.provisioning.NicknameFeed;
import com.google.gdata.data.appsforyourdomain.Nickname;
import com.google.gdata.data.appsforyourdomain.Login;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.util.LdapUtils;
import org.jasig.cas.web.support.IntData;


public class jdbcCamel {
	@NotNull
    private NamedParameterJdbcTemplate jdbcTemplate;
	
	@NotNull
    private JdbcTemplate jdbcCensus;
	
	@NotNull
    private JdbcTemplate jdbcBlackB;
    
    @NotNull
    private DataSource dataSource;
    @NotNull
    private DataSource censusSource;
    @NotNull
    private DataSource BlackBSource;
    
	@NotNull
	private LdapTemplate ldapTemplate;
	
	@NotNull
    private String filter;	
	
	@NotNull
    private String searchBase;
	
	@NotNull
    private String mainUsername;
	
	@NotNull
    private String mainPassword;
	
	@NotNull
    private String nuVisionPath;
	
	/* briley 7/20/2012 - added PIF to list */
	public enum Interrupts {
		AUP, OEM, QNA, ACT, PWD, EMR, AAUP, PIF, CNS, CHANGE, INIT, RESET, NOVALUE;    
		public static Interrupts toInt(String str) {
			try {
				return valueOf(str);
			} 
			catch (Exception ex) {
				return NOVALUE;
			}
		}
	}
	
	private Log log = LogFactory.getLog(this.getClass());
	
	public void readFlow (final String flag, final RequestContext context, final UsernamePasswordCredentials credentials) throws Exception {
		String userName = credentials.getUsername();
		
		String SQL = "";
		
		SqlParameterSource namedParameters = new MapSqlParameterSource().addValue("user", userName + "@conncoll.edu",java.sql.Types.VARCHAR);
		
		log.debug("readFlow Preparing data for " + flag + " user is " + userName);
		
		switch (Interrupts.toInt(flag)) {
			case AUP:
				SQL = "select count(*) ct from cc_user where email = :user and active=1";
				Map<String,Object> ChkUser = jdbcTemplate.queryForMap(SQL,namedParameters);
				
				context.getFlowScope().put("actcheck", ChkUser.get("ct"));
				break;
			case OEM:
				SQL = "select oemail, firstname from cc_user where email = :user and active=1";
		
				try {
					Map<String,Object> OEMData = jdbcTemplate.queryForMap(SQL,namedParameters);
					if (OEMData.get("oemail").toString().length() > 0){
						log.debug("readFlow connecting to email for " + OEMData.get("oemail").toString());
						Context initCtx = new InitialContext();
						Session session = (Session) initCtx.lookup("java:comp/env/mail/Session");
						log.debug("readFlow connected to email.");
						StringBuilder actMsg = new StringBuilder();
						
						actMsg.append("Welcome " + OEMData.get("firstname").toString() + ",\n\n");
						actMsg.append("This email is to alert you that your Connecticut College CamelWeb account has been activated.\n\n");
						actMsg.append("If you did not activate your account or believe you have otherwise received this email in error");
						actMsg.append(" please contact the Connecticut College Help Desk @ (860) 439 - HELP (4357).\n\n");
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
						context.getFlowScope().put("oemail", OEMData.get("oemail").toString());
						log.debug("readFlow  email sent");
					} else {
						context.getFlowScope().put("oemail", "");
					}
				} catch (Exception e) {
					log.warn("readFlow failed sending outside mail for " + userName );
					// No OEM email in cc_user		
					context.getFlowScope().put("oemail", "");	 
				}
			break;
			case QNA:				
				namedParameters = new MapSqlParameterSource("username", userName);
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
				AppsForYourDomainClient googleCTX = new AppsForYourDomainClient ("googleadmin@conncoll.edu","alpdhuez","conncoll.edu");
			
				try {
					NicknameFeed nickNames = googleCTX.retrieveNicknames(userName);
					List<NicknameEntry> nameList = nickNames.getEntries();
					log.debug("readFlow found " + nameList.size() + " nicknames ");
					if (nameList.size() > 0){
						for (int x=0; x<nameList.size(); x++) {
							Nickname firstNick = nameList.get(x).getNickname();
							if (firstNick.getName().indexOf(".") > 0){
								log.debug("readFlow sending nickname " + firstNick.getName());
								context.getFlowScope().put("NickName", firstNick.getName());
							}
						}
					}
				} catch (Exception e) {
					// No Google account					 
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
				Map<String,Object> termData = jdbcCensus.queryForMap(SQL,namedParameters);
				log.debug("Termcode returned by query " + termData.get("param_value").toString());
				// term code termData.get("param_value").toString()
				// get banner id from ldap
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
				
				String Attrib = ldapcontext.getStringAttribute("extensionAttribute15");
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
					SQL = "update clone.clone_card set customfield8 = 'Y' , customfield12 = SYSDATE where person_number = :bannerId";
					log.debug("SQL for update " + SQL);
					log.debug("banner id " + Attrib.toString());
					int check = jdbcBlackB.update(SQL, Attrib.toString());
					log.debug("insert rerutn" + Integer.toString(check));
				} catch (DataAccessException e){
					log.warn("SQL for Clone Table update failed " + e.getMessage());
				}
				/* Write to NuVision file no longer valid
				String fileStr = Attrib.toString() + ";;;;;;;;;;;;;;;;;;;;;;;\r\n";
				try {
					FileWriter writer = new FileWriter(nuVisionPath,true);
					log.info("writing to NuViosn file:" + fileStr);
				    writer.append(fileStr);
				    writer.flush();
				    writer.close();
				} catch(IOException e) {
					log.error("unable to update nuvision file for id " + Attrib.toString());
				} 
				try {
					FileWriter writer = new FileWriter(nuVisionPath+"_bak",true);
					Date now = new Date();
					fileStr = Attrib.toString() + ";;;;;;;;;;;;;;;;;;;;;;;"+now.toString()+"\r\n";
					log.info("writing to NuViosn file:" + fileStr);
				    writer.append(fileStr);
				    writer.flush();
				    writer.close();
				} catch(IOException e) {
					log.error("unable to update nuvision file for id " + Attrib.toString());
				} 
				*/
			break;
			default:
				
			break;
		}
	}
	
	public String writeFlow (final String flag, final RequestContext context, UsernamePasswordCredentials credentials, final IntData intData) 
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
			SQL="insert cc_user_qnaPair (UId, QuestNum, QuestionId, Answer) values(:username)";
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
		
		if (flag.equals("PWD")) {
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
			
			String Attrib = ldapcontext.getStringAttribute("extensionAttribute14");
			String domain;
			if (Attrib.equals("alumni")) {
				domain = "alumni.conncoll.edu";
			} else {
				domain  = "conncoll.edu";
			} 
												
			ModificationItem[] mods = new ModificationItem[1];
			
			String newQuotedPassword = "\"" + intData.getField(1) + "\"";
			byte[] newUnicodePassword = newQuotedPassword.getBytes("UTF-16LE");
 
 			mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("unicodePwd", newUnicodePassword));
			try {
				ldapTemplate.modifyAttributes(DN.get(0).toString(),mods);
			}catch( Exception e){
				log.warn("Password reset failed at AD");
				context.getFlowScope().put("ErrorMsg", "Password rejected by server, please ensure your password meets all the listed criteria.");
				return "Failed";
			}
			
			AppsForYourDomainClient googleCTX = new AppsForYourDomainClient (this.mainUsername,this.mainPassword,domain);
			try {
				UserEntry userEntry = googleCTX.retrieveUser(userName);
				Login userLogin = userEntry.getLogin();
				userLogin.setAgreedToTerms(true);
				userLogin.setChangePasswordAtNextLogin(false);
				userLogin.setPassword(intData.getField(1));
				googleCTX.updateUser(userName,userEntry);
			} catch (Exception e) {
				log.info("Password reset failed at google");
				// No Google account					 
			}		
			SQL = "insert cc_user_password_history (date,uid,ip,adminid) (select getdate() date, id uid, 'CAS Services' ip, id adminid from cc_user where email=:user) ";
			int check = jdbcTemplate.update(SQL,namedParameters);
			log.debug("Insert result " + check);
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
		return "Saved";
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
		
	public void setsearchBase (final String searchBase) {
		this.searchBase = searchBase;
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
	
	public void setFilter (final String filter) {
		this.filter = filter;
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
}