package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import com.brodavi.epicspacestunts.graphics.BitmapFont;
import com.brodavi.epicspacestunts.nodes.CountdownNode;
import com.brodavi.epicspacestunts.nodes.CongratsNode;
import com.brodavi.epicspacestunts.nodes.AsteroidCollisionNode;
import com.brodavi.epicspacestunts.nodes.SpaceshipCollisionNode;
import com.brodavi.epicspacestunts.GameState;

class TimerSystem extends System
{
	private var timer : Timer;
	private var gameState : GameState;
	private var countdowns : NodeList<CountdownNode>;
	private var congrats : NodeList<CongratsNode>;
	private var asteroids : NodeList<AsteroidCollisionNode>;
	private var spaceships : NodeList<SpaceshipCollisionNode>;

    public function new( timer : Timer, gameState : GameState )
    {
        super( );
		this.timer = timer;
		this.gameState = gameState;
    }

	override public function addToEngine( engine : Engine ) : Void
	{
		countdowns = engine.getNodeList( CountdownNode );
		congrats = engine.getNodeList( CongratsNode );
		asteroids = engine.getNodeList( AsteroidCollisionNode );
		spaceships = engine.getNodeList( SpaceshipCollisionNode );
	}

    override public function update( time : Float ) : Void
    {
		if ( gameState.state == PLAYING )
			{
				// make 'em go faster... little by little
				for ( asteroid in asteroids )
					{
						var num = gameState.difficulty==EASY?0.0005:gameState.difficulty==NORMAL?0.001:0.002;
						asteroid.motion.velocity.x *= 1 + Math.random() * num;
						asteroid.motion.velocity.y *= 1 + Math.random() * num;
						//trace ( "velocity x: " + asteroid.motion.velocity.x );
					}

				timer.timeLeft -= time;

				if ( timer.timeLeft < 0 )
					{
						var spaceship : SpaceshipCollisionNode = spaceships.head;
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "You Made It!" )
									{
										congrat.position.position.x = spaceship.position.position.x + Math.random() * 400 - 200;
										congrat.position.position.y = spaceship.position.position.y + Math.random() * 400 - 200;
										congrat.display.displayObject.width = congrat.text.text.length * 8;
										congrat.display.displayObject.height = 8;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}

						gameState.state = YOUMADEIT; // kinda like death throes state
						return;
					}

				for ( countdown in countdowns )
					{
						var bmpfont = cast(countdown.display.displayObject, BitmapFont);
						bmpfont.visible = true;
						bmpfont.text = "Time Left: " + Std.int(timer.timeLeft);
						bmpfont.width = bmpfont.text.length*8*2;
						bmpfont.height = 8*2;
					}
			}
		else if ( gameState.state == COUNTDOWN )
			{
				var countdown = countdowns.head;
				var bmpfont = cast(countdown.display.displayObject, BitmapFont);
				bmpfont.visible = true;
				bmpfont.text = "Time Left: " + Std.int(timer.timeLeft);
				bmpfont.width = bmpfont.text.length*8*2;
				bmpfont.height = 8*2;
			}
		else if ( gameState.state != GAMEOVER && gameState.state != DEATHTHROES && gameState.state != PAUSED )
			{
				for ( countdown in countdowns )
					{
						countdown.display.displayObject.visible = false;
					}
			}
    }

	override public function removeFromEngine( engine : Engine ) : Void
	{
		countdowns = null;
		congrats = null;
		asteroids = null;
		spaceships = null;
	}
}
