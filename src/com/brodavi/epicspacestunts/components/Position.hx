package com.brodavi.epicspacestunts.components;

import nme.geom.Point;

class Position
{
    public var position : Point;
    public var rotation : Float = 0;

    public function new( x : Float, y : Float, rotation : Float )
    {
        position = new Point( x, y );
        this.rotation = rotation;
    }
}
