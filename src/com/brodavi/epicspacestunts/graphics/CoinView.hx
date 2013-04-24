package com.brodavi.epicspacestunts.graphics;

import nme.filters.BitmapFilterQuality;
import nme.filters.GlowFilter;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Point;

#if haxe210
class CoinView extends Sprite, implements Animatable
#else
class CoinView extends Sprite implements Animatable
#end
{
	private var shape : Shape;
	private var growing : Bool;

	public function new()
	{
		super();

		var glow:GlowFilter = new GlowFilter();
		#if ( html5 || linux || android )
		#else
		glow.color = 0x0099aa44;
		glow.alpha = 1;
		glow.blurX = 25;
		glow.blurY = 25;
		glow.quality = BitmapFilterQuality.LOW;
		#end

		shape = new Shape();
		shape.graphics.beginFill(0x99aa44);
		shape.graphics.drawEllipse(-10,-20,20,40);
		shape.graphics.endFill();
		shape.graphics.beginFill(0xaabb55);
		shape.graphics.drawEllipse(-5,-10,10,20);
		shape.graphics.endFill();
		shape.filters = [glow];
		addChild( shape );

		growing = false;
	}

	public function animate( time : Float ) : Void
	{
		if ( growing && shape.width < 30 )
			{
				shape.width+=time*10;
			}
		if ( growing && shape.width >= 30 )
			{
				growing = false;
			}
		if ( !growing && shape.width > 6 )
			{
				shape.width-=time*10;
			}
		if ( !growing && shape.width <= 6 )
			{
				growing = true;
			}
	}
}
