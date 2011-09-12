/*
 * jQuery Form Plugin
 * version: 2.43 (12-MAR-2010)
 * @requires jQuery v1.3.2 or later
 *
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
(function(b){b.fn.ajaxSubmit=function(s){if(!this.length){a("ajaxSubmit: skipping submit process - no element selected");return this}if(typeof s=="function"){s={success:s}}var e=b.trim(this.attr("action"));if(e){e=(e.match(/^([^#]+)/)||[])[1]}e=e||window.location.href||"";s=b.extend({url:e,type:this.attr("method")||"GET",iframeSrc:/^https/i.test(window.location.href||"")?"javascript:false":"about:blank"},s||{});var u={};this.trigger("form-pre-serialize",[this,s,u]);if(u.veto){a("ajaxSubmit: submit vetoed via form-pre-serialize trigger");return this}if(s.beforeSerialize&&s.beforeSerialize(this,s)===false){a("ajaxSubmit: submit aborted via beforeSerialize callback");return this}var m=this.formToArray(s.semantic);if(s.data){s.extraData=s.data;for(var f in s.data){if(s.data[f] instanceof Array){for(var g in s.data[f]){m.push({name:f,value:s.data[f][g]})}}else{m.push({name:f,value:s.data[f]})}}}if(s.beforeSubmit&&s.beforeSubmit(m,this,s)===false){a("ajaxSubmit: submit aborted via beforeSubmit callback");return this}this.trigger("form-submit-validate",[m,this,s,u]);if(u.veto){a("ajaxSubmit: submit vetoed via form-submit-validate trigger");return this}var d=b.param(m);if(s.type.toUpperCase()=="GET"){s.url+=(s.url.indexOf("?")>=0?"&":"?")+d;s.data=null}else{s.data=d}var t=this,l=[];if(s.resetForm){l.push(function(){t.resetForm()})}if(s.clearForm){l.push(function(){t.clearForm()})}if(!s.dataType&&s.target){var p=s.success||function(){};l.push(function(k){var j=s.replaceTarget?"replaceWith":"html";b(s.target)[j](k).each(p,arguments)})}else{if(s.success){l.push(s.success)}}s.success=function(q,k,v){for(var n=0,j=l.length;n<j;n++){l[n].apply(s,[q,k,v||t,t])}};var c=b("input:file",this).fieldValue();var r=false;for(var i=0;i<c.length;i++){if(c[i]){r=true}}var h=false;if((c.length&&s.iframe!==false)||s.iframe||r||h){if(s.closeKeepAlive){b.get(s.closeKeepAlive,o)}else{o()}}else{b.ajax(s)}this.trigger("form-submit-notify",[this,s]);return this;function o(){var w=t[0];if(b(":input[name=submit]",w).length){alert('Error: Form elements must not be named "submit".');return}var q=b.extend({},b.ajaxSettings,s);var H=b.extend(true,{},b.extend(true,{},b.ajaxSettings),q);var v="jqFormIO"+(new Date().getTime());var D=b('<iframe id="'+v+'" name="'+v+'" src="'+q.iframeSrc+'" onload="(jQuery(this).data(\'form-plugin-onload\'))()" />');var F=D[0];D.css({position:"absolute",top:"-1000px",left:"-1000px"});var G={aborted:0,responseText:null,responseXML:null,status:0,statusText:"n/a",getAllResponseHeaders:function(){},getResponseHeader:function(){},setRequestHeader:function(){},abort:function(){this.aborted=1;D.attr("src",q.iframeSrc)}};var E=q.global;if(E&&!b.active++){b.event.trigger("ajaxStart")}if(E){b.event.trigger("ajaxSend",[G,q])}if(H.beforeSend&&H.beforeSend(G,H)===false){H.global&&b.active--;return}if(G.aborted){return}var k=false;var A=0;var j=w.clk;if(j){var y=j.name;if(y&&!j.disabled){q.extraData=q.extraData||{};q.extraData[y]=j.value;if(j.type=="image"){q.extraData[y+".x"]=w.clk_x;q.extraData[y+".y"]=w.clk_y}}}function x(){var K=t.attr("target"),I=t.attr("action");w.setAttribute("target",v);if(w.getAttribute("method")!="POST"){w.setAttribute("method","POST")}if(w.getAttribute("action")!=q.url){w.setAttribute("action",q.url)}if(!q.skipEncodingOverride){t.attr({encoding:"multipart/form-data",enctype:"multipart/form-data"})}if(q.timeout){setTimeout(function(){A=true;B()},q.timeout)}var J=[];try{if(q.extraData){for(var L in q.extraData){J.push(b('<input type="hidden" name="'+L+'" value="'+q.extraData[L]+'" />').appendTo(w)[0])}}D.appendTo("body");D.data("form-plugin-onload",B);w.submit()}finally{w.setAttribute("action",I);K?w.setAttribute("target",K):t.removeAttr("target");b(J).remove()}}if(q.forceSync){x()}else{setTimeout(x,10)}var z=100;function B(){if(k){return}var I=true;try{if(A){throw"timeout"}var J,M;M=F.contentWindow?F.contentWindow.document:F.contentDocument?F.contentDocument:F.document;var N=q.dataType=="xml"||M.XMLDocument||b.isXMLDoc(M);a("isXml="+N);if(!N&&(M.body==null||M.body.innerHTML=="")){if(--z){a("requeing onLoad callback, DOM not available");setTimeout(B,250);return}a("Could not access iframe DOM after 100 tries.");return}a("response detected");k=true;G.responseText=M.body?M.body.innerHTML:null;G.responseXML=M.XMLDocument?M.XMLDocument:M;G.getResponseHeader=function(P){var O={"content-type":q.dataType};return O[P]};if(q.dataType=="json"||q.dataType=="script"){var n=M.getElementsByTagName("textarea")[0];if(n){G.responseText=n.value}else{var L=M.getElementsByTagName("pre")[0];if(L){G.responseText=L.innerHTML}}}else{if(q.dataType=="xml"&&!G.responseXML&&G.responseText!=null){G.responseXML=C(G.responseText)}}J=b.httpData(G,q.dataType)}catch(K){a("error caught:",K);I=false;G.error=K;b.handleError(q,G,"error",K)}if(I){q.success(J,"success");if(E){b.event.trigger("ajaxSuccess",[G,q])}}if(E){b.event.trigger("ajaxComplete",[G,q])}if(E&&!--b.active){b.event.trigger("ajaxStop")}if(q.complete){q.complete(G,I?"success":"error")}setTimeout(function(){D.removeData("form-plugin-onload");D.remove();G.responseXML=null},100)}function C(n,I){if(window.ActiveXObject){I=new ActiveXObject("Microsoft.XMLDOM");I.async="false";I.loadXML(n)}else{I=(new DOMParser()).parseFromString(n,"text/xml")}return(I&&I.documentElement&&I.documentElement.tagName!="parsererror")?I:null}}};b.fn.ajaxForm=function(c){return this.ajaxFormUnbind().bind("submit.form-plugin",function(d){d.preventDefault();b(this).ajaxSubmit(c)}).bind("click.form-plugin",function(i){var h=i.target;var f=b(h);if(!(f.is(":submit,input:image"))){var d=f.closest(":submit");if(d.length==0){return}h=d[0]}var g=this;g.clk=h;if(h.type=="image"){if(i.offsetX!=undefined){g.clk_x=i.offsetX;g.clk_y=i.offsetY}else{if(typeof b.fn.offset=="function"){var j=f.offset();g.clk_x=i.pageX-j.left;g.clk_y=i.pageY-j.top}else{g.clk_x=i.pageX-h.offsetLeft;g.clk_y=i.pageY-h.offsetTop}}}setTimeout(function(){g.clk=g.clk_x=g.clk_y=null},100)})};b.fn.ajaxFormUnbind=function(){return this.unbind("submit.form-plugin click.form-plugin")};b.fn.formToArray=function(q){var p=[];if(this.length==0){return p}var d=this[0];var h=q?d.getElementsByTagName("*"):d.elements;if(!h){return p}for(var k=0,m=h.length;k<m;k++){var e=h[k];var f=e.name;if(!f){continue}if(q&&d.clk&&e.type=="image"){if(!e.disabled&&d.clk==e){p.push({name:f,value:b(e).val()});p.push({name:f+".x",value:d.clk_x},{name:f+".y",value:d.clk_y})}continue}var r=b.fieldValue(e,true);if(r&&r.constructor==Array){for(var g=0,c=r.length;g<c;g++){p.push({name:f,value:r[g]})}}else{if(r!==null&&typeof r!="undefined"){p.push({name:f,value:r})}}}if(!q&&d.clk){var l=b(d.clk),o=l[0],f=o.name;if(f&&!o.disabled&&o.type=="image"){p.push({name:f,value:l.val()});p.push({name:f+".x",value:d.clk_x},{name:f+".y",value:d.clk_y})}}return p};b.fn.formSerialize=function(c){return b.param(this.formToArray(c))};b.fn.fieldSerialize=function(d){var c=[];this.each(function(){var h=this.name;if(!h){return}var f=b.fieldValue(this,d);if(f&&f.constructor==Array){for(var g=0,e=f.length;g<e;g++){c.push({name:h,value:f[g]})}}else{if(f!==null&&typeof f!="undefined"){c.push({name:this.name,value:f})}}});return b.param(c)};b.fn.fieldValue=function(h){for(var g=[],e=0,c=this.length;e<c;e++){var f=this[e];var d=b.fieldValue(f,h);if(d===null||typeof d=="undefined"||(d.constructor==Array&&!d.length)){continue}d.constructor==Array?b.merge(g,d):g.push(d)}return g};b.fieldValue=function(c,j){var e=c.name,p=c.type,q=c.tagName.toLowerCase();if(typeof j=="undefined"){j=true}if(j&&(!e||c.disabled||p=="reset"||p=="button"||(p=="checkbox"||p=="radio")&&!c.checked||(p=="submit"||p=="image")&&c.form&&c.form.clk!=c||q=="select"&&c.selectedIndex==-1)){return null}if(q=="select"){var k=c.selectedIndex;if(k<0){return null}var m=[],d=c.options;var g=(p=="select-one");var l=(g?k+1:d.length);for(var f=(g?k:0);f<l;f++){var h=d[f];if(h.selected){var o=h.value;if(!o){o=(h.attributes&&h.attributes.value&&!(h.attributes.value.specified))?h.text:h.value}if(g){return o}m.push(o)}}return m}return c.value};b.fn.clearForm=function(){return this.each(function(){b("input,select,textarea",this).clearFields()})};b.fn.clearFields=b.fn.clearInputs=function(){return this.each(function(){var d=this.type,c=this.tagName.toLowerCase();if(d=="text"||d=="password"||c=="textarea"){this.value=""}else{if(d=="checkbox"||d=="radio"){this.checked=false}else{if(c=="select"){this.selectedIndex=-1}}}})};b.fn.resetForm=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};b.fn.enable=function(c){if(c==undefined){c=true}return this.each(function(){this.disabled=!c})};b.fn.selected=function(c){if(c==undefined){c=true}return this.each(function(){var d=this.type;if(d=="checkbox"||d=="radio"){this.checked=c}else{if(this.tagName.toLowerCase()=="option"){var e=b(this).parent("select");if(c&&e[0]&&e[0].type=="select-one"){e.find("option").selected(false)}this.selected=c}}})};function a(){if(b.fn.ajaxSubmit.debug){var c="[jquery.form] "+Array.prototype.join.call(arguments,"");if(window.console&&window.console.log){window.console.log(c)}else{if(window.opera&&window.opera.postError){window.opera.postError(c)}}}}})(jQuery);


// ColorBox v1.3.15 - a full featured, light-weight, customizable lightbox based on jQuery 1.3+
// Copyright (c) 2010 Jack Moore - jack@colorpowered.com
// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
(function(b,ib){var t="none",M="LoadedContent",c=false,v="resize.",o="y",q="auto",e=true,L="nofollow",m="x";function f(a,c){a=a?' id="'+i+a+'"':"";c=c?' style="'+c+'"':"";return b("<div"+a+c+"/>")}function p(a,b){b=b===m?n.width():n.height();return typeof a==="string"?Math.round(/%/.test(a)?b/100*parseInt(a,10):parseInt(a,10)):a}function U(b){return a.photo||/\.(gif|png|jpg|jpeg|bmp)(?:\?([^#]*))?(?:#(\.*))?$/i.test(b)}function cb(a){for(var c in a)if(b.isFunction(a[c])&&c.substring(0,2)!=="on")a[c]=a[c].call(l);a.rel=a.rel||l.rel||L;a.href=a.href||b(l).attr("href");a.title=a.title||l.title;return a}function w(c,a){a&&a.call(l);b.event.trigger(c)}function jb(){var b,e=i+"Slideshow_",c="click."+i,f,k;if(a.slideshow&&h[1]){f=function(){F.text(a.slideshowStop).unbind(c).bind(V,function(){if(g<h.length-1||a.loop)b=setTimeout(d.next,a.slideshowSpeed)}).bind(W,function(){clearTimeout(b)}).one(c+" "+N,k);j.removeClass(e+"off").addClass(e+"on");b=setTimeout(d.next,a.slideshowSpeed)};k=function(){clearTimeout(b);F.text(a.slideshowStart).unbind([V,W,N,c].join(" ")).one(c,f);j.removeClass(e+"on").addClass(e+"off")};a.slideshowAuto?f():k()}}function db(c){if(!O){l=c;a=cb(b.extend({},b.data(l,r)));h=b(l);g=0;if(a.rel!==L){h=b("."+G).filter(function(){return (b.data(this,r).rel||this.rel)===a.rel});g=h.index(l);if(g===-1){h=h.add(l);g=h.length-1}}if(!u){u=D=e;j.show();if(a.returnFocus)try{l.blur();b(l).one(eb,function(){try{this.focus()}catch(a){}})}catch(f){}x.css({opacity:+a.opacity,cursor:a.overlayClose?"pointer":q}).show();a.w=p(a.initialWidth,m);a.h=p(a.initialHeight,o);d.position(0);X&&n.bind(v+P+" scroll."+P,function(){x.css({width:n.width(),height:n.height(),top:n.scrollTop(),left:n.scrollLeft()})}).trigger("scroll."+P);w(fb,a.onOpen);Y.add(H).add(I).add(F).add(Z).hide();ab.html(a.close).show()}d.load(e)}}var gb={transition:"elastic",speed:300,width:c,initialWidth:"600",innerWidth:c,maxWidth:c,height:c,initialHeight:"450",innerHeight:c,maxHeight:c,scalePhotos:e,scrolling:e,inline:c,html:c,iframe:c,photo:c,href:c,title:c,rel:c,opacity:.9,preloading:e,current:"image {current} of {total}",previous:"previous",next:"next",close:"close",open:c,returnFocus:e,loop:e,slideshow:c,slideshowAuto:e,slideshowSpeed:2500,slideshowStart:"start slideshow",slideshowStop:"stop slideshow",onOpen:c,onLoad:c,onComplete:c,onCleanup:c,onClosed:c,overlayClose:e,escKey:e,arrowKey:e},r="colorbox",i="cbox",fb=i+"_open",W=i+"_load",V=i+"_complete",N=i+"_cleanup",eb=i+"_closed",Q=i+"_purge",hb=i+"_loaded",E=b.browser.msie&&!b.support.opacity,X=E&&b.browser.version<7,P=i+"_IE6",x,j,A,s,bb,T,R,S,h,n,k,J,K,Z,Y,F,I,H,ab,B,C,y,z,l,g,a,u,D,O=c,d,G=i+"Element";d=b.fn[r]=b[r]=function(c,f){var a=this,d;if(!a[0]&&a.selector)return a;c=c||{};if(f)c.onComplete=f;if(!a[0]||a.selector===undefined){a=b("<a/>");c.open=e}a.each(function(){b.data(this,r,b.extend({},b.data(this,r)||gb,c));b(this).addClass(G)});d=c.open;if(b.isFunction(d))d=d.call(a);d&&db(a[0]);return a};d.init=function(){var l="hover",m="clear:left";n=b(ib);j=f().attr({id:r,"class":E?i+"IE":""});x=f("Overlay",X?"position:absolute":"").hide();A=f("Wrapper");s=f("Content").append(k=f(M,"width:0; height:0; overflow:hidden"),K=f("LoadingOverlay").add(f("LoadingGraphic")),Z=f("Title"),Y=f("Current"),I=f("Next"),H=f("Previous"),F=f("Slideshow").bind(fb,jb),ab=f("Close"));A.append(f().append(f("TopLeft"),bb=f("TopCenter"),f("TopRight")),f(c,m).append(T=f("MiddleLeft"),s,R=f("MiddleRight")),f(c,m).append(f("BottomLeft"),S=f("BottomCenter"),f("BottomRight"))).children().children().css({"float":"left"});J=f(c,"position:absolute; width:9999px; visibility:hidden; display:none");b("body").prepend(x,j.append(A,J));s.children().hover(function(){b(this).addClass(l)},function(){b(this).removeClass(l)}).addClass(l);B=bb.height()+S.height()+s.outerHeight(e)-s.height();C=T.width()+R.width()+s.outerWidth(e)-s.width();y=k.outerHeight(e);z=k.outerWidth(e);j.css({"padding-bottom":B,"padding-right":C}).hide();I.click(d.next);H.click(d.prev);ab.click(d.close);s.children().removeClass(l);b("."+G).live("click",function(a){if(!(a.button!==0&&typeof a.button!=="undefined"||a.ctrlKey||a.shiftKey||a.altKey)){a.preventDefault();db(this)}});x.click(function(){a.overlayClose&&d.close()});b(document).bind("keydown",function(b){if(u&&a.escKey&&b.keyCode===27){b.preventDefault();d.close()}if(u&&a.arrowKey&&!D&&h[1])if(b.keyCode===37&&(g||a.loop)){b.preventDefault();H.click()}else if(b.keyCode===39&&(g<h.length-1||a.loop)){b.preventDefault();I.click()}})};d.remove=function(){j.add(x).remove();b("."+G).die("click").removeData(r).removeClass(G)};d.position=function(f,d){function b(a){bb[0].style.width=S[0].style.width=s[0].style.width=a.style.width;K[0].style.height=K[1].style.height=s[0].style.height=T[0].style.height=R[0].style.height=a.style.height}var e,h=Math.max(document.documentElement.clientHeight-a.h-y-B,0)/2+n.scrollTop(),g=Math.max(n.width()-a.w-z-C,0)/2+n.scrollLeft();e=j.width()===a.w+z&&j.height()===a.h+y?0:f;A[0].style.width=A[0].style.height="9999px";j.dequeue().animate({width:a.w+z,height:a.h+y,top:h,left:g},{duration:e,complete:function(){b(this);D=c;A[0].style.width=a.w+z+C+"px";A[0].style.height=a.h+y+B+"px";d&&d()},step:function(){b(this)}})};d.resize=function(b){if(u){b=b||{};if(b.width)a.w=p(b.width,m)-z-C;if(b.innerWidth)a.w=p(b.innerWidth,m);k.css({width:a.w});if(b.height)a.h=p(b.height,o)-y-B;if(b.innerHeight)a.h=p(b.innerHeight,o);if(!b.innerHeight&&!b.height){b=k.wrapInner("<div style='overflow:auto'></div>").children();a.h=b.height();b.replaceWith(b.children())}k.css({height:a.h});d.position(a.transition===t?0:a.speed)}};d.prep=function(m){var c="hidden";function l(s){var p,f,m,c,l=h.length,q=a.loop;d.position(s,function(){function s(){E&&j[0].style.removeAttribute("filter")}if(u){E&&o&&k.fadeIn(100);k.show();w(hb);Z.show().html(a.title);if(l>1){typeof a.current==="string"&&Y.html(a.current.replace(/\{current\}/,g+1).replace(/\{total\}/,l)).show();I[q||g<l-1?"show":"hide"]().html(a.next);H[q||g?"show":"hide"]().html(a.previous);p=g?h[g-1]:h[l-1];m=g<l-1?h[g+1]:h[0];a.slideshow&&F.show();if(a.preloading){c=b.data(m,r).href||m.href;f=b.data(p,r).href||p.href;c=b.isFunction(c)?c.call(m):c;f=b.isFunction(f)?f.call(p):f;if(U(c))b("<img/>")[0].src=c;if(U(f))b("<img/>")[0].src=f}}K.hide();a.transition==="fade"?j.fadeTo(e,1,function(){s()}):s();n.bind(v+i,function(){d.position(0)});w(V,a.onComplete)}})}if(u){var o,e=a.transition===t?0:a.speed;n.unbind(v+i);k.remove();k=f(M).html(m);k.hide().appendTo(J.show()).css({width:function(){a.w=a.w||k.width();a.w=a.mw&&a.mw<a.w?a.mw:a.w;return a.w}(),overflow:a.scrolling?q:c}).css({height:function(){a.h=a.h||k.height();a.h=a.mh&&a.mh<a.h?a.mh:a.h;return a.h}()}).prependTo(s);J.hide();b("#"+i+"Photo").css({cssFloat:t,marginLeft:q,marginRight:q});X&&b("select").not(j.find("select")).filter(function(){return this.style.visibility!==c}).css({visibility:c}).one(N,function(){this.style.visibility="inherit"});a.transition==="fade"?j.fadeTo(e,0,function(){l(0)}):l(e)}};d.load=function(u){var n,c,s,q=d.prep;D=e;l=h[g];u||(a=cb(b.extend({},b.data(l,r))));w(Q);w(W,a.onLoad);a.h=a.height?p(a.height,o)-y-B:a.innerHeight&&p(a.innerHeight,o);a.w=a.width?p(a.width,m)-z-C:a.innerWidth&&p(a.innerWidth,m);a.mw=a.w;a.mh=a.h;if(a.maxWidth){a.mw=p(a.maxWidth,m)-z-C;a.mw=a.w&&a.w<a.mw?a.w:a.mw}if(a.maxHeight){a.mh=p(a.maxHeight,o)-y-B;a.mh=a.h&&a.h<a.mh?a.h:a.mh}n=a.href;K.show();if(a.inline){f().hide().insertBefore(b(n)[0]).one(Q,function(){b(this).replaceWith(k.children())});q(b(n))}else if(a.iframe){j.one(hb,function(){var c=b("<iframe frameborder='0' style='width:100%; height:100%; border:0; display:block'/>")[0];c.name=i+ +new Date;c.src=a.href;if(!a.scrolling)c.scrolling="no";if(E)c.allowtransparency="true";b(c).appendTo(k).one(Q,function(){c.src="//about:blank"})});q(" ")}else if(a.html)q(a.html);else if(U(n)){c=new Image;c.onload=function(){var e;c.onload=null;c.id=i+"Photo";b(c).css({border:t,display:"block",cssFloat:"left"});if(a.scalePhotos){s=function(){c.height-=c.height*e;c.width-=c.width*e};if(a.mw&&c.width>a.mw){e=(c.width-a.mw)/c.width;s()}if(a.mh&&c.height>a.mh){e=(c.height-a.mh)/c.height;s()}}if(a.h)c.style.marginTop=Math.max(a.h-c.height,0)/2+"px";h[1]&&(g<h.length-1||a.loop)&&b(c).css({cursor:"pointer"}).click(d.next);if(E)c.style.msInterpolationMode="bicubic";setTimeout(function(){q(c)},1)};setTimeout(function(){c.src=n},1)}else n&&J.load(n,function(d,c,a){q(c==="error"?"Request unsuccessful: "+a.statusText:b(this).children())})};d.next=function(){if(!D){g=g<h.length-1?g+1:0;d.load()}};d.prev=function(){if(!D){g=g?g-1:h.length-1;d.load()}};d.close=function(){if(u&&!O){O=e;u=c;w(N,a.onCleanup);n.unbind("."+i+" ."+P);x.fadeTo("fast",0);j.stop().fadeTo("fast",0,function(){w(Q);k.remove();j.add(x).css({opacity:1,cursor:q}).hide();setTimeout(function(){O=c;w(eb,a.onClosed)},1)})}};d.element=function(){return b(l)};d.settings=gb;b(d.init)})(jQuery,this);

jQuery.easing.jswing=jQuery.easing.swing;jQuery.extend(jQuery.easing,{def:"easeOutQuad",swing:function(e,f,a,h,g){return jQuery.easing[jQuery.easing.def](e,f,a,h,g)},easeInQuad:function(e,f,a,h,g){return h*(f/=g)*f+a},easeOutQuad:function(e,f,a,h,g){return -h*(f/=g)*(f-2)+a},easeInOutQuad:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f+a}return -h/2*((--f)*(f-2)-1)+a},easeInCubic:function(e,f,a,h,g){return h*(f/=g)*f*f+a},easeOutCubic:function(e,f,a,h,g){return h*((f=f/g-1)*f*f+1)+a},easeInOutCubic:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f*f+a}return h/2*((f-=2)*f*f+2)+a},easeInQuart:function(e,f,a,h,g){return h*(f/=g)*f*f*f+a},easeOutQuart:function(e,f,a,h,g){return -h*((f=f/g-1)*f*f*f-1)+a},easeInOutQuart:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f*f*f+a}return -h/2*((f-=2)*f*f*f-2)+a},easeInQuint:function(e,f,a,h,g){return h*(f/=g)*f*f*f*f+a},easeOutQuint:function(e,f,a,h,g){return h*((f=f/g-1)*f*f*f*f+1)+a},easeInOutQuint:function(e,f,a,h,g){if((f/=g/2)<1){return h/2*f*f*f*f*f+a}return h/2*((f-=2)*f*f*f*f+2)+a},easeInSine:function(e,f,a,h,g){return -h*Math.cos(f/g*(Math.PI/2))+h+a},easeOutSine:function(e,f,a,h,g){return h*Math.sin(f/g*(Math.PI/2))+a},easeInOutSine:function(e,f,a,h,g){return -h/2*(Math.cos(Math.PI*f/g)-1)+a},easeInExpo:function(e,f,a,h,g){return(f==0)?a:h*Math.pow(2,10*(f/g-1))+a},easeOutExpo:function(e,f,a,h,g){return(f==g)?a+h:h*(-Math.pow(2,-10*f/g)+1)+a},easeInOutExpo:function(e,f,a,h,g){if(f==0){return a}if(f==g){return a+h}if((f/=g/2)<1){return h/2*Math.pow(2,10*(f-1))+a}return h/2*(-Math.pow(2,-10*--f)+2)+a},easeInCirc:function(e,f,a,h,g){return -h*(Math.sqrt(1-(f/=g)*f)-1)+a},easeOutCirc:function(e,f,a,h,g){return h*Math.sqrt(1-(f=f/g-1)*f)+a},easeInOutCirc:function(e,f,a,h,g){if((f/=g/2)<1){return -h/2*(Math.sqrt(1-f*f)-1)+a}return h/2*(Math.sqrt(1-(f-=2)*f)+1)+a},easeInElastic:function(f,h,e,l,k){var i=1.70158;var j=0;var g=l;if(h==0){return e}if((h/=k)==1){return e+l}if(!j){j=k*0.3}if(g<Math.abs(l)){g=l;var i=j/4}else{var i=j/(2*Math.PI)*Math.asin(l/g)}return -(g*Math.pow(2,10*(h-=1))*Math.sin((h*k-i)*(2*Math.PI)/j))+e},easeOutElastic:function(f,h,e,l,k){var i=1.70158;var j=0;var g=l;if(h==0){return e}if((h/=k)==1){return e+l}if(!j){j=k*0.3}if(g<Math.abs(l)){g=l;var i=j/4}else{var i=j/(2*Math.PI)*Math.asin(l/g)}return g*Math.pow(2,-10*h)*Math.sin((h*k-i)*(2*Math.PI)/j)+l+e},easeInOutElastic:function(f,h,e,l,k){var i=1.70158;var j=0;var g=l;if(h==0){return e}if((h/=k/2)==2){return e+l}if(!j){j=k*(0.3*1.5)}if(g<Math.abs(l)){g=l;var i=j/4}else{var i=j/(2*Math.PI)*Math.asin(l/g)}if(h<1){return -0.5*(g*Math.pow(2,10*(h-=1))*Math.sin((h*k-i)*(2*Math.PI)/j))+e}return g*Math.pow(2,-10*(h-=1))*Math.sin((h*k-i)*(2*Math.PI)/j)*0.5+l+e},easeInBack:function(e,f,a,i,h,g){if(g==undefined){g=1.70158}return i*(f/=h)*f*((g+1)*f-g)+a},easeOutBack:function(e,f,a,i,h,g){if(g==undefined){g=1.70158}return i*((f=f/h-1)*f*((g+1)*f+g)+1)+a},easeInOutBack:function(e,f,a,i,h,g){if(g==undefined){g=1.70158}if((f/=h/2)<1){return i/2*(f*f*(((g*=(1.525))+1)*f-g))+a}return i/2*((f-=2)*f*(((g*=(1.525))+1)*f+g)+2)+a},easeInBounce:function(e,f,a,h,g){return h-jQuery.easing.easeOutBounce(e,g-f,0,h,g)+a},easeOutBounce:function(e,f,a,h,g){if((f/=g)<(1/2.75)){return h*(7.5625*f*f)+a}else{if(f<(2/2.75)){return h*(7.5625*(f-=(1.5/2.75))*f+0.75)+a}else{if(f<(2.5/2.75)){return h*(7.5625*(f-=(2.25/2.75))*f+0.9375)+a}else{return h*(7.5625*(f-=(2.625/2.75))*f+0.984375)+a}}}},easeInOutBounce:function(e,f,a,h,g){if(f<g/2){return jQuery.easing.easeInBounce(e,f*2,0,h,g)*0.5+a}return jQuery.easing.easeOutBounce(e,f*2-g,0,h,g)*0.5+h*0.5+a}});

/*
 * jQuery Cycle Plugin (with Transition Definitions)
 * Examples and documentation at: http://jquery.malsup.com/cycle/
 * Copyright (c) 2007-2010 M. Alsup
 * Version: 2.86 (05-APR-2010)
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 * Requires: jQuery v1.2.6 or later
 */
