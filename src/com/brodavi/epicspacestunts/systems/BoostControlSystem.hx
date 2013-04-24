package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Boost;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.MotionControls;
import com.brodavi.epicspacestunts.nodes.AsteroidCollisionNode;
import com.brodavi.epicspacestunts.nodes.SpaceshipNode;
import nme.ui.Keyboard;
import nme.filters.BitmapFilterQuality; 
import nme.filters.BlurFilter; 

class BoostControlSystem extends System
{
    private var keyPoll : KeyPoll;
	private var gameState : GameState;
	private var spaceships : NodeList<SpaceshipNode>;
	private var asteroids : NodeList<AsteroidCollisionNode>;

    public function new( keyPoll : KeyPoll, gameState : GameState )
    {
        super( );
        this.keyPoll = keyPoll;
		this.gameState = gameState;
    }

	override public function addToEngine( engine : Engine ) : Void
	{
		spaceships = engine.getNodeList( SpaceshipNode );
		asteroids = engine.getNodeList( AsteroidCollisionNode );
	}

	private var keysup : Bool = false;
	private var tick : Int = 0;
    override public function update( time : Float ) : Void
    {
		tick++;
		if ( spaceships.empty ) return;

		var node : SpaceshipNode; 
		node = spaceships.head;
		var boost : Boost;
		boost = node.entity.get( Boost );
		var motion : Motion;
		motion = node.entity.get( Motion );
		var position : Position;
		position = node.entity.get( Position );
		var control : MotionControls;
		control = node.entity.get( MotionControls );

		if ( !node.entity.has( Boost ) ) return; // death throes :|

		if ( gameState.state != PLAYING )
			{
				boost.display.alpha = 0;
				return;
			}

		/*
		boost.point2.x += Math.cos( time ) * 4;
		boost.point2.y += Math.sin( time ) * 4;
		boost.point3.x += Math.cos( time ) * 4;
		boost.point3.y += Math.sin( time ) * 4;
		boost.point9.x += Math.cos( time ) * 4;
		boost.point9.y += Math.sin( time ) * 4;
		boost.point10.x += Math.cos( time ) * 4;
		boost.point10.y += Math.sin( time ) * 4;
		*/
		boost.display.height += Math.cos( tick ) * 2;
		boost.display.width += Math.sin( tick ) * 2;

        if ( keysup && ( keyPoll.isDown( control.accelerate ) || defaultAndW() ))
			{
				SoundManager.playBoost();
				boost.display.alpha = 1;
				motion.velocity.x += Math.cos( position.rotation ) * control.accelerationRate * 20 * time;
				motion.velocity.y += Math.sin( position.rotation ) * control.accelerationRate * 20 * time;
				boost.timeLeft = 2;
				boost.animationTimeLeft = 0.5;
				keysup = false;

				for ( asteroid in asteroids )
					{
						// motion blur
						var blur:BlurFilter = new BlurFilter();
						#if ( html5 || linux || android )
						#else
						blur.blurX = 5;
						blur.blurY = 5;
						blur.quality = BitmapFilterQuality.LOW;
						#end
						asteroid.entity.get( Display ).displayObject.filters = [blur];
					}
			}

		else if ( boost.timeLeft < 0 || ( keyPoll.isUp( control.accelerate ) && defaultAndW() ) )
			{
				keysup = true;
			}

		if ( boost.animationTimeLeft < 0 )
			{
				boost.display.alpha = 0;

				for ( asteroid in asteroids )
					{
						asteroid.entity.get( Display ).displayObject.filters = [];
					}
			}

		boost.timeLeft -= time;
		boost.animationTimeLeft -= time;
    }

	private inline function defaultAndW()
	{
		return gameState.defaultControls && keyPoll.isDown( Keyboard.W );
	}

	override public function removeFromEngine( engine : Engine ) : Void
	{
		spaceships = null;
	}
}
