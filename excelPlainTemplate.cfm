<cfset variables.fileName = "ContactDataExport.xlsx">	
<cfset contactData = session.contactData>
<cfset spreadsheetObj = SpreadsheetNew("AddressBook", true)>

<cfset myFormat=StructNew()>
<cfset myFormat.bold="true">
<cfset myFormat.alignV="center">

<cfset data={color="black", alignV="center"}>
<cfset dataHead={color="white",fgcolor="grey_50_percent",bold="true",alignV="center"}>


<cfset spreadsheetSetCellValue(spreadsheetObj, "TITLE", 1, 1)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "FIRSTNAME", 1, 2)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "LASTNAME", 1, 3)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "GENDER", 1, 4)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "DOB", 1, 5)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "ADDRESS", 1, 6)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "STREET",1,7)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "EMAIL",1,8)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "PINCODE", 1, 9)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "PHONE", 1, 10)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "HOBBIES", 1,11)>
<cfset spreadsheetSetCellValue(spreadsheetObj, "IS_PUBLIC", 1,12)>

<cfset SpreadsheetFormatRow (spreadsheetObj, data, 1)>



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
	
<cfset binary = SpreadsheetReadBinary(spreadsheetObj)>
<cfheader name="Content-Disposition" value="attachment; filename=#variables.fileName#">
<cfcontent type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" variable="#binary#" >