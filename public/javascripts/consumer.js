$(document).ready(function() {
	bindTerms();
});

function verifyTermsAgreement(){
	if(!$("input#confirm_agreement").is(":checked")){
		alert("Please accept the terms and conditions before proceeding.")
		return false;
	}
}

function bindTerms(){
	$("a#terms").live('click',function(){
		load(this);
    return false;
  });
}
