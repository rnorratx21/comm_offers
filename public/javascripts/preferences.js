$(document).ready(function() {
	$("a.select_all").click(function(){ toggleAllSiblings($(this),true)});
	$("a.deselect_all").click(function(){ toggleAllSiblings($(this),false)});
});

function toggleAllSiblings(anchor,value){
	$(anchor).siblings("ul").find("input[type=checkbox]").each(function(){
		$(this).attr('checked', value);
	});
	
}