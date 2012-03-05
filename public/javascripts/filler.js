/*!
 * jQuery formFiller Plugin
 * Examples and documentation at: http://jellypirate.org/formfiller
 * Copyright (c) 2011 S. Lövgren
 * Version: 1.0.0 (11-NOV-2011)
 *
 * Dual licensed under the MIT and GPL licenses.
 * http://jellypirate.org/license
 * Requires: jQuery v1.4.4 or later
 */
(function($){$.fn.formFiller=function(a){var b={'content':'','color':'#999','bg':'','attr':'','bold':false,'italic':false};return this.each(function(){if(a){$.extend(b,a)}if(!b['content']){if(!b['attr']){this.filler=$(this).attr('alt')}else{this.filler=$(this).attr(b['attr'])}}else{this.filler=b['content']}this.bold='';if(b['bold']){this.bold='bold'}this.italic='';if(b['italic']){this.italic='italic'}$(this).attr('value',this.filler).css('color',b['color']).css('background',b['bg']).css('font-weight',this.bold).css('font-style',this.italic);$(this).focusin(function(){if($(this).attr('value')==this.filler){$(this).attr('value','').css('color','').css('background','').css('font-weight','').css('font-style','')}});$(this).focusout(function(){if(!$(this).attr('value')){$(this).attr('value',this.filler).css('color',b['color']).css('background',b['bg']).css('background',b['bg']).css('font-weight',this.bold).css('font-style',this.italic)}})})}})(jQuery);