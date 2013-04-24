package com.brodavi.epicspacestunts.graphics;

import nme.display.GradientType;
import nme.display.InterpolationMethod;
import nme.display.SpreadMethod;
import nme.display.Sprite;
import nme.geom.Matrix;

class SpaceshipView extends Sprite
{
  public function new()
  {
    super();

	var type:GradientType = GradientType.LINEAR;
	#if ( html5 || linux || android )
	var colors:Array<Int> = [0x888888, 0xFFFFFF];
	#else
	var colors:Array<UInt> = [0x888888, 0xFFFFFF];
	#end
	var alphas:Array<Int> = [1, 1];
	var ratios:Array<Int> = [0, 255];
	var spreadMethod:SpreadMethod = SpreadMethod.PAD; 
	var interp:InterpolationMethod = InterpolationMethod.LINEAR_RGB; 
	var focalPtRatio:Float = 0; 

	var matrix:Matrix = new Matrix();
	var boxWidth:Float = 20;
	var boxHeight:Float = 20;
	var boxRotation:Float = 0;
	var tx:Float = -10;
	var ty:Float = 0;
	matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);

	graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);

    //graphics.beginFill( 0xFFFFFF );

	// original
	/*
    graphics.moveTo( 10, 0 );
    graphics.lineTo( -7, 7 );
    graphics.lineTo( -4, 0 );
    graphics.lineTo( -7, -7 );
    graphics.lineTo( 10, 0 );
	*/

	// main body
    graphics.moveTo( 15, 2 );
    graphics.lineTo( 5, 5 );
    graphics.lineTo( 0, 10 );
    graphics.lineTo( -7, 10 );
    graphics.lineTo( -9, 5 );
    graphics.lineTo( -15, 3 );
    graphics.lineTo( -15, -3 );
    graphics.lineTo( -9, -5 );
    graphics.lineTo( -7, -10 );
    graphics.lineTo( 0, -10 );
    graphics.lineTo( 5, -5 );
    graphics.lineTo( 15, -2 );
    graphics.lineTo( 15, 2 ); // back again
	graphics.endFill();

	// red side pod
	// starboard
	graphics.beginFill( 0xAC3839 );
	graphics.moveTo( 0, 10 );
	graphics.lineTo( 3, 11 );
	graphics.lineTo( 4, 13 );
	graphics.lineTo( -8, 13 );
	graphics.lineTo( -7, 10 );
	graphics.lineTo( 0, 10 );
	// port
	graphics.moveTo( 0, -10 );
	graphics.lineTo( 3, -11 );
	graphics.lineTo( 4, -13 );
	graphics.lineTo( -8, -13 );
	graphics.lineTo( -7, -10 );
	graphics.lineTo( 0, -10 );
	// center red
    graphics.moveTo( 12, 2 );
    graphics.lineTo( 3, 3 );
    graphics.lineTo( 0, 4 );
    graphics.lineTo( -6, 4 );
    graphics.lineTo( -7, 3 );
    graphics.lineTo( -12, 1 );
    graphics.lineTo( -12, -1 );
    graphics.lineTo( -7, -3 );
    graphics.lineTo( -6, -4 );
    graphics.lineTo( 0, -4 );
    graphics.lineTo( 3, -3 );
    graphics.lineTo( 12, -2 );
    graphics.lineTo( 12, 2 ); // back again
	graphics.endFill();

	// cockpit
	graphics.beginFill( 0x444444 );
	graphics.drawRect( 0, -4, 4, 8 );
    graphics.endFill();

	// if debug, draw center dot
	/*
	graphics.beginFill( 0x880000 );
	graphics.drawEllipse( -2, -2, 4, 4 );
    graphics.endFill();
	*/
  }

}
