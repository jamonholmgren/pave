<?php
  defined("C5_EXECUTE") or die("Access Denied.");
  $this->inc("includes/view_helpers.php");
?>
<!DOCTYPE html>
<html lang="<?php echo LANGUAGE?>">
  <head>
    <?php Loader::element("header_required"); ?>

    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/normalize/2.1.3/normalize.min.css" />
    <link rel="stylesheet" href="<?= $this->getThemePath(); ?>/css/styles.css" />

    <!--[if lt IE 9]>
      <script src="//cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.2/html5shiv.js"></script>
    <![endif]-->
  </head>
  <body class="<?= $c->getCollectionTypeHandle(); ?>">

    <!-- BLOCK EXAMPLE -->
    <?php
      $a = new Area("Header");
      $a->display($c);
    ?>

    <!-- NAV EXAMPLE -->
    <?php
      $nav = BlockType::getByHandle("autonav");
      $nav->controller->orderBy = "display_asc";
      $nav->controller->displayPages = "top";
      $nav->controller->displaySubPages = "all";
      $nav->controller->displaySubPageLevels = "custom";
      $nav->controller->displaySubPageLevelsNum = 1;
      $nav->render("templates/header_menu");
    ?>
