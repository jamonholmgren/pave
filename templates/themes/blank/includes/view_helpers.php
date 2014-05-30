<?
  function pretty_r($var, $die=true) {
    echo "<pre>";
    var_dump($var);
    echo "<pre>";
    if($die) {
      die();
    };
  }

  function is_edit_mode() {
    global $c;
    return $c->isEditMode();
  }

  function is_logged_in() {
    global $u;
    return $u->isLoggedIn();
  }

  function has_blocks($area) {
    global $c;
    return $area->getTotalBlocksInArea($c) > 0;
  }

  function is_admin() {
    $u = new User();
    $g = Group::getByName('Administrators');
    return $u->isSuperUser()||$u->inGroup($g);
  }

  function current_url() {
    Loader::helper('navigation');
    return NavigationHelper::getLinkToCollection(Page::getCurrentPage(), true);
  }

  function page_classes($c) {
    return $c->getCollectionTypeHandle() . " " . $c->getCollectionHandle() . " " . (is_admin() ? 'admin' : '');
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
    return "<img src='" . $imgPath . $img . "'" . $options . " />";
  }

  function image_placeholder_tag($width, $height = false, $text = false, $html_options = false) {
    $img = "http://placehold.it/" . $width . ($height ? "x" . $height : "") . ($text ? "&text=" . $text : "");

    if ($html_options) {
      foreach ($html_options as $k => $v) {
        $options .= " " . $k . "='" . addslashes($v) . "'";
      }
    }

    return "<img src='" . $img . "'" . $options . " />";
  }

  function page_specific_scripts($page, $t) {
    $script_html = "";

    $handle = $page->getCollectionTypeHandle();
    if (isset($handle) === true) {
      $script_path = __DIR__ . "/../js/template_" . $handle . ".js";
      if (file_exists($script_path) === true) {
        $script_html .= "<script src='" . $t->getThemePath() . "/js/template_" . $handle . ".js'></script>";
      }
    }

    $page_name = $page->getCollectionHandle();
    if (isset($page_name) === true) {
      $script_path = __DIR__ . "/../js/page_" . $page_name . ".js";
      if (file_exists($script_path) === true) {
        $script_html .= "<script src='" . $t->getThemePath() . "/js/page_" . $page_name . ".js'></script>";
      }
    }

    return $script_html;
  }

?>
