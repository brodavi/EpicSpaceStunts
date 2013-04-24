package com.brodavi.epicspacestunts.graphics;

import nme.display.GradientType;
import nme.display.InterpolationMethod;
import nme.display.SpreadMethod;
import nme.display.Sprite;
import nme.geom.Matrix;

class AsteroidView extends Sprite
{
  public function new( radius : Float )
  {
    super();

	var points = [];
    var angle : Float = 0;

	var type:GradientType = GradientType.LINEAR;
	#if ( html5 || linux || android )
	var colors:Array<Int> = [0x83604A, 0x53301A];
	#else
	var colors:Array<UInt> = [0x83604A, 0x53301A];
	#end
	var alphas:Array<Int> = [1, 1];
	var ratios:Array<Int> = [0, 255];
	var spreadMethod:SpreadMethod = SpreadMethod.PAD; 
	var interp:InterpolationMethod = InterpolationMethod.LINEAR_RGB; 
	var focalPtRatio:Float = 0; 

	var matrix:Matrix = new Matrix();
	var boxWidth:Float = 40;
	var boxHeight:Float = 40;
	var boxRotation:Float = 0;
	var tx:Float = 0;
	var ty:Float = 0;
	matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);

	graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);

    //graphics.beginFill( 0x83604A );
    graphics.moveTo( radius, 0 );
    while( angle < Math.PI * 2 )
      {
        var length : Float = ( 0.8 + Math.random() * 0.2 ) * radius;
        var posX : Float = Math.cos( angle ) * length;
        var posY : Float = Math.sin( angle ) * length;
		points.push( new nme.geom.Point( posX, posY ) );
        graphics.lineTo( posX, posY );
        angle += Math.random() * 1.5;
      }
    graphics.lineTo( radius, 0 );
	graphics.endFill();

	// the 'inner' shading
    //graphics.beginFill( 0x996F56 );
	colors = [0x996F56, 0x794F36];
	boxWidth = 20;
	boxHeight = 20;
	graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
    graphics.moveTo( radius/1.61, 0 );
	for ( point in points )
		{
			graphics.lineTo( point.x/1.61, point.y/1.61 );
		}
    graphics.lineTo( radius/1.61, 0 );

	// draw a dimple
	graphics.drawEllipse( Math.random() * radius/1.61 - radius/3.61, Math.random() * radius/1.61 - radius/3.61, Math.random() * radius/3 + 1, Math.random() * radius/3 + 1 );

	graphics.endFill();

	// 50/50 draw another dimple
	if ( Math.random() > 0.5 )
		{
			graphics.drawEllipse( Math.random() * radius/1.61 - radius/3.61, Math.random() * radius/1.61 - radius/3.61, Math.random() * radius/3 + 1, Math.random() * radius/3 + 1 );
		}

	graphics.endFill();

  }
}
