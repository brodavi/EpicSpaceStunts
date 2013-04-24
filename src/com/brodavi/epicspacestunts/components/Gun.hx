package com.brodavi.epicspacestunts.components;

import nme.geom.Point;

class Gun
{
    public var shooting : Bool = false;
    public var offsetFromParent : Point;
    public var timeSinceLastShot : Float = 0;
    public var minimumShotInterval : Float = 0;
    public var bulletLifetime : Float = 0;

    public function new( offsetX : Int, offsetY : Int, minimumShotInterval : Float, bulletLifetime : Float )
    {
        offsetFromParent = new Point( offsetX, offsetY );
        this.minimumShotInterval = minimumShotInterval;
        this.bulletLifetime = bulletLifetime;
    }
}
