<?php  defined('C5_EXECUTE') or die("Access Denied."); ?> 
<style type="text/css">
table#googleMapBlockSetup th {font-weight: bold; text-style: normal; padding-right: 8px; white-space: nowrap; vertical-align:top ; padding-bottom:8px}
table#googleMapBlockSetup td{ font-size:12px; vertical-align:top; padding-bottom:8px;}
</style> 

<table id="googleMapBlockSetup" width="100%" class="table table-bordered"> 
	<tr>
		<th><?php echo t('Map Title')?>: <div class="note">(<?php echo t('Optional')?>)</div></th>
		<td><input id="ccm_googlemap_block_title" name="title" value="<?php echo $mapObj->title?>" maxlength="255" type="text" style="width:80%"></td>
	</tr>	
	<tr>
		<th><?php echo t('Location')?>:</th>
		<td>
		<input id="ccm_googlemap_block_location" name="location" value="<?php echo $mapObj->location?>" maxlength="255" type="text" style="width:80%">
		<div class="note"><?php echo t('e.g. 17 SE 3rd #410, Portland, OR, 97214')?></div>
		</td>
	</tr>
	<tr>
		<th><?php echo t('Zoom')?>:</th>
		<td>
		<input id="ccm_googlemap_block_zoom" name="zoom" value="<?php echo $mapObj->zoom?>" maxlength="255" type="text" style="width:80%">
		<div class="ccm-note"><?php echo t('Enter a number from 0 to 21, with 21 being the most zoomed in.')?> </div>
		</td>
	</tr>			
</table>