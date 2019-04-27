


<?php

   $db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");

    if(!$db_conn){
        $m = oci_error();
        echo $m['message'], "\n" ; //error function returns an Oracle error message
        $success = False;
        exit;
    }

    $query = "SELECT lid, name, email, address
                        FROM patron
                        WHERE patron.lid=:PatronID " ;


    $userID = oci_parse($db_conn, $query);
        

    $PatronID = $_GET["LID"];
    
    oci_bind_by_name($userID, ":PatronID", $PatronID);
    oci_execute($userID, OCI_DEFAULT);

    //fetching row from database
    $row= oci_fetch_array($userID);
    ocicommit($db_conn);
    $name = $row["NAME"];
    $email = $row["EMAIL"];
    $address = $row["ADDRESS"];
   

  
    

  
   if(!empty($_GET['update_name'])){
        $name = $_GET['update_name'];
        
    }
    if(!empty($_GET['update_email']) ) {
        $email = $_GET['update_email'];
    }
    if(!empty($_GET['update_address'])){
        $address = $_GET['update_address'];

    }

    $SQL = "UPDATE patron SET patron.email=:email, patron.name=:name, patron.address=:address WHERE patron.lid=:LID";
    
    $updateID = ociparse($db_conn, $SQL);

    if(!$updateID){
        echo "SQL not working";
    }

    ocibindbyname($updateID, ":email", $email);
    ocibindbyname($updateID,":name", $name);
    ocibindbyname($updateID,":address", $address);
    ocibindbyname($updateID,":LID", $PatronID);
    oci_execute($updateID);
    ocicommit();
    ocilogoff($db_conn);

   
    
    
    header("Location: welcomePatron.php?user=".$PatronID);

 

?>