function OfferMap(map_element, mapControl) {
	if (!mapControl) {
		mapControl = new GLargeMapControl3D();
	}
	this.map = new GMap2(map_element);
	this.mappables = [];

	this.map.addControl(mapControl);
}

OfferMap.prototype.addMappables = function(mappables) {
	this.mappables = this.mappables.concat(mappables);
}

OfferMap.prototype.addMarkers = function() {
	var instance = this;
	$(this.mappables).each(function(index, mappable) {
		mappable.addMarker(instance.map);
	});
}

OfferMap.prototype.center = function() {
	var bounds = this.visibleBounds();
	this.map.setCenter(bounds.getCenter());

/* Center map */
    // Extract zip parameter from query string
    var urlParams = {};
    var e;
    var q = window.location.search.substring(1);
    var r = /([^&=]+)=([^&]+)/g;

    while (e = r.exec(q)) {
       urlParams[decodeURIComponent(e[1])] = decodeURIComponent(e[2]);
    }

    // if zip parameter presents in query string then find its coordinates and center map around them using Google Map API
    if (urlParams.zip != undefined) {
	    var geocoder = new GClientGeocoder();
	    var map = this.map;

        geocoder.getLatLng(urlParams.zip, function(point) {
            map.setCenter(point);
        });
    }
/* end Center map */
	if (this.mappables.length == 1) {
		this.map.setZoom(13);
	} else {
		this.map.setZoom(this.map.getBoundsZoomLevel(bounds));
	}
}

OfferMap.prototype.visibleBounds = function() {
	var bounds = new GLatLngBounds();

	$(this.mappables).each(function(index, mappable) {
		bounds.extend(new GLatLng(mappable.lat, mappable.lng));
	})

	this.extendBounds(bounds);

	return bounds;
}

OfferMap.prototype.extendBounds = function(bounds) {
	this.extendSW(bounds);
	this.extendNE(bounds);
}

OfferMap.prototype.extendSW = function(bounds) {
	var span = bounds.toSpan();
	var sw = bounds.getSouthWest();
	bounds.extend(new GLatLng(sw.lat()-(0.01)*span.lat(), sw.lng()-(0.01)*span.lng()));
}

OfferMap.prototype.extendNE = function(bounds) {
	var span = bounds.toSpan();
	var ne = bounds.getNorthEast();
	bounds.extend(new GLatLng(ne.lat()+(0.01)*span.lat(), ne.lng()+(0.01)*span.lng()));
}

