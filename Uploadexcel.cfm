<cftry>
	<cfset uploadPath = ExpandPath('./excelUploads/')>

	<cffile action = "upload" 
		destination = "#uploadPath#" 
		fileField = "excelFile" 
		nameConflict = "makeUnique" 
		result = "fileUploadResult">

	<cfset uploadedFilePath = uploadPath & fileUploadResult.serverFile>
	
	<cfspreadsheet action = "read" 
		src = "#uploadedFilePath#"
		query = "excelData"
		headerrow = "1"> 

	
	<cfset excelDataArray = []>
	<cfloop from="2" to="#excelData.recordCount#" index="i">
		<cfset rowStruct = {
			"title": excelData.TITLE[i],
			"firstName": excelData.FIRSTNAME[i],
			"lastName": excelData.LASTNAME[i],
			"gender": excelData.GENDER[i],
			"dob": excelData.DOB[i],
			"address": excelData.ADDRESS[i],
			"street": excelData.STREET[i],
			"pincode": excelData.PINCODE[i],
			"email": excelData.EMAIL[i],
			"phone": excelData.PHONE[i],
			"hobbies": excelData.HOBBIES[i],
			"is_public": excelData.PUBLIC[i]
		}>
		<cfset arrayAppend(excelDataArray, rowStruct)>
	</cfloop>

	<cfset validatedData = []> 

	<cfloop array="#excelDataArray#" index="row">
    		<cfset result = application.userService.validateAddEditContactDetails(titleName = row.title,
        									firstName = row.firstName,
        									lastName = row.lastName,
       	 									genderName = row.gender,
        									dob = row.dob,
        									address = row.address,
        									street = row.street,
        									pincode = row.pincode,
        									email = row.email,
        									phone = row.phone,
        									hobbiesName = row.hobbies,
        									is_public = row.is_public
    		)>
   
    		<cfset arrayAppend(validatedData, result)>
	</cfloop>
	<cfdump var="#result#" abort>

	
	
	
	
	
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>

