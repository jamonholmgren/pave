		<?php defined("C5_EXECUTE") or die("Access Denied."); ?>


    <?php
      $a = new GlobalArea("Footer - Meta");
      $a->display($c);
    ?>


		<?php Loader::element("footer_required"); ?>
    <script src="<?= $this->getThemePath(); ?>/js/scripts.js"></script>
	</body>
</html>
