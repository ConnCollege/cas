/*
 * Copyright 2007 The JA-SIG Collaborative. All rights reserved. See license
 * distributed with this file and available online at
 * http://www.uportal.org/license.html
 */
package org.jasig.cas.adaptors.x509.authentication.handler.support;

import java.math.BigInteger;
import java.security.GeneralSecurityException;
import java.security.cert.X509CRL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;

import net.sf.ehcache.Cache;

import org.jasig.cas.adaptors.x509.util.MockWebServer;
import org.junit.After;
import org.junit.Before;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;
import org.springframework.core.io.ClassPathResource;


/**
 * Unit test for {@link CRLDistributionPointRevocationChecker} class.
 *
 * @author Marvin S. Addison
 * @version $Revision$
 * @since 3.4.76
 *
 */
@RunWith(Parameterized.class)
public class CRLDistributionPointRevocationCheckerTests extends AbstractCRLRevocationCheckerTests {

    /** Instance under test */
    private CRLDistributionPointRevocationChecker checker;

    /** Answers requests for CRLs made to localhost:8085. */
    private MockWebServer webServer;


    /**
     * Creates a new test instance with given parameters.
     *
     * @param checker Revocation checker instance.
     * @param expiredCRLPolicy Policy instance for handling expired CRL data.
     * @param certFiles File names of certificates to check.
     * @param crlFile File name of CRL file to serve out.
     * @param expected Expected result of check; null to indicate expected success.
     */
    public CRLDistributionPointRevocationCheckerTests(
        final CRLDistributionPointRevocationChecker checker,
        final RevocationPolicy<X509CRL> expiredCRLPolicy,
        final String[] certFiles,
        final String crlFile,
        final GeneralSecurityException expected) {
        
        super(certFiles, expected);

        this.checker = checker;
        this.checker.setExpiredCRLPolicy(expiredCRLPolicy);
        this.webServer = new MockWebServer(8085, new ClassPathResource(crlFile), "text/plain");
    }

    /**
     * Gets the unit test parameters.
     *
     * @return  Test parameter data.
     */
    @Parameters
    public static Collection<Object[]> getTestParameters()
    {
      final Collection<Object[]> params = new ArrayList<Object[]>();
      Cache cache;
      final ThresholdExpiredCRLRevocationPolicy defaultPolicy = new ThresholdExpiredCRLRevocationPolicy();
      final ThresholdExpiredCRLRevocationPolicy zeroThresholdPolicy = new ThresholdExpiredCRLRevocationPolicy();
      zeroThresholdPolicy.setThreshold(0);
      
      // Test case #1
      // Valid certificate on valid CRL data
      cache = new Cache("crlCache-1", 100, false, false, 20, 10);
      cache.initialise();
      params.add(new Object[] {
          new CRLDistributionPointRevocationChecker(cache),
          defaultPolicy,
          new String[] {"user-valid-distcrl.crt"},
         "userCA-valid.crl",
          null,
      });
      
      // Test case #2
      // Revoked certificate on valid CRL data
      cache = new Cache("crlCache-2", 100, false, false, 20, 10);
      cache.initialise();
      params.add(new Object[] {
          new CRLDistributionPointRevocationChecker(cache),
          defaultPolicy,
          new String[] {"user-revoked-distcrl.crt"},
         "userCA-valid.crl",
          new RevokedCertificateException(new Date(), new BigInteger("1")),
      });
      
      // Test case #3
      // Valid certificate on expired CRL data
      cache = new Cache("crlCache-3", 100, false, false, 20, 10);
      cache.initialise();
      params.add(new Object[] {
          new CRLDistributionPointRevocationChecker(cache),
          zeroThresholdPolicy,
          new String[] {"user-valid-distcrl.crt"},
         "userCA-expired.crl",
          new ExpiredCRLException("test", new Date()),
      });
      
      // Test case #4
      // Valid certificate on expired CRL data with custom expiration
      // policy to always allow expired CRL data
      cache = new Cache("crlCache-4", 100, false, false, 20, 10);
      cache.initialise();
      params.add(new Object[] {
          new CRLDistributionPointRevocationChecker(cache),
          new RevocationPolicy<X509CRL>() {
              public void apply(X509CRL crl) {/* Do nothing to allow unconditionally */}
          },
          new String[] {"user-valid-distcrl.crt"},
         "userCA-expired.crl",
          null,
      });
      
      // Test case #5
      // Valid certificate with no CRL distribution points defined but with
      // "AllowRevocationPolicy" set to allow unavailable CRL data
      cache = new Cache("crlCache-5", 100, false, false, 20, 10);
      cache.initialise();
      final CRLDistributionPointRevocationChecker checker5 = new CRLDistributionPointRevocationChecker(cache);
      checker5.setUnavailableCRLPolicy(new AllowRevocationPolicy());
      params.add(new Object[] {
          checker5,
          defaultPolicy,
          new String[] {"user-valid.crt"},
         "userCA-expired.crl",
          null,
      });
      
      // Test case #6
      // EJBCA test case
      // Revoked certificate with CRL distribution point URI that is technically
      // not a valid URI since the issuer DN in the querystring is not encoded per
      // the escaping of reserved characters in RFC 2396.
      // Make sure we can convert given URI to valid URI and confirm it's revoked
      cache = new Cache("crlCache-6", 100, false, false, 20, 10);
      cache.initialise();
      params.add(new Object[] {
          new CRLDistributionPointRevocationChecker(cache),
          defaultPolicy,
          new String[] {"user-revoked-distcrl2.crt"},
         "userCA-valid.crl",
          new RevokedCertificateException(new Date(), new BigInteger("1")),
      });
      
      return params;
    }

    /**
     * Called once before every test.
     *
     * @throws Exception On setup errors.
     */
    @Before
    public void setUp() throws Exception {
        this.webServer.start();
    }

    /**
     * Called once before every test.
     *
     * @throws Exception On setup errors.
     */
    @After
    public void tearDown() throws Exception {
        this.webServer.stop();
    }
    
    protected RevocationChecker getChecker() {
        return this.checker;
    }
}
