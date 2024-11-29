
<cfif structKeyExists(form, 'submit')>
	
	<cftry>
	<cfset variables.validationErrors = application.userService.validateRegisterInput(fullName=form.fullname,
 												email=form.email,
												username=form.username, 
												password=form.password, 
												confirmPassword=form.confirmPassword)>

	<cfif structKeyExists(variables, "validationErrors") AND arrayLen(validationErrors) EQ 0>
		<cfset result = application.userService.registerUser(fullname=form.fullname, 
										email=form.email, 
										username=form.username, 
										password=form.password)>
		<cfif result.success>
            	<cfset successMessage = result.message>
		<cfelse>
			<cfset errorMessage = result.message>
		</cfif>
	</cfif>

	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
	</cftry>
</cfif>

<!DOCTYPE html>
<html lang="en">
	<head>
    		<meta charset="UTF-8">
    		<meta name="viewport" content="width=device-width, initial-scale=1.0">
    		<title>Sign Up Page</title>
    		<link rel="stylesheet" href="./css/styleSignup.css">		
	</head>
	<body>
   
    		<nav class="navbar">
        		<div class="navbar-left">
            			<img src="./img/addressbook.png" alt="Address Book Icon" class="nav-icon">
            			<span>ADDRESS BOOK</span>
        		</div>
        		<div class="navbar-right">
            			<a href="./login.cfm" class="nav-link">Login</a>
        		</div>
    		</nav>

  		<div class="container">
        		<div class="signup-box">
            			<div class="icon-side">
                			<img src="./img/addressbook.png" alt="Address Book Icon" class="icon">
            			</div>
            			<div class="form-side">
                			<h2>SIGN UP</h2>
					
                			<form id="myForm" method="post" enctype="multipart/form-data" action="signup.cfm">
                    				<div class="input-box">
                        				<label for="fullname">Full Name</label>
                        				<input type="text" id="fullname" name="fullname" required >
							<span id="fullnameError" class="error"></span>
                    				</div>
						
						<div class="input-box">
						
                    					<label for="email">Email ID</label>
                        				<input type="email" id="email" name="email" required> 
                    					<span class="error" id="emailError"></span>
						</div>
						<div class="input-box">
                    				
                        				<label for="username">Username</label>
                        				<input type="text" id="username" name="username" required >
                    					<span class="error" id="usernameError"></span>
						</div>
						<div class="input-box">

                        				<label for="password">Password</label>
                        				<input type="password" id="password" name="password" required> 
             
                    					<span class="error" id="passwordError"></span>
						</div>
						<div class="input-box">
                    					<label for="confirmPassword">Confirm Password</label>
                        				<input type="password" id="confirmPassword" name="confirmPassword" required>
                    					<span class="error" id="confirmPasswordError"></span>
						</div>

						<button type="submit" name="submit" class="signup-btn">REGISTER</button><br><br>
						<cfif structKeyExists(variables, "validationErrors") AND arrayLen(validationErrors) GT 0>
							<cfoutput>
     
                						<cfloop array="#validationErrors#" index="error">
                    						<span class="error">#error#</span>
                						</cfloop>
            						</cfoutput>

        						
    						</cfif>
						<cfif structKeyExists(variables, "errorMessage")>
                        				<span class="error">
                            					<cfoutput>#errorMessage#</cfoutput>
                        				</span>
                    				</cfif>
						<cfif structKeyExists(variables, "successMessage")>
                        				<span class="success">
                            					<cfoutput>#successMessage#</cfoutput>
                        				</span>
                    				</cfif>


						
                			</form>
            			</div>
        		</div>
    		</div>
		<script src="./js/jquery.js"></script>
		<script src="./js/scriptSignup.js"></script>
		
	</body>
</html>

