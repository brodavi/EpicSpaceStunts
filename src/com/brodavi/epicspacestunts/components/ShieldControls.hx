package com.brodavi.epicspacestunts.components;

class ShieldControls
{
	#if ( html5 || linux || android )
    public var shieldsUp : Int = 0;
	#else
    public var shieldsUp : UInt = 0;
	#end

	#if ( html5 || linux || android )
    public function new( shieldsUp : Int )
	#else
    public function new( shieldsUp : UInt )
	#end
    {
        this.shieldsUp = shieldsUp;
    }
}
