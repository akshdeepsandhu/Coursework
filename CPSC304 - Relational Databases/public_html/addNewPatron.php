<?php include "header.php" ; ?>

<?php
    $EmployeeID = $_GET["EmployeeID"]; 
?>

    <br><br>
    </form>
    <form method="POST" >

        <div class="container" >

            <b>Enter the new account's details here: </b>

            <input type="text" name="input_name" placeholder="First name Last name">
            <input type="text" name="input_email" placeholder="Enter email">
            <input type="text" name="input_address" placeholder="Enter address">
            <input type="submit" value="Create Account" name="makeAccount">
            <input type="hidden" value="<?php echo $EmployeeID ?>" name="EID" >
        </div>
    </form>
    <br><br>

<?php 
    $EID = $_GET["EmployeeID"]; 
    $name = $_POST["input_name"];
    $email= $_POST["input_email"];
    $address = $_POST["input_address"];

    $db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


    if(!$db_conn){
        $m = oci_error();
        echo $m['message'], "\n" ; //error function returns an Oracle error message
        $success = False;
        exit;
    }

    $query = "INSERT INTO patron VALUES (:lid, :name, :email, :address)" ;
    $queryParsed = ociparse($db_conn, $query);
    ocibindbyname($queryParsed, ":name", $name);
    ocibindbyname($queryParsed, ":email", $email);
    ocibindbyname($queryParsed, ":address", $address);
    
    ociexecute($queryParsed);
    ocicommit($db_conn);
    ocilogoff($db_conn);


    ?>

<?php include "footer.php" ; ?>