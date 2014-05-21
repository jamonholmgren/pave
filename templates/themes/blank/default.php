<?php
  defined("C5_EXECUTE") or die("Access Denied.");
  $this->inc("elements/header.php");
?>

	<?php
	  $a = new Area("Main");
	  $a->display($c);
	?>


<?php  $this->inc("elements/footer.php"); ?>
