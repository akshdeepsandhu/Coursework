<?php include "header.php"; ?>

<?php 

$db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


if(!$db_conn){
    $m = oci_error();
    echo $m['message'], "\n" ; //error function returns an Oracle error message
    $success = False;
    exit;
}


$LID = $_GET["user"];

$query = "SELECT a.rid, title, a.callNum
		  FROM loan l, accountrecord a, material m 
		WHERE l.rid = a.rid AND
		 a.callNum = m.callNum AND
		a.lid =:searchLID
		order by a.dated";


$queryParse = oci_parse($db_conn,$query);
ocibindbyname($queryParse, ":searchLID", $LID);
executeSQL($queryParse);


function executeSQL($cmdstr){
    oci_execute($cmdstr);
    printResult($cmdstr);

}

function printResult($result){
    echo "<br>Search results below: <br>";
    echo "<table>";
    echo "<tr> <th>RID</th> <th>Title</th> <th>callNum</th></tr>"; 
    while($row = oci_fetch_array($result, OCI_BOTH)){
            echo "<tr><td>" . $row["RID"] . "</td><td>" . $row['TITLE'] ."</td><td>" .$row['CALLNUM']."</td></tr>"; 
            }

    }

?>
<?php include "footer.php"; ?>