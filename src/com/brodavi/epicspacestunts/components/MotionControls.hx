package com.brodavi.epicspacestunts.components;

class MotionControls
{
	#if ( html5 || linux || android )
    public var left : Int = 0;
    public var right : Int = 0;
    public var accelerate : Int = 0;
	#else
    public var left : UInt = 0;
    public var right : UInt = 0;
    public var accelerate : UInt = 0;
	#end

    public var accelerationRate : Float = 0;
    public var rotationRate : Float = 0;

	#if ( html5 || linux || android )
    public function new( left : Int, right : Int, accelerate : Int, accelerationRate : Float, rotationRate : Float )
	#else
	public function new( left : UInt, right : UInt, accelerate : UInt, accelerationRate : Float, rotationRate : Float )
	#end
    {
        this.left = left;
        this.right = right;
        this.accelerate = accelerate;
        this.accelerationRate = accelerationRate;
        this.rotationRate = rotationRate;
    }
}
