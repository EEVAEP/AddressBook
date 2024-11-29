
<cfif structKeyExists(url, "contacts")>
	<cfset contacts = deserializeJSON(url.contacts)>

    	<cfheader name="Content-Disposition" value="attachment; filename=Address_Book.pdf">
    	<cfheader name="Content-Type" value="application/pdf">
    	<cfcontent type="application/pdf" reset="true">

    	<cfdocument format="PDF" orientation="portrait">
        	<h1 style="text-align: center;">Address Book</h1>
        	<table center-table border="1" cellpadding="5" cellspacing="0">    
            		<thead>
                		<tr>
                    			<th>Name</th>
                    			<th>Email</th>
                    			<th>Phone</th>
                		</tr>
            		</thead>
            		<tbody>
                		<cfoutput>
                    			<cfloop array="#contacts#" index="contact">
                        			<tr>
                            				<td>#contact.name#</td>
                            				<td>#contact.email#</td>
                            				<td>#contact.phone#</td>
						</tr>
                    			</cfloop>
                		</cfoutput>
            		</tbody>
        	</table>
    </cfdocument>
<cfelse>
    <p>No contact data provided.</p>
</cfif>
