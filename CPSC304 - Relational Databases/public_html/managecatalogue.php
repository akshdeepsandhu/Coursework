<?php include "header.php" ; ?>

<form method="POST"  accept-charset="UTF-8">

	<div class = "container" >
	<input type="submit" value="Add Movie" name="addMov">
	<input type="submit" value="Add Book" name="addBook">
	<input type="submit" value="Delete Material" name="delete">
	</div>

</form>

<?php 

	$EID = $_GET["EmployeeID"];
	
	if(isset($_POST['addMov'])){
	header("Location: AddMovie.php?EmployeeID=".$EID);


	}
	if(isset($_POST['addBook'])){
		header("Location: AddBook.php?EmployeeID=".$EID);

	}
	if(isset($_POST['delete'])){
		header("Location: Delete.php?EmployeeID=".$EID);

	}
?>



<?php include "footer.php"; ?>