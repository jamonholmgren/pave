<?php  defined('C5_EXECUTE') or die("Access Denied.");
$nh = Loader::helper('navigation');
?>



<?php  if (!empty($field_2_textbox_text)): ?>
	<?php  echo htmlentities($field_2_textbox_text, ENT_QUOTES, APP_CHARSET); ?>
<?php  endif; ?>

<?php  if (!empty($field_3_textarea_text)): ?>
	<?php  echo nl2br(htmlentities($field_3_textarea_text, ENT_QUOTES, APP_CHARSET)); ?>
<?php  endif; ?>

<?php  if (!empty($field_4_image)): ?>
	<img src="<?php  echo $field_4_image->src; ?>" width="<?php  echo $field_4_image->width; ?>" height="<?php  echo $field_4_image->height; ?>" alt="" />
<?php  endif; ?>

<?php  if (!empty($field_5_file)):
	$link_url = View::url('/download_file', $field_5_file_fID, Page::getCurrentPage()->getCollectionID());
	$link_class = 'file-'.$field_5_file->getExtension();
	$link_text = empty($field_5_file_linkText) ? $field_5_file->getFileName() : htmlentities($field_5_file_linkText, ENT_QUOTES, APP_CHARSET);
	?>
	<a href="<?php  echo $link_url; ?>" class="<?php  echo $link_class; ?>"><?php  echo $link_text; ?></a>
<?php  endif; ?>

<?php  if (!empty($field_6_link_cID)):
	$link_url = $nh->getLinkToCollection(Page::getByID($field_6_link_cID), true);
	$link_text = empty($field_6_link_text) ? $link_url : htmlentities($field_6_link_text, ENT_QUOTES, APP_CHARSET);
	?>
	<a href="<?php  echo $link_url; ?>"><?php  echo $link_text; ?></a>
<?php  endif; ?>

<?php  if (!empty($field_7_link_url)):
	$link_url = $this->controller->valid_url($field_7_link_url);
	$link_text = empty($field_7_link_text) ? $field_7_link_url : htmlentities($field_7_link_text, ENT_QUOTES, APP_CHARSET);
	?>
	<a href="<?php  echo $link_url; ?>" target="_blank"><?php  echo $link_text; ?></a>
<?php  endif; ?>

<?php  if (!empty($field_8_date_value)): ?>
	<?php  echo date('F jS, Y', strtotime($field_8_date_value)); ?>
<?php  endif; ?>

<?php  if ($field_9_select_value == 1): ?>
	<!-- ENTER MARKUP HERE FOR FIELD "Dropdown List" : CHOICE "Choice 1" -->
<?php  endif; ?>

<?php  if ($field_9_select_value == 2): ?>
	<!-- ENTER MARKUP HERE FOR FIELD "Dropdown List" : CHOICE "Choice 2" -->
<?php  endif; ?>

<?php  if ($field_9_select_value == 3): ?>
	<!-- ENTER MARKUP HERE FOR FIELD "Dropdown List" : CHOICE "Choice 3" -->
<?php  endif; ?>

<?php  if (!empty($field_10_wysiwyg_content)): ?>
	<?php  echo $field_10_wysiwyg_content; ?>
<?php  endif; ?>


