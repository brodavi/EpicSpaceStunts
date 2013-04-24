package com.brodavi.epicspacestunts.components;

class Collision
{
    public var radius : Float = 0;
    public var proximityRadius : Float = 0;

    public function new( radius : Float, proximityRadius : Float )
    {
        this.radius = radius;
        this.proximityRadius = proximityRadius;
    }
}
