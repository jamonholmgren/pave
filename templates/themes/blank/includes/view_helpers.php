<?

  function is_edit_mode() {
    global $c;
    if ($c->isEditMode()) {
      echo "edit-mode";
    }
  }

  function is_logged_in() {
    global $u;
    if ($u -> isLoggedIn ()) {
      echo "logged-in";
    }
  }

  function has_blocks($area) {
    global $c;
    return $area->getTotalBlocksInArea($c) > 0;
  }

  function image_tag($t, $img, $html_options = false) {
    $imgPath = ($t->getThemePath()) . "/images/";
    if ($html_options) {
      $options = " alt='" . explode(".", $img, 2)[0] . "'";
      foreach ($html_options as $k => $v) {
        $options .= " " . $k . "='" . addslashes($v) . "'";
      }
    } else {
      $options = " alt='" . explode(".", $img, 2)[0] . "'";
    };
    echo "<img src='" . $imgPath . $img . "'" . $options . " />";
  }

?>
