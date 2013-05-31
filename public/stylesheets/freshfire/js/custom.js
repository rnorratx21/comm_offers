// JQUERY CYCLE
$(document).ready(function() {
	$("#slideshow").css("overflow", "hidden");
			
	$("ul#slides").cycle({
		fx: 'fade',
		prev: '#prev',
		pause: 1,
		next: '#next'
	});
			
	$("#slideshow").hover(function() {
		$("ul#nav").show();
	},
		function() {
		$("ul#nav").hide();
	});		
});

// Lightbox for images
$(document).ready(function() {
	$(".gallery li.image a, .portfolio li.image a, a.fancy").fancybox({
		'titlePosition'		: 'over'
	});
});

// Lightbox for vimeo videos
$(document).ready(function() {
$("li.vimeo a").click(function() {
	$.fancybox({
		'padding'		: 0,
		'autoScale'		: false,
		'transitionIn'	: 'none',
		'transitionOut'	: 'none',
		'title'			: this.title,
		'width'			: 600,
		'height'		: 398,
		'href'			: this.href.replace(new RegExp("([0-9])","i"),'moogaloop.swf?clip_id=$1'),
		'type'			: 'swf'
	});
		return false;
	});
});

// Lightbox for YouTube videos
$(document).ready(function() {
$("li.youtube a").click(function() {
	$.fancybox({
			'padding'		: 0,
			'autoScale'		: false,
			'transitionIn'	: 'none',
			'transitionOut'	: 'none',
			'title'			: this.title,
			'width'		: 680,
			'height'		: 495,
			'href'			: this.href.replace(new RegExp("watch\\?v=", "i"), 'v/'),
			'type'			: 'swf',
			'swf'			: {
			   	 'wmode'		: 'transparent',
				'allowfullscreen'	: 'true'
			}
		});

	return false;
});
});

// TOOLTIP
$(document).ready(function() {
	$('.ttip').tipsy({delayIn: 0, delayOut: 0});
});

// IMAGE GALLERY FADE OPACITY WHEN HOVER
$(document).ready(function() {

	$(function() {
	
		$(".gallery img, .portfolio img").css("opacity", "1");
			
		// ON MOUSE OVER
		$(".gallery img, .portfolio img").hover(function () {

			// SET OPACITY TO 100%
			$(this).stop().animate({
			opacity: 0.5
			}, "fast");
		},

		// ON MOUSE OUT
		function () {

			// SET OPACITY BACK TO 100%
			$(this).stop().animate({
			opacity: 1
			}, "fast");
		});	
	});
});

// PAGENAV CLICK
$(document).ready(function() {
		$("#page-nav a, .submenu li").click(function () {
            $('#page-nav .current, .submenu .current').removeClass("current", 1000);
			$(this).addClass("current", 1000);
			$(this).find('a').stop().animate({
            opacity: 1
            }, "fast");
        });
});

//* CONTENT TOGGLE
$(document).ready(function(){

	$(".toggle_div").hide(); 
			
	$("h4.toggle").toggle(function(){
		$(this).addClass("active");
		}, function () {
		$(this).removeClass("active");
	});

	$("h4.toggle").click(function(){
		$(this).next(".toggle_div").slideToggle();
	});
});

// MAINNAV
$(document).ready(function() { 
	$('ul.sf-menu').superfish({ 
	delay:       400,                           // one second delay on mouseout 
	animation:   {height:'show'},  				// fade-in and slide-down animation 
	speed:       'fast'                        // normal animation speed 
	}); 
}); 

/**
 * Cookie plugin
 *
 * Copyright (c) 2006 Klaus Hartl (stilbuero.de)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 */

jQuery.cookie = function(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};

//
// Skin switch function
// ---------------------------
function switchSkin(skin) {
	$.cookie("skin", skin);
	document.location.reload(true);
}

//
// Include skin style sheet
// ---------------------------
	var skin = $.cookie("skin") || "1";
	document.write('<link rel="stylesheet" href="assets/css/skin-'+ skin +'.css" type="text/css" />');