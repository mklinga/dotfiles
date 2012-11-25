//////////////////////////////////////////////////////////////////////////////////
// A demonstration of a Canvas nebula effect
// (c) 2010 by R Cecco. <http://www.professorcloud.com>
// MIT License
//
// Please retain this copyright header in all versions of the software if
// using significant parts of it
//////////////////////////////////////////////////////////////////////////////////

// **** Image link at bottom ***** //

$(document).ready(function(){	
													   
	(function ($) {			
			// The canvas element we are drawing into.      
			var	$canvas11 = $('#canvas11');
			var	$canvas12 = $('#canvas12');
			var	$canvas13 = $('#canvas13');			
			var	ctx2 = $canvas12[0].getContext('2d');
			var	ctx = $canvas11[0].getContext('2d');
			var	w = $canvas11[0].width, h = $canvas11[0].height;		
			var	img = new Image();	
			
			// A puff.
			var	Puff = function(p) {				
				var	opacity,
					sy = (Math.random()*285)>>0,//Orig= 285 //
					sx = (Math.random()*285)>>0;//Orig= 285 //
				
				this.p = p;
						
				this.move = function(timeFac) {						
					p = this.p + 0.1 * timeFac; //this is the speed Orig 0.3 //			
					opacity = (Math.sin(p*0.05)*0.5);						
					if(opacity <0) {
						p = opacity = 0;
						sy = (Math.random()*285)>>0;//Orig= 285//
						sx = (Math.random()*285)>>0;//Orig= 285//
					}												
					this.p = p;																			
					ctx.globalAlpha = opacity;						
					ctx.drawImage($canvas13[0], sx+p, sy+p, 285-(p*2),285-(p*2), 0,0, w, h);//where 1000 is, Orig= 285//
				};
			};
			
			var	puffs = [];			
			var	sortPuff = function(p1,p2) { return p1.p-p2.p; };	
			puffs.push( new Puff(0) ); //Orig= 0 //
			puffs.push( new Puff(20) );//Orig= 20 //
			puffs.push( new Puff(40) );//Orig= 40 //
			
			var	newTime, oldTime = 0, timeFac;
					
			var	loop = function()
			{								
				newTime = new Date().getTime();				
				if(oldTime === 0 ) {
					oldTime=newTime;
				}
				timeFac = (newTime-oldTime) * 0.1;
				if(timeFac>3) {timeFac=3;}
				oldTime = newTime;						
				puffs.sort(sortPuff);							
				
				for(var i=0;i<puffs.length;i++)
				{
					puffs[i].move(timeFac);	
				}					
				ctx2.drawImage( $canvas11[0] ,0,0,570,570);//Orig=0,0,570,570//				
				setTimeout(loop, 10 );				
			};
			// Turns out Chrome is much faster doing bitmap work if the bitmap is in an existing canvas rather
			// than an IMG, VIDEO etc. So draw the big nebula image into canvas3
			var	$canvas13 = $('#canvas13');
			var	ctx3 = $canvas13[0].getContext('2d');
			$(img).bind('load',null, function() {  ctx3.drawImage(img, 0,0, 570, 570);	loop(); });//where 1000 is, Orig=570//
			img.src = 'star.jpg';
		
	})(jQuery);	 
});
