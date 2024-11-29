
<cfcomponent output="false">
	
	<cfset this.name = "AddressBookAuthentication"> 
    	<cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)> 
    	<cfset this.sessionManagement = true> 
    	<cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)> >
    	<cfset this.setClientCookies = true>
	<cfset this.datasource = "addressbook"> 
    
    	<cffunction name="onApplicationStart" returnType="boolean">
		<cfset application.userService = createObject("component","components.db")>
		<cfset application.encryptionKey = generateSecretKey("AES")>
        	<cfreturn true>
    	</cffunction>
	
    	<cffunction name="onRequestStart" returnType="void">
        	<cfargument name="requestname" required="true">
        	<cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            		<cfset onApplicationStart()>
        	</cfif>

        	<cfset local.pages = ["signup.cfm","login.cfm"]>
        	<cfif NOT structKeyExists(session,"username") AND NOT arrayFindNoCase(local.pages, ListLast(CGI.SCRIPT_NAME,'/'))>
		    <cflocation url="login.cfm" addToken="no">
	    	</cfif>
    	</cffunction>

</cfcomponent>
