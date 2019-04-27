<?php include "header.php" ; ?>

<?php
    $LID = $_GET["user"]; 
    //title, genre, availability(Y,N), type, callNum
?>


<br><br>
<h2> Search for materials: </h2>
<h3> Please input either a Call Number or Title</h3>
<br>
<form method="POST" action="searchData.php" id="booksearch" >

	<div class = "container">	
		<label><b>Call Number:</b></label>
	<input type="text" placeholder="AB1234" name="callNum">
	<input type="hidden" value="<?php echo $LID; ?>" name="LID">
	<br><label><b>Title:</b> </label>
	<input type="text" placeholder="Title" name="title">
	Book <input type="radio" name="type" value="book">
	Movie <input type="radio" name="type" value ="movie">
	</div>
	<div class="container" style="width:200px;">
			<label><b>Select Genre:</b></label>
			<select name="genre" form="booksearch" style="width:200px; height:25px; font-size: 15px;">
				<option value ="genre">Genre</option>
				<option value="fantasy">Fantasy</option>
				<option value="biography">Biography</option>
				<option value="thriller">Thriller</option>
				<option value="mystery">Mystery</option>
				<option value="autobiography">Autobiography</option>
				<option value="philosophy">Philosophy</option>
			</select>
	</div>
	<div class="container">
		<input type="submit" value="Search" name="Login">
	</div>


</form>

<?php include "footer.php" ; ?>


	
