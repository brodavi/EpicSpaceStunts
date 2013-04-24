package com.brodavi.epicspacestunts.components;

import nme.display.Shape;
import nme.filters.BitmapFilterQuality;
import nme.filters.GlowFilter;

class Shield
{
	public var display : Shape;
    public var shield : Bool = false;
    public var timeLeft : Float = 3;
    public var shieldMax : Float = 3;
	public var delayedShutoff : Float = -1;

    public function new( )
    {
		display = new Shape();
		display.graphics.beginFill(0x74d216);
		display.graphics.drawEllipse(-25,-25,50,50);
		display.graphics.endFill();

		var glow:GlowFilter = new GlowFilter();
		#if ( html5 || linux || android )
		#else
		glow.color = 0x00ff00;
		glow.alpha = 0.7;
		glow.blurX = 25;
		glow.blurY = 25;
		glow.quality = BitmapFilterQuality.LOW;
		#end

		display.filters = [glow];
    }
}
