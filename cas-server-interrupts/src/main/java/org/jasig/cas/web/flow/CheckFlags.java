package org.jasig.cas.web.flow;

import java.util.List;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;

import org.apache.commons.net.util.SubnetUtils;

import org.springframework.webflow.execution.RequestContext;
import org.springframework.ldap.core.support.AbstractContextMapper;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.ldap.core.LdapTemplate;

import org.jasig.cas.util.LdapUtils;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.web.support.WebUtils;

public final class CheckFlags {
	
	@NotNull
	private LdapTemplate ldapTemplate;
	
	@NotNull
    private String filter;
	
	@NotNull
    private String ldapAttrib;
		
	@NotNull
    private String searchBase;
	
	private List<String> localIpRanges;
	
	private List<String> vpnIpRanges;
	
	private List<String> localOnly;
	
	private List<SubnetUtils> localSubNets;
	
	private List<SubnetUtils> vpnSubNets;	
	
	private Log log = LogFactory.getLog(this.getClass());
	
	public final String check(final RequestContext context, final UsernamePasswordCredentials credentials) throws Exception {
		final String userName = credentials.getUsername();
        final String searchFilter = LdapUtils.getFilterWithValues(this.filter, userName);
		context.getFlowScope().put("ErrorMsg", " ");
		log.debug("CheckFlags searching " + searchFilter);
		log.debug("CheckFlags searching for attribute " + ldapAttrib);
		
		List DN = this.ldapTemplate.search(
			this.searchBase, searchFilter, 
			new AbstractContextMapper(){
				protected Object doMapFromContext(DirContextOperations ctx) {
					return ctx.getNameInNamespace();
				}
			}
		);
		
		log.debug("CheckFlags found user DN " + DN.get(0).toString());
		
		DirContextOperations ldapcontext = ldapTemplate.lookupContext(DN.get(0).toString());
		
		String Attrib = ldapcontext.getStringAttribute(ldapAttrib);
		
		if (Attrib == null){
			return "noFlag";
		}
		
		log.info("CheckFlags user flag attribute is " + Attrib);
		String[] FlagPairs = Attrib.split(";");
		if (FlagPairs.length > 0){
			for (int x=0; x<FlagPairs.length; x++) {
				log.debug("CheckFlags flag pair found: " + FlagPairs[x]);
				String[] FlagSet = FlagPairs[x].split("=");
				//Check if flag is local only
				if (this.localOnly.indexOf(FlagSet[0]) != -1) {
					HttpServletRequest httpRequest = WebUtils.getHttpServletRequest(context);
					String clientIp = httpRequest.getRemoteAddr();
					String ipStatus="Off Campus IP";
					for(SubnetUtils subNet : localSubNets){
						if (subNet.getInfo().isInRange(clientIp)){
							ipStatus="Local IP";
							for(SubnetUtils vpnSubNet : vpnSubNets){
								if (vpnSubNet.getInfo().isInRange(clientIp)){
									ipStatus="VPN IP";								
								}
							}
						}
					}
					log.info("Client IP is" + ipStatus);
					if (ipStatus.equals("Local IP")){
						log.info("CheckFlags returning flag " + FlagSet[0]);
						return FlagSet[0];
					}
				} else {	
					if (FlagSet.length < 2) {
						log.info("CheckFlags returning flag " + FlagSet[0]);
						return FlagSet[0];
					}
				} 
			}
		}
		return "noFlag";
	}
	
		
	public final String update(final RequestContext context, final UsernamePasswordCredentials credentials, final String flag) throws Exception {
		final String userName = credentials.getUsername();
        final String searchFilter = LdapUtils.getFilterWithValues(this.filter, userName);
		
		log.debug("CheckFlags searching " + searchFilter);
		log.debug("CheckFlags searching for attribute " + ldapAttrib);
		
		List DN = this.ldapTemplate.search(
			this.searchBase, searchFilter, 
			new AbstractContextMapper(){
				protected Object doMapFromContext(DirContextOperations ctx) {
					return ctx.getNameInNamespace();
				}
			}
		);
		
		DirContextOperations ldapcontext = ldapTemplate.lookupContext(DN.get(0).toString());
		
		
		log.debug("CheckFlags Updating attribute " + ldapAttrib);
		String Attrib = ldapcontext.getStringAttribute(ldapAttrib);
		if (Attrib == null){
			return "noFlag";
		}
		DateFormat dfm = new SimpleDateFormat("MM/dd/yyyy");
		Attrib = Attrib.toString().replace(flag+"=;",flag+"="+dfm.format(new Date())+";");
		
		log.info("CheckFlags writing update '"+ Attrib +"'to attribute " + ldapAttrib);
		ldapcontext.setAttributeValue(ldapAttrib, Attrib);
		ldapTemplate.modifyAttributes(ldapcontext);
		
		return "success";
	}
		
	public void setldapAttrib (final String ldapAttrib) {
		this.ldapAttrib = ldapAttrib;
	}
		
	public void setsearchBase (final String searchBase) {
		this.searchBase = searchBase;
	}
	
	public String getldapAttrib() {
		return this.ldapAttrib;
	}
		
	public void setldapTemplate(final LdapTemplate ldapTemplate){
		this.ldapTemplate=ldapTemplate;	
	}
	
	public void setFilter (final String filter) {
		this.filter = filter;
	}
	
	public final void setlocalIpRanges(final List<String> localIpRanges) {
	        this.localIpRanges = localIpRanges;
	        for(String subNet :  this.localIpRanges) {
	        	log.debug("CheckFlags adding local ip range " + subNet);
	        	this.localSubNets.add( new SubnetUtils(subNet));
	        }
	}
	
	public final void setvpnIpRanges(final List<String> vpnIpRanges) {
	        this.vpnIpRanges = vpnIpRanges;
	        for(String subNet :  this.localIpRanges) {
	        	log.debug("CheckFlags adding VPN ip range " + subNet);
	        	this.vpnSubNets.add( new SubnetUtils(subNet));
	        }
	}
	
	public void setLocalOnly(final List<String> localOnly) {
	        this.localOnly = localOnly;
	}
}