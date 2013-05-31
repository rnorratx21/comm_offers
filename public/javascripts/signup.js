
$(document).ready(function() {
  $("h3 a", "#signup_category").click(function(){ 
    $(this).parents("h3").siblings("ul").slideToggle();
    toggleExpandCollapse($(this).parents("h3").children("span.expander").children("a"));
  });
  $("a#build_address", "div#offer_address").click(function(){ 
    $('div#existing_offer_address').remove();
    $('div#new_address').slideToggle();
  });
  
  setupZipCodeAddon();
  toggleAddonContent();

	bindPlanButtons();
	setupAddressMap();
	bindPaymentMethodCheckboxes();
	convertDateDashes($("#advertiser_offers_attributes_0_expires_on"));
	$("tr:odd").addClass("odd");
	// offerHeadlineSizeTip();
});

function bindPlanButtons(){
	$("a.plan_button", "#plan_buttons").live('click',function(){
    loadPlanForm(this);
    return false;
  });
}

function verifyTermsAgreement(){
	if(!$("input#confirm_agreement").is(":checked")){
		alert("Please accept the terms and conditions before proceeding.")
		return false;
	}
}

function loadPlanForm(link){
	load(link);
}

function toggleExpandCollapse(elem){
  if(elem.html().indexOf("Expand") > 0){
    elem.html($("div#collapse","div#hidden_expand_collapse").html());
  } else {
    elem.html($("div#expand","div#hidden_expand_collapse").html());
  }
}

function setupZipCodeAddon(){
  if ($("div#addon_addl_zip_block").length > 0){
    if ($("div#addon_addl_zip_block input[type=checkbox]").attr('checked')){
      $("div#addon_addl_zip_block div.content").show();
    } else {
      $("div#addon_addl_zip_block div.content").hide();
      // alert($("div#addon_addl_zip_block input[type=checkbox]").attr('checked'));
    }
  }  
}

function toggleAddonContent(){
  $("div.addon input[type=checkbox]").click(function(e){
    $(this).parent().siblings("div.content").slideToggle();
  });
}

function setupAddressMap(){
	$("#address_map").hide();
	$("button","#show_map_option").click(function(){
		$("#address_map").slideToggle(500, function(){
			$("#show_map_option > button").text($(this).is(':visible') ? "Hide Map" : "Show Map");
		});
	});
	
}

function bindPaymentMethodCheckboxes(){
	$("input[type=checkbox]", "#payment_method_checkboxes").click(function(){
		if($(this).is(":checked")){
			$("ul","#payment_methods").append("<li id='type_" + $(this).val() + "'>" + $(this).next("span").text() + "</li>");
		} else {
			$("ul","#payment_methods").children("li#type_" + $(this).val()).remove();
		}
	});
}
// Placeholder for later - would be nice to be able to give tips on sizing concerns
// function offerFieldSizeTip(fieldName, maxWordLength, maxOverallLength){
// 	$(fieldName).blur(function(){
// 		alert($(this).val().length);
		// alert($(this).val())
	// });
// }