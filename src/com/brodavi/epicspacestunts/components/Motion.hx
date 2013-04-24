package com.brodavi.epicspacestunts.components;

import nme.geom.Point;

class Motion
{
  public var velocity : Point;
  public var angularVelocity : Float = 0;
  public var maxVelocity : Float = 0;
  public var damping : Float = 0;

	public function new( velocityX : Float, velocityY : Float, angularVelocity : Float, maxVelocity : Float, damping : Float )
	{
		velocity = new Point( velocityX, velocityY );
		this.angularVelocity = angularVelocity;
		this.maxVelocity = maxVelocity;
		this.damping = damping;
	}
}
