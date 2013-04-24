package com.brodavi.epicspacestunts.systems;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import com.brodavi.epicspacestunts.EntityCreator;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.nodes.AsteroidCollisionNode;
import com.brodavi.epicspacestunts.nodes.BulletCollisionNode;
import com.brodavi.epicspacestunts.nodes.CoinCollisionNode;
import com.brodavi.epicspacestunts.nodes.CongratsNode;
import com.brodavi.epicspacestunts.nodes.SpaceshipCollisionNode;
import nme.display.Shape;
import nme.geom.Point;

class CollisionSystem extends System
{
	private var creator : EntityCreator;
	private var config : GameConfig;
	private var score : Score;
	private var gameState : GameState;

	private var spaceships : NodeList<SpaceshipCollisionNode>;
	private var asteroids : NodeList<AsteroidCollisionNode>;
	private var coins : NodeList<CoinCollisionNode>;
	private var bullets : NodeList<BulletCollisionNode>;
	private var congrats : NodeList<CongratsNode>;

	public function new( creator : EntityCreator, score : Score, gameState : GameState )
	{
		super();
		this.creator = creator;
		this.score = score;
		this.gameState = gameState;
	}

	override public function addToEngine( engine : Engine ) : Void
	{
		spaceships = engine.getNodeList( SpaceshipCollisionNode );
		asteroids = engine.getNodeList( AsteroidCollisionNode );
		coins = engine.getNodeList( CoinCollisionNode );
		bullets = engine.getNodeList( BulletCollisionNode );
		congrats = engine.getNodeList( CongratsNode );
	}

