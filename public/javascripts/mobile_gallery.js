$(document).ready(function() {

	// $('#slider').nivoSlider();

	$('#slider').nivoSlider({
	  effect:'slideInRight', //Specify sets like: 'fold,fade,sliceDown'
	  slices:15,
	  animSpeed:500, //Slide transition speed
	  pauseTime:3000,
	  startSlide:0, //Set starting Slide (0 index)
	  directionNav:true, //Next & Prev
	  directionNavHide:true, //Only show on hover
	  controlNav:true, //1,2,3...
	  // controlNavThumbs:false, //Use thumbnails for Control Nav
	  // controlNavThumbsFromRel:false, //Use image rel for thumbs
	  // controlNavThumbsSearch: '.jpg', //Replace this with...
	  // controlNavThumbsReplace: '_thumb.jpg', //...this in thumb Image src
	  keyboardNav:true, //Use left & right arrows
	  pauseOnHover:true, //Stop animation while hovering
	  manualAdvance:true, //Force manual transitions
	  captionOpacity:0.8, //Universal caption opacity
	  beforeChange: function(){},
	  afterChange: function(){},
	  slideshowEnd: function(){}, //Triggers after all slides have been shown
	  lastSlide: function(){}, //Triggers when last slide is shown
	  afterLoad: function(){} //Triggers when slider has loaded
	});

});
