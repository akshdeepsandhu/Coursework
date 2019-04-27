<?php include "header.php"; ?>

<h2> Patron Login </h2>

<h3> Please enter either your Email address and/or Library ID number</h3>

<label for="PatronID">

<form id="login" method="POST" action="login.php" accept-charset="UTF-8">

	<div class = "container">
		<label for="PatronID">
			<b>Library ID: </b> 
		</label>
		<input type ="text" placeholder="Enter Library ID" name = "PatronID" id="PatronID" size="10">

		
		<label for="email">
		<b>Email: </b> 
		</label>
		<input type="text" placeholder="Enter Email" name="email" id="email" size="10">
		<input type="submit" value="Login" name="Login">
	</div>
	
</form>


<?php include "footer.php"; ?>
