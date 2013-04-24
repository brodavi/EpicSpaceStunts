package com.brodavi.epicspacestunts.components;

class GunControls
{
	#if ( html5 || linux || android )
    public var trigger : Int = 0;
	#else
    public var trigger : UInt = 0;
	#end

	#if ( html5 || linux || android )
    public function new( trigger : Int )
	#else
    public function new( trigger : UInt )
	#end
    {
        this.trigger = trigger;
    }
}
