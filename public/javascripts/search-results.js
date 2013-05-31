
function initSearchResults() {
	// $(".offer").each(function() {
	// 	if ($(this).attr("data-featured") == "true") {
	// 		$(".badge", this).toggleClass("featured");
	// 	}
	// });

	// $(".badge").click(function() {
	// 	window.location = $(".go_offer_button a", this).attr("href");
	// });

	var infoWindow = function(element) {
		function sanitizeBadgeForMap(badge) {
			badge.removeClass("rounded");
			badge.removeClass("featured");
			badge.removeClass("rounded_by_jQuery_corners");
			badge.removeAttr("style");
		}

		return function() {			
			var badge = $(".badge", element).clone();
			sanitizeBadgeForMap(badge);

			var div = document.createElement("div");
			var infoWindowBadge = $(div).addClass("offer").append(badge).get(0);
			return infoWindowBadge;
		}		
	}

	$("#map").each(function() {
		var offers = Mappables.get(Mappables.selector(), infoWindow);
		var offerMap = new OfferMap(this);	
		offerMap.addMappables(offers);
		offerMap.addMarkers();
		offerMap.center();
	});

}
