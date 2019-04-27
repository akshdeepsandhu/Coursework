<?php include "header.php"; ?>




	<form method='POST'>
					
		<p><font size='3'> Library ID:</font></p>
		<input type='text' placeholder="Library ID" name='LID' size='18'>
		<input type="submit" name="search" value="Search" style="display:inline-block; width:20%;">
		</form>




<?php 

	$db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


	if(!$db_conn){
	    $m = oci_error();
	    echo $m['message'], "\n" ; //error function returns an Oracle error message
	    $success = False;
	    exit;
	}


	$query = "SELECT SUM(amount)
			  FROM lateFee f, accountRecord a
				WHERE f.rid = a.rid AND
					      a.lid =:LID "; 

	$LID = $_POST["LID"];
	
	
	$parseQuery = ociparse($db_conn,$query);
	ocibindbyname($parseQuery, ":LID", $LID);
	$r = oci_execute($parseQuery);
	echo "<h2>Sum of late fees: </h2>";
	echo "<br>";
	echo "<tr> <th>Amount: $ </th></tr>";
	$row = oci_fetch_array($parseQuery, OCI_BOTH) ; 


	echo "<tr><td>" . $row["SUM(AMOUNT)"]."</td></tr>";
	           
	   

?>

<?php include "footer.php" ; ?>
    

    
<?php include "footer.php" ; ?>
