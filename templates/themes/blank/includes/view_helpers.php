<?

  function is_edit_mode() {
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
    global $c;
    return $area->getTotalBlocksInArea($c) > 0;
  }

?>