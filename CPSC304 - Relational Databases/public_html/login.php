

<?php //verify info from patron POST data

//$db_conn = OCILogon("ora_z1z0b", "a12574159", "dbhost.ugrad.cs.ubc.ca:1522/ug");
$db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


if(!$db_conn){
    $m = oci_error();
    echo $m['message'], "\n" ; //error function returns an Oracle error message
    $success = False;
    exit;
}


$query = "SELECT lid, name, email, address
                FROM patron
                WHERE patron.lid=:PatronID or patron.email =:email" ;

$userID = oci_parse($db_conn, $query);

if(!$userID){
    echo "<br>Cannot parse the following command: " . $query . "<br>";
}


if(isset($_POST["PatronID"]) || isset($_POST["email"]) ){
    $email = $_POST["email"];
    $PatronID = $_POST["PatronID"];
    oci_bind_by_name($userID, ":PatronID", $PatronID);
    oci_bind_by_name($userID, ':email', $email);
    oci_execute($userID, OCI_DEFAULT);
    $row= oci_fetch_array($userID);
    ocicommit($db_conn);

    if(!$row){
        echo "Incorrect login details. Please check your spelling and try again";
        header("location: Patron.php");
    }else{
        $LID = $row["LID"];
        header("Location: welcomePatron.php?user=".$LID);
        
    }



}else{
    echo "No information, try again. ";
    exit;
}

oci_free_statement($userID);
ocilogoff($db_conn);


?>