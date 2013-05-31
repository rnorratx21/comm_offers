function initOfferDetailsMap(serviceAreaMappablesData) {

	var infoWindow = function(element) {
		return function() {
			var marker_info = ($(element).hasClass("marker_info")) ? element.text() : $(".marker_info", element).text();
			return "<p class=\"map_info\">" + marker_info + "</p>";
		}
	}
	
	var zipCodeInfoWindow = function(zipCode) {
		return function() {
			return "<p class=\"map_info\">" + zipCode + "</p>";
		}
	}
	
	function serviceAreaMappables(serviceAreaMappablesData) {
		var serviceAreaMappables = []
		
		for (var i=0; i<serviceAreaMappablesData.length; i++) {
			var data = serviceAreaMappablesData[i];

			var mappable = new Mappable(data,  zipCodeInfoWindow(data.zipCode));
			serviceAreaMappables.push(mappable);
		}
		return serviceAreaMappables;
	}
	
	$("#map").each(function() {
		var offerMap = new OfferMap(this, new GSmallZoomControl3D());	
		
		var mappables = Mappables.get(Mappables.selector(), infoWindow);
		offerMap.addMappables(mappables);
		if (serviceAreaMappablesData) {
			var mappables = serviceAreaMappables(serviceAreaMappablesData);
			offerMap.addMappables(mappables);					
		}
		offerMap.addMarkers();
		offerMap.center();
	});
}

/*
 * Fill in preview box for offer badge title.  Purpose is to 
 * show user how it will look prior to expensive preview process
 */
var update_headline = function() {
  var text = $("#headline-text").val();
  $(".headline", "#badge_preview").html(text);
  $("#offer_headline", "#offer_preview").html(text);
}

var update_title = function() {
  var text = $("#title-text").val();
  $("p.title", "#badge_preview").html(text);
  $("#title", "#offer_preview").html(text);
}

/*
	Google map with draggable marker to select lat/lng.
*/
function MapManager(config){
	var map = new GMap2(document.getElementById(config.divId));
	map.addControl(new GMapTypeControl());
	map.addControl(new GLargeMapControl3D());
	$('#' + config.latInputId).val(config.lat);
	$('#' + config.lngInputId).val(config.lng);
	
	var displayMarkerFunc = function(point, latInputId, lngInputId){
		map.clearOverlays();
		if (config.supportMarkerDragging) {
			var marker = new GMarker(point, {draggable: true});
			
			GEvent.addListener(marker, "dragend", function() {
				var a = marker.getLatLng();
				$(latInputId).val(a.y); 
				$(lngInputId).val(a.x);
				map.setCenter(a);
		    });
		} else {
			var marker = new GMarker(point);
		}
		map.setCenter(point, 4);
		map.addOverlay(marker);
	}
	
	var getPointFromLatLngTextBoxes = function() {
		return (config.latInputId != undefined && config.lngInputId != undefined) 
			? new GLatLng($('#' + config.latInputId).val(), $('#' + config.lngInputId).val())
		 	: new GLatLng(config.lat, config.lng);
	}

	var center = getPointFromLatLngTextBoxes();
	displayMarkerFunc(center, '#' + config.latInputId, '#' + config.lngInputId);
	
	$('#' + config.locateAddressId).click(function(){
		var geocoderAddressResolvedFunc = function(point) {
      		if (!point) {
        		alert("Address not found");
      		} else {
				$('#' + config.latInputId).val(point.y);
				$('#' + config.lngInputId).val(point.x);
				displayMarkerFunc(point, '#' + config.latInputId, '#' + config.lngInputId);
	     	}
    	}

		geocoder = new GClientGeocoder();
		geocoder.getLatLng(config.getCurrentAddress(), geocoderAddressResolvedFunc);
	});
	
	$('#' + config.locateLatLngId).click(function(){
		var center = getPointFromLatLngTextBoxes();
		displayMarkerFunc(center, '#' + config.latInputId, '#' + config.lngInputId);
	});
}

$(document).ready(function() {
  $("#headline-text").keyup(update_headline);
  $("#title-text").keyup(update_title);
  $("input#advertiser_offers_attributes_0_hours").keyup(function(){
    $("#offer_preview span#hours").html($(this).val())
  });
  $("input#advertiser_offers_attributes_0_effective").keyup(function(){
    $("#offer_preview span#effective").html($(this).val())
  });
  $("input#advertiser_offers_attributes_0_expires_on").keyup(function(){
    $("#offer_preview span#expires_on").html($(this).val())
  });
  $("input#advertiser_offers_attributes_0_disclaimers").keyup(function(){
    $("#offer_preview span#disclaimers").html($(this).val())
  });
  $("input#advertiser_offers_attributes_0_payment_methods").keyup(function(){
    $("#offer_preview div#payment_methods").html($(this).val())
  });
  $("textarea#advertiser_offers_attributes_0_description").keyup(function(){
    txt = $(this).val().replace(/\n/g,"<br>");
    $("#offer_preview #description").html(txt);
  });
  
  
  // $("input#offer_signup_state_hours").keyup(update_offer_field($("#offer_preview span#hours")));
});