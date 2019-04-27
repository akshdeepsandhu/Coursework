<?php include "header.php" ; ?>
<header>
	<h2>Popularity Report</h2>
</header>

<b>The materials that have been checked out by all patrons are: </b> 

<?php 

$success = True; //keep track of errors so it redirects the page only if there are no errors
$db_conn = OCILogon("ora_h1w0b", "a30187158", "dbhost.ugrad.cs.ubc.ca:1522/ug");

function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
	//echo "<br>running ".$cmdstr."<br>";
	global $db_conn, $success;
	$statement = OCIParse($db_conn, $cmdstr); //There is a set of comments at the end of the file that describe some of the OCI specific functions and how they work

	if (!$statement) {
		echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
		$e = OCI_Error($db_conn); // For OCIParse errors pass the       
		// connection handle
		echo htmlentities($e['message']);
		$success = False;
	}

	$r = OCIExecute($statement, OCI_DEFAULT);
	if (!$r) {
		echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
		$e = oci_error($statement); // For OCIExecute errors pass the statementhandle
		echo htmlentities($e['message']);
		$success = False;
	} else {

	}
	return $statement;
} 

if ($db_conn) {
	$takenOut = executePlainSQL("select title, callNum
					from material m
					where not exists ((select p.lid
										from patron p)
										minus (select a.lid
												from accountRecord a
												where a.callNum = m.callNum))");
	$row = oci_fetch_array($takenOut);
	if (isset($takenOut)) {
		echo "<br><br>";
		echo "<table>";
		echo "<tr><th>Title</th><th>Call Number</th></tr>";
		echo "<tr><td>" . $row["TITLE"] . "</td><td>" . $row["CALLNUM"] . "</td></tr>";
		echo "</table>";

	} else {
		echo "There currently is no material that has been checked out by all patrons.";
	}
	OCICommit($db_conn);
	}
	else {
	echo "cannot connect";
	$e = OCI_Error(); // For OCILogon errors pass no handle
	echo htmlentities($e['message']);
}
?>
<br>

<b>The book that has been on loan the most times is:</b>
<?php

if ($db_conn) {
	$mostPopBook = executePlainSQL("select Distinct t1.title, t1.timesLoaned
									from timesTakenOutBook t1
									where t1.timesLoaned >= ALL (SELECT t2.timesLoaned FROM timesTakenOutBook t2);");

	$row2 = oci_fetch_array($mostPopBook);
	echo "<br><br>";
	echo "<table>";
	echo "<tr><th>Title</th><th>Times Loaned</th></tr>";
	echo "<tr><td>" . $row["TITLE"] . "</td><td>" . $row["TIMESLOANED"] . "</td></tr>";
	echo "</table>";
	OCICommit($db_conn);
} 
else {
	echo "cannot connect";
	$e = OCI_Error(); // For OCILogon errors pass no handle
	echo htmlentities($e['message']);
}
/*
if ($db_conn) {
	$timesTakenOutBook = executePlainSQL("create view timesTakenOutBook(title, timesLoaned) as 
											select title, COUNT(*) as timesLoaned
											from accountrecord a, loan l, material m
											where a.dated >= '&date1' AND a.dated <= '&date2' AND m.type = 'book' AND a.rid = l.rid AND a.callNum = m.callNum
											group by title");
	OCICommit($db_conn);
}
*/
?> 

<?php include "footer.php" ; ?>