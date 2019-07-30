/* ==========================================================
 * MobilyBlocks
 * date: 29.11.2010
 * last update: 25.1.2011
 * author: Marcin Dziewulski
 * web: http://www.mobily.pl or http://playground.mobily.pl
 * email: hello@mobily.pl
 * Free to use under the MIT license.
 * 在原有基础上做了一点点修改
========================================================== */
(
	function($){
		$.fn.mobilyblocks=function(options){
			var defaults={
				trigger:"click",//触发方式
				direction:"clockwise",
				duration:350,//持续时间
				zIndex:10,
				widthMultiplier:1.9 //半径
			};
			var sets=$.extend({},defaults,options);
			return this.each(
				function(){
					var $t=$(this),
					w=$t.width(),
					h=$t.height(),
					parent=$t.find("ul"),
					list=parent.find("li"),
					size=list.length,hov=false,dir;
					if(sets.direction=="clockwise"){
						dir=-1
					}else{
						if(sets.direction=="counter"){
							dir=1
						}
					}
					var socials={
						init:function(){
							parent.hide().css({zIndex:sets.zIndex});
							$t.append($("<a />").addClass("trigger").css({
								display:"block",
								position:"absolute",
								zIndex:1,
								top:0,
								left:0,
								width:"100%",
								height:"100%"
							}));
							switch(sets.trigger){
								case"click":
									socials.click();
									break;
								case"hover":
									socials.hover();
									break;
								default:socials.click()
							}
						},
						click:function(){
							var trigger=$t.find("a.trigger");
							trigger.bind("click",function(){
								if($t.hasClass("close1")){
									parent.fadeTo(sets.duration,0);
									socials.animation.close();
									$t.removeClass("close1")
								}else{
									parent.fadeTo(sets.duration,1);
									socials.animation.open();
									$t.addClass("close1")
								}
								return false
							})
						},
						hover:function(){
							var trigger=$t.find("a.trigger");
							trigger.bind("mouseover",function(){
								if(hov==false){
									parent.fadeTo(sets.duration,1);
									socials.animation.open();
									$t.addClass("close1")
								}
							});
							parent.bind("mouseleave",function(){
								$t.removeClass("close1");
								parent.fadeTo(sets.duration,0);
								socials.animation.close();
								hov=true;setTimeout(function(){hov=false},500)
							})
						},
						animation:{
							open:function(){
								socials.ie.open();
								var startNum = -15;//开始角度介于-90和270之间
								var wholeNum = 230;//总得展开角度
								var widthNum = sets.widthMultiplier;
								if(size<5){
									startNum = 20;
									wholeNum = 190;
									widthNum = 1.3;
								}
								
								list.each(function(i){
									var li=$(this);
									li.animate(
										{path:new $.path.arc(
											{center:[0,0],
											radius:w*widthNum,//画圆时的半径
											start:startNum,//开始角度介于-90和270之间
											step:wholeNum/size*i,//每一步增加的角度
											dir:dir
										})},
										sets.duration
									)
								});
								list.hover(function(){
									var li=$(this);l
									i.css({zIndex:sets.zIndex}).siblings("li").css({zIndex:sets.zIndex-1})
								})
							},
							close:function(){
								list.each(function(i){
									var li=$(this);
									li.animate(
										{top:"35px",left:"35px"},
										sets.duration,
										function(){socials.ie.close()}
									)
								})
							}
						},
						ie:{
							open:function(){if($.browser.msie){list.show()}},
							close:function(){if($.browser.msie){list.hide()}}
						}
					};
					socials.init()
				}
			)
		}
	}(jQuery)
);
(
	function($){
		$.path={};
		$.path.arc=function(params){
			for(var i in params){this[i]=params[i]}
			this.css=function(p){
				var a = this.start + this.step;//圆上某个点的角度
				var x = this.center[0] + this.radius * Math.sin(Math.PI*a/180);//点相对于圆心的横轴距离，可以直接使用sin函数
				var y = this.center[1] + this.radius * Math.cos(Math.PI*(a+180)/180);//点相对于圆心的纵轴距离，cos函数左移90度后可以满足画圆的需求
				
				return{top:y+20+"px",left:x+20+"px"}//最后把整个圆下移20px
			}
		};
		$.fx.step.path=function(fx){var css=fx.end.css(1-fx.pos);for(var i in css){fx.elem.style[i]=css[i]}}
	}
)(jQuery);