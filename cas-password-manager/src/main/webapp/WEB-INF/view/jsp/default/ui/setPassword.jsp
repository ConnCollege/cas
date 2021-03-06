<%--
  ~ Licensed to Jasig under one or more contributor license
  ~ agreements. See the NOTICE file distributed with this work
  ~ for additional information regarding copyright ownership.
  ~ Jasig licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file
  ~ except in compliance with the License.  You may obtain a
  ~ copy of the License at the following location:
  ~
  ~   http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<jsp:directive.include file="includes/top.jsp" />
<link type="text/css" rel="stylesheet" href="<c:url value="/css/cas-pm.css" />" />
<c:url var="loginUrl" value="/login">
    <c:if test="${not empty service}">
        <c:param name="service" value="${service}" />
    </c:if>
</c:url>

<div id="admin" class="useradmin">
   
        <h2><spring:message code="pm.setPassword.header" /></h2>

        <p class="note">
        <c:choose>
        <c:when test="${pmExtra eq 'wait'}">
            <spring:message code="pm.setPassword.wait" arguments="${loginUrl}" />
        </c:when>
        <c:otherwise>
            <spring:message code="pm.setPassword.text" arguments="${loginUrl}" />            
        </c:otherwise>
        </c:choose>        
        </p>
            
</div>

<jsp:directive.include file="includes/bottom.jsp" />
