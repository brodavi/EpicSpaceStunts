package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.System;
import ash.core.NodeList;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Boost;
import com.brodavi.epicspacestunts.nodes.CongratsNode;
import com.brodavi.epicspacestunts.nodes.SpaceshipNode;

class ScoreSystem extends System
{
	private var gameState : GameState;
	private var score : Score;
	private var congrats : NodeList<CongratsNode>;
	private var spaceship : NodeList<SpaceshipNode>;

    public function new( score : Score, gameState : GameState )
    {
        super( );
		this.score = score;
		this.gameState = gameState;
    }

	override public function addToEngine( engine : Engine ) : Void
	{
		congrats = engine.getNodeList( CongratsNode );
		spaceship = engine.getNodeList( SpaceshipNode );
	}

    override public function update( time : Float ) : Void
    {
		if ( score.currentScore > score.highScore )
			{
				score.highScore = score.currentScore;
			}

		if ( gameState.state != PLAYING ) return;

		var spaceshp : SpaceshipNode = spaceship.head;

		// coins are nice
		score.addToScore *= score.multiplier;

		// so is boosting
		var boost = spaceshp.entity.get( Boost );
		if ( boost.timeLeft > 0 )
			{
				score.addToScore += gameState.difficulty==EASY?10:gameState.difficulty==NORMAL?20:40;
			}

		// x bounces within y milliseconds
		if ( score.bounceTime.length != 0 )
			{
				var limit = 1; // within 1 second
				var count = 0;

				// for each asteroid bounced off of recently, increase time... after y milliseconds, ignore that bounce
				for ( i in 0...score.bounceTime.length )
					{
						// increase
						score.bounceTime[i] += time;

						// if too old, tag it for killing
						if ( score.bounceTime[i] > limit )
							{
								score.bounceTime[i] = -1;
							}
						// otherwise count it
						else count++;
					}

				// clean up tagged timers
				var res = true;
				for ( i in 0...score.bounceTime.length )
					{
						if ( score.bounceTime[i] == -1 )
							{
								res = score.bounceTime.remove( score.bounceTime[i] );
							}
					}
				if ( !res ) trace("we have a problem");

				// if 3 bounces within y milliseconds
				if ( count > 3 )
					{
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "Multi-Bounce!" )
									{
										gameState.difficulty==EASY?7.5:gameState.difficulty==NORMAL?15:30;

										congrat.position.position.x = spaceshp.position.position.x;
										congrat.position.position.y = spaceshp.position.position.y;
										congrat.display.displayObject.width = congrat.text.text.length * 8 * 3;
										congrat.display.displayObject.height = 8 * 3;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}
						for ( i in 0...score.bounceTime.length )
							{
								score.bounceTime.remove( score.bounceTime[i] );
							}
					}
			}

		// lots of asteroids almost touching you!
		if ( score.wildArray.length > 4 )
			{
				score.addToScore += gameState.difficulty==EASY?2.5:gameState.difficulty==NORMAL?5:10;
			}
		else if ( score.wildArray.length > 2 )
			{
				score.addToScore += gameState.difficulty==EASY?1.75:gameState.difficulty==NORMAL?2.5:5;
			}
		score.wildArray = [];

		// lots of asteroids closeby
		if ( score.nearArray.length > 4 )
			{
				score.addToScore += gameState.difficulty==EASY?2.5:gameState.difficulty==NORMAL?5:10;
			}
		else if ( score.nearArray.length > 2 )
			{
				score.addToScore += gameState.difficulty==EASY?1.75:gameState.difficulty==NORMAL?2.5:5;
			}
		score.nearArray = [];

		// set highscore
		if ( score.currentScore > score.highScore )
			{
				score.highScore = score.currentScore;
			}
		else
			{
				score.currentScore += score.addToScore;
			}
		score.addToScore = 0;
    }

	override public function removeFromEngine( engine : Engine ) : Void
	{
		congrats = null;
		spaceship = null;
	}
}
