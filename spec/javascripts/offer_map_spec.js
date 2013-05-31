require("spec_helper.js");
require("../../public/javascripts/search-results.js");
require("../../public/javascripts/offer-map.js");
require("http://maps.google.com/maps?file=api&v=2&key=ABQIAAAArqRYJAYO7t6Qq22fovsL_xToPEpFso3nIYdPKN-ZmNOPZiKIsBRZQYr6aR0Te9FhV0rAhjtHzx_PtQ&hl=en");

Screw.Unit(function() {
	describe("Offer", function() {
		var offer = null;

		before(function() {
			var offer_element = $(SearchResults.offersSelector(":first"));
			offer = new Offer(offer_element);
		});

		describe("when creating an offer from search results markup", function() {
			it("should read the lat", function() {
				expect(offer.lat).to(equal, "30.267862");
			});
			it("should read the lng", function() {
				expect(offer.lng).to(equal, "-97.738891");
			});
			it("should read the map marker letter", function() {
				expect(offer.markerLetter).to(equal, "A");
			});
		});		
	});
});

