$(document).ready(function() {
	// setupMerchantApprovedImg();
	$("a#search_submit").click(function(){
		$(this).closest('form').submit();
	});
	
	$("a.open_panel", "ul#featured_actions").click(function(){
		featuredActionClick($(this));
	});
	
	$("a.close_panel", "ul#featured_actions").click(function(){
		$(this).closest('.panel').hide();
	});
	
	setupPanelPositioning();
});

function featuredActionClick(e){
	$("div.panel").each(function(){ $(this).hide(); });
	e.closest("li").children("div.panel").slideToggle('slow');
}

function setupPanelPositioning(){
	$("div.panel", "ul#featured_actions").each(function(){
		$(this).css({'top' : $(this).parent().offset().top});
	});
}
