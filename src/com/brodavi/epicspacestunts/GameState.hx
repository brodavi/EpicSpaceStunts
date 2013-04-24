package com.brodavi.epicspacestunts;

enum Difficulty
{
	EASY;
	NORMAL;
	INSANE;
}

enum State
{
	SPLASH00;
	SPLASH01;
	//INSTRUCTIONS00;
	//INSTRUCTIONS01;
	//INSTRUCTIONS02;
	//INSTRUCTIONS03;
	//INSTRUCTIONS04;
	INSTRUCTIONS05;
	COUNTDOWN;
	PLAYING;
	PAUSED;
	DEATHTHROES;
	YOUMADEIT;
	CREDITS00;
	CONFIG00;
	MENU;
	ERROR;
	GAMEOVER;

	SETLEFT;
	SETRIGHT;
	SETBOOST;
	SETFIRE;
	SETSHIELD;
}

class GameState
{
	public var state : State;
	public var difficulty : Difficulty;
	public var defaultControls : Bool;

	public function new()
	{
		defaultControls = true;
	}
}
