<?php  defined('C5_EXECUTE') or die("Access Denied.");
$al = Loader::helper('concrete/asset_library');
$ps = Loader::helper('form/page_selector');
$dt = Loader::helper('form/date_time');
Loader::element('editor_config');
?>

<style type="text/css" media="screen">
	.ccm-block-field-group h2 { margin-bottom: 5px; }
	.ccm-block-field-group td { vertical-align: middle; }
</style>

<div class="ccm-block-field-group">
	<h2>Textbox Field</h2>
	<?php  echo $form->text('field_2_textbox_text', $field_2_textbox_text, array('style' => 'width: 95%;', 'maxlength' => '255')); ?>
</div>

<div class="ccm-block-field-group">
	<h2>Text Area Field</h2>
	<textarea id="field_3_textarea_text" name="field_3_textarea_text" rows="5" style="width: 95%;"><?php  echo $field_3_textarea_text; ?></textarea>
</div>

<div class="ccm-block-field-group">
	<h2>Image Field</h2>
	<?php  echo $al->image('field_4_image_fID', 'field_4_image_fID', 'Choose Image', $field_4_image); ?>
</div>

<div class="ccm-block-field-group">
	<h2>File Download Field</h2>
	<?php  echo $al->file('field_5_file_fID', 'field_5_file_fID', 'Choose File', $field_5_file); ?>
	<table border="0" cellspacing="3" cellpadding="0" style="width: 95%; margin-top: 5px;">
		<tr>
			<td align="right" nowrap="nowrap"><label for="field_5_file_linkText">Link Text (or leave blank to use file name):</label>&nbsp;</td>
			<td align="left" style="width: 100%;"><?php  echo $form->text('field_5_file_linkText', $field_5_file_linkText, array('style' => 'width: 100%;')); ?></td>
		</tr>
	</table>
</div>

<div class="ccm-block-field-group">
	<h2>Page Link Field</h2>
	<?php  echo $ps->selectPage('field_6_link_cID', $field_6_link_cID); ?>
	<table border="0" cellspacing="3" cellpadding="0" style="width: 95%;">
		<tr>
			<td align="right" nowrap="nowrap"><label for="field_6_link_text">Link Text:</label>&nbsp;</td>
			<td align="left" style="width: 100%;"><?php  echo $form->text('field_6_link_text', $field_6_link_text, array('style' => 'width: 100%;')); ?></td>
		</tr>
	</table>
</div>

<div class="ccm-block-field-group">
	<h2>External URL Field</h2>
	<table border="0" cellspacing="3" cellpadding="0" style="width: 95%;">
		<tr>
			<td align="right" nowrap="nowrap"><label for="field_7_link_url">Link to URL:</label>&nbsp;</td>
			<td align="left" style="width: 100%;"><?php  echo $form->text('field_7_link_url', $field_7_link_url, array('style' => 'width: 100%;')); ?></td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap"><label for="field_7_link_text">Link Text:</label>&nbsp;</td>
			<td align="left" style="width: 100%;"><?php  echo $form->text('field_7_link_text', $field_7_link_text, array('style' => 'width: 100%;')); ?></td>
		</tr>
	</table>
</div>

<div class="ccm-block-field-group">
	<h2>Date Picker Field</h2>
	<?php  echo $dt->date('field_8_date_value', $field_8_date_value); ?>
</div>

<div class="ccm-block-field-group">
	<h2>Dropdown List</h2>
	<?php 
	$options = array(
		'0' => '--Choose One--',
		'1' => 'Choice 1',
		'2' => 'Choice 2',
		'3' => 'Choice 3',
	);
	echo $form->select('field_9_select_value', $options, $field_9_select_value);
	?>
</div>

<div class="ccm-block-field-group">
	<h2>WYSIWYG Editor</h2>
	<?php  Loader::element('editor_controls'); ?>
	<textarea id="field_10_wysiwyg_content" name="field_10_wysiwyg_content" class="ccm-advanced-editor"><?php  echo $field_10_wysiwyg_content; ?></textarea>
</div>


