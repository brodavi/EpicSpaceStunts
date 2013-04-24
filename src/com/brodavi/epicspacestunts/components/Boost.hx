package com.brodavi.epicspacestunts.components;

import nme.display.Shape;
import nme.geom.Point;

class Boost
{

	public var display : Shape;
    public var timeLeft : Float = 1;
    public var animationTimeLeft : Float = 0.5;

	public var point1 : Point;
	public var point2 : Point;
	public var point3 : Point;
	public var point4 : Point;
	public var point5 : Point;
	public var point6 : Point;
	public var point7 : Point;
	public var point8 : Point;
	public var point9 : Point;
	public var point10 : Point;

	public function new()
	{
		display = new Shape();

		point1 = new Point( -20, 0 );
		point2 = new Point( -25, -7 );
		point3 = new Point( -22, -3 );
		point4 = new Point( -30, -5 );
		point5 = new Point( -27, -2 );
		point6 = new Point( -35, 0 );
		point7 = new Point( -27, 2 );
		point8 = new Point( -30, 5 );
		point9 = new Point( -22, 3 );
		point10 = new Point( -25, 7 );

		display.graphics.beginFill( 0xAA6611 );

		display.graphics.moveTo( point1.x, point1.y );
		display.graphics.lineTo( point2.x, point2.y );
		display.graphics.lineTo( point3.x, point3.y );
		display.graphics.lineTo( point4.x, point4.y );
		display.graphics.lineTo( point5.x, point5.y );
		display.graphics.lineTo( point6.x, point6.y );
		display.graphics.lineTo( point7.x, point7.y );
		display.graphics.lineTo( point8.x, point8.y );
		display.graphics.lineTo( point9.x, point9.y );
		display.graphics.lineTo( point10.x, point10.y );
		display.graphics.lineTo( point1.x, point1.y );
		display.graphics.endFill();

		/*
		display.graphics.moveTo( 12, 2 );
		display.graphics.lineTo( 3, 3 );
		display.graphics.lineTo( 0, 4 );
		display.graphics.lineTo( -6, 4 );
		display.graphics.lineTo( -7, 3 );
		display.graphics.lineTo( -12, 1 );
		display.graphics.lineTo( -12, -1 );
		display.graphics.lineTo( -7, -3 );
		display.graphics.lineTo( -6, -4 );
		display.graphics.lineTo( 0, -4 );
		display.graphics.lineTo( 3, -3 );
		display.graphics.lineTo( 12, -2 );
		display.graphics.lineTo( 12, 2 ); // back again
		display.graphics.endFill();
		*/
	}
}
