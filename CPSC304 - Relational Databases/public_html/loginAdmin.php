
<?php //verify info from patron POST data

//$db_conn = OCILogon("ora_z1z0b", "a12574159", "dbhost.ugrad.cs.ubc.ca:1522/ug");
$db_conn = OCILogon("ora_h1w0b", "a30187158", "dbhost.ugrad.cs.ubc.ca:1522/ug");


if(!$db_conn){
    $m = oci_error();
    echo $m['message'], "\n" ; //error function returns an Oracle error message
    $success = False;
    exit;
}


$query = "SELECT *
                FROM librarian
                WHERE librarian.employeeID=:EmployeeID " ;

$userID = oci_parse($db_conn, $query);

if(!$userID){
    echo "<br>Cannot parse the following command: " . $query . "<br>";
}


if(isset($_POST["EmployeeID"])){
  
    $EmployeeID = $_POST["EmployeeID"];
    oci_bind_by_name($userID, ":EmployeeID", $EmployeeID);
    oci_execute($userID, OCI_DEFAULT);
    $row= oci_fetch_array($userID);
    ocicommit($db_conn);

    if(!$row){
        echo "Incorrect login details. Please check your spelling and try again";
        header("location: Patron.php");
    }else{
        header("Location: welcomeEmployee.php?user=".$EmployeeID);
        
    }



}else{
    echo "No information, try again. ";
    exit;
}

oci_free_statement($userID);
ocilogoff($db_conn);


?>