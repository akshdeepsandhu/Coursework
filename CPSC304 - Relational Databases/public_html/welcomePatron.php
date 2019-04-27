<?php include "header.php"; ?>

<?php

if($_GET){
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


    $PatronID = $_GET["user"];
    $userID = oci_parse($db_conn, $query);

    oci_bind_by_name($userID, ":PatronID", $PatronID);
    oci_execute($userID, OCI_DEFAULT);

    $row= oci_fetch_array($userID);
    ocicommit($db_conn);
    
    $name = $row["NAME"];
    $LID = $row["LID"];
    $email = $row["EMAIL"];
    $address = $row["ADDRESS"];
    
}

else{
    echo "Url has no user";
}

?>



    <h2> Welcome, <?php echo substr($name, 0, strrpos($name, ' ')); ?> </h2>
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
            <th>Library ID: </th>
            <th> <?php echo $LID ; ?> </th>
        </tr>
        <tr>
            <th>Email address: </th>
            <th><?php echo $email; ?> </th>
        </tr>
        <tr>
            <th>
                Address:
            </th>
            <th><?php echo $address;?> </th>
        </tr>
    </table>

    <br>


    

        <div class="containerB" >
            <form method="POST"   style="border:none ;">
            <input type="submit" value="Update Informaton" name="update">
            </form>

            <form method="POST" style="border:none ;">
            <input type="submit" value="Search catalog" name="search">
            </form>

            <form method="POST" style="border:none ;">
            <input type="submit" value="Checkout history" name='checkout' >
            </form>
            
            
        </div>

  



<?php 
    if(isset($_POST['update'])){   
        header("Location: update.php?user=".$LID);
    } 

    if(isset($_POST['search'])){
        header("Location: search.php?user=".$LID);

    }
     if(isset($_POST['checkout'])){
        header("Location: checkout.php?user=".$LID);

     }
   
?>

<?php include "footer.php" ; ?>