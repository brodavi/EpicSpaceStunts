package com.brodavi.epicspacestunts;

import ash.core.Entity;

class Score
{
	public var currentScore : Float;
	public var highScore : Float;
	public var addToScore : Float;
	public var multiplier : Float;
	public var wildArray : Array< Entity >;
	public var nearArray : Array< Entity >;
	public var bounce : Array< Entity >;
	public var bounceTime : Array< Float >;

	public function new( )
	{
		currentScore = 0;
		highScore = 0;
		addToScore = 0;
		multiplier = 1;
		wildArray = [];
		nearArray = [];
		bounce = [];
		bounceTime = [];
	}
}
