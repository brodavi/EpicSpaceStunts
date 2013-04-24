package com.brodavi.epicspacestunts.graphics;

import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Point;

#if haxe210
class SpaceshipDeathView extends Sprite, implements Animatable
#else
class SpaceshipDeathView extends Sprite, implements Animatable
#end
{
	private var shape1 : Shape;
	private var vel1 : Point;
	private var rot1 : Float;

	private var shape2 : Shape;
	private var vel2 : Point;
	private var rot2 : Float;

	private var shape3 : Shape;
	private var vel3 : Point;
	private var rot3 : Float;

	private var shape4 : Shape;
	private var vel4 : Point;
	private var rot4 : Float;

	private var shape5 : Shape;
	private var vel5 : Point;
	private var rot5 : Float;

	private var parts : Array<Shape>;
	private var vels : Array<Point>;

	public function new()
	{
		super();
		shape1 = new Shape();
		shape1.graphics.beginFill( 0xFFFFFF );
		shape1.graphics.moveTo( 15, 2 );
		shape1.graphics.lineTo( 5, 5 );
		shape1.graphics.lineTo( 0, 10 );
		shape1.graphics.lineTo( -7, 10 );
		shape1.graphics.lineTo( -9, 5 );
		shape1.graphics.lineTo( -15, 3 );
		shape1.graphics.lineTo( 15, 2 );
		shape1.graphics.endFill();
		addChild( shape1 );

		shape2 = new Shape();
		shape2.graphics.beginFill( 0xFFFFFF );
		shape2.graphics.moveTo( 10, 0 );
		shape2.graphics.lineTo( -7, -7 );
		shape2.graphics.lineTo( -4, 0 );
		shape2.graphics.lineTo( 10, 0 );
		shape2.graphics.endFill();
		addChild( shape2 );

		shape3 = new Shape();
		shape3.graphics.beginFill( 0xAC3839 );
		shape3.graphics.moveTo( 0, 10 );
		shape3.graphics.lineTo( 3, 11 );
		shape3.graphics.lineTo( 4, 13 );
		shape3.graphics.lineTo( -8, 13 );
		shape3.graphics.lineTo( -7, 10 );
		shape3.graphics.lineTo( 0, 10 );
		shape3.graphics.endFill();
		addChild( shape3 );
		shape3.y += 5;

		shape4 = new Shape();
		shape4.graphics.beginFill( 0xFFFFFF );
		shape4.graphics.moveTo( 10, 0 );
		shape4.graphics.lineTo( -7, -7 );
		shape4.graphics.lineTo( -4, 0 );
		shape4.graphics.lineTo( 10, 0 );
		shape4.graphics.endFill();
		addChild( shape4 );

		shape5 = new Shape();
		shape5.graphics.beginFill( 0xAC3839 );
		shape5.graphics.moveTo( 0, 10 );
		shape5.graphics.lineTo( 5, 11 );
		shape5.graphics.lineTo( 4, 15 );
		shape5.graphics.lineTo( -8, 15 );
		shape5.graphics.lineTo( -7, 10 );
		shape5.graphics.lineTo( 0, 10 );
		shape5.graphics.endFill();
		addChild( shape5 );
		shape5.y += 5;

		var speed = 40;
		vel1 = new Point( Math.random() * speed - 5, Math.random() * speed + 10 );
		vel2 = new Point( Math.random() * speed - 5, - ( Math.random() * speed + 10 ) );
		vel3 = new Point( Math.random() * speed - 5, - ( Math.random() * speed + 10 ) );
		vel4 = new Point( Math.random() * speed - 5, Math.random() * speed + 10 );
		vel5 = new Point( Math.random() * speed - 5, - ( Math.random() * speed + 10 ) );

		rot1 = Math.random() * 300 - 150;
		rot2 = Math.random() * 300 - 150;
		rot3 = Math.random() * 300 - 150;
		rot4 = Math.random() * 300 - 150;
		rot5 = Math.random() * 300 - 150;

		parts = [];
		vels = [];
		for ( i in 0...20 )
			{
				var part = new Shape();
				part.graphics.beginFill(0xffffff);
				part.graphics.drawRect(2,2,2,2);
				part.graphics.endFill();
				parts.push(part);
				vels.push( new Point( Math.random() * speed * 3 - speed * 1.5, Math.random() * speed * 3 - speed * 1.5 ) );
				addChild(part);
			}
	}

	public function animate( time : Float ) : Void
	{
		shape1.x += vel1.x * time;
		shape1.y += vel1.y * time;
		shape1.rotation += rot1 * time;
		shape2.x += vel2.x * time;
		shape2.y += vel2.y * time;
		shape2.rotation += rot2 * time;
		shape3.x += vel3.x * time;
		shape3.y += vel3.y * time;
		shape3.rotation += rot3 * time;
		shape4.x += vel4.x * time;
		shape4.y += vel4.y * time;
		shape4.rotation += rot4 * time;
		shape5.x += vel5.x * time;
		shape5.y += vel5.y * time;
		shape5.rotation += rot5 * time;

		for ( i in 0...parts.length )
			{
				parts[i].x += vels[i].x * time;
				parts[i].y += vels[i].y * time;
			}
	}
}
