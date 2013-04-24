package com.brodavi.epicspacestunts;

import nme.ui.Keyboard;

class GameConfig
{
	public var width : Int;
	public var height : Int;

	#if ( html5 || linux || android )
	public var leftKey : Int;
	public var rightKey : Int;
	public var boostKey : Int;
	public var fireKey : Int;
	public var shieldKey : Int;
	#else
	public var leftKey : UInt;
	public var rightKey : UInt;
	public var boostKey : UInt;
	public var fireKey : UInt;
	public var shieldKey : UInt;
	#end

	public function new()
	{
		leftKey = Keyboard.LEFT;
		rightKey = Keyboard.RIGHT;
		boostKey = Keyboard.UP;
		fireKey = Keyboard.X;
		shieldKey = Keyboard.SPACE;
	}
}
