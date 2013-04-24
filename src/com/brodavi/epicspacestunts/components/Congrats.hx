package com.brodavi.epicspacestunts.components;

class Congrats
{
    public var text : String;
	public var timeLeft : Float;
	public var maxTime : Float;

    public function new( text : String, maxTime : Float )
    {
        this.text = text;
		this.maxTime = maxTime;
    }
}
