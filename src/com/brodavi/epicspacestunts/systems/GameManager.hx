package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import nme.geom.Point;
import com.brodavi.epicspacestunts.EntityCreator;
import com.brodavi.epicspacestunts.GameConfig;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.Timer;
import com.brodavi.epicspacestunts.nodes.AsteroidCollisionNode;
import com.brodavi.epicspacestunts.nodes.BulletCollisionNode;
import com.brodavi.epicspacestunts.nodes.ButtonNode;
import com.brodavi.epicspacestunts.nodes.CoinCollisionNode;
import com.brodavi.epicspacestunts.nodes.InstructionNode;
import com.brodavi.epicspacestunts.nodes.CongratsNode;
import com.brodavi.epicspacestunts.nodes.ShieldIndicatorNode;
import com.brodavi.epicspacestunts.nodes.ShieldIndicatorTextNode;
import com.brodavi.epicspacestunts.nodes.ScoreDisplayNode;
import com.brodavi.epicspacestunts.nodes.ScoreMultiplierDisplayNode;
import com.brodavi.epicspacestunts.nodes.StartCountdownNode;
import com.brodavi.epicspacestunts.nodes.HighScoreDisplayNode;
import com.brodavi.epicspacestunts.nodes.CountdownNode;
import com.brodavi.epicspacestunts.nodes.SpaceshipNode;
import com.brodavi.epicspacestunts.nodes.StarNode;
import com.brodavi.epicspacestunts.graphics.BitmapFont;

class GameManager extends System
{
	private var config : GameConfig;
	private var gameState : GameState;
	private var timer : Timer;
	private var creator : EntityCreator;
	private var score : Score;

	private var spaceships : NodeList<SpaceshipNode>;
	private var scoredisp : NodeList<ScoreDisplayNode>;
	private var scoremultidisp : NodeList<ScoreMultiplierDisplayNode>;
	private var highscoredisp : NodeList<HighScoreDisplayNode>;
	private var buttons : NodeList<ButtonNode>;
	private var instructions : NodeList<InstructionNode>;
	private var countdown : NodeList<CountdownNode>;
	private var startcountdown : NodeList<StartCountdownNode>;
	private var congrats : NodeList<CongratsNode>;
	private var shieldIndicator : NodeList<ShieldIndicatorNode>;
	private var shieldIndicatorText : NodeList<ShieldIndicatorTextNode>;

	private var asteroids : NodeList<AsteroidCollisionNode>;
	private var coins : NodeList<CoinCollisionNode>;
	private var bullets : NodeList<BulletCollisionNode>;

	private var stars : NodeList<StarNode>;

	public function new( creator : EntityCreator, config : GameConfig, gameState : GameState, timer : Timer, score : Score )
	{
		super();
		this.creator = creator;
		this.config = config;
		this.gameState = gameState;
		this.timer = timer;
		this.score = score;
	}

	override public function addToEngine( engine : Engine ) : Void
	{
		spaceships = engine.getNodeList( SpaceshipNode );
		asteroids = engine.getNodeList( AsteroidCollisionNode );
		coins = engine.getNodeList( CoinCollisionNode );
		stars = engine.getNodeList( StarNode );
		bullets = engine.getNodeList( BulletCollisionNode );
		scoredisp = engine.getNodeList( ScoreDisplayNode );
		scoremultidisp = engine.getNodeList( ScoreMultiplierDisplayNode );
		highscoredisp = engine.getNodeList( HighScoreDisplayNode );
		buttons = engine.getNodeList( ButtonNode );
		instructions = engine.getNodeList( InstructionNode );
		countdown = engine.getNodeList( CountdownNode );
		startcountdown = engine.getNodeList( StartCountdownNode );
		congrats = engine.getNodeList( CongratsNode );
		shieldIndicator = engine.getNodeList( ShieldIndicatorNode );
		shieldIndicatorText = engine.getNodeList( ShieldIndicatorTextNode );
	}

