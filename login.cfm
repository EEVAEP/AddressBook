
<cfif structKeyExists(url, "logOut")>
	<cfset structDelete(session, "username")>
	<cfset structDelete(session, "userid")>
</cfif>


<cfif structKeyExists(session, "username")>
	<cflocation url="dashboard.cfm" addtoken="false">
</cfif>

<cfif structKeyExists(form, "submit")>
	<cfset user = application.userService.validateUserLogin(username=form.username,
									password=form.password)>

	<cfif structKeyExists(user, "username") AND user.username EQ form.username>
		<cfset session.username = user.username>
		<cfset session.userid = user.userid>
        	<cflocation url="dashboard.cfm" addtoken="false">
		
    	<cfelse>
        	<cfset errorMessage = "Invalid Username or Password">
        </cfif>

</cfif>

<!DOCTYPE html>
<html lang="en">
	<head>
    		<meta charset="UTF-8">
    		<meta name="viewport" content="width=device-width, initial-scale=1.0">
    		<title>Login Page</title>
    		<link rel="stylesheet" href="./css/styleLogin.css">
	</head>
	<body>
        	<nav class="navbar">
        		<div class="navbar-left">
            			<img src="./img/addressbook.png" alt="Address Book Icon" class="nav-icon">
            			<span>ADDRESS BOOK</span>
        		</div>
        		<div class="navbar-right">
            			<a href="./signup.cfm" class="nav-link">Sign Up</a>
            			
        		</div>
    		</nav>

    
    		<div class="container">
        		<div class="login-box">
            			<div class="icon-side">
                			<img src="./img/addressbook.png" alt="Address Book Icon" class="icon">
            			</div>
            			<div class="form-side">
                			<h2>LOGIN</h2>
                			<form method="post" action="login.cfm">
                    				<div class="input-box">
                        				<label for="username">Username</label>
                        				<input type="text" id="username" name="username">
                    				</div>
                    				<div class="input-box">
                        				<label for="password">Password</label>
                        				<input type="password" id="password" name="password">
                    				</div>
                    				<button type="submit" name="submit" class="login-btn">LOGIN</button>
						<cfif structKeyExists(variables, "errorMessage")>
                        				<span class="error">
                            					<cfoutput>#errorMessage#</cfoutput>
                        				</span>
                    				</cfif>
						
                			</form>
                			
                			<div class="register-link">
                    				<p>Don't have an account? <a href="./signup.cfm">Register Here</a></p>
                			</div>
            			</div>
        		</div>
    		</div>
	</body>
</html>
