ccmValidateBlockForm = function() {
	
	if ($('#field_2_textbox_text').val() == '') {
		ccm_addError('Missing required text: Textbox Field');
	}


	return false;
}
