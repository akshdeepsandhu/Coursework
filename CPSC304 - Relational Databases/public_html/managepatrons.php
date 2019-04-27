<?php include "header.php" ; ?>

<?php
    $EmployeeID = $_GET["EmployeeID"]; 
?>
<header>
    <h2> Please select one of the following options: </h2>
</header>
    </form>
    <form mehtod="POST" action="addNewPatron.php">

        <div class="container" >
            <input type="submit" value="Open a New Patron Account" name="create">
            <input type="hidden" value="<?php echo $EmployeeID ?>" name="EmployeeID" >
        </div>
    </form>
    </form>
    <form mehtod="POST" action="removePatron.php?EmployeeID=<?php echo $EmployeeID; ?>">

        <div class="container" >
            <input type="submit" value="Remove a Patron Account" name="delete">
            <input type="hidden" value="<?php echo $EmployeeID ?>" name="EmployeeID" >
        </div>
    </form>
    </form>
    <form mehtod="POST" action="rewnewLoan.php?EmployeeID=<?php echo $EmployeeID; ?>">

        <div class="container" >
            <input type="submit" value="Renew or Loan a book" name="checkout">
            <input type="hidden" value="<?php echo $EmployeeID ?>" name="EmployeeID" >
        </div>
    </form>
    <br><br>



<?php include "footer.php" ; ?>