<?php include "header.php" ;?>
<label>
	<h2>Add book :</h2>
</label>
<form id="Addbook" method="POST"  accept-charset="UTF-8">

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
			<b>ISBN :</b>
		</label>
		<input type="text" placeholder="isbn" name="isbn" style="width: 250px;">
		<label>
			<b>Author :</b>
		</label>
		<input type="text" placeholder="Author" name="author" style="width: 250px;">
		<label>
			<b>Publisher :</b>
		</label>
		<input type="text" placeholder="Publisher" name="publisher" style="width: 250px;">
		<label>
			<b>Edition :</b>
		</label>
		<input type="text" placeholder="Edn" name="edition" style="width: 250px;">


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

$isbn = $_POST['isbn'];
$author = $_POST['author'];
$pub = $_POST['publisher'];
$ed = $_POST['edition'];

$queryM = "INSERT INTO material VALUES (:callNum,:genre , :title,:condition,:availability,:cost,:EID,:type)";
$queryMov = "INSERT INTO book VALUES (:callNum, :isbn, :author, :publisher, :edition)" ;
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

ocibindbyname($queryMov, ":isbn", $isbn);
ocibindbyname($queryMov, ":author", $author);
ocibindbyname($queryMov, ":publisher", $pub);
ocibindbyname($queryMov, ":callNum", $callnum);
ocibindbyname($queryMov, ":edition",$ed); //bind to vars


ociexecute($queryMov);
ocicommit($db_conn);

?>

<?php include "footer.php" ; ?>



