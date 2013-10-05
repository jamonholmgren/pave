<?php  defined('C5_EXECUTE') or die("Access Denied."); ?>

<?php 
$records = WorkflowProgressHistory::getList($wp);
foreach($records as $r) { ?>
	
	<div>
		<strong><?php echo date(DATE_APP_GENERIC_MDYT_FULL, strtotime($r->getWorkflowProgressHistoryTimestamp()))?></strong>. 
		<?php echo $r->getWorkflowProgressHistoryDescription();?>
	</div>	
	
<?php  } ?>