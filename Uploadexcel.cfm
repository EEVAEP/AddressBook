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
		excludeHeaderRow = "true"
		headerrow = "1"> 

	<cfset invalidRows = []>
	<cfset validRows = []>
	
<<<<<<< HEAD
<<<<<<< Updated upstream
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
=======

	<cfset application.titleQuery = application.userService.getTitleName()>
	<cfset application.genderQuery = application.userService.getGenderName()>
	<cfset application.hobbyQuery = application.userService.getHobbyName()>
	

	<cfset application.titleQuery = application.userService.getTitleName()>
	<cfset application.genderQuery = application.userService.getGenderName()>
	<cfset application.hobbyQuery = application.userService.getHobbyName()>
	

	<cfloop query = "excelData">
		<cfset result = application.userService.validateAddEditContactDetails(titleName = excelData.TITLE,
        									firstName = excelData.FIRSTNAME,
        									lastName = excelData.LASTNAME,
       	 									genderName = excelData.GENDER,
        									dob = excelData.DOB,
        									address = excelData.ADDRESS,
        									street = excelData.STREET,
        									pincode = excelData.PINCODE,
        									email = excelData.EMAIL,
        									phone = excelData.PHONE,
        									hobbiesName = excelData.HOBBIES,
        									is_public = excelData.PUBLIC,
										is_excel = 1
		
    		)>
		<cfset excelDetails =  {
			"titleName" : excelData.TITLE,
			"firstName" : excelData.FIRSTNAME,
			"lastName" : excelData.LASTNAME,
			"genderName" : excelData.GENDER,
			"dob" : excelData.DOB,
			"address" : excelData.ADDRESS,
			"street" : excelData.STREET,
        		"pincode" : excelData.PINCODE,
        		"email" : excelData.EMAIL,
        		"phone" : excelData.PHONE,
        		"hobbiesName" : excelData.HOBBIES,
        		"is_public" : excelData.PUBLIC,
			"is_excel": 1,
			"remarks" : ""
		
>>>>>>> Stashed changes
		}>
		<cfset arrayAppend(excelDataArray, rowStruct)>
	</cfloop>
=======
>>>>>>> 369ee314bf05dd39e49cc2b8b9399a4e16a3c6d4

	<cfloop query = "excelData">
		<cfset result = application.userService.validateAddEditContactDetails(titleName = excelData.TITLE,
        									firstName = excelData.FIRSTNAME,
        									lastName = excelData.LASTNAME,
       	 									genderName = excelData.GENDER,
        									dob = excelData.DOB,
        									address = excelData.ADDRESS,
        									street = excelData.STREET,
        									pincode = excelData.PINCODE,
        									email = excelData.EMAIL,
        									phone = excelData.PHONE,
        									hobbiesName = excelData.HOBBIES,
        									is_public = excelData.PUBLIC,
										is_excel = 1
		
    		)>
		<cfset excelDetails =  {
			"titleName" : excelData.TITLE,
			"firstName" : excelData.FIRSTNAME,
			"lastName" : excelData.LASTNAME,
			"genderName" : excelData.GENDER,
			"dob" : excelData.DOB,
			"address" : excelData.ADDRESS,
			"street" : excelData.STREET,
        		"pincode" : excelData.PINCODE,
        		"email" : excelData.EMAIL,
        		"phone" : excelData.PHONE,
        		"hobbiesName" : excelData.HOBBIES,
        		"is_public" : excelData.PUBLIC,
			"is_excel": 1,
			"remarks" : ""
		
		}>
		
		
		<cfif arrayLen(result.errors) GT 0>
			
			<cfset excelDetails.remarks  = ArrayToList(result.errors)>
			<cfset arrayAppend(invalidRows, excelDetails)>
			
			
		<cfelse>
			<cfset excelDetails.remarks  = result.remarks>
			<cfset arrayAppend(validRows, excelDetails)>
			
		</cfif>
		
		
		
		
	</cfloop>
	<cfset variables.fileName = "Upload_Result.xlsx">	
	
	<cfset spreadsheetObj = SpreadsheetNew("AddressBook", true)>

	<cfset myFormat=StructNew()>
	<cfset myFormat.bold="true">
	<cfset myFormat.alignV="center">

	<cfset data={color="white",fgcolor="grey_50_percent", alignV="center"}>
	<cfset dataHead={color="white",fgcolor="grey_50_percent",bold="true",alignV="center"}>

	<cfset spreadsheetSetCellValue(spreadsheetObj, "TITLE", 1, 1)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "FIRSTNAME", 1, 2)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "LASTNAME", 1, 3)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "GENDER", 1, 4)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "DOB", 1, 5)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "ADDRESS", 1, 6)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "EMAIL", 1, 7)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "PHONE", 1, 8)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "STREET",1,9)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "PINCODE",1,10)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "HOBBIES", 1,11)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "PUBLIC", 1,12)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "REMARKS", 1,13)>

	<cfset SpreadsheetFormatRow (spreadsheetObj, dataHead, 1)>
	

	<cfset count = 0>
	<cfloop from="1" to="#ArrayLen(invalidRows)#" index="i">
		<cfset fullName = invalidRows[i].firstName & " " & invalidRows[i].lastName>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].titleName#", i+1, 1)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].firstName#", i+1, 2)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].lastName#", i+1, 3)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].genderName#", i+1, 4)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].dob#", i+1, 5)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].address#", i+1, 6)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].email#", i+1, 7)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].phone#", i+1, 8)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].street#", i+1, 9)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].pincode#", i+1, 10)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].hobbiesName#", i+1, 11)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].is_public#", i+1, 12)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#invalidRows[i].remarks#", i+1, 13)>
		<cfset count = count+1>

		<cfset SpreadsheetSetRowHeight(spreadsheetObj,i+1,20)>
	</cfloop>
	<cfset count = count+1>
	<cfloop from="1" to="#ArrayLen(validRows)#" index="i">
		<cfset fullName = validRows[i].firstName & " " & validRows[i].lastName>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].titleName#", count+i, 1)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].firstName#", count+i, 2)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].lastName#", count+i, 3)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].genderName#", count+i, 4)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].dob#", count+i, 5)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].address#", count+i, 6)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].email#", count+i, 7)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].phone#", count+i, 8)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].street#", count+i, 9)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].pincode#", count+i, 10)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].hobbiesName#", count+i, 11)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].is_public#", count+i, 12)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#validRows[i].remarks#", count+i, 13)>

		<cfset SpreadsheetSetRowHeight(spreadsheetObj,count+i,20)>
	</cfloop>

	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,1,25)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,2,25)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,3,25)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,4,25)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,5,20)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,6,25)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,7,25)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,8,35)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,9,25)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,10,20)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,11,20)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,12,20)>
	<cfset SpreadSheetSetColumnWidth(spreadsheetobj,13,30)>

	<cfset binary = SpreadsheetReadBinary(spreadsheetObj)>

	
	<cfset resultFolderPath = ExpandPath('./resultFiles/')>
	<cfset resultFilePath = resultFolderPath & fileName>

	<cfspreadsheet action="write"
                filename="#resultFilePath#"
                name="spreadsheetObj"
                overwrite="true">
	
	
	
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>

