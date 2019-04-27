<?php include "header.php";?>


<label>
	<h2>Remove material :</h2>
</label>
<form method="POST">
	<div class = "container" >
	<input type="text" placeholder="callNumber" name="callNumb" >
	Book: <input type="radio" name="type" value="book">
	Movie: <input type="radio" name="type" value="movie">
	<input type="submit" value="Delete" name="delete">
	</div>
	
</form>

<?php 

	$db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


    if(!$db_conn){
        $m = oci_error();
        echo $m['message'], "\n" ; //error function returns an Oracle error message
        $success = False;
        exit;
    }

	$EID = $_GET["EmployeeID"]; 
	$callNum = $_POST["callNumb"];
	$type = $_POST["type"];



	if($_POST["type"] == "book"){
		$query = "DELETE FROM book
				WHERE callNum =:bookCallNum ";
		$queryParsed = ociparse($db_conn,$query);
		ocibindbyname($queryParsed, ":bookCallNum", $callNum);
		oci_execute($queryParsed);
		ocicommit($db_conn);

	}else{
	
		$querymov = "DELETE FROM movie
					WHERE callNum =:movieCallNum";
		$queryParsed = ociparse($db_conn,$query);
		ocibindbyname($queryParsed, ":movieCallNum", $callNum);
		oci_execute($queryParsed);
		ocicommit($db_conn);
		}
		ocilogoff($db_conn);

?>
<?php include "footer.php";?>