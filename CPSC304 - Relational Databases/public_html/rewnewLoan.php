<?php include "header.php" ;?>

  <form mehtod="POST">

        <div class="container" >

            Renew: <input type="radio" value="Renew" name="what">
            Loan: <input type="radio" value="Loan" name="what"><br><br>
            Library ID: <input type="text" placeholder="Library ID" name="LID">
            Date: <input type="text" placeholder="YYYYMMDD" name="date">
            CallNum: <input type="text" placeholder="CallNum" name="CallNum">
            <input type="submit" value="Submit">
        </div>
    </form>

  <?php 
  	$db_conn = OCILogon("ora_z1z0b", "a12574159", "dbhost.ugrad.cs.ubc.ca:1522/ug");

    if(!$db_conn){
        $m = oci_error();
        echo $m['message'], "\n" ; //error function returns an Oracle error message
        $success = False;
        exit;
    }
    $LID = $_POST['LID'];
    $Date = $_POST['Date'];
    $CallNum = $_POST['CallNum'];
    if($_POST['what'] == "Loan"){
    	//Loan query
    }else{
    	//Renew query 
    }

    ?>


<?php include "footer.php" ;?>