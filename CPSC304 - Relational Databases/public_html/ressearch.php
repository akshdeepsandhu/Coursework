 <?php include "header.php"; ?>   

 <?php  	$EID = $_GET['EmployeeID'];    ?>

 <h2>Reservation Search</h2>
					</header>

<br>

				<b><font size = '3'> Filter reservations by patron:</b><br>

				
				<form method='POST' action="resbypatron.php?EmployeeID=<?php echo $EID; ?>" >
					<p><font size='3'> Enter Patron LID:</font></p>
					<input type='text' placeholder="Library ID" name='LID' size='6'>

					<input type="submit" name="patron" value="Search Reservations" style="display:inline-block; width:20%;">
					<br>
				</form>
				<b><font size ='3'> Filter reservations by date:</b><br></font>

				<form method='POST' action="resbydate.php?EmployeeID=<?php echo $EID; ?>" >
					
					<p><font size='3'> Enter Date:</font></p>
					<input type='text' placeholder="YYYYMMDD" name='date' size='18'>
					<input type="submit" name="filter" value="Search Reservations" style="display:inline-block; width:20%;">
				</form>
				
			
			


  


<?php


	
	

    $db_conn = OCILogon("ora_z1z0b", "a12574159", "dbhost.ugrad.cs.ubc.ca:1522/ug");

    if(!$db_conn){
        $m = oci_error();
        echo $m['message'], "\n" ; //error function returns an Oracle error message
        $success = False;
        exit;
    }

    $query = "SELECT m.title, a.callNum, a.lid, r.heldUntil FROM reservation r, accountrecord a, material m
		WHERE a.rid = r.rid and m.callNum = a.callNum ORDER BY a.dated" ;
	$parseQuery = ociparse($db_conn,$query);
	oci_execute($parseQuery);
	echo "<h2>All current reservations: </h2>";
	echo "<br>Reservations: <br>";
	echo "<table>";
	echo "<tr> <th>Title</th> <th>callNum</th> <th>lid</th> <th>heldUntil</th></tr>";
	if($row = oci_fetch_array($parseQuery, OCI_BOTH)){
		while($row = oci_fetch_array($parseQuery, OCI_BOTH)){
	            echo "<tr><td>" . $row["TITLE"] . "</td><td>" . $row['CALLNUM'] ."</td><td>" .$row['LID']."</td><td>" . $row['HELDUNTIL'] ."</td></tr>"; 
	            }
	         }

				
	
	

?>
    
<?php include "footer.php";  ?>
