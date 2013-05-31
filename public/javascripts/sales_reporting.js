$(document).ready(function() {
	$("a#report_csv_run").click(function(e){
		originalAction = $(this).closest('form').attr('action');
		e.preventDefault();
		$(this).closest('form').attr('action', $(this).attr('href'));
		$(this).closest('form').submit();
		$(this).closest('form').attr('action', originalAction);
	});
	
});

