<?php include "header.php" ; ?>


<?php
    $EmployeeID = $_GET["EmployeeID"]; 
?>

    <br><br>
    </form>
    <form method="POST" >

        <div class="container" >

            <b>Enter account number to delete here: </b>
            <input type="text" name="LID" placeholder="Library ID Number">
            <input type="submit" value="Delete Account" name="deleteAccount">
            <input type="hidden" value="<?php echo $EmployeeID ?>" name="EID" >
        </div>
    </form>
    <br><br>

<?php 

    $db_conn = OCILogon("ora_y4t0b", "a20665148", "dbhost.ugrad.cs.ubc.ca:1522/ug");


    if(!$db_conn){
        $m = oci_error();
        echo $m['message'], "\n" ; //error function returns an Oracle error message
        $success = False;
        exit;
    }  
    $LID = $_POST["LID"];
    $query = "DELETE FROM patron WHERE lid =:lid";
    $queryParsed = ociparse($db_conn, $query);
    ocibindbyname($queryParsed, ":lid", $LID);
    ociexecute($queryParsed);
    ocicommit($db_conn);
    ocilogoff($db_conn);




    ?>
<?php include "footer.php" ; ?>

