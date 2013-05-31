$(document).ready(function() {
	var setSearchButtonState = function(){
		
		var search_query_fields = $('#admin_search_query');
		var admin_search_submits = $('#admin_search_submit');
		
		if (search_query_fields.length == 0 || admin_search_submits.length == 0)
			return;
	
		//var search_query = search_query_fields[0].value;
		//var admin_search_submit = admin_search_submits[0];
	
		if (search_query_fields[0].value.length > 0) {
			$('#admin_search_submit').removeAttr("disabled");
		} else {
			$('#admin_search_submit').attr("disabled", "disabled");
		}
	}

	setSearchButtonState();

	$('#admin_search_query').focus(setSearchButtonState);
	$('#admin_search_query').keyup(setSearchButtonState);
	$('#admin_search_query').change(setSearchButtonState);
	$('#admin_search_query').blur(setSearchButtonState);
	bindEditToggleFields();
	
	addUserRole($('#add_user_role_submit'));
});

/* Used on new/edit offer screens */
function bindEditToggleFields(){
	$('.editable').each(function(){ $(this).hide(); });
  $('.edit_toggle').click(function(){
    $(this).parent().siblings('.editable').show();
    $(this).remove();
  });
}

function addUserRole(button){
	ajaxPost(button);
}
