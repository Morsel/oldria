/*
 * 	Character Count Plugin with disable control - jQuery plugin
 * 	Dynamic character count for text areas and input fields and disable control
 *	written by Muhammad Arifur Rahman
 *	http://cssglobe.com/post/7161/jquery-plugin-simplest-twitterlike-dynamic-character-count-for-textareas
 *
 *	Copyright (c) 2011 Muhammad Arifur Rahman (http://learneveryday.net)
 *  Company web site : www.smartwebsouce.com
 *  Special thankx to Alen Grakalic (http://cssglobe.com) for his Character Count Plugin 
 * 
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
 
(function($) {
 
$.fn.charCount = function(options) {

    // default configuration properties
    var defaults = {
        allowed: 140,
        minChar: 5,
        warning: 25,
        css: 'counter',
        counterElement: 'span',
        cssWarning: 'warning',
        cssExceeded: 'exceeded',
        counterText: '',
        disableControl: '',
        isDisable: true
    };

    var options = $.extend(defaults, options);


    function disableControl(obj) {

        
// if the control need to disable then it will disable
        if (options.isDisable) {

            $(options.disableControl).attr("disabled", "disabled");

            var chars = 0;
            $(options.countControl).keyup(function() {
            chars = $(obj).val().length;
                if ((chars < options.minChar) || (chars > options.allowed)) {
                    $(options.disableControl).attr("disabled", "disabled");
                }
                else {
                    $(options.disableControl).removeAttr("disabled");
                }


            });
        };

        // end of each function

    };

 
        function calculate(obj) {
            var count = $(obj).val().length;
            var available = options.allowed - count;
            if (available <= options.warning && available >= 0) {
                $(obj).next().addClass(options.cssWarning);
            } else {
                $(obj).next().removeClass(options.cssWarning);
            }
            if (available < 0) {
                $(obj).next().addClass(options.cssExceeded);
            } else {
                $(obj).next().removeClass(options.cssExceeded);
            }
            $(obj).next().html(options.counterText + available);
        };

        this.each(function() {
            $(this).after('<' + options.counterElement + ' class="' + options.css + '">' + options.counterText + '</' + options.counterElement + '>');
            calculate(this);
            disableControl(this);
            $(this).keyup(function() { calculate(this) });
            $(this).change(function() { calculate(this) });
        });

    };

})(jQuery);