	override public function update( time : Float ) : Void
	{
		if ( gameState.state == GAMEOVER )
			{
				score.multiplier = 1;

				// this kinda stinks... it should be a 1-time event firing.. but it just keeps on going....
				SoundManager.stopTrack01();
				SoundManager.playMenu();

				for ( countdown in startcountdown )
					{
						countdown.startCountdown.timeLeft = 4;
					}
				for ( spaceship in spaceships )
					{
						creator.destroyEntity( spaceship.entity );
					}
				/*
				for ( asteroid in asteroids )
					{
						creator.destroyEntity( asteroid.entity );
					}
				*/
				for ( coin in coins )
					{
						creator.destroyEntity( coin.entity );
					}
				/*
				for ( star in stars )
					{
						creator.destroyEntity( star.entity );
					}
				*/
				for ( indicator in shieldIndicator ) // we have to destroy the indicator because we destroyed the spaceship. If it's destroyed, how are we going to tie it to the ship? Just kill it and make another one
					{
						creator.destroyEntity( indicator.entity );
					}
				for ( indicatorText in shieldIndicatorText )
					{
						creator.destroyEntity( indicatorText.entity ); // this smells bad
					}
				// we don't delete text stuff because we can reuse it
			}

		if ( congrats.empty )
			{
				var text = ["Near Miss!", "WILD!", "Destructive!", "Faster!", "WIPEOUT!", "Score Multiplier!", "Multi-Trouble!", "INSANITY!!", "Ridiculous!!", "SERIOUSLY HOW?!?!", "Multi-Bounce!", "Nice!", "Wow!!"];
				var maxTime = [3, 3, 3, 3, 5, 3, 3, 5, 5, 5, 4, 3, 4];
				for ( i in 0...text.length )
					{
						creator.createCongrats( text[i], maxTime[i] );
					}

				// for lasting the whole 100 seconds... 10 congrats!
				for ( i in 0...20 )
					{
						creator.createCongrats( "You Made It!", Math.random()*3 + 2 ); // random maxTime from 2 to 5
					}
			}

		if ( instructions.empty )
			{
				creator.createInstruction( "assets/splash00.png", SPLASH00 );
				creator.createInstruction( "assets/splash01.png", SPLASH01 );
				//creator.createInstruction( "assets/instructions00.png", INSTRUCTIONS00 );
				//creator.createInstruction( "assets/instructions01.png", INSTRUCTIONS01 );
				//creator.createInstruction( "assets/instructions02.png", INSTRUCTIONS02 );
				//creator.createInstruction( "assets/instructions03.png", INSTRUCTIONS03 );
				//creator.createInstruction( "assets/instructions04.png", INSTRUCTIONS04 )
				creator.createInstruction( "assets/instructions05.png", INSTRUCTIONS05 );
				creator.createInstruction( "assets/keycapturenotification.png", CONFIG00 );
				creator.createInstruction( "assets/credits.png", CREDITS00 );
				creator.createInstruction( "assets/menu.png", MENU );
			}

		if ( startcountdown.empty )
			{
				creator.createStartCountdown();
			}

		if ( buttons.empty )
			{
				creator.createButton( config.width/2 - 150, 240, "Easy", 2, function(e){
					if ( !SoundManager.isMute )
						{
							SoundManager.stopMenu();
							SoundManager.playTrack01();
						}
					gameState.difficulty = EASY;
					gameState.state = COUNTDOWN;
					timer.timeLeft = timer.maxTime;
				});

				creator.createButton( config.width/2, 240, "Normal", 2, function(e){
					if ( !SoundManager.isMute )
						{
							SoundManager.stopMenu();
							SoundManager.playTrack01();
						}
					gameState.difficulty = NORMAL;
					gameState.state = COUNTDOWN;
					timer.timeLeft = timer.maxTime;
				});

				creator.createButton( config.width/2 + 150, 240, "iNSaNE", 2, function(e){
					if ( !SoundManager.isMute )
						{
							SoundManager.stopMenu();
							SoundManager.playTrack01();
						}
					gameState.difficulty = INSANE;
					gameState.state = COUNTDOWN;
					timer.timeLeft = timer.maxTime;
				});

				creator.createButton( config.width/2, 295, "Instructions", 2, function(e){
					gameState.state = INSTRUCTIONS05;
				});
				creator.createButton( config.width/2, 345, "Credits", 2, function(e){
					gameState.state = CREDITS00;
				});
				creator.createButton( config.width/2, 400, "Configure Controls", 2, function(e){
					gameState.state = CONFIG00;
				});

				creator.createButton( config.width/2, 60, "Set Left", 2, function(e){
					gameState.state = SETLEFT;
					gameState.defaultControls = false;
				});
				creator.createButton( config.width/2, 120, "Set Right", 2, function(e){
					gameState.state = SETRIGHT;
					gameState.defaultControls = false;
				});
				creator.createButton( config.width/2, 180, "Set Boost", 2, function(e){
					gameState.state = SETBOOST;
					gameState.defaultControls = false;
				});
				creator.createButton( config.width/2, 240, "Set Fire", 2, function(e){
					gameState.state = SETFIRE;
					gameState.defaultControls = false;
				});
				creator.createButton( config.width/2, 300, "Set Shield", 2, function(e){
					gameState.state = SETSHIELD;
					gameState.defaultControls = false;
				});

				creator.createButton( config.width/2, 380, "Got It!", 2, function(e){
					gameState.state = switch (gameState.state) {
						case SPLASH01: INSTRUCTIONS05;
						//case INSTRUCTIONS00: INSTRUCTIONS01;
						//case INSTRUCTIONS01: INSTRUCTIONS02;
						//case INSTRUCTIONS02: INSTRUCTIONS03;
						//case INSTRUCTIONS03: INSTRUCTIONS04;
						//case INSTRUCTIONS04: MENU;
						case INSTRUCTIONS05: MENU;
						default: ERROR;
					};
				});
				creator.createButton( config.width/2, config.height/2 + 180, "Back", 2, function(e){
					gameState.state = switch (gameState.state) {
						case CREDITS00: MENU;
						case CONFIG00: MENU;
						default: ERROR;
					};
				});
				creator.createButton ( config.width/2, config.height/2 + 160, "Click", 2, function(e){
					gameState.state = INSTRUCTIONS05;
				});
				creator.createButton ( config.width - 45, 30, "Mute", 1, function(e){
					SoundManager.mute();
				});
				creator.createButton ( config.width - 45, 30, "Unmute", 1, function(e){
					SoundManager.unMute();
				});

				creator.createButton ( 45, config.height - 30, "Pause", 1, function(e){
					gameState.state = PAUSED;
				});
				creator.createButton ( config.width/2, config.height/2, "Unpause", 2, function(e){
					gameState.state = PLAYING;
				});
				creator.createButton ( config.width/2, config.height/2 + 100, "Menu", 2, function(e){
					gameState.state = GAMEOVER;
				});

				creator.createHyperlink ( config.width/2, 460, "Epic Space Stunts | copyright 2013 | blog.brodavi.com", 1, "http://blog.brodavi.com" );

				creator.createHyperlink ( config.width/2 - 140, 193, "brodavi", 1, "blog.brodavi.com" );
				creator.createHyperlink ( config.width/2 + 140, 193, "Richard Lord", 1, "http://www.richardlord.net/" );
				creator.createHyperlink ( config.width/2 + 80, 250, "Kenney", 1, "www.kenney.nl" );
				creator.createHyperlink ( config.width/2 - 120, 300, "primeval_polypod", 1, "http://www.freesound.org/people/primeval_polypod/" );
				creator.createHyperlink ( config.width/2, 300, "sandyrb", 1, "http://www.freesound.org/people/sandyrb/" );
				creator.createHyperlink ( config.width/2 + 160, 300, "BFXR", 1, "www.bfxr.net" );
				
				creator.createHyperlink ( config.width/2 + 60, 345, "Kevin MacLeod", 1, "incompetech.com" );
			}

		if ( stars.empty )
			{
				for ( i in 0...20 )
					{
						creator.createStar( 1 );
					}
				for ( i in 0...20 )
					{
						creator.createStar( 0 );
					}
			}

		if( asteroids.empty )
			{
				var spaceship : SpaceshipNode = spaceships.head;
				var asteroidCount : Int = gameState.difficulty==EASY?5:gameState.difficulty==NORMAL?15:25;
				var asteroidSizes : Array<Int> = gameState.difficulty==EASY?[ 30, 30, 30 ]:[ 30, 20, 10 ];

				var position : Point;

				for ( i in 0...asteroidCount )
					{
						do
							{
								position = new Point( Math.random() * 800 - 80, Math.random() * 600 - 60 );
							}
						while ( Point.distance( position, spaceship!=null?spaceship.position.position:new Point(0,0) ) <= 150 );

						creator.createAsteroid( asteroidSizes[ Std.int( Math.random() * 3 ) ], position.x, position.y );
					}
			}

		if ( !(gameState.state == PLAYING || gameState.state == COUNTDOWN) ) return; // kind of a cop-out. I don't need to create anything below this line if not playing...

		if ( shieldIndicator.empty )
			{
				creator.createShieldIndicator( );
			}
		if ( shieldIndicatorText.empty )
			{
				creator.createShieldIndicatorText( );
			}
		if ( scoredisp.empty )
			{
				creator.createScoreTF( );
			}
		if ( scoremultidisp.empty )
			{
				creator.createScoreMultiplierTF( );
			}
		if ( highscoredisp.empty )
			{
				creator.createHighScoreTF( );
			}
		if ( countdown.empty )
			{
				creator.createCountdownTF( );
			}
		if ( spaceships.empty )
			{

				// NOTE: the only time this gets executed is when we are ready to play.
				// SOOOO ICKY...
				for ( asteroid in asteroids )
					{
						creator.destroyEntity( asteroid.entity );
					}
				for ( star in stars )
					{
						creator.destroyEntity( star.entity );
					}

				score.currentScore = 0;

				var newSpaceshipPosition : Point = new Point( config.width * 0.5, config.height * 0.5 );
				var clearToAddSpaceship : Bool = true;
				for ( asteroid in asteroids )
					{
						if ( Point.distance( asteroid.position.position, newSpaceshipPosition ) <= asteroid.collision.radius + 50 )
							{
								//clearToAddSpaceship = false;
								creator.destroyEntity( asteroid.entity );
								break;
							}
					}
				if( clearToAddSpaceship )
					{
						creator.createSpaceship();
					}
			}
		if( coins.empty )
			{
				var coinCount : Int = 3;

				for ( i in 0...coinCount )
					{
						creator.createCoin( );
					}
			}
	}

	override public function removeFromEngine( engine : Engine ) : Void
	{
		spaceships = null;
		asteroids = null;
		bullets = null;
		coins = null;
		stars = null;
		scoredisp = null;
		scoremultidisp = null;
		highscoredisp = null;
		buttons = null;
		instructions = null;
		countdown = null;
		startcountdown = null;
		congrats = null;
		shieldIndicator = null;
		shieldIndicatorText = null;
	}
}