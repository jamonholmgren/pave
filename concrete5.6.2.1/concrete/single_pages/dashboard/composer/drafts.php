<?php  defined('C5_EXECUTE') or die("Access Denied."); ?>

<?php echo Loader::helper('concrete/dashboard')->getDashboardPaneHeaderWrapper(t('Composer Drafts'))?>

<?php  
$today = Loader::helper('date')->getLocalDateTime('now', 'Y-m-d');
if (count($drafts) > 0) { ?>

<table class="table table-striped">
<tr>
	<th width="60%"><?php echo t('Page Name')?></th>
	<th width="20%"><?php echo t('Page Type')?></th>
	<th width="20%"><?php echo t('Last Modified')?></th>
</tr>
<?php  foreach($drafts as $dr) { ?>
<tr>
	<td><a href="<?php echo $this->url('/dashboard/composer/write', 'edit', $dr->getCollectionID())?>"><?php  if (!$dr->getCollectionName()) {
		print t('(Untitled Page)');
	} else {
		print $dr->getCollectionName();
	} ?></a></td>
	<td><?php echo $dr->getCollectionTypeName()?></td>
	<td><?php 
		$mask = DATE_APP_GENERIC_MDYT;
		if ($today == $dr->getCollectionDateLastModified("Y-m-d")) {
			$mask = DATE_APP_GENERIC_T;
		}
		print $dr->getCollectionDateLastModified($mask)?></td>
<?php  } ?>
</table>

<?php  } else { ?>
	
	<p><?php echo t('You have not created any drafts. <a href="%s">Visit Composer &gt;</a>', $this->url('/dashboard/composer/write'))?></p>

<?php  } ?>

<?php echo Loader::helper('concrete/dashboard')->getDashboardPaneFooterWrapper();?>