	override public function update( time : Float ) : Void
	{
		var bullet : BulletCollisionNode;
		var asteroid : AsteroidCollisionNode;
		var coin : CoinCollisionNode;
		var spaceship : SpaceshipCollisionNode;
		var congrat : CongratsNode;

		var bounceTimeout : Float = 0;

		// check for bullets destroying asteroids
		for ( bullet in bullets )
			{
				for ( asteroid in asteroids )
					{
						if ( Point.distance( asteroid.position.position, bullet.position.position )
						<= asteroid.collision.radius )
							{
								creator.destroyEntity( bullet.entity );
								if ( asteroid.collision.radius > 10 )
									{
										for ( i in 0...5 )
											{
												creator.createAsteroid( asteroid.collision.radius - 10,
												asteroid.position.position.x + Math.random() * 20 - 10,
												asteroid.position.position.y + Math.random() * 20 - 10 );
											}

										var smast = asteroids.tail;
										for ( i in 0...10 )
											{
												var mc = cast(smast.entity.get( Display ).displayObject, nme.display.Sprite);
												var part = new Shape();
												part.graphics.beginFill( 0x83604A );
												part.graphics.drawRect( -2,-2,4,4 );
												part.graphics.endFill;
												var duration = Math.random() + 0.5;
												var targetX = Math.random() * 100 - 50;
												var targetY = Math.random() * 100 - 50;
												mc.addChild( part );
												Actuate.tween(part, duration, { x:targetX, y:targetY }).ease( Quad.easeOut ).onComplete(function(){
													mc.removeChild( part );
												});
											}

										score.addToScore += gameState.difficulty==EASY?0.5:gameState.difficulty==NORMAL?1:2;

										SoundManager.playAsteroidExplosion();

										for ( congrat in congrats )
											{
												if ( congrat.congrats.text == "Destructive!" )
													{
														congrat.position.position.x = asteroid.position.position.x;
														congrat.position.position.y = asteroid.position.position.y;
														congrat.congrats.timeLeft = congrat.congrats.maxTime;
														congrat.display.displayObject.visible = true;
													}
											}
											
									}

								creator.destroyEntity( asteroid.entity );

								break;
							}
					}
			}

		// collect coins!
		for ( spaceship in spaceships )
			{
				for ( coin in coins )
					{
						if ( Point.distance( coin.position.position, spaceship.position.position )
						< coin.collision.radius + spaceship.collision.radius )
							{
								SoundManager.playCoin();
								score.multiplier += gameState.difficulty==EASY?0.25:gameState.difficulty==NORMAL?0.5:1;
								coin.position.position.x += Math.random()<0.5?-1:1 * 640; // either left or right off screen
								coin.position.position.y += Math.random()<0.5?-1:1 * 480; // either up or down off screen
								// as long as it is far enough away off-screen, movement system will 'loop it around'
								// so that it always 'follows the player' sort of

								for ( congrat in congrats )
									{
										if ( congrat.congrats.text == "Score Multiplier!" )
											{
												congrat.position.position.x = spaceship.position.position.x;
												congrat.position.position.y = spaceship.position.position.y;
												congrat.congrats.timeLeft = congrat.congrats.maxTime;
												congrat.display.displayObject.visible = true;
											}
									}
							}
					}

				// check for proximity stunts and collision
				for ( asteroid in asteroids )
					{
						// if actually hit
						if ( Point.distance( asteroid.position.position, spaceship.position.position )
						<= asteroid.collision.radius + spaceship.collision.radius )
							{
								if ( !spaceship.shield.shield ) // that ! is the most important one in the game............
									{
										spaceship.spaceship.fsm.changeState("destroyed");

										SoundManager.playShipExplosion();

										for ( congrat in congrats )
											{
												if ( congrat.congrats.text == "WIPEOUT!" )
													{
														congrat.position.position.x = spaceship.position.position.x;
														congrat.position.position.y = spaceship.position.position.y;
														congrat.display.displayObject.width = congrat.text.text.length * 8;
														congrat.display.displayObject.height = 8;
														congrat.congrats.timeLeft = congrat.congrats.maxTime;
														congrat.display.displayObject.visible = true;
													}
											}

										break;
									}
								else // shield was up.. boing!
									{
										// if x bounces in y milliseconds...
										score.bounceTime.push( 0 );

										if ( bounceTimeout <= 0 )
											{
												spaceship.motion.velocity.x *= -2;
												spaceship.motion.velocity.y *= -2;

												// I need the ship to get out of the way of the asteroid... else weirdness happens
												spaceship.position.position.x += spaceship.motion.velocity.x * 0.01;
												spaceship.position.position.y += spaceship.motion.velocity.y * 0.01;

												// a hard limit here, no relying on damping
												if ( Math.abs(spaceship.motion.velocity.x) > spaceship.motion.maxVelocity )
													{
														if ( spaceship.motion.velocity.x > spaceship.motion.maxVelocity )
															{
																spaceship.motion.velocity.x = spaceship.motion.maxVelocity;
															}
														if ( spaceship.motion.velocity.x < spaceship.motion.maxVelocity )
															{
																spaceship.motion.velocity.x = -spaceship.motion.maxVelocity;
															}
													}
												if ( Math.abs(spaceship.motion.velocity.y) > spaceship.motion.maxVelocity )
													{
														if ( spaceship.motion.velocity.y > spaceship.motion.maxVelocity )
															{
																spaceship.motion.velocity.y = spaceship.motion.maxVelocity;
															}
														if ( spaceship.motion.velocity.y < spaceship.motion.maxVelocity )
															{
																spaceship.motion.velocity.y = -spaceship.motion.maxVelocity;
															}
													}

												spaceship.position.rotation += Math.PI; // turn the ship around
												bounceTimeout = 0.1; // this is so that two bounces cannot happen twice in less than 0.1 second
											}
										bounceTimeout -= time;

										// conserve energy
										//asteroid.motion.velocity.x = -spaceship.motion.velocity.x/2;
										//asteroid.motion.velocity.y = -spaceship.motion.velocity.y/2;

										// something is wrong here or up there.. bounce is weird
										/*
										if ( spaceship.motion.velocity.x == 0 || spaceship.motion.velocity.y == 0 )
											{
												spaceship.motion.velocity.x = Math.random() + 2 * -asteroid.motion.velocity.x;
												spaceship.motion.velocity.y = Math.random() + 2 * -asteroid.motion.velocity.y;
											}
										*/
									}
							}

						// if really close?
						else if ( Point.distance( asteroid.position.position, spaceship.position.position )
						<= asteroid.collision.radius + spaceship.collision.proximityRadius * 0.5 
						&& !spaceship.shield.shield) // no cheating with shield
							{
								score.addToScore += gameState.difficulty==EASY?2.5:gameState.difficulty==NORMAL?5:10;
								score.wildArray.push( asteroid.entity );

								for ( congrat in congrats )
									{
										if ( congrat.congrats.text == "WILD!" )
											{
												congrat.position.position.x = spaceship.position.position.x;
												congrat.position.position.y = spaceship.position.position.y;
												congrat.congrats.timeLeft = congrat.congrats.maxTime;
												congrat.display.displayObject.visible = true;
											}
									}
							}

						// if kinda close
						else if ( Point.distance( asteroid.position.position, spaceship.position.position )
						<= asteroid.collision.radius + spaceship.collision.proximityRadius
						&& !spaceship.shield.shield)
							{
								score.addToScore += gameState.difficulty==EASY?0.5:gameState.difficulty==NORMAL?1:2;
								score.nearArray.push( asteroid.entity );

								for ( congrat in congrats )
									{
										if ( congrat.congrats.text == "Near Miss!" )
											{
												congrat.position.position.x = spaceship.position.position.x;
												congrat.position.position.y = spaceship.position.position.y;
												congrat.congrats.timeLeft = congrat.congrats.maxTime;
												congrat.display.displayObject.visible = true;
											}
									}
							}
					}

				// check for multiple asteroids in wild distance
				if ( score.wildArray.length > 5 )
					{
						score.addToScore += gameState.difficulty==EASY?25:gameState.difficulty==NORMAL?50:100;
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "SERIOUSLY HOW?!?!" )
									{
										congrat.position.position.x = spaceship.position.position.x;
										congrat.position.position.y = spaceship.position.position.y;
										congrat.display.displayObject.width = congrat.text.text.length * 8 * 4;
										congrat.display.displayObject.height = 8 * 4;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}
					}
				else if ( score.wildArray.length > 3 )
					{
						score.addToScore += gameState.difficulty==EASY?7.5:gameState.difficulty==NORMAL?15:30;
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "Ridiculous!!" )
									{
										congrat.position.position.x = spaceship.position.position.x;
										congrat.position.position.y = spaceship.position.position.y;
										congrat.display.displayObject.width = congrat.text.text.length * 8 * 4;
										congrat.display.displayObject.height = 8 * 4;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}
					}
				else if ( score.wildArray.length > 2 )
					{
						score.addToScore += gameState.difficulty==EASY?7.5:gameState.difficulty==NORMAL?15:30;
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "Wow!!" )
									{
										congrat.position.position.x = spaceship.position.position.x;
										congrat.position.position.y = spaceship.position.position.y;
										congrat.display.displayObject.width = congrat.text.text.length * 8 * 4;
										congrat.display.displayObject.height = 8 * 4;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}
					}
				// check for multiple asteroids nearby for congrats
				else if ( score.nearArray.length > 4 )
					{
						score.addToScore += gameState.difficulty==EASY?5:gameState.difficulty==NORMAL?10:20;
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "INSANITY!!" )
									{
										congrat.position.position.x = spaceship.position.position.x;
										congrat.position.position.y = spaceship.position.position.y;
										congrat.display.displayObject.width = congrat.text.text.length * 8 * 3;
										congrat.display.displayObject.height = 8 * 3;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}
					}
				else if ( score.nearArray.length > 3 )
					{
						score.addToScore += gameState.difficulty==EASY?3.75:gameState.difficulty==NORMAL?7.5:15;
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "Crowd Control!" )
									{
										congrat.position.position.x = spaceship.position.position.x;
										congrat.position.position.y = spaceship.position.position.y;
										congrat.display.displayObject.width = congrat.text.text.length * 8 * 2;
										congrat.display.displayObject.height = 8 * 2;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}
					}
				else if ( score.nearArray.length > 2 )
					{
						score.addToScore += gameState.difficulty==EASY?2.5:gameState.difficulty==NORMAL?5:10;
						for ( congrat in congrats )
							{
								if ( congrat.congrats.text == "Nice!" )
									{
										congrat.position.position.x = spaceship.position.position.x;
										congrat.position.position.y = spaceship.position.position.y;
										congrat.display.displayObject.width = congrat.text.text.length * 8 * 2;
										congrat.display.displayObject.height = 8 * 2;
										congrat.congrats.timeLeft = congrat.congrats.maxTime;
										congrat.display.displayObject.visible = true;
									}
							}
					}
			}
	}

	override public function removeFromEngine( engine : Engine ) : Void
	{
		spaceships = null;
		asteroids = null;
		coins = null;
		bullets = null;
		congrats = null;
	}
}
