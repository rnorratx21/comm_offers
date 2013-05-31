var Mappables = {};
Mappables.selector = function(filter) {
	var selector = ".mappable";
	if (filter) {
		selector = selector + filter;
	}
	return selector;
}

Mappables.get = function(selector, infoWindow) {
	var mappables = [];

	$(selector).each(function() {
		var element = $(this);

		var mappableData = Mappable.fromElement(element)
    if (mappableData.lat && mappableData.lng) {
      var mappable = new Mappable(mappableData, infoWindow(element));
      mappables.push(mappable);
    }
	});
	
	return mappables;
}

function Mappable(mappable, infoWindowCreator) {
	this.lat = mappable.lat;
	this.lng = mappable.lng;
	this.width = mappable.width;
	this.height = mappable.height;
	this.marker = mappable.marker;
	this.markerIconUrl = mappable.markerIconUrl;
	this.infoWindowCreator = infoWindowCreator;
}

Mappable.fromElement = function(element) {
	var mappable = {
		lat : element.attr("data-lat"),
		lng : element.attr("data-lng"),
		width : element.attr("data-width"),
		height : element.attr("data-height"),
		shadownIcon : element.attr("data-shadow"),
		marker : $("img", element),
	}

	mappable.markerIconUrl = mappable.marker.attr("src");	
	if (!mappable.markerIconUrl) {
		mappable.markerIconUrl = element.attr("data-marker");
	}
	return mappable;
}

Mappable.prototype.addMarker = function(map) {
	var point = new GLatLng(this.lat, this.lng);
	
	var icon = new GIcon(G_DEFAULT_ICON);
	icon.image = this.markerIconUrl;
	
	if (this.height && this.width) {
		icon.iconSize = new GSize(this.width, this.height);
		icon.shadow = this.shadownIcon;
	}
		
	var marker = new GMarker(point, {title : this.title, icon : icon});

	var mappable = this;
	var handler = function() {
		marker.openInfoWindow(mappable.infoWindowCreator())
	}
	
	GEvent.addListener(marker, "click", handler);
	if (this.marker) {
		$(this.marker).click(handler);		
	}
	
	map.addOverlay(marker);	
}
