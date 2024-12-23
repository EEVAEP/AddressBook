<cfcomponent>
	
	<cffunction name="hashPassword" access="private">
		<cfargument name="pass" type="string" required="true">
		<cfargument name="salt" type="string" required="true">
		<cfset local.saltedPass = arguments.pass & arguments.salt>
		<cfset local.hashedPass = hash(local.saltedPass,"SHA-256","UTF-8")>	
		<cfreturn local.hashedPass>
	</cffunction>

	
	<cffunction name="decryptId" access="public" returntype="string" output="false">
    		<cfargument name="encryptedId" type="string" required="true">
    		<cfset local.decryptedId = decrypt(arguments.encryptedId, application.encryptionKey, "AES", "Hex")>
    		<cfreturn local.decryptedId>
	</cffunction>
	

	
	<cffunction name="validateRegisterInput" access="public" returntype="array">
        
        	<cfargument name="fullname" type="string" required="true">
		<cfargument name="email" type="string" required="true">
        	<cfargument name="username" type="string" required="true">
        	<cfargument name="password" type="string" required="true">
        	<cfargument name="confirmPassword" type="string" required="true">

		<cfset local.errors = []>

        
        	<cfif len(trim(arguments.fullname)) EQ 0>
            		<cfset arrayAppend(local.errors, "*Fullname is required")>
        	<cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)*$", arguments.fullname)>
			<cfset arrayAppend(local.errors, "*Enter a valid fullname")>
        	</cfif>

        
        	<cfif len(trim(arguments.email)) EQ 0>
            		<cfset arrayAppend(local.errors, "*Email is required")>
        	<cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", arguments.email)>
            		<cfset arrayAppend(local.errors, "*Enter a valid email")>
        	</cfif>

       
        	<cfif len(trim(arguments.username)) EQ 0>
            		<cfset arrayAppend(local.errors, "*Please enter the username")>
        	<cfelseif NOT reFindNoCase("^[a-zA-Z_][a-zA-Z0-9_]{3,13}$", arguments.username)>
            		<cfset arrayAppend(local.errors, "*Please enter a valid username")>
        	</cfif>

       
        	<cfif len(trim(arguments.password)) EQ 0>
            		<cfset arrayAppend(local.errors, "*Please enter the password")>
        	<cfelseif NOT reFindNoCase("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$", arguments.password)>
            		<cfset arrayAppend(local.errors, "*Please enter a valid password (minimum 8 characters, 1 lowercase, 1 uppercase, 1 special character)")>
        	</cfif>

        
        	<cfif len(trim(arguments.confirmPassword)) EQ 0>
        		<cfset arrayAppend(local.errors, "*Password confirmation is required")>
        	<cfelseif arguments.confirmPassword NEQ arguments.password>
            		<cfset arrayAppend(local.errors, "*Password confirmation does not match the password")>
        	</cfif>

        
        	<cfreturn local.errors>
	</cffunction>

	
	<cffunction name="registerUser" returntype="struct">
    		<cfargument name="fullname" type="string" required="true">
		<cfargument name="email" type="string" required="true">
        	<cfargument name="username" type="string" required="true">
        	<cfargument name="password" type="string" required="true">
        	
		<cfset local ={}>

		<cfquery name="local.qryCheckUser">
        		SELECT *
        		FROM 
				register
        		WHERE 
				username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
			AND	email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
    		</cfquery>

		<cfif local.qryCheckUser.recordCount EQ 0>

			<cfset local.salt = generateSecretKey("AES")>

			<cfset local.hashedPassword = hashPassword(arguments.password, local.salt)>

			<cfquery>
        			INSERT INTO 
					register (fullname, email, username, password, salt)
        			VALUES(
					<cfqueryparam value="#arguments.fullname#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">,
            				<cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#local.salt#" cfsqltype="cf_sql_varchar">
        			)
    			</cfquery>
			
			<cfset local.result.success = true>
			<cfset local.result.message = "Registration successful. Please login">

		<cfelse>
			<cfset local.result.success = false>
			<cfset local.result.message = "User already exists. Please login">
		</cfif>

		<cfreturn local.result>

	</cffunction>

	

	<cffunction name="validateUserLogin" access="public" returntype="struct">
    		<cfargument name="username" required="true" type="string">
    		<cfargument name="password" required="true" type="string">
		
		
    		<cfquery name="local.qryLogin">
        		SELECT 
				id AS userid,
				username,
				password,
				salt
        		FROM 
				register
        		WHERE 
				username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
        		
    		</cfquery>
		<cfif local.qryLogin.recordCount EQ 1>
			<cfset local.salt = local.qryLogin.salt>
			<cfset local.hashedPassword  = hashPassword(arguments.password, local.salt)>
			<cfset local.result = {}>
			
			<cfif local.hashedPassword  EQ  local.qryLogin.password>
        			<cfset local.result['userid'] = local.qryLogin.userid>
				<cfset local.result['username'] = local.qryLogin.username>
			</cfif>
		</cfif>
		<cfreturn local.result>
	</cffunction>



	<cffunction name="getTitleName" access="public" returntype="query">
        	<cfquery name="local.titleName">
            		SELECT 
				idtitle,
				titlename
			 FROM 
				title
        	</cfquery>
        	<cfreturn local.titleName>
    	</cffunction>

	
	<cffunction name="getGenderName" access="public" returntype="query">
		<cfquery name="local.genderTitle" >
			SELECT
				idgender,
				gendername
			FROM
				gender
				
		</cfquery>
		<cfreturn local.genderTitle>
	</cffunction>


	<cffunction name="getHobbyName" access="public" returntype="query">
		<cfquery name="local.insertHobby">
			SELECT
				idhobby,
				hobby_name
			FROM
				hobbies_sample
		</cfquery>
		<cfreturn local.insertHobby>
	
	</cffunction>

	
	
	<cffunction name="validateAddEditContactDetails" access="public" returntype="any" returnformat="JSON">
		
		
		<cfargument name="title" type="numeric" required="false">
		<cfargument name="titleName" type="string" required="false">
		<cfargument name="firstName" type="string" required="true">
        	<cfargument name="lastName" type="string" required="true">
        	<cfargument name="gender" type="numeric" required="false">
		<cfargument name="genderName" type="string" required="false">	
        	<cfargument name="dob" type="string" required="true">
		<cfargument name="photo" type="string" required="false">
		<cfargument name="address" type="string" required="true">
		<cfargument name="street" type="string" required="true">
		<cfargument name="pincode" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="hobbies" type="string" required="false">
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
		<cfargument name="hobbiesName" type="string" required="true">
