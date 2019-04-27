<?php include "header.php"; ?>
<header>
	<h2>Reservation Search</h2>
</header>


<?php 

	$db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


	if(!$db_conn){
	    $m = oci_error();
	    echo $m['message'], "\n" ; //error function returns an Oracle error message
	    $success = False;
	    exit;
	}


	$query = "SELECT callNum, lid, heldUntil from reservation r, loan l, accountrecord a where r.loanRID = l.rid and l.rid = a.rid and a.lid =:LID";
	$LID = $_POST["LID"];
	$EID = $_GET["EmployeeID"];

	$parseQuery = ociparse($db_conn,$query);
	ocibindbyname($parseQuery, ":LID", $LID);
	oci_execute($parseQuery);
	echo "<h2>All current reservations: </h2>";
	echo "<br>Reservations: <br>";
	echo "<table>";
	echo "<tr> <th>callNum</th> <th>lid</th> <th>heldUntil</th></tr>";
	while($row = oci_fetch_array($parseQuery, OCI_BOTH)){
	            echo "<tr><td>" . $row['CALLNUM'] ."</td><td>" .$row['LID']."</td><td>" . $row['HELDUNTIL'] ."</td></tr>"; 
	            
	            }
	   

?>

<br>
    

    
<?php include "footer.php" ; ?>
