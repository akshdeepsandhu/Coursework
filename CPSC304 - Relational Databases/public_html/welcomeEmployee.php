<?php include "header.php"; ?>

<?php

if($_GET){
    $db_conn = OCILogon("ora_h1w0b", "a30187158", "dbhost.ugrad.cs.ubc.ca:1522/ug");

    if(!$db_conn){
        $m = oci_error();
        echo $m['message'], "\n" ; //error function returns an Oracle error message
        $success = False;
        exit;
    }

    $query = "SELECT employeeID, name
                FROM librarian 
                WHERE librarian.employeeID =:EmployeeID " ;


    $EmployeeID = $_GET["user"];
    $userID = oci_parse($db_conn, $query);
    oci_bind_by_name($userID, ":EmployeeID", $EmployeeID);
    oci_execute($userID, OCI_DEFAULT);
    $row= oci_fetch_array($userID);
    ocicommit($db_conn);
    $name = $row["NAME"];
    $EmployeeID = $row["EMPLOYEEID"];
}

else{
    echo "Url has no user";
}

?>

    <h2> Welcome, <?php echo substr($name, 0, strrpos($name, ' ')); ?>! </h2>
    <h3> Personal information </h3>



    <table>
        <tr>
            <th>First name: </th>
            <th> <?php echo substr($name, 0, strrpos($name, ' ')); ?> </th>
        </tr>
        <tr>
            <th>Last name: </th>
            <th> <?php echo strstr($name, ' '); ?> </th>
        </tr>
        <tr>
            <th>Employee ID: </th>
            <th> <?php echo $EmployeeID ; ?> </th>
        </tr>
    </table>

    <br>

    <form method="POST" style="border:none; width:70%;border-radius: ">
    <div class = "container">
    <a href = "searchCat.php"> <input type = "button" value= "Search Catalogue" name="searchCat"> </input></a>
    <a href ="managepatrons.php?EmployeeID=<?php echo $EmployeeID; ?>"> <input type="button" value = "Manage Patron Accounts" name="managepatrons"> </input> </a>
    <a href = "managecatalogue.php?EmployeeID=<?php echo $EmployeeID; ?>" > <input type="button" value = "Manage Catalogue" name = "manageacatalogue"> </input> </a><br><br>
    <a href = "popreport.php"> <input type = "button" value = "Popularity Report" name = "popreport"> </input> </a>
    <a href = "ressearch.php?EmployeeID=<?php echo $EmployeeID; ?>" > <input type = "button" value = "Reservation Search" name= "ressearch"> </input> </a>
    <a href = "latefees.php?EmployeeID=<?php echo $EmployeeID; ?>" > <input type = "button" value = "Manage Late Fees" name = "latefees"> </input> </a>
</div>

</form> 

<?php include "footer.php" ; ?>