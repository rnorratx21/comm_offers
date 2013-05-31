$(document).ready(function() {
  
  // Stripe Tables
  $("table.striped tr:nth-child(even)").addClass("even");
  $("table.striped tr:nth-child(odd)").addClass("odd");

  $("table.jumptable tr").click(function(){
    url = $(this).find("a:first").attr("href");
    if (url) {
      window.location = url;
    };
  });
  
  $("select#contract_advertiser_id").change(function(){
    $.getJSON("/admin/offers/without_contract.json",{advertiser_id: $(this).val(), ajax: 'true'}, function(data){
      var options = '';
      for (var i = 0; i < data.length; i++) {
        options += '<option value="' + data[i].offer.id + '">' + data[i].offer.title + '</option>';
      }
      $("select#contract_offer_ids").html(options);
    })
  });

  // temporarily here!
  unbindChangeConsecuentDates();
  bindChangeConsecuentDates();

	bindHomeSearch();
	bindHeadlineResize();
	
	setupDatePickers();
	bindUrlAutoSuggest();
	$("table.tablesorter").tablesorter();
});


function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
};

// Is due, start, or through date block
function selectId2DateBlockNum(id) {
	return (id.indexOf('due_date') != -1) ? 1 : (id.indexOf('period_start') != -1) ? 2 : 3;
}

// Is year, month, or day select
function selectId2DatePartNum(id) {
	return (id.indexOf('1i') != -1) ? 1 : (id.indexOf('2i') != -1) ? 2 : 3;
}

function convertDateDashes(element){
	element.blur(function(){ $(this).val($(this).val().replace(/-/g,"/")) });
}

function findSiblingSelectValue(select, datePartNum) {
	var value = 0;
	var siblingSelects = $(select).parent().parent().parent().find('select');
	var dateBlockNum = selectId2DateBlockNum(select.id);
	
	$.each(siblingSelects, function() { 
		if (dateBlockNum == selectId2DateBlockNum(this.id) && selectId2DatePartNum(this.id) == datePartNum) {
			value = parseInt(this.value);
		}
	});
	
	return value;
}

function setSiblingSelectValue(select, datePartNum, value) {
	var siblingSelects = $(select).parent().parent().parent().find('select');
	var dateBlockNum = selectId2DateBlockNum(select.id);
	
	$.each(siblingSelects, function() { 
		if (dateBlockNum == selectId2DateBlockNum(this.id) && selectId2DatePartNum(this.id) == datePartNum) {
			this.value = value;
		}
	});
}

function getMaxMonthDay(_year, month) {
	var monthMaxDays = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	var maxDay = monthMaxDays[month];
	var isLeapFeb = (month == 2) && (_year == 2004 || _year == 2008 || _year == 2012);
	return (isLeapFeb) ? maxDay + 1 : maxDay;
}

function getNearestValidDay(_year, month, day) {
	var maxMonthDay = getMaxMonthDay(_year, month);
	return Math.min(day, maxMonthDay);
}