=======
		<cfargument name="hobbiesName" type="string" required="false">
>>>>>>> 369ee314bf05dd39e49cc2b8b9399a4e16a3c6d4
		<cfargument name="is_public" type="string" required="true">
=======
		<cfargument name="hobbiesName" type="string" required="false">
		<cfargument name="is_public" type="numeric" required="true">
>>>>>>> Stashed changes
=======
		<cfargument name="hobbiesName" type="string" required="false">
		<cfargument name="is_public" type="numeric" required="true">
>>>>>>> Stashed changes
		<cfargument name="contactId" type="string" required="false">
		<cfargument name="is_excel" type="numeric" required="false">

		
		
		<cfset local.result = {
			"errors" : [],
			"remarks" : ""
		}>

	
<<<<<<< HEAD
		
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    		<cfset local.titleQuery = getTitleName()>
=======
		<cfset local.titleQuery = getTitleName()>
>>>>>>> 369ee314bf05dd39e49cc2b8b9399a4e16a3c6d4

=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
		<cfif structKeyExists(arguments, "title")>
			<cfset local.validTitles = []>
    			<cfloop query="application.titleQuery">
        			<cfset arrayAppend(local.validTitles, application.titleQuery.idtitle)>
    			</cfloop>
			<cfif NOT arrayContains(local.validTitles, arguments.title)>
        			<cfset arrayAppend(local.result.errors, "*The title must be one of the following: " & arrayToList(local.validTitles, ", "))>
    			</cfif>
		</cfif>
		<cfif structKeyExists(arguments, "titleName")>
			<cfset local.validTitleNames = []>
			<cfloop query="application.titleQuery">
        			<cfset arrayAppend(local.validTitleNames, application.titleQuery.titlename)>
    			</cfloop>
			<cfif NOT arrayContains(local.validTitleNames, arguments.titleName)>
        			<cfset arrayAppend(local.result.errors, "*The title must be one of the following: " & arrayToList(local.validTitleNames, ", "))>
			<cfelse>
				<cfquery name="local.getTitleId" dbtype="query">
            				SELECT 
                				idtitle
            				FROM 
                				application.titleQuery
           				WHERE 
                				titlename = <cfqueryparam value="#arguments.titleName#" cfsqltype="cf_sql_varchar">
        			</cfquery>
				<cfif local.getTitleId.recordCount EQ 1>
            				<cfset arguments['title'] = local.getTitleName.idtitle>
				</cfif>
    			</cfif>
		</cfif>
	
			

		<cfif trim(arguments.firstName) EQ "">
        		<cfset arrayAppend(local.result.errors, "*First Name is required.")>
    		<cfelseif not reFind("^[A-Za-z]+$", trim(arguments.firstName))>
        		<cfset arrayAppend(local.result.errors, "*First Name cannot contain numbers or special characters.")>
    		</cfif>


		<cfif trim(arguments.lastName) EQ "">
    			<cfset arrayAppend(local.result.errors, "*Last Name is required.")>
		<cfelseif not reFind("^[A-Za-z]+(\s[A-Za-z]+)*$", trim(arguments.lastName))>
    			<cfset arrayAppend(local.result.errors, "*Last Name cannot contain numbers or special characters.")>
		</cfif>



		
		<cfif structKeyExists(arguments, "gender")>
			<cfset local.validGender = []>
			<cfloop query="application.genderQuery">
				<cfset arrayAppend(local.validGender, application.genderQuery.idgender)>
			</cfloop>
			<cfif NOT arrayContains(local.validGender, arguments.gender)>
				<cfset arrayAppend(local.result.errors, "*Enter a valid gender")>
			</cfif>	
		</cfif>
		<cfif structKeyExists(arguments, "genderName")>
			<cfset local.validGenderName = []>
			<cfloop query="application.genderQuery">
				<cfset arrayAppend(local.validGenderName, application.genderQuery.gendername)>
			</cfloop>
			<cfif NOT arrayContains(local.validGenderName, arguments.genderName)>
				<cfset arrayAppend(local.result.errors, "*Enter a valid gender")>
			<cfelse>
				<cfquery name="local.getGenderId" dbtype="query">
            				SELECT 
                				idgender
            				FROM 
                				application.genderQuery
           				WHERE 
                				gendername = <cfqueryparam value="#arguments.genderName#" cfsqltype="cf_sql_varchar">
        			</cfquery>
				<cfif local.getGenderId.recordCount EQ 1>
            				<cfset arguments['gender'] = local.getGenderId.idgender>
				</cfif>
    			
			</cfif>	
		</cfif>
		
		


		<cfif not isDate(arguments.dob)>
        		<cfset arrayAppend(local.result.errors, "*Date of Birth must be a valid date.")>
    		</cfif>


		<cfset local.uploadPath = ExpandPath('./uploads/')>
		
		<cfif structKeyExists(form, "photo") AND len(form.photo) GT 0 >
			
			<cffile action="upload" fileField="photo" destination="#local.uploadPath#" nameConflict="makeUnique" result="local.fileUploadResult">
			<cfset local.originalFileName = local.fileUploadResult.serverFile>
		

			<cfset local.allowedFormats = "jpg,jpeg,png,jfif">
    			<cfset local.imageExtension = ListLast(local.originalFileName, ".")> 
		
			<cfif NOT ListFindNoCase(local.allowedFormats, local.imageExtension)>
        			<cfset arrayAppend(local.result.errors, "*Invalid image format. Only JPG, JPEG, JFIF and PNG are allowed")>
			<cfelse>
				<cfset local.uploadPath = ExpandPath('./Temp/')>
				<cffile action="upload" fileField="photo" destination="#local.uploadPath#" nameConflict="makeUnique" result="local.fileUploadResult">
				<cfset local.photopath = "./Temp/" & local.fileUploadResult.serverFile>
				<cfset arguments['photo'] = local.photopath>
				
    			</cfif>
		<cfelseif structKeyExists(arguments, 'contactId') AND len(arguments.contactId) GT 0 AND arguments.photo EQ "">
			<cfset local.decryptedId = decryptId(arguments.contactId)>
			
			<cfquery name="local.getPhotoPath">
				SELECT 
					photo
				FROM
					contact
				WHERE
					idcontact = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
		
			</cfquery>

			<cfset arguments['photo'] = local.getPhotoPath.photo>
		<cfelseif structKeyExists(arguments, "is_excel") AND arguments.is_excel EQ 1 AND  (NOT structKeyExists(arguments, 'contactId'))>
			<cfset local.photopath = "./Temp/user.png">
			<cfset arguments['photo'] = local.photopath>
		<cfelse>
			<cfif NOT structKeyExists(arguments, "is_excel") OR arguments.is_excel NEQ 1>
				<cfset arrayAppend(local.result.errors, "*Image is required")>
			</cfif>
		</cfif>



		<cfif trim(arguments.address) EQ "">
			<cfset arrayAppend(local.result.errors, "*Address is required.")>
		</cfif>

		
		<cfif trim(arguments.street) EQ "">
			<cfset arrayAppend(local.result.errors, "*Street is required.")>
		</cfif>

		<cfif trim(arguments.pincode) EQ "" OR (NOT isNumeric(arguments.pincode))>
			<cfset arrayAppend(local.result.errors, "*pincode must be numeric")>
		<cfelseif len(arguments.pincode) GT 8>
			<cfset arrayAppend(local.result.errors, "*pincode length must be less than 9")>
		</cfif>

		

		
		<cfquery name="local.getContactEmail">
			SELECT idcontact
			FROM
				contact
			WHERE 
				email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