(function(i){var l="2.86";if(i.support==undefined){i.support={opacity:!(i.browser.msie)}}function a(r){if(i.fn.cycle.debug){f(r)}}function f(){if(window.console&&window.console.log){window.console.log("[cycle] "+Array.prototype.join.call(arguments," "))}}i.fn.cycle=function(s,r){var t={s:this.selector,c:this.context};if(this.length===0&&s!="stop"){if(!i.isReady&&t.s){f("DOM not ready, queuing slideshow");i(function(){i(t.s,t.c).cycle(s,r)});return this}f("terminating; zero elements found by selector"+(i.isReady?"":" (DOM not ready)"));return this}return this.each(function(){var x=m(this,s,r);if(x===false){return}x.updateActivePagerLink=x.updateActivePagerLink||i.fn.cycle.updateActivePagerLink;if(this.cycleTimeout){clearTimeout(this.cycleTimeout)}this.cycleTimeout=this.cyclePause=0;var y=i(this);var z=x.slideExpr?i(x.slideExpr,this):y.children();var v=z.get();if(v.length<2){f("terminating; too few slides: "+v.length);return}var u=k(y,z,v,x,t);if(u===false){return}var w=u.continuous?10:h(u.currSlide,u.nextSlide,u,!u.rev);if(w){w+=(u.delay||0);if(w<10){w=10}a("first timeout: "+w);this.cycleTimeout=setTimeout(function(){e(v,u,0,!u.rev)},w)}})};function m(r,u,s){if(r.cycleStop==undefined){r.cycleStop=0}if(u===undefined||u===null){u={}}if(u.constructor==String){switch(u){case"destroy":case"stop":var w=i(r).data("cycle.opts");if(!w){return false}r.cycleStop++;if(r.cycleTimeout){clearTimeout(r.cycleTimeout)}r.cycleTimeout=0;i(r).removeData("cycle.opts");if(u=="destroy"){q(w)}return false;case"toggle":r.cyclePause=(r.cyclePause===1)?0:1;v(r.cyclePause,s,r);return false;case"pause":r.cyclePause=1;return false;case"resume":r.cyclePause=0;v(false,s,r);return false;case"prev":case"next":var w=i(r).data("cycle.opts");if(!w){f('options not found, "prev/next" ignored');return false}i.fn.cycle[u](w);return false;default:u={fx:u}}return u}else{if(u.constructor==Number){var t=u;u=i(r).data("cycle.opts");if(!u){f("options not found, can not advance slide");return false}if(t<0||t>=u.elements.length){f("invalid slide index: "+t);return false}u.nextSlide=t;if(r.cycleTimeout){clearTimeout(r.cycleTimeout);r.cycleTimeout=0}if(typeof s=="string"){u.oneTimeFx=s}e(u.elements,u,1,t>=u.currSlide);return false}}return u;function v(y,z,x){if(!y&&z===true){var A=i(x).data("cycle.opts");if(!A){f("options not found, can not resume");return false}if(x.cycleTimeout){clearTimeout(x.cycleTimeout);x.cycleTimeout=0}e(A.elements,A,1,1)}}}function b(r,s){if(!i.support.opacity&&s.cleartype&&r.style.filter){try{r.style.removeAttribute("filter")}catch(t){}}}function q(r){if(r.next){i(r.next).unbind(r.prevNextEvent)}if(r.prev){i(r.prev).unbind(r.prevNextEvent)}if(r.pager||r.pagerAnchorBuilder){i.each(r.pagerAnchors||[],function(){this.unbind().remove()})}r.pagerAnchors=null;if(r.destroy){r.destroy(r)}}function k(z,L,v,u,F){var D=i.extend({},i.fn.cycle.defaults,u||{},i.metadata?z.metadata():i.meta?z.data():{});if(D.autostop){D.countdown=D.autostopCount||v.length}var s=z[0];z.data("cycle.opts",D);D.$cont=z;D.stopCount=s.cycleStop;D.elements=v;D.before=D.before?[D.before]:[];D.after=D.after?[D.after]:[];D.after.unshift(function(){D.busy=0});if(!i.support.opacity&&D.cleartype){D.after.push(function(){b(this,D)})}if(D.continuous){D.after.push(function(){e(v,D,0,!D.rev)})}n(D);if(!i.support.opacity&&D.cleartype&&!D.cleartypeNoBg){g(L)}if(z.css("position")=="static"){z.css("position","relative")}if(D.width){z.width(D.width)}if(D.height&&D.height!="auto"){z.height(D.height)}if(D.startingSlide){D.startingSlide=parseInt(D.startingSlide)}if(D.random){D.randomMap=[];for(var J=0;J<v.length;J++){D.randomMap.push(J)}D.randomMap.sort(function(N,w){return Math.random()-0.5});D.randomIndex=1;D.startingSlide=D.randomMap[1]}else{if(D.startingSlide>=v.length){D.startingSlide=0}}D.currSlide=D.startingSlide||0;var y=D.startingSlide;L.css({position:"absolute",top:0,left:0}).hide().each(function(w){var N=y?w>=y?v.length-(w-y):y-w:v.length-w;i(this).css("z-index",N)});i(v[y]).css("opacity",1).show();b(v[y],D);if(D.fit&&D.width){L.width(D.width)}if(D.fit&&D.height&&D.height!="auto"){L.height(D.height)}var E=D.containerResize&&!z.innerHeight();if(E){var x=0,C=0;for(var H=0;H<v.length;H++){var r=i(v[H]),M=r[0],B=r.outerWidth(),K=r.outerHeight();if(!B){B=M.offsetWidth||M.width||r.attr("width")}if(!K){K=M.offsetHeight||M.height||r.attr("height")}x=B>x?B:x;C=K>C?K:C}if(x>0&&C>0){z.css({width:x+"px",height:C+"px"})}}if(D.pause){z.hover(function(){this.cyclePause++},function(){this.cyclePause--})}if(c(D)===false){return false}var t=false;u.requeueAttempts=u.requeueAttempts||0;L.each(function(){var P=i(this);this.cycleH=(D.fit&&D.height)?D.height:(P.height()||this.offsetHeight||this.height||P.attr("height")||0);this.cycleW=(D.fit&&D.width)?D.width:(P.width()||this.offsetWidth||this.width||P.attr("width")||0);if(P.is("img")){var N=(i.browser.msie&&this.cycleW==28&&this.cycleH==30&&!this.complete);var Q=(i.browser.mozilla&&this.cycleW==34&&this.cycleH==19&&!this.complete);var O=(i.browser.opera&&((this.cycleW==42&&this.cycleH==19)||(this.cycleW==37&&this.cycleH==17))&&!this.complete);var w=(this.cycleH==0&&this.cycleW==0&&!this.complete);if(N||Q||O||w){if(F.s&&D.requeueOnImageNotLoaded&&++u.requeueAttempts<100){f(u.requeueAttempts," - img slide not loaded, requeuing slideshow: ",this.src,this.cycleW,this.cycleH);setTimeout(function(){i(F.s,F.c).cycle(u)},D.requeueTimeout);t=true;return false}else{f("could not determine size of image: "+this.src,this.cycleW,this.cycleH)}}}return true});if(t){return false}D.cssBefore=D.cssBefore||{};D.animIn=D.animIn||{};D.animOut=D.animOut||{};L.not(":eq("+y+")").css(D.cssBefore);if(D.cssFirst){i(L[y]).css(D.cssFirst)}if(D.timeout){D.timeout=parseInt(D.timeout);if(D.speed.constructor==String){D.speed=i.fx.speeds[D.speed]||parseInt(D.speed)}if(!D.sync){D.speed=D.speed/2}var G=D.fx=="shuffle"?500:250;while((D.timeout-D.speed)<G){D.timeout+=D.speed}}if(D.easing){D.easeIn=D.easeOut=D.easing}if(!D.speedIn){D.speedIn=D.speed}if(!D.speedOut){D.speedOut=D.speed}D.slideCount=v.length;D.currSlide=D.lastSlide=y;if(D.random){if(++D.randomIndex==v.length){D.randomIndex=0}D.nextSlide=D.randomMap[D.randomIndex]}else{D.nextSlide=D.startingSlide>=(v.length-1)?0:D.startingSlide+1}if(!D.multiFx){var I=i.fn.cycle.transitions[D.fx];if(i.isFunction(I)){I(z,L,D)}else{if(D.fx!="custom"&&!D.multiFx){f("unknown transition: "+D.fx,"; slideshow terminating");return false}}}var A=L[y];if(D.before.length){D.before[0].apply(A,[A,A,D,true])}if(D.after.length>1){D.after[1].apply(A,[A,A,D,true])}if(D.next){i(D.next).bind(D.prevNextEvent,function(){return o(D,D.rev?-1:1)})}if(D.prev){i(D.prev).bind(D.prevNextEvent,function(){return o(D,D.rev?1:-1)})}if(D.pager||D.pagerAnchorBuilder){d(v,D)}j(D,v);return D}function n(r){r.original={before:[],after:[]};r.original.cssBefore=i.extend({},r.cssBefore);r.original.cssAfter=i.extend({},r.cssAfter);r.original.animIn=i.extend({},r.animIn);r.original.animOut=i.extend({},r.animOut);i.each(r.before,function(){r.original.before.push(this)});i.each(r.after,function(){r.original.after.push(this)})}function c(x){var v,t,s=i.fn.cycle.transitions;if(x.fx.indexOf(",")>0){x.multiFx=true;x.fxs=x.fx.replace(/\s*/g,"").split(",");for(v=0;v<x.fxs.length;v++){var w=x.fxs[v];t=s[w];if(!t||!s.hasOwnProperty(w)||!i.isFunction(t)){f("discarding unknown transition: ",w);x.fxs.splice(v,1);v--}}if(!x.fxs.length){f("No valid transitions named; slideshow terminating.");return false}}else{if(x.fx=="all"){x.multiFx=true;x.fxs=[];for(p in s){t=s[p];if(s.hasOwnProperty(p)&&i.isFunction(t)){x.fxs.push(p)}}}}if(x.multiFx&&x.randomizeEffects){var u=Math.floor(Math.random()*20)+30;for(v=0;v<u;v++){var r=Math.floor(Math.random()*x.fxs.length);x.fxs.push(x.fxs.splice(r,1)[0])}a("randomized fx sequence: ",x.fxs)}return true}function j(s,r){s.addSlide=function(u,v){var t=i(u),w=t[0];if(!s.autostopCount){s.countdown++}r[v?"unshift":"push"](w);if(s.els){s.els[v?"unshift":"push"](w)}s.slideCount=r.length;t.css("position","absolute");t[v?"prependTo":"appendTo"](s.$cont);if(v){s.currSlide++;s.nextSlide++}if(!i.support.opacity&&s.cleartype&&!s.cleartypeNoBg){g(t)}if(s.fit&&s.width){t.width(s.width)}if(s.fit&&s.height&&s.height!="auto"){$slides.height(s.height)}w.cycleH=(s.fit&&s.height)?s.height:t.height();w.cycleW=(s.fit&&s.width)?s.width:t.width();t.css(s.cssBefore);if(s.pager||s.pagerAnchorBuilder){i.fn.cycle.createPagerAnchor(r.length-1,w,i(s.pager),r,s)}if(i.isFunction(s.onAddSlide)){s.onAddSlide(t)}else{t.hide()}}}i.fn.cycle.resetState=function(s,r){r=r||s.fx;s.before=[];s.after=[];s.cssBefore=i.extend({},s.original.cssBefore);s.cssAfter=i.extend({},s.original.cssAfter);s.animIn=i.extend({},s.original.animIn);s.animOut=i.extend({},s.original.animOut);s.fxFn=null;i.each(s.original.before,function(){s.before.push(this)});i.each(s.original.after,function(){s.after.push(this)});var t=i.fn.cycle.transitions[r];if(i.isFunction(t)){t(s.$cont,i(s.elements),s)}};function e(y,r,x,A){if(x&&r.busy&&r.manualTrump){a("manualTrump in go(), stopping active transition");i(y).stop(true,true);r.busy=false}if(r.busy){a("transition active, ignoring new tx request");return}var v=r.$cont[0],C=y[r.currSlide],B=y[r.nextSlide];if(v.cycleStop!=r.stopCount||v.cycleTimeout===0&&!x){return}if(!x&&!v.cyclePause&&((r.autostop&&(--r.countdown<=0))||(r.nowrap&&!r.random&&r.nextSlide<r.currSlide))){if(r.end){r.end(r)}return}var z=false;if((x||!v.cyclePause)&&(r.nextSlide!=r.currSlide)){z=true;var w=r.fx;C.cycleH=C.cycleH||i(C).height();C.cycleW=C.cycleW||i(C).width();B.cycleH=B.cycleH||i(B).height();B.cycleW=B.cycleW||i(B).width();if(r.multiFx){if(r.lastFx==undefined||++r.lastFx>=r.fxs.length){r.lastFx=0}w=r.fxs[r.lastFx];r.currFx=w}if(r.oneTimeFx){w=r.oneTimeFx;r.oneTimeFx=null}i.fn.cycle.resetState(r,w);if(r.before.length){i.each(r.before,function(D,E){if(v.cycleStop!=r.stopCount){return}E.apply(B,[C,B,r,A])})}var t=function(){i.each(r.after,function(D,E){if(v.cycleStop!=r.stopCount){return}E.apply(B,[C,B,r,A])})};a("tx firing; currSlide: "+r.currSlide+"; nextSlide: "+r.nextSlide);r.busy=1;if(r.fxFn){r.fxFn(C,B,r,t,A,x&&r.fastOnEvent)}else{if(i.isFunction(i.fn.cycle[r.fx])){i.fn.cycle[r.fx](C,B,r,t,A,x&&r.fastOnEvent)}else{i.fn.cycle.custom(C,B,r,t,A,x&&r.fastOnEvent)}}}if(z||r.nextSlide==r.currSlide){r.lastSlide=r.currSlide;if(r.random){r.currSlide=r.nextSlide;if(++r.randomIndex==y.length){r.randomIndex=0}r.nextSlide=r.randomMap[r.randomIndex];if(r.nextSlide==r.currSlide){r.nextSlide=(r.currSlide==r.slideCount-1)?0:r.currSlide+1}}else{var u=(r.nextSlide+1)==y.length;r.nextSlide=u?0:r.nextSlide+1;r.currSlide=u?y.length-1:r.nextSlide-1}}if(z&&r.pager){r.updateActivePagerLink(r.pager,r.currSlide,r.activePagerClass)}var s=0;if(r.timeout&&!r.continuous){s=h(C,B,r,A)}else{if(r.continuous&&v.cyclePause){s=10}}if(s>0){v.cycleTimeout=setTimeout(function(){e(y,r,0,!r.rev)},s)}}i.fn.cycle.updateActivePagerLink=function(r,t,s){i(r).each(function(){i(this).children().removeClass(s).eq(t).addClass(s)})};function h(w,u,v,s){if(v.timeoutFn){var r=v.timeoutFn(w,u,v,s);while((r-v.speed)<250){r+=v.speed}a("calculated timeout: "+r+"; speed: "+v.speed);if(r!==false){return r}}return v.timeout}i.fn.cycle.next=function(r){o(r,r.rev?-1:1)};i.fn.cycle.prev=function(r){o(r,r.rev?1:-1)};function o(t,w){var s=t.elements;var v=t.$cont[0],u=v.cycleTimeout;if(u){clearTimeout(u);v.cycleTimeout=0}if(t.random&&w<0){t.randomIndex--;if(--t.randomIndex==-2){t.randomIndex=s.length-2}else{if(t.randomIndex==-1){t.randomIndex=s.length-1}}t.nextSlide=t.randomMap[t.randomIndex]}else{if(t.random){t.nextSlide=t.randomMap[t.randomIndex]}else{t.nextSlide=t.currSlide+w;if(t.nextSlide<0){if(t.nowrap){return false}t.nextSlide=s.length-1}else{if(t.nextSlide>=s.length){if(t.nowrap){return false}t.nextSlide=0}}}}var r=t.onPrevNextEvent||t.prevNextClick;if(i.isFunction(r)){r(w>0,t.nextSlide,s[t.nextSlide])}e(s,t,1,w>=0);return false}function d(s,t){var r=i(t.pager);i.each(s,function(u,v){i.fn.cycle.createPagerAnchor(u,v,r,s,t)});t.updateActivePagerLink(t.pager,t.startingSlide,t.activePagerClass)}i.fn.cycle.createPagerAnchor=function(v,w,t,u,x){var s;if(i.isFunction(x.pagerAnchorBuilder)){s=x.pagerAnchorBuilder(v,w);a("pagerAnchorBuilder("+v+", el) returned: "+s)}else{s='<a href="#">'+(v+1)+"</a>"}if(!s){return}var y=i(s);if(y.parents("body").length===0){var r=[];if(t.length>1){t.each(function(){var z=y.clone(true);i(this).append(z);r.push(z[0])});y=i(r)}else{y.appendTo(t)}}x.pagerAnchors=x.pagerAnchors||[];x.pagerAnchors.push(y);y.bind(x.pagerEvent,function(C){C.preventDefault();x.nextSlide=v;var B=x.$cont[0],A=B.cycleTimeout;if(A){clearTimeout(A);B.cycleTimeout=0}var z=x.onPagerEvent||x.pagerClick;if(i.isFunction(z)){z(x.nextSlide,u[x.nextSlide])}e(u,x,1,x.currSlide<v)});if(!/^click/.test(x.pagerEvent)&&!x.allowPagerClickBubble){y.bind("click.cycle",function(){return false})}if(x.pauseOnPagerHover){y.hover(function(){x.$cont[0].cyclePause++},function(){x.$cont[0].cyclePause--})}};i.fn.cycle.hopsFromLast=function(u,t){var s,r=u.lastSlide,v=u.currSlide;if(t){s=v>r?v-r:u.slideCount-r}else{s=v<r?r-v:r+u.slideCount-v}return s};function g(t){a("applying clearType background-color hack");function s(u){u=parseInt(u).toString(16);return u.length<2?"0"+u:u}function r(x){for(;x&&x.nodeName.toLowerCase()!="html";x=x.parentNode){var u=i.css(x,"background-color");if(u.indexOf("rgb")>=0){var w=u.match(/\d+/g);return"#"+s(w[0])+s(w[1])+s(w[2])}if(u&&u!="transparent"){return u}}return"#ffffff"}t.each(function(){i(this).css("background-color",r(this))})}i.fn.cycle.commonReset=function(x,u,v,s,t,r){i(v.elements).not(x).hide();v.cssBefore.opacity=1;v.cssBefore.display="block";if(s!==false&&u.cycleW>0){v.cssBefore.width=u.cycleW}if(t!==false&&u.cycleH>0){v.cssBefore.height=u.cycleH}v.cssAfter=v.cssAfter||{};v.cssAfter.display="none";i(x).css("zIndex",v.slideCount+(r===true?1:0));i(u).css("zIndex",v.slideCount+(r===true?0:1))};i.fn.cycle.custom=function(D,x,r,u,w,s){var C=i(D),y=i(x);var t=r.speedIn,B=r.speedOut,v=r.easeIn,A=r.easeOut;y.css(r.cssBefore);if(s){if(typeof s=="number"){t=B=s}else{t=B=1}v=A=null}var z=function(){y.animate(r.animIn,t,v,u)};C.animate(r.animOut,B,A,function(){if(r.cssAfter){C.css(r.cssAfter)}if(!r.sync){z()}});if(r.sync){z()}};i.fn.cycle.transitions={fade:function(s,t,r){t.not(":eq("+r.currSlide+")").css("opacity",0);r.before.push(function(w,u,v){i.fn.cycle.commonReset(w,u,v);v.cssBefore.opacity=0});r.animIn={opacity:1};r.animOut={opacity:0};r.cssBefore={top:0,left:0}}};i.fn.cycle.ver=function(){return l};i.fn.cycle.defaults={fx:"fade",timeout:4000,timeoutFn:null,continuous:0,speed:1000,speedIn:null,speedOut:null,next:null,prev:null,onPrevNextEvent:null,prevNextEvent:"click.cycle",pager:null,onPagerEvent:null,pagerEvent:"click.cycle",allowPagerClickBubble:false,pagerAnchorBuilder:null,before:null,after:null,end:null,easing:null,easeIn:null,easeOut:null,shuffle:null,animIn:null,animOut:null,cssBefore:null,cssAfter:null,fxFn:null,height:"auto",startingSlide:0,sync:1,random:0,fit:0,containerResize:1,pause:0,pauseOnPagerHover:0,autostop:0,autostopCount:0,delay:0,slideExpr:null,cleartype:!i.support.opacity,cleartypeNoBg:false,nowrap:0,fastOnEvent:0,randomizeEffects:1,rev:0,manualTrump:true,requeueOnImageNotLoaded:true,requeueTimeout:250,activePagerClass:"activeSlide",updateActivePagerLink:null}})(jQuery);
/*
 * jQuery Cycle Plugin Transition Definitions
 * This script is a plugin for the jQuery Cycle Plugin
 * Examples and documentation at: http://malsup.com/jquery/cycle/
 * Copyright (c) 2007-2008 M. Alsup
 * Version:	 2.72
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 */
(function(a){a.fn.cycle.transitions.none=function(c,d,b){b.fxFn=function(g,e,f,h){a(e).show();a(g).hide();h()}};a.fn.cycle.transitions.scrollUp=function(d,e,c){d.css("overflow","hidden");c.before.push(a.fn.cycle.commonReset);var b=d.height();c.cssBefore={top:b,left:0};c.cssFirst={top:0};c.animIn={top:0};c.animOut={top:-b}};a.fn.cycle.transitions.scrollDown=function(d,e,c){d.css("overflow","hidden");c.before.push(a.fn.cycle.commonReset);var b=d.height();c.cssFirst={top:0};c.cssBefore={top:-b,left:0};c.animIn={top:0};c.animOut={top:b}};a.fn.cycle.transitions.scrollLeft=function(d,e,c){d.css("overflow","hidden");c.before.push(a.fn.cycle.commonReset);var b=d.width();c.cssFirst={left:0};c.cssBefore={left:b,top:0};c.animIn={left:0};c.animOut={left:0-b}};a.fn.cycle.transitions.scrollRight=function(d,e,c){d.css("overflow","hidden");c.before.push(a.fn.cycle.commonReset);var b=d.width();c.cssFirst={left:0};c.cssBefore={left:-b,top:0};c.animIn={left:0};c.animOut={left:b}};a.fn.cycle.transitions.scrollHorz=function(c,d,b){c.css("overflow","hidden").width();b.before.push(function(h,f,g,e){a.fn.cycle.commonReset(h,f,g);g.cssBefore.left=e?(f.cycleW-1):(1-f.cycleW);g.animOut.left=e?-h.cycleW:h.cycleW});b.cssFirst={left:0};b.cssBefore={top:0};b.animIn={left:0};b.animOut={top:0}};a.fn.cycle.transitions.scrollVert=function(c,d,b){c.css("overflow","hidden");b.before.push(function(h,f,g,e){a.fn.cycle.commonReset(h,f,g);g.cssBefore.top=e?(1-f.cycleH):(f.cycleH-1);g.animOut.top=e?h.cycleH:-h.cycleH});b.cssFirst={top:0};b.cssBefore={left:0};b.animIn={top:0};b.animOut={left:0}};a.fn.cycle.transitions.slideX=function(c,d,b){b.before.push(function(g,e,f){a(f.elements).not(g).hide();a.fn.cycle.commonReset(g,e,f,false,true);f.animIn.width=e.cycleW});b.cssBefore={left:0,top:0,width:0};b.animIn={width:"show"};b.animOut={width:0}};a.fn.cycle.transitions.slideY=function(c,d,b){b.before.push(function(g,e,f){a(f.elements).not(g).hide();a.fn.cycle.commonReset(g,e,f,true,false);f.animIn.height=e.cycleH});b.cssBefore={left:0,top:0,height:0};b.animIn={height:"show"};b.animOut={height:0}};a.fn.cycle.transitions.shuffle=function(e,f,d){var c,b=e.css("overflow","visible").width();f.css({left:0,top:0});d.before.push(function(i,g,h){a.fn.cycle.commonReset(i,g,h,true,true,true)});if(!d.speedAdjusted){d.speed=d.speed/2;d.speedAdjusted=true}d.random=0;d.shuffle=d.shuffle||{left:-b,top:15};d.els=[];for(c=0;c<f.length;c++){d.els.push(f[c])}for(c=0;c<d.currSlide;c++){d.els.push(d.els.shift())}d.fxFn=function(m,j,l,g,i){var h=i?a(m):a(j);a(j).css(l.cssBefore);var k=l.slideCount;h.animate(l.shuffle,l.speedIn,l.easeIn,function(){var o=a.fn.cycle.hopsFromLast(l,i);for(var q=0;q<o;q++){i?l.els.push(l.els.shift()):l.els.unshift(l.els.pop())}if(i){for(var r=0,n=l.els.length;r<n;r++){a(l.els[r]).css("z-index",n-r+k)}}else{var s=a(m).css("z-index");h.css("z-index",parseInt(s)+1+k)}h.animate({left:0,top:0},l.speedOut,l.easeOut,function(){a(i?this:m).hide();if(g){g()}})})};d.cssBefore={display:"block",opacity:1,top:0,left:0}};a.fn.cycle.transitions.turnUp=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,true,false);f.cssBefore.top=e.cycleH;f.animIn.height=e.cycleH});b.cssFirst={top:0};b.cssBefore={left:0,height:0};b.animIn={top:0};b.animOut={height:0}};a.fn.cycle.transitions.turnDown=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,true,false);f.animIn.height=e.cycleH;f.animOut.top=g.cycleH});b.cssFirst={top:0};b.cssBefore={left:0,top:0,height:0};b.animOut={height:0}};a.fn.cycle.transitions.turnLeft=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,false,true);f.cssBefore.left=e.cycleW;f.animIn.width=e.cycleW});b.cssBefore={top:0,width:0};b.animIn={left:0};b.animOut={width:0}};a.fn.cycle.transitions.turnRight=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,false,true);f.animIn.width=e.cycleW;f.animOut.left=g.cycleW});b.cssBefore={top:0,left:0,width:0};b.animIn={left:0};b.animOut={width:0}};a.fn.cycle.transitions.zoom=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,false,false,true);f.cssBefore.top=e.cycleH/2;f.cssBefore.left=e.cycleW/2;f.animIn={top:0,left:0,width:e.cycleW,height:e.cycleH};f.animOut={width:0,height:0,top:g.cycleH/2,left:g.cycleW/2}});b.cssFirst={top:0,left:0};b.cssBefore={width:0,height:0}};a.fn.cycle.transitions.fadeZoom=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,false,false);f.cssBefore.left=e.cycleW/2;f.cssBefore.top=e.cycleH/2;f.animIn={top:0,left:0,width:e.cycleW,height:e.cycleH}});b.cssBefore={width:0,height:0};b.animOut={opacity:0}};a.fn.cycle.transitions.blindX=function(d,e,c){var b=d.css("overflow","hidden").width();c.before.push(function(h,f,g){a.fn.cycle.commonReset(h,f,g);g.animIn.width=f.cycleW;g.animOut.left=h.cycleW});c.cssBefore={left:b,top:0};c.animIn={left:0};c.animOut={left:b}};a.fn.cycle.transitions.blindY=function(d,e,c){var b=d.css("overflow","hidden").height();c.before.push(function(h,f,g){a.fn.cycle.commonReset(h,f,g);g.animIn.height=f.cycleH;g.animOut.top=h.cycleH});c.cssBefore={top:b,left:0};c.animIn={top:0};c.animOut={top:b}};a.fn.cycle.transitions.blindZ=function(e,f,d){var c=e.css("overflow","hidden").height();var b=e.width();d.before.push(function(i,g,h){a.fn.cycle.commonReset(i,g,h);h.animIn.height=g.cycleH;h.animOut.top=i.cycleH});d.cssBefore={top:c,left:b};d.animIn={top:0,left:0};d.animOut={top:c,left:b}};a.fn.cycle.transitions.growX=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,false,true);f.cssBefore.left=this.cycleW/2;f.animIn={left:0,width:this.cycleW};f.animOut={left:0}});b.cssBefore={width:0,top:0}};a.fn.cycle.transitions.growY=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,true,false);f.cssBefore.top=this.cycleH/2;f.animIn={top:0,height:this.cycleH};f.animOut={top:0}});b.cssBefore={height:0,left:0}};a.fn.cycle.transitions.curtainX=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,false,true,true);f.cssBefore.left=e.cycleW/2;f.animIn={left:0,width:this.cycleW};f.animOut={left:g.cycleW/2,width:0}});b.cssBefore={top:0,width:0}};a.fn.cycle.transitions.curtainY=function(c,d,b){b.before.push(function(g,e,f){a.fn.cycle.commonReset(g,e,f,true,false,true);f.cssBefore.top=e.cycleH/2;f.animIn={top:0,height:e.cycleH};f.animOut={top:g.cycleH/2,height:0}});b.cssBefore={left:0,height:0}};a.fn.cycle.transitions.cover=function(f,g,e){var i=e.direction||"left";var b=f.css("overflow","hidden").width();var c=f.height();e.before.push(function(j,d,h){a.fn.cycle.commonReset(j,d,h);if(i=="right"){h.cssBefore.left=-b}else{if(i=="up"){h.cssBefore.top=c}else{if(i=="down"){h.cssBefore.top=-c}else{h.cssBefore.left=b}}}});e.animIn={left:0,top:0};e.animOut={opacity:1};e.cssBefore={top:0,left:0}};a.fn.cycle.transitions.uncover=function(f,g,e){var i=e.direction||"left";var b=f.css("overflow","hidden").width();var c=f.height();e.before.push(function(j,d,h){a.fn.cycle.commonReset(j,d,h,true,true,true);if(i=="right"){h.animOut.left=b}else{if(i=="up"){h.animOut.top=-c}else{if(i=="down"){h.animOut.top=c}else{h.animOut.left=-b}}}});e.animIn={left:0,top:0};e.animOut={opacity:1};e.cssBefore={top:0,left:0}};a.fn.cycle.transitions.toss=function(e,f,d){var b=e.css("overflow","visible").width();var c=e.height();d.before.push(function(i,g,h){a.fn.cycle.commonReset(i,g,h,true,true,true);if(!h.animOut.left&&!h.animOut.top){h.animOut={left:b*2,top:-c/2,opacity:0}}else{h.animOut.opacity=0}});d.cssBefore={left:0,top:0};d.animIn={left:0}};a.fn.cycle.transitions.wipe=function(s,m,e){var q=s.css("overflow","hidden").width();var j=s.height();e.cssBefore=e.cssBefore||{};var g;if(e.clip){if(/l2r/.test(e.clip)){g="rect(0px 0px "+j+"px 0px)"}else{if(/r2l/.test(e.clip)){g="rect(0px "+q+"px "+j+"px "+q+"px)"}else{if(/t2b/.test(e.clip)){g="rect(0px "+q+"px 0px 0px)"}else{if(/b2t/.test(e.clip)){g="rect("+j+"px "+q+"px "+j+"px 0px)"}else{if(/zoom/.test(e.clip)){var o=parseInt(j/2);var f=parseInt(q/2);g="rect("+o+"px "+f+"px "+o+"px "+f+"px)"}}}}}}e.cssBefore.clip=e.cssBefore.clip||g||"rect(0px 0px 0px 0px)";var k=e.cssBefore.clip.match(/(\d+)/g);var u=parseInt(k[0]),c=parseInt(k[1]),n=parseInt(k[2]),i=parseInt(k[3]);e.before.push(function(w,h,t){if(w==h){return}var d=a(w),b=a(h);a.fn.cycle.commonReset(w,h,t,true,true,false);t.cssAfter.display="block";var r=1,l=parseInt((t.speedIn/13))-1;(function v(){var y=u?u-parseInt(r*(u/l)):0;var z=i?i-parseInt(r*(i/l)):0;var A=n<j?n+parseInt(r*((j-n)/l||1)):j;var x=c<q?c+parseInt(r*((q-c)/l||1)):q;b.css({clip:"rect("+y+"px "+x+"px "+A+"px "+z+"px)"});(r++<=l)?setTimeout(v,13):d.css("display","none")})()});e.cssBefore={display:"block",opacity:1,top:0,left:0};e.animIn={left:0};e.animOut={left:0}}})(jQuery);