// Handles select value change in a date block
function changeConsecuentDates(changedSelect) {
	var dateBlockNum = selectId2DateBlockNum(changedSelect.id); // Due or start or through
	var datePartNum = selectId2DatePartNum(changedSelect.id); // Year or month or day
	
	// If day changed
	if (datePartNum == 3) {
		var startDay = parseInt(changedSelect.value);
		var startMonth = findSiblingSelectValue(changedSelect, 2);
		var startYear = findSiblingSelectValue(changedSelect, 1);
		
		changedSelect.value = getNearestValidDay(startYear, startMonth, startDay);
	}
	// If month changed 
	else if (datePartNum == 2) {
		var startDay = findSiblingSelectValue(changedSelect, 3);
		var startMonth = changedSelect.value;
		var startYear = findSiblingSelectValue(changedSelect, 1);
		
		setSiblingSelectValue(changedSelect, 3, getNearestValidDay(startYear, startMonth, startDay));
	}
	// If year changed
	else if (datePartNum == 1) {
		var startDay = findSiblingSelectValue(changedSelect, 3);
		var startMonth = findSiblingSelectValue(changedSelect, 2);
		var startYear = (startMonth == 12) ? parseInt(changedSelect.value) + 1 : changedSelect.value;
		
		setSiblingSelectValue(changedSelect, 3, getNearestValidDay(startYear, startMonth, startDay));
	}
	
	// consecuent div tags with date select controls to be changed
	var nextDivs = $(changedSelect).parent().parent().parent().nextAll('div.fields');
	
	// Iterate through all div tags with an invoice form
	$.each(nextDivs, function() {
		var selects = $(this).find('select');
		
		// Iterate over all selects in an invoice form 
		$.each(selects, function() { 
			if (dateBlockNum == selectId2DateBlockNum(this.id)) {
				// Day changed
				if (datePartNum == 3 && selectId2DatePartNum(this.id) == 3) {
					var selectedMonth = findSiblingSelectValue(this, 2);
					var selectedYear = findSiblingSelectValue(this, 1);
					var maxMonthDay = getMaxMonthDay(selectedYear, selectedMonth);
					this.value = getNearestValidDay(selectedYear, selectedMonth, startDay);
				// Month changed
				} else if (datePartNum == 2 && selectId2DatePartNum(this.id) == 2) {
					startYear = (startMonth == 12) ? ++startYear : startYear;
					startMonth = (startMonth == 12) ? 1 : ++startMonth;
					this.value = startMonth;
					setSiblingSelectValue(this, 1, startYear);
					// Set day is the current month doesn't have this date. i.e. no Feb 30
					setSiblingSelectValue(this, 3, getNearestValidDay(startYear, startMonth, findSiblingSelectValue(this, 3)));
				// Year changed
				} else if (datePartNum == 1 && selectId2DatePartNum(this.id) == 1) {
					this.value = startYear;
					var thisMonth = findSiblingSelectValue(this, 2);
					startYear = (thisMonth == 12) ? ++startYear : startYear;
					// Set day is the current month doesn't have this date. i.e. no Feb 30
					setSiblingSelectValue(this, 3, getNearestValidDay(startYear, thisMonth, findSiblingSelectValue(this, 3)));
				}
			}
		})
	});
};

var changeConsecuentDatesHanler = function() { 
	unbindChangeConsecuentDates();
	changeConsecuentDates(this); 
	bindChangeConsecuentDates();
};

function unbindChangeConsecuentDates() { $('div.fields select').die('change', changeConsecuentDatesHanler); }

function bindChangeConsecuentDates() { $('div.fields select').live('change', changeConsecuentDatesHanler);}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));

  unbindChangeConsecuentDates();
  bindChangeConsecuentDates();
};

function bindHomeSearch(){
	elem = $("input#search_search_text");
	var val = elem.attr("value");
	// alert(val);
	var default_text = "Enter Your Zip Code"
	if(val == "") elem.addClass("empty").attr("value", default_text);
	elem.focus(function(){
		var focus_val = $(this).attr("value");
		$(this).removeClass("empty");
		if(focus_val == default_text) $(this).attr("value","");
	});
	elem.blur(function(){
		var blur_val = $(this).attr("value");
		if(blur_val == ""){
			$(this).addClass("empty");
			$(this).attr("value", default_text); 
		}
	});
}

function bindHeadlineResize(){
	elem = $("h1", "#headerWrap");
	len = $(elem).text().length;

	// Only worry about re-sizing if over a certain total length
	if(len && len > 49){
		if(len > 70){
			$(elem).css("font-size", "170%");
		} else if(len > 65){
			$(elem).css("font-size", "200%");
		} else if(len > 60){
			$(elem).css("font-size", "220%");
		} else if(len > 55){
			$(elem).css("font-size", "240%");
		} else if(len > 50){
			$(elem).css("font-size", "260%");
		}
	}
}

// AJAX calls
function load(link){
  $.get(link.href, null, null, "script");
}

function setup_datepicker(element){
  $(element).datepicker({
       showOn: 'button',
       buttonImage: '/images/jquery/calendar.gif',
       buttonImageOnly: true,
       numberOfMonths: 1,
       showButtonPanel: true,
      // dateFormat: 'mm/dd/yy',
       currentText: 'Today'
   });
}

function setupDatePickers() {
  $('input.datepicker').each(function(i,obj){
    setup_datepicker(obj);
  });
}

function bindUrlAutoSuggest(){
	$("input.url_suggest").focus(function(){
		if($(this).val() == ''){
			$(this).val('http://');
		}
	});
	$("input.url_suggest").blur(function(){
		if($(this).val() == 'http://'){
			$(this).val('');
		}
	});

}

function ajaxPost(button){
	button.click(function(){
		form = button.closest('form'); 
		url = form.attr('action');
		$.post(url, form.serialize(), null, "script");
		return false;
	});
	
}


