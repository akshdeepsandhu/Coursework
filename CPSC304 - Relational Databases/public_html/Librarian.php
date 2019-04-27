<?php include "header.php"; ?>


<h2> Admin Login </h2>
<h3> Please enter your Employee ID </h3>

<label for="EmployeeID">

<form id="login" method="POST" action="loginAdmin.php" accept-charset="UTF-8">

	<div class = "container">
		<label for="EmployeeID">
			<b>Employee ID:  </b> 
		</label>
		<input type ="text" placeholder="Enter Employee ID" name = "EmployeeID" id="EmployeeID" size="10">
		<input type="submit" value="Login" name="Login">

	
		</button>




	
</form>


<?php include "footer.php"; ?>