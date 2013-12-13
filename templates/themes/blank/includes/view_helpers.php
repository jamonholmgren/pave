<?
  function editmode() {
    global $c;
    if ($c->isEditMode()) {
      echo "editMode";
    }
  }

  function image_tag($t, $img) {
    $imgPath = ($t->getThemePath()) . "/images/";
    echo "<img src='" . $imgPath . $img . "' />";
  } 

?>