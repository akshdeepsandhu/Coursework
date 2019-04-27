<?php include "header.php" ; ?>

<?php
    $LID = $_GET["user"]; 
    
?>

    <br><br>
    <form mehtod="POST" action="updateInfo.php" >

        <div class="container" >

            <b>Update Personal Informaton: </b>

            <input type="text" name="update_name" placeholder="First name Last name">
            <input type="text" name="update_email" placeholder="Enter new email">
            <input type="text" name="update_address" placeholder="Enter new address">
            <input type="submit" value="Update Informaton" name="update">
            <input type="hidden" value="<?php echo $LID ?>" name="LID" >
        </div>
    </form>
    <br><br>



<?php include "footer.php" ; ?>