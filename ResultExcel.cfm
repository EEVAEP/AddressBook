<cfparam name="url.filePath" default="">

<cfif len(url.filePath)>
	<cfif fileExists(url.filePath)>
		<cfset customFileName = "Upload_Result.xlsx">
        	<cfheader name="Content-Disposition" value="attachment;filename=#customFileName#">
        	<cfcontent file="#url.filePath#" type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet">
		 
    	<cfelse>
        	<cflocation url ="dashboard.cfm" addtoken="false">
    	</cfif>
<cfelse> 
    <cfoutput>Invalid file request.</cfoutput>
</cfif>
