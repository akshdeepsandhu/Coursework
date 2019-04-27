<?php include "header.php"; ?>

    <label>Time period:</label><br><br>
    <div class = "containerB">
        <form method="POST"  id="booksearch" >


            Start date:<input type="text" placeholder="YYYYMMDD" name="Start">
            End date:<input type="text" placeholder="YYYYMMDD" name="End">
            <input type="submit" value="Submit" name="sumbit">

        </form>
    </div>
<?php

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

$db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


if(!$db_conn){
    $m = oci_error();
    echo $m['message'], "\n" ; //error function returns an Oracle error message
    $success = False;
    exit;
}

$LID = $_GET["user"];

$view = executePlainSQL("SELECT view_name
							FROM all_views
							WHERE view_name = 'cardPayments");
$view2 = executePlainSQL("SELECT view_name
							FROM all_views
							WHERE view_name = 'cashPayments");
if (!is_null($view)) {
    executePlainSQL("DROP VIEW cardPayments");
}
if (!is_null($view2)) {
    executePlainSQL("DROP VIEW cashPayments");
}

$q1 = "CREATE VIEW cardPayments(rid, cardPayment, dated) as
		select a.rid, c.amount as cardPayment, dated
		from accountRecord a, cardPayment c
		where a.rid = c.rid AND a.dated >=:date1 AND a.dated <=:date2";

OCICommit($db_conn);

$q2 = "CREATE VIEW cashPayments(rid, cashPayment, dated) as
		select a.rid, m.amount as cashPayment, dated
		from accountRecord a, cashPayment m
		where a.rid = m.rid AND a.dated >=:date1 AND a.dated <=:date2";

OCICommit($db_conn);

$q3 = "SELECT *
		from cashPayments NATURAL FULL OUTER JOIN cardPayments";

function printResult($result){
    echo "<br>Search results below: <br>";
    echo "<table>";
    echo "<tr><th>Record ID</th><th>Cash Payments (CAD)</th><th>Card Payments (CAD)</th><th>Transaction Date</th></tr>";
    $row = oci_fetch_array($result, OCI_BOTH);
    echo var_dump($row);
    while($row = oci_fetch_array($result, OCI_BOTH)){
        echo "<tr><td>" . $row["RID"] . "</td><td>" . $row["CASHPAYMENT"] . "</tr><td>" . $row["CARDPAYMENT"] . "</tr><td>" . $row["DATED"] ."</td></tr>";
            }
    echo "</table>";
    OCICommit($db_conn);
}

/*$view = executePlainSQL("SELECT view_name
		FROM all_views
		WHERE view_name = 'timesTakenOutBook'");

	if (isset($view)) {
		executePlainSQL("DROP VIEW timesTakenOutBook");
	}

	$timesTakenOutBook = executePlainSQL("CREATE view timesTakenOutBook(title, timesLoaned) as
		select title, COUNT(*) as timesLoaned
		from accountrecord a, loan l, material m
		where a.dated >=20001010 AND a.dated <=20181231 AND m.type = 'book' AND a.rid = l.rid AND a.callNum = m.callNum
		group by title");
	OCICommit($db_conn);*/

if(!empty($_POST['submit'])){
    $date1 = $_POST['Start'];
    $date2 = $_POST['End'];

    $q1Parse = oci_parse($db_conn,$q1);
    $q2Parse = oci_parse($db_conn,$q2);
    $q3Parse = oci_parse($db_conn,$q3);

    ocibindbyname($q1Parse, ":date1", $date1);
    ocibindbyname($q1Parse, ":date2", $date2);

    ocibindbyname($q2Parse, ":date1", $date1);
    ocibindbyname($q2Parse, ":date2", $date2);

    ociexecute($q1Parse);
    ociexecute($q2Parse);
    ociexecute($q3Parse);

    printResult($q3Parse);
}


?>
<?php include "footer.php"; ?>