<<<<<<< Updated upstream
<<<<<<< Updated upstream
		<cfif local.getContactEmail.recordCount GT 0 AND NOT structKeyExists(arguments, 'contactId')>
<<<<<<< HEAD
			<cfset arrayAppend(local.errors, "*Email already exists")>
=======
=======
>>>>>>> Stashed changes
		
		<cfif local.getContactEmail.recordCount GT 0 AND (NOT structKeyExists(arguments, 'contactId') OR len(trim(arguments.contactId)) EQ 0)>
=======
>>>>>>> 369ee314bf05dd39e49cc2b8b9399a4e16a3c6d4
			
			<cfif NOT structKeyExists(arguments, "is_excel")>
				<cfset arrayAppend(local.result.errors, "*Email already exists")>
			<cfelse>
				<cfset local.result.remarks = "UPDATED">
				<cfset arguments['contactId'] = local.getContactEmail.idcontact>
			</cfif>
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> 369ee314bf05dd39e49cc2b8b9399a4e16a3c6d4
		<cfelseif len(trim(arguments.email)) EQ 0>
			<cfset arrayAppend(local.result.errors, "*Email is required")>
		<cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", arguments.email)>
            		<cfset arrayAppend(local.result.errors, "*Enter a valid email")>
		<cfelse>
			<cfset local.result.remarks = "ADDED">
			
		</cfif>

		

		<cfif trim(arguments.phone) EQ "" OR not reFind("^\d{10}$", arguments.phone)>
			
    			<cfset arrayAppend(local.result.errors, "*Phone number must contain exactly 10 digits.")>
		</cfif>
		

		<cfif structKeyExists(arguments, "hobbies")>
			
			<cfif Len(arguments.hobbies) EQ 0>
				<cfset arrayAppend(local.result.errors, "*Hobby is required")>
			<cfelse>
				<cfset local.validHobbies = []>
				
				<cfloop query="application.hobbyquery">
					<cfset ArrayAppend(local.validHobbies, application.hobbyQuery.idhobby)>
				</cfloop>
				<cfset local.selectedHobbiesArray = ListToArray(arguments.hobbies, ",")>
				<cfloop array="#local.selectedHobbiesArray#" index="local.hobbyID">
        				<cfif NOT arrayContains(local.validHobbies, local.hobbyID)>
            					<cfset arrayAppend(local.result.errors, "*Invalid hobby selected: " & local.hobbyID)>
        				</cfif>
    				</cfloop>

			</cfif>
		</cfif>

		<cfif structKeyExists(arguments, "hobbiesName")>
			<cfset local.validHobbiesName = []>
			<cfset local.validHobbiesList = valueList(application.hobbyQuery.hobby_name)>
			<cfset local.invalidHobby = []>
