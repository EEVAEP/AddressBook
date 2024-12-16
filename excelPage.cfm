<cfset variables.fileName = "ContactDataExport.xlsx">	
<cfset contactData = session.contactData>
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
	<cfset spreadsheetSetCellValue(spreadsheetObj, "EMAIL", 1, 6)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "PHONE", 1, 7)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "STREET",1,8)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "PINCODE",1,9)>
	<cfset spreadsheetSetCellValue(spreadsheetObj, "HOBBIES", 1,10)>

	<cfset SpreadsheetFormatRow (spreadsheetObj, dataHead, 1)>
	

	
	<cfloop from="1" to="#ArrayLen(contactData)#" index="i">
		<cfset fullName = contactData[i].firstname & " " & contactData[i].lastname>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].titlename#", i+1, 1)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].firstname#", i+1, 2)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].lastname#", i+1, 3)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].gendername#", i+1, 4)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].dob#", i+1, 5)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].email#", i+1, 6)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].phone#", i+1, 7)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].street#", i+1, 8)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].pincode#", i+1, 9)>
		<cfset spreadsheetSetCellValue(spreadsheetObj, "#contactData[i].hobbyNames#", i+1, 10)>

		<cfset SpreadsheetSetRowHeight(spreadsheetObj,i+1,20)>
	</cfloop>

	<cfloop from="3" to="#3+ArrayLen(contactData)#" index="i">
		<cfif i%2 NEQ 0>
			<cfset SpreadsheetFormatRow(spreadsheetObj,data,i)>
		</cfif>
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
	

	<cfset binary = SpreadsheetReadBinary(spreadsheetObj)>

	<cfheader name="Content-Disposition" value="attachment; filename=#variables.fileName#">
	
	<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" variable="#binary#" >