package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.System;
import ash.core.NodeList;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Asteroid;
import com.brodavi.epicspacestunts.components.Coin;
import com.brodavi.epicspacestunts.components.Collision;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.components.Spaceship;
import com.brodavi.epicspacestunts.components.Star;
import com.brodavi.epicspacestunts.nodes.MovementNode;
import com.brodavi.epicspacestunts.nodes.CongratsNode;
import com.brodavi.epicspacestunts.nodes.SpaceshipCollisionNode;

import nme.display.Sprite;

class MovementSystem extends System
{
    private var config : GameConfig;
	private var gameState : GameState;
	private var score : Score;
	private var world : Sprite;

	private var movers : NodeList<MovementNode>;
	private var congrats : NodeList<CongratsNode>;
	private var spaceships : NodeList<SpaceshipCollisionNode>;

    public function new( config : GameConfig, gameState : GameState, score : Score, world : Sprite )
    {
		super();
        this.config = config;
		this.world = world;
		this.gameState = gameState;
		this.score = score;
    }

	override public function addToEngine( engine : Engine ) : Void
	{
		movers = engine.getNodeList( MovementNode );
		congrats = engine.getNodeList( CongratsNode );
		spaceships = engine.getNodeList( SpaceshipCollisionNode );
	}

    override public function update( time : Float ) : Void
    {
		var mover : MovementNode;
		var congrat : CongratsNode;

		if ( gameState.state == PAUSED ) return;

		for ( mover in movers )
			{
				var position : Position = mover.position;
				var motion : Motion = mover.motion;

				// center camera on spaceship
				if ( gameState.state == COUNTDOWN )
					{
						world.x = 0;
						world.y = 0;
					}

				if ( gameState.state == COUNTDOWN || gameState.state == DEATHTHROES ) return;

				position = mover.position;
				motion = mover.motion;
				position.position.x += motion.velocity.x * time;
				position.position.y += motion.velocity.y * time;

				if ( mover.entity.has( Star ) )
					{
						var spaceship = spaceships.head;
						if ( spaceship != null )
							{
								var ratio : Float;
								if ( mover.entity.get( Star ).layer == 0 )
									{
										ratio = 0.5;
									}
								else
									{
										ratio = 0.25;
									}
								motion.velocity.x = -spaceship.motion.velocity.x * ratio;
								motion.velocity.y = -spaceship.motion.velocity.y * ratio;
								//motion.velocity.x = -spaceship.motion.velocity.x * mover.entity.get( Star ).layer==0?0:1;
								//motion.velocity.y = -spaceship.motion.velocity.y * mover.entity.get( Star ).layer==0?0:1;
							}
					}

				// recycle asteroids and coins and stars
				if ( mover.entity.has( Asteroid ) || mover.entity.has( Coin ) || mover.entity.has( Star ) )
					{
						// if too far left
						if ( position.position.x < -world.x - 100 )
							{
								// appear on right side somewhere
								position.position.x = -world.x + config.width + 90;
								position.position.y = -world.y - 60 + Std.int( Math.random() * 600 );
							}
						// if too far right
						if ( position.position.x > -world.x + config.width + 100 )
							{
								// appear on the left side somewhere
								position.position.x = -world.x - 90;
								position.position.y = -world.y - 60 + Std.int( Math.random() * 600 );
							}
						// if too far up
						if ( position.position.y < -world.y - 100 )
							{
								position.position.x = -world.x - 80 + Std.int( Math.random() * 800 );
								position.position.y = -world.y + config.height + 90;
							}
						// if too far down
						if ( position.position.y > -world.y + config.height + 100)
							{
								position.position.x = -world.x - 80 + Std.int( Math.random() * 800 );
								position.position.y = -world.y - 90;
							}
					}

				// rotate
				position.rotation += motion.angularVelocity * time;

				// max velocity
				if ( Math.abs( motion.velocity.x ) > motion.maxVelocity )
					{
						if ( motion.velocity.x > 0 )
							{
								motion.velocity.x--;
							}
						if ( motion.velocity.x < 0 )
							{
								motion.velocity.x+=1;
							}
					}
				if ( Math.abs( motion.velocity.y ) > motion.maxVelocity )
					{
						if ( motion.velocity.y > 0 )
							{
								motion.velocity.y--;
							}
						if ( motion.velocity.y < 0 )
							{
								motion.velocity.y+=1;
							}
					}

				// let's try motion damping.. 'friction' ?
				if ( motion.damping != 0 )
					{
						if ( motion.velocity.x > 0 || motion.velocity.x < 0 )
							{
								motion.velocity.x *= motion.damping;

								if ( Math.abs( motion.velocity.x ) < 0.1 )
									{
										motion.velocity.x = 0;
									}
							}
						if ( motion.velocity.y > 0 || motion.velocity.y < 0 )
							{
								motion.velocity.y *= motion.damping;

								if ( Math.abs( motion.velocity.y ) < 0.1 )
									{
										motion.velocity.y = 0;
									}
							}
					}

				// if going fast
				/*
				if ( mover.entity.has( Spaceship ) )
					{
						var spaceship = mover;

						// going fast? then up the proximity
						if ( Math.abs(spaceship.motion.velocity.x) > 180 || Math.abs(spaceship.motion.velocity.y) > 180 )
							{
								spaceship.entity.get( Collision ).proximityRadius = 100;
							}
						else
							{
								spaceship.entity.get( Collision ).proximityRadius = 50;
							}
					}
				*/

				// center camera on spaceship
				if ( mover.entity.has( Spaceship ) )
					{
						world.x = Std.int(-position.position.x + config.width/2);
						world.y = Std.int(-position.position.y + config.height/2);
					}
			}
	}

	override public function removeFromEngine( engine : Engine ) : Void
	{
		movers = null;
		congrats = null;
		spaceships = null;
	}
}