<<<<<<< HEAD
<<<<<<< Updated upstream
<<<<<<< Updated upstream
			<cfset local.HobbiesArray = ListToArray(arguments.hobbiesName)>
=======
>>>>>>> 369ee314bf05dd39e49cc2b8b9399a4e16a3c6d4
			
			
			<cfloop list="#arguments.hobbiesName#" index="local.i">
				<cfset local.i = trim(local.i)>
        			<cfif NOT listFindNoCase(local.validHobbiesList, local.i)>
					
					<cfset arrayAppend(local.invalidHobby, local.i)>
				</cfif>
				
        			
    			</cfloop>
=======
=======
>>>>>>> Stashed changes
			<cfloop list="#arguments.hobbiesName#" index="local.i">
				<cfset local.i = trim(local.i)>
        			<cfif NOT listFindNoCase(local.validHobbiesList, local.i)>
					
					<cfset arrayAppend(local.invalidHobby, local.i)>
				</cfif>
			</cfloop>
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
			
			<cfif arrayLen(local.invalidHobby) GT 0>
				<cfset arrayAppend(local.result.errors, "*Enter a valid hobby")>
			<cfelse>
				 <cfquery name="local.getHobbyIds" dbtype="query">
            				SELECT 
                				idhobby 
            				FROM 
                				application.hobbyquery
            				WHERE 
                				hobby_name IN (<cfqueryparam value="#arguments.hobbiesName#" cfsqltype="cf_sql_varchar" list="true">)
        			</cfquery>
				<cfif local.getHobbyIds.recordCount GT 0>
            				<cfset local.hobbyIdList = valueList(local.getHobbyIds.idhobby)>
           				<cfset arguments['hobbies'] = local.hobbyIdList>
				</cfif>
			
			</cfif>  
		</cfif>
		

		<cfset local.isValidPublic  = ["0", "1"]>
		<cfif NOT ArrayContains(local.isValidPublic, arguments.is_public)>
			<cfset arrayAppend(local.result.errors, "*Invalid value for Public")>
		</cfif>
		   
		

		<cfif arrayLen(local.result.errors) EQ 0>
			
			<cfset local.addUser=createOrUpdateContact(argumentCollection=arguments)>
				
			<cfreturn local.result>
		<cfelse>
			<cfreturn local.result>
		
		</cfif>
		

	</cffunction>
		

	<cffunction name="createOrUpdateContact" access="public">
		
		<cfargument name="title" type="string" required="true">
		<cfargument name="firstName" type="string" required="true">
        	<cfargument name="lastName" type="string" required="true">
        	<cfargument name="gender" type="string" required="true">
        	<cfargument name="dob" type="string" required="true">
		<cfargument name="photo" type="string" required="false">
		<cfargument name="address" type="string" required="true">
		<cfargument name="street" type="string" required="true">
		<cfargument name="pincode" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">
		<cfargument name="hobbies" type="string" required="false">
		<cfargument name="is_public" type="numeric" required="true">
		<cfargument name="contactId" type="string" required="false" default="">
		<cfargument name="is_excel" type="numeric" required="false">
		
		
		
		
		<cfif StructKeyExists(arguments, "contactId") AND arguments.contactId NEQ "" >
			<cfif NOT structKeyExists(arguments, "is_excel")>
				<cfset local.decryptedId = decryptId(arguments.contactId)>
			<cfelse>
				<cfset local.decryptedId = arguments.contactId>
			</cfif>
			<cfquery>
        			UPDATE contact
				SET 
					titleid = <cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_integer">,
					firstname = <cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
					lastname = <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
					genderid = <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_integer">,
					dob = <cfqueryparam value="#arguments.dob#" cfsqltype="cf_sql_date">,
					photo = <cfqueryparam value="#arguments.photo#" cfsqltype="cf_sql_varchar">,
					address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
					street = <cfqueryparam value="#arguments.street#" cfsqltype="cf_sql_varchar">,
					pincode = <cfqueryparam value="#arguments.pincode#" cfsqltype="cf_sql_integer">,
					email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
					phone = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">,
					iduser = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
					is_public = <cfqueryparam value="#arguments.is_public#" cfsqltype="cf_sql_integer">
					
				WHERE
					idcontact = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
				AND
					iduser = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
            				
        		</cfquery>

			
			<cfquery name="local.existingHobbies">
				SELECT
					hobby_id
				FROM
					user_hobbies
				WHERE
					contact_id = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset local.existingHobbiesArray = ValueList(local.existingHobbies.hobby_id)>
			<cfset local.existingHobbiesArray = ListToArray(local.existingHobbiesArray, ",")>
			<cfset local.selectedHobbiesArray = ListToArray(arguments.hobbies, ",")>
			
			
			
			<cfset local.hobbiesToAdd = []>
			<cfloop array="#local.selectedHobbiesArray#" index="local.selectedHobby">
    				<cfif NOT ArrayContains(local.existingHobbiesArray, local.selectedHobby)>
        				<cfset ArrayAppend(local.hobbiesToAdd, local.selectedHobby)>
    				</cfif>
			</cfloop>

			<cfquery name="local.DeleteUserHobby">
					DELETE 
					FROM user_hobbies
					WHERE 
						contact_id = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
					AND 
						
						hobby_id NOT IN ( <cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_integer" list="true">)
						
			</cfquery>

			<cfif arrayLen(local.hobbiesToAdd) GT 0>
				<cfquery name="local.AddUserHobby">
					INSERT INTO 
						user_hobbies(contact_id,
								hobby_id)
					VALUES
					<cfloop array="#local.hobbiesToAdd#" item="local.hobbyIdToAdd" index="local.i">
						(
							<cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#local.hobbyIdToAdd#" cfsqltype="cf_sql_varchar">	
						)
						<cfif local.i NEQ ArrayLen(local.hobbiesToAdd)>,</cfif>
					</cfloop>;
				</cfquery>
			</cfif>	
			

		<cfelse>
			
			<cfquery name="local.insertContact" result="local.r">
        			INSERT INTO 
					contact (titleid, 
						firstname, 
						lastname, 
						genderid, 
						dob, 
						photo, 
						address, 
						street, 
						pincode, 
						email, 
						phone, 
						iduser,
						is_public)
        			VALUES(
					
					<cfqueryparam value="#arguments.title#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#arguments.dob#" cfsqltype="cf_sql_date">,
					<cfqueryparam value="#arguments.photo#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.street#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.pincode#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#arguments.is_public#" cfsqltype="cf_sql_integer">
            				
        			)
    			</cfquery>
			
			
			<cfset local.selectedHobbiesArray = arguments.hobbies>
			<cfloop list="#local.selectedHobbiesArray#" index="local.hobbyID" delimiters=",">
    				<cfquery name="local.insertUserHobby">
        				INSERT INTO user_hobbies (contact_id, hobby_id)
        				VALUES (
            					<cfqueryparam value="#local.r.generatedkey#" cfsqltype="cf_sql_integer">,
            					<cfqueryparam value="#local.hobbyID#" cfsqltype="cf_sql_integer">
        				)
    				</cfquery>
			</cfloop>
			
		</cfif>
	
	</cffunction>

	<cffunction name="getDataById" access="remote" returntype="any" returnformat="JSON">	
		<cfargument name="contactId" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.contactId)>
		<cftry>
			<cfquery name="local.getCont">
				SELECT 
					c.idcontact,
					c.titleid,
					c.firstname,
					c.lastname,
                        		c.genderid,
                        		c.dob,
                        		c.photo,
                        		c.address,
					c.street,
					c.pincode,
					c.email,  
					c.phone,
					t.titlename,
					g.gendername,
					c.is_public,
					GROUP_CONCAT(h.idhobby) AS hobby_ids,   
					GROUP_CONCAT(h.hobby_name) AS hobby_names
				FROM contact c
				INNER JOIN
					title t ON c.titleid = t.idtitle
				INNER JOIN
					gender g ON c.genderid = g.idgender
				INNER JOIN 
        				user_hobbies uh ON c.idcontact = uh.contact_id
				INNER JOIN 
        				hobbies_sample h ON uh.hobby_id = h.idhobby
				WHERE 
					c.idcontact=<cfqueryparam value=#decryptedId#  cfsqltype="cf_sql_integer">				
			</cfquery>
			
			<cfset local.singleData = {}>
			<cfif local.getCont.recordCount gt 0>
				<cfset local.singleData = {
					"idcontact" : local.getCont.idcontact,
					"titleid" : local.getCont.titleid,
					"titlename": local.getCont.titlename,
					"firstname": local.getCont.firstname,
					"lastname": local.getCont.lastname,
					"genderid": local.getCont.genderid,
					"gendername": local.getCont.gendername,
					"dob": local.getCont.dob,
					"photo": local.getCont.photo,
					"address": local.getCont.address,
					"street": local.getCont.street,
					"pincode": local.getCont.pincode,
					"email": local.getCont.email,
					"phone": local.getCont.phone,
					"titlename": local.getCont.titlename,
					"gendername": local.getCont.gendername,
					"is_public": local.getCont.is_public,
					"hobby_ids": local.getCont.hobby_ids,
					"hobby_names": local.getCont.hobby_names
				}>
			</cfif>

			<cfreturn local.singleData>
		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>
		</cftry>	

	</cffunction>

	<cftry>

	<cffunction name="getTotalUserDetails" access="public" returntype="query">
		<cfset var local= {}>
		<cfquery name="local.qryPages">
			SELECT 
				c.idcontact,
				c.titleid,
				c.genderid,
				CONCAT(firstname," ", lastname) AS Fullname,
				c.firstname,
				c.lastname,
				CONCAT(t.titlename," ", c.firstname," ", c.lastname) AS titleFullname, 
				c.email, 
				c.phone,
				c.photo,
				c.dob,
				c.address,
				c.pincode,
				c.street,
				t.titlename,
				g.gendername,
				c.iduser,
				c.is_public,
				GROUP_CONCAT(h.idhobby) AS hobby_ids,
				GROUP_CONCAT(h.hobby_name) AS hobby_names
			FROM contact c
			INNER JOIN
				title t ON c.titleid = t.idtitle
			INNER JOIN
				gender g ON c.genderid = g.idgender
			INNER JOIN 
        			user_hobbies uh ON c.idcontact = uh.contact_id
			INNER JOIN 
        			hobbies_sample h ON uh.hobby_id = h.idhobby
			WHERE 
				(iduser = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
				OR c.is_public = 1)
 
			GROUP BY c.idcontact
		</cfquery>

		<cfreturn local.qryPages>
	</cffunction>
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>


	

	<cffunction name="deleteContact" access="remote" returnformat = "JSON" output="false">
    		<cfargument name="contactId" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.contactId)>
    
    		<cftry>
			
			<cfquery name="deleteContactData">
            			DELETE 
				FROM contact 
            			WHERE 
					idcontact = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
				AND
					iduser = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
			</cfquery>
			
       			<cfset local.response = {status="success", message="Contact deleted successfully."}>
        		<cfreturn local.response>
    			<cfcatch>
				
        			<cfset local.response = {status="error", message="An error occurred while deleting the contact."}>
        			<cfreturn local.response>
    			</cfcatch>
		</cftry>
	</cffunction>


</cfcomponent>