/**
 * Equal Heights Plugin
 * Equalize the heights of elements. Great for columns or any elements
 * that need to be the same size (floats, etc).
 * 
 * Version 1.0
 * Updated 12/10/2008
 *
 * Copyright (c) 2008 Rob Glazebrook (cssnewbie.com) 
 *
 * Usage: $(object).equalHeights([minHeight], [maxHeight]);
 * 
 * Example 1: $(".cols").equalHeights(); Sets all columns to the same height.
 * Example 2: $(".cols").equalHeights(400); Sets all cols to at least 400px tall.
 * Example 3: $(".cols").equalHeights(100,300); Cols are at least 100 but no more
 * than 300 pixels tall. Elements with too much content will gain a scrollbar.
 * 
 */

(function($) {
	$.fn.equalHeights = function(minHeight, maxHeight) {
		tallest = (minHeight) ? minHeight : 0;
		this.each(function() {
			if($(this).outerHeight(true) > tallest) {
				tallest = $(this).outerHeight(true);
			}
		});
		if((maxHeight) && tallest > maxHeight) tallest = maxHeight;
		return this.each(function() {
			$(this).height(tallest).css("overflow","auto");
		});
	}
})(jQuery);

/*
 * jQuery UI Tabs 1.8.5
 *
 * Copyright 2010, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Tabs
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */
(function( $, undefined ) {

var tabId = 0,
	listId = 0;

function getNextTabId() {
	return ++tabId;
}

function getNextListId() {
	return ++listId;
}

$.widget( "ui.tabs", {
	options: {
		add: null,
		ajaxOptions: null,
		cache: false,
		cookie: null, // e.g. { expires: 7, path: '/', domain: 'jquery.com', secure: true }
		collapsible: false,
		disable: null,
		disabled: [],
		enable: null,
		event: "click",
		fx: null, // e.g. { height: 'toggle', opacity: 'toggle', duration: 200 }
		idPrefix: "ui-tabs-",
		load: null,
		panelTemplate: "<div></div>",
		remove: null,
		select: null,
		show: null,
		spinner: "<em>Loading&#8230;</em>",
		tabTemplate: "<li><a href='#{href}'><span>#{label}</span></a></li>"
	},

	_create: function() {
		this._tabify( true );
	},

	_setOption: function( key, value ) {
		if ( key == "selected" ) {
			if (this.options.collapsible && value == this.options.selected ) {
				return;
			}
			this.select( value );
		} else {
			this.options[ key ] = value;
			this._tabify();
		}
	},

	_tabId: function( a ) {
		return a.title && a.title.replace( /\s/g, "_" ).replace( /[^\w\u00c0-\uFFFF-]/g, "" ) ||
			this.options.idPrefix + getNextTabId();
	},

	_sanitizeSelector: function( hash ) {
		// we need this because an id may contain a ":"
		return hash.replace( /:/g, "\\:" );
	},

	_cookie: function() {
		var cookie = this.cookie ||
			( this.cookie = this.options.cookie.name || "ui-tabs-" + getNextListId() );
		return $.cookie.apply( null, [ cookie ].concat( $.makeArray( arguments ) ) );
	},

	_ui: function( tab, panel ) {
		return {
			tab: tab,
			panel: panel,
			index: this.anchors.index( tab )
		};
	},

	_cleanup: function() {
		// restore all former loading tabs labels
		this.lis.filter( ".ui-state-processing" )
			.removeClass( "ui-state-processing" )
			.find( "span:data(label.tabs)" )
				.each(function() {
					var el = $( this );
					el.html( el.data( "label.tabs" ) ).removeData( "label.tabs" );
				});
	},

	_tabify: function( init ) {
		var self = this,
			o = this.options,
			fragmentId = /^#.+/; // Safari 2 reports '#' for an empty hash

		this.list = this.element.find( "nav" ).eq( 0 );
		this.lis = $( " > span:has(a[href])", this.list );
		this.anchors = this.lis.map(function() {
			return $( "a", this )[ 0 ];
		});
		this.panels = $( [] );

		this.anchors.each(function( i, a ) {
			var href = $( a ).attr( "href" );
			// For dynamically created HTML that contains a hash as href IE < 8 expands
			// such href to the full page url with hash and then misinterprets tab as ajax.
			// Same consideration applies for an added tab with a fragment identifier
			// since a[href=#fragment-identifier] does unexpectedly not match.
			// Thus normalize href attribute...
			var hrefBase = href.split( "#" )[ 0 ],
				baseEl;
			if ( hrefBase && ( hrefBase === location.toString().split( "#" )[ 0 ] ||
					( baseEl = $( "base" )[ 0 ]) && hrefBase === baseEl.href ) ) {
				href = a.hash;
				a.href = href;
			}

			// inline tab
			if ( fragmentId.test( href ) ) {
				self.panels = self.panels.add( self._sanitizeSelector( href ) );
			// remote tab
			// prevent loading the page itself if href is just "#"
			} else if ( href && href !== "#" ) {
				// required for restore on destroy
				$.data( a, "href.tabs", href );

				// TODO until #3808 is fixed strip fragment identifier from url
				// (IE fails to load from such url)
				$.data( a, "load.tabs", href.replace( /#.*$/, "" ) );

				var id = self._tabId( a );
				a.href = "#" + id;
				var $panel = $( "#" + id );
				if ( !$panel.length ) {
					$panel = $( o.panelTemplate )
						.attr( "id", id )
						.addClass( "ui-tabs-panel ui-widget-content ui-corner-bottom" )
						.insertAfter( self.panels[ i - 1 ] || self.list );
					$panel.data( "destroy.tabs", true );
				}
				self.panels = self.panels.add( $panel );
			// invalid tab href
			} else {
				o.disabled.push( i );
			}
		});

		// initialization from scratch
		if ( init ) {
			// attach necessary classes for styling
			this.element.addClass( "ui-tabs ui-widget ui-widget-content ui-corner-all" );
			this.list.addClass( "ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all" );
			this.lis.addClass( "ui-state-default ui-corner-top" );
			this.panels.addClass( "ui-tabs-panel ui-widget-content ui-corner-bottom" );

			// Selected tab
			// use "selected" option or try to retrieve:
			// 1. from fragment identifier in url
			// 2. from cookie
			// 3. from selected class attribute on <li>
			if ( o.selected === undefined ) {
				if ( location.hash ) {
					this.anchors.each(function( i, a ) {
						if ( a.hash == location.hash ) {
							o.selected = i;
							return false;
						}
					});
				}
				if ( typeof o.selected !== "number" && o.cookie ) {
					o.selected = parseInt( self._cookie(), 10 );
				}
				if ( typeof o.selected !== "number" && this.lis.filter( ".ui-tabs-selected" ).length ) {
					o.selected = this.lis.index( this.lis.filter( ".ui-tabs-selected" ) );
				}
				o.selected = o.selected || ( this.lis.length ? 0 : -1 );
			} else if ( o.selected === null ) { // usage of null is deprecated, TODO remove in next release
				o.selected = -1;
			}

			// sanity check - default to first tab...
			o.selected = ( ( o.selected >= 0 && this.anchors[ o.selected ] ) || o.selected < 0 )
				? o.selected
				: 0;

			// Take disabling tabs via class attribute from HTML
			// into account and update option properly.
			// A selected tab cannot become disabled.
			o.disabled = $.unique( o.disabled.concat(
				$.map( this.lis.filter( ".ui-state-disabled" ), function( n, i ) {
					return self.lis.index( n );
				})
			) ).sort();

			if ( $.inArray( o.selected, o.disabled ) != -1 ) {
				o.disabled.splice( $.inArray( o.selected, o.disabled ), 1 );
			}

			// highlight selected tab
			this.panels.addClass( "ui-tabs-hide" );
			this.lis.removeClass( "ui-tabs-selected ui-state-active" );
			// check for length avoids error when initializing empty list
			if ( o.selected >= 0 && this.anchors.length ) {
				this.panels.eq( o.selected ).removeClass( "ui-tabs-hide" );
				this.lis.eq( o.selected ).addClass( "ui-tabs-selected ui-state-active" );

				// seems to be expected behavior that the show callback is fired
				self.element.queue( "tabs", function() {
					self._trigger( "show", null,
						self._ui( self.anchors[ o.selected ], self.panels[ o.selected ] ) );
				});

				this.load( o.selected );
			}

			// clean up to avoid memory leaks in certain versions of IE 6
			// TODO: namespace this event
			$( window ).bind( "unload", function() {
				self.lis.add( self.anchors ).unbind( ".tabs" );
				self.lis = self.anchors = self.panels = null;
			});
		// update selected after add/remove
		} else {
			o.selected = this.lis.index( this.lis.filter( ".ui-tabs-selected" ) );
		}

		// update collapsible
		// TODO: use .toggleClass()
		this.element[ o.collapsible ? "addClass" : "removeClass" ]( "ui-tabs-collapsible" );

		// set or update cookie after init and add/remove respectively
		if ( o.cookie ) {
			this._cookie( o.selected, o.cookie );
		}

		// disable tabs
		for ( var i = 0, li; ( li = this.lis[ i ] ); i++ ) {
			$( li )[ $.inArray( i, o.disabled ) != -1 &&
				// TODO: use .toggleClass()
				!$( li ).hasClass( "ui-tabs-selected" ) ? "addClass" : "removeClass" ]( "ui-state-disabled" );
		}

		// reset cache if switching from cached to not cached
		if ( o.cache === false ) {
			this.anchors.removeData( "cache.tabs" );
		}

		// remove all handlers before, tabify may run on existing tabs after add or option change
		this.lis.add( this.anchors ).unbind( ".tabs" );

		if ( o.event !== "mouseover" ) {
			var addState = function( state, el ) {
				if ( el.is( ":not(.ui-state-disabled)" ) ) {
					el.addClass( "ui-state-" + state );
				}
			};
			var removeState = function( state, el ) {
				el.removeClass( "ui-state-" + state );
			};
			this.lis.bind( "mouseover.tabs" , function() {
				addState( "hover", $( this ) );
			});
			this.lis.bind( "mouseout.tabs", function() {
				removeState( "hover", $( this ) );
			});
			this.anchors.bind( "focus.tabs", function() {
				addState( "focus", $( this ).closest( "span" ) );
			});
			this.anchors.bind( "blur.tabs", function() {
				removeState( "focus", $( this ).closest( "span" ) );
			});
		}

		// set up animations
		var hideFx, showFx;
		if ( o.fx ) {
			if ( $.isArray( o.fx ) ) {
				hideFx = o.fx[ 0 ];
				showFx = o.fx[ 1 ];
			} else {
				hideFx = showFx = o.fx;
			}
		}

		// Reset certain styles left over from animation
		// and prevent IE's ClearType bug...
		function resetStyle( $el, fx ) {
			$el.css( "display", "" );
			if ( !$.support.opacity && fx.opacity ) {
				$el[ 0 ].style.removeAttribute( "filter" );
			}
		}

		// Show a tab...
		var showTab = showFx
			? function( clicked, $show ) {
				$( clicked ).closest( "span" ).addClass( "ui-tabs-selected ui-state-active" );
				$show.hide().removeClass( "ui-tabs-hide" ) // avoid flicker that way
					.animate( showFx, showFx.duration || "normal", function() {
						resetStyle( $show, showFx );
						self._trigger( "show", null, self._ui( clicked, $show[ 0 ] ) );
					});
			}
			: function( clicked, $show ) {
				$( clicked ).closest( "span" ).addClass( "ui-tabs-selected ui-state-active" );
				$show.removeClass( "ui-tabs-hide" );
				self._trigger( "show", null, self._ui( clicked, $show[ 0 ] ) );
			};

		// Hide a tab, $show is optional...
		var hideTab = hideFx
			? function( clicked, $hide ) {
				$hide.animate( hideFx, hideFx.duration || "normal", function() {
					self.lis.removeClass( "ui-tabs-selected ui-state-active" );
					$hide.addClass( "ui-tabs-hide" );
					resetStyle( $hide, hideFx );
					self.element.dequeue( "tabs" );
				});
			}
			: function( clicked, $hide, $show ) {
				self.lis.removeClass( "ui-tabs-selected ui-state-active" );
				$hide.addClass( "ui-tabs-hide" );
				self.element.dequeue( "tabs" );
			};

		// attach tab event handler, unbind to avoid duplicates from former tabifying...
		this.anchors.bind( o.event + ".tabs", function() {
			var el = this,
				$li = $(el).closest( "span" ),
				$hide = self.panels.filter( ":not(.ui-tabs-hide)" ),
				$show = $( self._sanitizeSelector( el.hash ) );

			// If tab is already selected and not collapsible or tab disabled or
			// or is already loading or click callback returns false stop here.
			// Check if click handler returns false last so that it is not executed
			// for a disabled or loading tab!
			if ( ( $li.hasClass( "ui-tabs-selected" ) && !o.collapsible) ||
				$li.hasClass( "ui-state-disabled" ) ||
				$li.hasClass( "ui-state-processing" ) ||
				self.panels.filter( ":animated" ).length ||
				self._trigger( "select", null, self._ui( this, $show[ 0 ] ) ) === false ) {
				this.blur();
				return false;
			}

			o.selected = self.anchors.index( this );

			self.abort();

			// if tab may be closed
			if ( o.collapsible ) {
				if ( $li.hasClass( "ui-tabs-selected" ) ) {
					o.selected = -1;

					if ( o.cookie ) {
						self._cookie( o.selected, o.cookie );
					}

					self.element.queue( "tabs", function() {
						hideTab( el, $hide );
					}).dequeue( "tabs" );

					this.blur();
					return false;
				} else if ( !$hide.length ) {
					if ( o.cookie ) {
						self._cookie( o.selected, o.cookie );
					}

					self.element.queue( "tabs", function() {
						showTab( el, $show );
					});

					// TODO make passing in node possible, see also http://dev.jqueryui.com/ticket/3171
					self.load( self.anchors.index( this ) );

					this.blur();
					return false;
				}
			}

			if ( o.cookie ) {
				self._cookie( o.selected, o.cookie );
			}

			// show new tab
			if ( $show.length ) {
				if ( $hide.length ) {
					self.element.queue( "tabs", function() {
						hideTab( el, $hide );
					});
				}
				self.element.queue( "tabs", function() {
					showTab( el, $show );
				});

				self.load( self.anchors.index( this ) );
			} else {
				throw "jQuery UI Tabs: Mismatching fragment identifier.";
			}

			// Prevent IE from keeping other link focussed when using the back button
			// and remove dotted border from clicked link. This is controlled via CSS
			// in modern browsers; blur() removes focus from address bar in Firefox
			// which can become a usability and annoying problem with tabs('rotate').
			if ( $.browser.msie ) {
				this.blur();
			}
		});

		// disable click in any case
		this.anchors.bind( "click.tabs", function(){
			return false;
		});
	},

    _getIndex: function( index ) {
		// meta-function to give users option to provide a href string instead of a numerical index.
		// also sanitizes numerical indexes to valid values.
		if ( typeof index == "string" ) {
			index = this.anchors.index( this.anchors.filter( "[href$=" + index + "]" ) );
		}

		return index;
	},

	destroy: function() {
		var o = this.options;

		this.abort();

		this.element
			.unbind( ".tabs" )
			.removeClass( "ui-tabs ui-widget ui-widget-content ui-corner-all ui-tabs-collapsible" )
			.removeData( "tabs" );

		this.list.removeClass( "ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all" );

		this.anchors.each(function() {
			var href = $.data( this, "href.tabs" );
			if ( href ) {
				this.href = href;
			}
			var $this = $( this ).unbind( ".tabs" );
			$.each( [ "href", "load", "cache" ], function( i, prefix ) {
				$this.removeData( prefix + ".tabs" );
			});
		});

		this.lis.unbind( ".tabs" ).add( this.panels ).each(function() {
			if ( $.data( this, "destroy.tabs" ) ) {
				$( this ).remove();
			} else {
				$( this ).removeClass([
					"ui-state-default",
					"ui-corner-top",
					"ui-tabs-selected",
					"ui-state-active",
					"ui-state-hover",
					"ui-state-focus",
					"ui-state-disabled",
					"ui-tabs-panel",
					"ui-widget-content",
					"ui-corner-bottom",
					"ui-tabs-hide"
				].join( " " ) );
			}
		});

		if ( o.cookie ) {
			this._cookie( null, o.cookie );
		}

		return this;
	},

	add: function( url, label, index ) {
		if ( index === undefined ) {
			index = this.anchors.length;
		}

		var self = this,
			o = this.options,
			$li = $( o.tabTemplate.replace( /#\{href\}/g, url ).replace( /#\{label\}/g, label ) ),
			id = !url.indexOf( "#" ) ? url.replace( "#", "" ) : this._tabId( $( "a", $li )[ 0 ] );

		$li.addClass( "ui-state-default ui-corner-top" ).data( "destroy.tabs", true );

		// try to find an existing element before creating a new one
		var $panel = $( "#" + id );
		if ( !$panel.length ) {
			$panel = $( o.panelTemplate )
				.attr( "id", id )
				.data( "destroy.tabs", true );
		}
		$panel.addClass( "ui-tabs-panel ui-widget-content ui-corner-bottom ui-tabs-hide" );

		if ( index >= this.lis.length ) {
			$li.appendTo( this.list );
			$panel.appendTo( this.list[ 0 ].parentNode );
		} else {
			$li.insertBefore( this.lis[ index ] );
			$panel.insertBefore( this.panels[ index ] );
		}

		o.disabled = $.map( o.disabled, function( n, i ) {
			return n >= index ? ++n : n;
		});

		this._tabify();

		if ( this.anchors.length == 1 ) {
			o.selected = 0;
			$li.addClass( "ui-tabs-selected ui-state-active" );
			$panel.removeClass( "ui-tabs-hide" );
			this.element.queue( "tabs", function() {
				self._trigger( "show", null, self._ui( self.anchors[ 0 ], self.panels[ 0 ] ) );
			});

			this.load( 0 );
		}

		this._trigger( "add", null, this._ui( this.anchors[ index ], this.panels[ index ] ) );
		return this;
	},

	remove: function( index ) {
		index = this._getIndex( index );
		var o = this.options,
			$li = this.lis.eq( index ).remove(),
			$panel = this.panels.eq( index ).remove();

		// If selected tab was removed focus tab to the right or
		// in case the last tab was removed the tab to the left.
		if ( $li.hasClass( "ui-tabs-selected" ) && this.anchors.length > 1) {
			this.select( index + ( index + 1 < this.anchors.length ? 1 : -1 ) );
		}

		o.disabled = $.map(
			$.grep( o.disabled, function(n, i) {
				return n != index;
			}),
			function( n, i ) {
				return n >= index ? --n : n;
			});

		this._tabify();

		this._trigger( "remove", null, this._ui( $li.find( "a" )[ 0 ], $panel[ 0 ] ) );
		return this;
	},

	enable: function( index ) {
		index = this._getIndex( index );
		var o = this.options;
		if ( $.inArray( index, o.disabled ) == -1 ) {
			return;
		}

		this.lis.eq( index ).removeClass( "ui-state-disabled" );
		o.disabled = $.grep( o.disabled, function( n, i ) {
			return n != index;
		});

		this._trigger( "enable", null, this._ui( this.anchors[ index ], this.panels[ index ] ) );
		return this;
	},

	disable: function( index ) {
		index = this._getIndex( index );
		var self = this, o = this.options;
		// cannot disable already selected tab
		if ( index != o.selected ) {
			this.lis.eq( index ).addClass( "ui-state-disabled" );

			o.disabled.push( index );
			o.disabled.sort();

			this._trigger( "disable", null, this._ui( this.anchors[ index ], this.panels[ index ] ) );
		}

		return this;
	},

	select: function( index ) {
		index = this._getIndex( index );
		if ( index == -1 ) {
			if ( this.options.collapsible && this.options.selected != -1 ) {
				index = this.options.selected;
			} else {
				return this;
			}
		}
		this.anchors.eq( index ).trigger( this.options.event + ".tabs" );
		return this;
	},

	load: function( index ) {
		index = this._getIndex( index );
		var self = this,
			o = this.options,
			a = this.anchors.eq( index )[ 0 ],
			url = $.data( a, "load.tabs" );

		this.abort();

		// not remote or from cache
		if ( !url || this.element.queue( "tabs" ).length !== 0 && $.data( a, "cache.tabs" ) ) {
			this.element.dequeue( "tabs" );
			return;
		}

		// load remote from here on
		this.lis.eq( index ).addClass( "ui-state-processing" );

		if ( o.spinner ) {
			var span = $( "span", a );
			span.data( "label.tabs", span.html() ).html( o.spinner );
		}

		this.xhr = $.ajax( $.extend( {}, o.ajaxOptions, {
			url: url,
			success: function( r, s ) {
				$( self._sanitizeSelector( a.hash ) ).html( r );

				// take care of tab labels
				self._cleanup();

				if ( o.cache ) {
					$.data( a, "cache.tabs", true );
				}

				self._trigger( "load", null, self._ui( self.anchors[ index ], self.panels[ index ] ) );
				try {
					o.ajaxOptions.success( r, s );
				}
				catch ( e ) {}
			},
			error: function( xhr, s, e ) {
				// take care of tab labels
				self._cleanup();

				self._trigger( "load", null, self._ui( self.anchors[ index ], self.panels[ index ] ) );
				try {
					// Passing index avoid a race condition when this method is
					// called after the user has selected another tab.
					// Pass the anchor that initiated this request allows
					// loadError to manipulate the tab content panel via $(a.hash)
					o.ajaxOptions.error( xhr, s, index, a );
				}
				catch ( e ) {}
			}
		} ) );

		// last, so that load event is fired before show...
		self.element.dequeue( "tabs" );

		return this;
	},

	abort: function() {
		// stop possibly running animations
		this.element.queue( [] );
		this.panels.stop( false, true );

		// "tabs" queue must not contain more than two elements,
		// which are the callbacks for the latest clicked tab...
		this.element.queue( "tabs", this.element.queue( "tabs" ).splice( -2, 2 ) );

		// terminate pending requests from other tabs
		if ( this.xhr ) {
			this.xhr.abort();
			delete this.xhr;
		}

		// take care of tab labels
		this._cleanup();
		return this;
	},

	url: function( index, url ) {
		this.anchors.eq( index ).removeData( "cache.tabs" ).data( "load.tabs", url );
		return this;
	},

	length: function() {
		return this.anchors.length;
	}
});

$.extend( $.ui.tabs, {
	version: "1.8.5"
});

/*
 * Tabs Extensions
 */

/*
 * Rotate
 */
$.extend( $.ui.tabs.prototype, {
	rotation: null,
	rotate: function( ms, continuing ) {
		var self = this,
			o = this.options;

		var rotate = self._rotate || ( self._rotate = function( e ) {
			clearTimeout( self.rotation );
			self.rotation = setTimeout(function() {
				var t = o.selected;
				self.select( ++t < self.anchors.length ? t : 0 );
			}, ms );

			if ( e ) {
				e.stopPropagation();
			}
		});

		var stop = self._unrotate || ( self._unrotate = !continuing
			? function(e) {
				if (e.clientX) { // in case of a true click
					self.rotate(null);
				}
			}
			: function( e ) {
				t = o.selected;
				rotate();
			});

		// start rotation
		if ( ms ) {
			this.element.bind( "tabsshow", rotate );
			this.anchors.bind( o.event + ".tabs", stop );
			rotate();
		// stop rotation
		} else {
			clearTimeout( self.rotation );
			this.element.unbind( "tabsshow", rotate );
			this.anchors.unbind( o.event + ".tabs", stop );
			delete this._rotate;
			delete this._unrotate;
		}

		return this;
	}
});

})( jQuery );


$.fn.showy = function(){
  return this.each(function(){
    var hidable = $(this.hash);

    // Just in case it starts out shown, hide it
    if (hidable.is(":visible")) {
      hidable.hide();
      hidable.removeClass('open');
    }

    $(this).click(function(e) {
      var link = $(this);
      hidable.slideToggle(200);
      link.toggleClass('open');
      hidable.toggleClass('open');
      
      var text = link.html();
      if (link.hasClass('open')) {
        link.html(text.replace(/View/, 'Close'));
      } else {
        link.html(text.replace(/Close/, 'View'));
      }
      return false;
    });
  });
}

/*************************************************
**  jQuery Masonry version 1.3.2
**  Copyright David DeSandro, licensed MIT
**  http://desandro.com/resources/jquery-masonry
**************************************************/
(function(e){var n=e.event,o;n.special.smartresize={setup:function(){e(this).bind("resize",n.special.smartresize.handler)},teardown:function(){e(this).unbind("resize",n.special.smartresize.handler)},handler:function(j,l){var g=this,d=arguments;j.type="smartresize";o&&clearTimeout(o);o=setTimeout(function(){jQuery.event.handle.apply(g,d)},l==="execAsap"?0:100)}};e.fn.smartresize=function(j){return j?this.bind("smartresize",j):this.trigger("smartresize",["execAsap"])};e.fn.masonry=function(j,l){var g=
{getBricks:function(d,b,a){var c=a.itemSelector===undefined;b.$bricks=a.appendedContent===undefined?c?d.children():d.find(a.itemSelector):c?a.appendedContent:a.appendedContent.filter(a.itemSelector)},placeBrick:function(d,b,a,c,h){b=Math.min.apply(Math,a);for(var i=b+d.outerHeight(true),f=a.length,k=f,m=c.colCount+1-f;f--;)if(a[f]==b)k=f;d.applyStyle({left:c.colW*k+c.posLeft,top:b},e.extend(true,{},h.animationOptions));for(f=0;f<m;f++)c.colY[k+f]=i},setup:function(d,b,a){g.getBricks(d,a,b);if(a.masoned)a.previousData=
d.data("masonry");a.colW=b.columnWidth===undefined?a.masoned?a.previousData.colW:a.$bricks.outerWidth(true):b.columnWidth;a.colCount=Math.floor(d.width()/a.colW);a.colCount=Math.max(a.colCount,1)},arrange:function(d,b,a){var c;if(!a.masoned||b.appendedContent!==undefined)a.$bricks.css("position","absolute");if(a.masoned){a.posTop=a.previousData.posTop;a.posLeft=a.previousData.posLeft}else{d.css("position","relative");var h=e(document.createElement("div"));d.prepend(h);a.posTop=Math.round(h.position().top);
a.posLeft=Math.round(h.position().left);h.remove()}if(a.masoned&&b.appendedContent!==undefined){a.colY=a.previousData.colY;for(c=a.previousData.colCount;c<a.colCount;c++)a.colY[c]=a.posTop}else{a.colY=[];for(c=a.colCount;c--;)a.colY.push(a.posTop)}e.fn.applyStyle=a.masoned&&b.animate?e.fn.animate:e.fn.css;b.singleMode?a.$bricks.each(function(){var i=e(this);g.placeBrick(i,a.colCount,a.colY,a,b)}):a.$bricks.each(function(){var i=e(this),f=Math.ceil(i.outerWidth(true)/a.colW);f=Math.min(f,a.colCount);
if(f===1)g.placeBrick(i,a.colCount,a.colY,a,b);else{var k=a.colCount+1-f,m=[];for(c=0;c<k;c++){var p=a.colY.slice(c,c+f);m[c]=Math.max.apply(Math,p)}g.placeBrick(i,k,m,a,b)}});a.wallH=Math.max.apply(Math,a.colY);d.applyStyle({height:a.wallH-a.posTop},e.extend(true,[],b.animationOptions));a.masoned||setTimeout(function(){d.addClass("masoned")},1);l.call(a.$bricks);d.data("masonry",a)},resize:function(d,b,a){a.masoned=!!d.data("masonry");var c=d.data("masonry").colCount;g.setup(d,b,a);a.colCount!=c&&
g.arrange(d,b,a)}};return this.each(function(){var d=e(this),b={};b.masoned=!!d.data("masonry");var a=b.masoned?d.data("masonry").options:{},c=e.extend({},e.fn.masonry.defaults,a,j),h=a.resizeable;b.options=c.saveOptions?c:a;l=l||function(){};g.getBricks(d,b,c);if(!b.$bricks.length)return this;g.setup(d,c,b);g.arrange(d,c,b);!h&&c.resizeable&&e(window).bind("smartresize.masonry",function(){g.resize(d,c,b)});h&&!c.resizeable&&e(window).unbind("smartresize.masonry")})};e.fn.masonry.defaults={singleMode:false,
columnWidth:undefined,itemSelector:undefined,appendedContent:undefined,saveOptions:true,resizeable:true,animate:false,animationOptions:{}}})(jQuery);