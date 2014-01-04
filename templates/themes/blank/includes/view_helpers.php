<?

  function id_edit_mode() {
    global $c;
    if ($c->isEditMode()) {
      echo "edit-mode";
    }
  }

  function image_tag($t, $img) {
    $imgPath = ($t->getThemePath()) . "/images/";
    echo "<img src='" . $imgPath . $img . "' />";
  } 

  function has_blocks($area) {
    if ($area->getTotalBlocksInArea($c) > 0) { 
      return true;
    } else {
      return false;
    }
  }

?>