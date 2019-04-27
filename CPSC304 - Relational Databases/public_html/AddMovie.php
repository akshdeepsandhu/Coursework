<?php include "header.php";?>


<label>
	<h2>Add Movie :</h2>
</label>
<form id="AddMov" method="POST"  accept-charset="UTF-8">

	<div class = "container" >
		<label>
			<b> Call Number:</b>
		</label>
		<input type ="text" placeholder="callNumber" name = "callNumber" style="width:250px;">
		<label>
			<b>Title :</b>
		</label>
		<input type="text" placeholder="Title" name="title" style="width: 250px;">
		<label>
			<b>Condition :</b>
		</label>
		<input type="text" placeholder="Condition" name="condition" style="width: 250px;">
		<label><br>
			<b>Availability :</b>
		</label>
		<input type="text" placeholder="Availability" name="avail" style="width: 250px;">
		<label>
			<b>Cost :</b>
		</label>
		<input type="text" placeholder="Cost" name="cost" style="width: 250px;">
		<label>
			<b>Genre :</b>
		</label>
		<input type="text" placeholder="Genre" name="genre" style="width: 250px;">
		<label>
			<b>Type :</b>
		</label>
		<input type="text" placeholder="Type" name="type" style="width: 250px;">
		<label><br>
			<b>Director :</b>
		</label>
		<input type="text" placeholder="Director" name="dir" style="width: 250px;">
		<label>
			<b>ReleaseDate :</b>
		</label>
		<input type="text" placeholder="ReleaseDate" name="date" style="width: 250px;">
	


		<input type="submit" value="Add" name="add">
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

$callnum = $_POST['callNumber'];
$title = $_POST['title'];
$cond = $_POST['condition'];
$avail = $_POST['avail'];
$cost = $_POST['cost'];
$genre = $_POST['genre'];
$type = $_POST['type'];
$dir = $_POST['dir'];
$date = $_POST['date'];


$queryM = "INSERT INTO material VALUES (:callNum,:genre , :title,:condition,:availability,:cost,:EID,:type)";
$queryMov = "INSERT INTO movie VALUES (:callNum, :director, :releaseDate)" ;
oci_parse($db_conn, $queryM);

ocibindbyname($queryM, ":callNum", $callnum); //bind to vars
ocibindbyname($queryM, ":genre", $genre);
ocibindbyname($queryM, ":title", $title);
ocibindbyname($queryM, ":condition", $condition);
ocibindbyname($queryM, ":availability", $avail);
ocibindbyname($queryM, ":cost", $cost);
ocibindbyname($queryM, ":EID", $eid);
ocibindbyname($queryM, ":type", $type);

ociexecute($queryM); //execute

oci_parse($db_conn, $queryMov);

ocibindbyname($queryMov, ":callNum", $callnum);
ocibindbyname($queryMov, ":director", $dir);
ocibindbyname($queryMov, ":releaseDate", $date);

ociexecute($queryMov);
ocicommit($db_conn);


?>

<?php include "footer.php";?>

