<cfcomponent>
	
	<cffunction name="hashPassword" returntype="string">
    		<cfargument name="password" required="true" type="string">
    		<cfset local.hashedPassword = hash(arguments.password, "SHA-512")>
    		<cfreturn local.hashedPassword>
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
			<cfset local.hashedPassword = hashPassword(arguments.password)>

			<cfquery>
        			INSERT INTO 
					register (fullname, email, username, password)
        			VALUES(
					<cfqueryparam value="#arguments.fullname#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">,
            				<cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">
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
		
		
    
        	<cfset local.hashedPassword = hashPassword(arguments.password)>
		
		<cfquery name="local.qryLogin">
        		SELECT 
				id AS userid,
				username
        		FROM 
				register
        		WHERE 
				username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
        		AND 
				password = <cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">
    		</cfquery>
	
		<cfset local.result = {}>
		

    		<cfif local.qryLogin.recordCount EQ 1>
        		<cfset local.result['userid'] = local.qryLogin.userid>
			<cfset local.result['username'] = local.qryLogin.username>
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

	

	<cffunction name="validateAddEditContactDetails" access="remote" returntype="any" returnformat="JSON">
			
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
		<cfargument name="hobbies" type="string" required="true">
		<cfargument name="is_public" type="string" required="true">
		<cfargument name="contactId" type="string" required="false">

		

		<cfset local.errors = []>


		<cfset local.validTitles = []>
    		<cfset local.titleQuery = getTitleName()>
    		<cfloop query="local.titleQuery">
        		<cfset arrayAppend(local.validTitles, local.titleQuery.idtitle)>
    		</cfloop>
		<cfif NOT arrayContains(local.validTitles, arguments.title)>
        		<cfset arrayAppend(local.errors, "*The title must be one of the following: " & arrayToList(local.validTitles, ", "))>
    		</cfif>
	
		
		<cfif trim(arguments.firstName) EQ "">
        		<cfset arrayAppend(local.errors, "*First Name is required.")>
    		<cfelseif not reFind("^[A-Za-z]+$", trim(arguments.firstName))>
        		<cfset arrayAppend(local.errors, "*First Name cannot contain numbers or special characters.")>
    		</cfif>


		<cfif trim(arguments.lastName) EQ "">
    			<cfset arrayAppend(local.errors, "*Last Name is required.")>
		<cfelseif not reFind("^[A-Za-z]+(\s[A-Za-z]+)*$", trim(arguments.lastName))>
    			<cfset arrayAppend(local.errors, "*Last Name cannot contain numbers or special characters.")>
		</cfif>



		<cfset local.validGender = []>
		<cfset local.genderQuery= getGenderName()>
		<cfloop query="local.genderQuery">
			<cfset arrayAppend(local.validGender, local.genderQuery.idgender)>
		</cfloop>
		<cfif NOT arrayContains(local.validGender, arguments.gender)>
			<cfset arrayAppend(local.errors, "*Enter a valid gender")>
		</cfif>	
		


		<cfif not isDate(arguments.dob)>
        		<cfset arrayAppend(local.errors, "*Date of Birth must be a valid date.")>
    		</cfif>


		<cfset local.uploadPath = ExpandPath('../uploads/')>
		
		<cfif structKeyExists(form, "photo") AND len(form.photo) GT 0 AND form.photo NEQ "undefined">
			<cffile action="upload" fileField="photo" destination="#local.uploadPath#" nameConflict="makeUnique" result="local.fileUploadResult">
			<cfset local.originalFileName = local.fileUploadResult.serverFile>
		

			<cfset local.allowedFormats = "jpg,jpeg,png,jfif">
    			<cfset local.imageExtension = ListLast(local.originalFileName, ".")> 
		
			<cfif NOT ListFindNoCase(local.allowedFormats, local.imageExtension)>
        			<cfset arrayAppend(local.errors, "*Invalid image format. Only JPG, JPEG, JFIF and PNG are allowed")>
			<cfelse>
				<cfset local.uploadPath = ExpandPath('../Temp/')>
				<cffile action="upload" fileField="photo" destination="#local.uploadPath#" nameConflict="makeUnique" result="local.fileUploadResult">
				<cfset local.photopath = "./Temp/" & local.fileUploadResult.serverFile>
				<cfset arguments['photo'] = local.photopath>
    			</cfif>
		<cfelseif form.photo EQ "undefined" AND structKeyExists(arguments, 'contactId')>
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
		<cfelse>
			
			<cfset arrayAppend(local.errors, "*Image is required")>
		</cfif>
			


		
		<cfif trim(arguments.address) EQ "">
			<cfset arrayAppend(local.errors, "*Address is required.")>
		</cfif>

		
		<cfif trim(arguments.street) EQ "">
			<cfset arrayAppend(local.errors, "*Street is required.")>
		</cfif>

		<cfif trim(arguments.pincode) EQ "" OR (NOT isNumeric(arguments.pincode))>
			<cfset arrayAppend(local.errors, "*pincode must be numeric")>
		<cfelseif len(arguments.pincode) GT 8>
			<cfset arrayAppend(local.errors, "*pincode length must be less than 9")>
		</cfif>



		
		<cfquery name="local.getContactEmail">
			SELECT *
			FROM
				contact
			WHERE 
				email = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif local.getContactEmail.recordCount GT 0 AND NOT structKeyExists(arguments, 'contactId')>
			<cfset arrayAppend(local.errors, "*Email already exists")>
		<cfelseif len(trim(arguments.email)) EQ 0>
			<cfset arrayAppend(local.errors, "*Email is required")>
		<cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", arguments.email)>
            		<cfset arrayAppend(local.errors, "*Enter a valid email")>
		</cfif>

		

		
		<cfif trim(arguments.phone) EQ "" OR not reFind("^\d{10}$", arguments.phone)>
    			<cfset arrayAppend(local.errors, "*Phone number must contain exactly 10 digits.")>
		</cfif>

		
		<cfif Len(arguments.hobbies) EQ 0>
			<cfset arrayAppend(local.errors, "*Hobby is required")>
		<cfelse>
			<cfset local.validHobbies = []>
			<cfset local.hobbyQuery = getHobbyName()>
			<cfloop query="local.hobbyquery">
				<cfset ArrayAppend(local.validHobbies, local.hobbyQuery.idhobby)>
			</cfloop>
			<cfset local.selectedHobbiesArray = ListToArray(arguments.hobbies, ",")>
			<cfloop array="#local.selectedHobbiesArray#" index="local.hobbyID">
        			<cfif NOT arrayContains(local.validHobbies, local.hobbyID)>
            				<cfset arrayAppend(local.errors, "*Invalid hobby selected: " & local.hobbyID)>
        			</cfif>
    			</cfloop>

		</cfif>


		<cfset local.isValidPublic  = ["0", "1"]>
		<cfif NOT ArrayContains(local.isValidPublic, arguments.is_public)>
			<cfset arrayAppend(local.errors, "*Invalid value for Public")>
		</cfif>
		   
		

		<cfif arrayLen(local.errors) EQ 0>
			<cfset local.addUser=createOrUpdateContact(argumentCollection=arguments)>
				
			<cfreturn local.errors>
		<cfelse>
			<cfreturn local.errors>
		
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
		<cfargument name="is_public" type="string" required="true">
		<cfargument name="contactId" type="string" required="false" default="">
		
		
		<!---<cfset local.uploadPath = ExpandPath('../Temp/')>
		<cffile action="upload" fileField="photo" destination="#local.uploadPath#" nameConflict="makeUnique" result="local.fileUploadResult">
		<cfset local.photopath = "./Temp/" & local.fileUploadResult.serverFile>--->

		
		

		<cfif StructKeyExists(arguments, "contactId") AND arguments.contactId NEQ "">
			<cfset local.decryptedId = decryptId(arguments.contactId)>
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



