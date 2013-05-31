$(document).ready(function() {
	bindReporting();
});


function bindReporting(){
	$("li.page_reporting").each(function(){
	  path = $(this).children("a.path");
    $(this).children("msg").show();
    $.get(path.attr('href'), null, null, "script");
  });
}
