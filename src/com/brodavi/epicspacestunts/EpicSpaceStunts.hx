package com.brodavi.epicspacestunts;

import ash.core.Engine;
import ash.tick.FrameTickProvider;

import com.brodavi.epicspacestunts.systems.AnimationSystem;
import com.brodavi.epicspacestunts.systems.BoostControlSystem;
import com.brodavi.epicspacestunts.systems.BulletAgeSystem;
import com.brodavi.epicspacestunts.systems.ButtonSystem;
import com.brodavi.epicspacestunts.systems.CollisionSystem;
import com.brodavi.epicspacestunts.systems.CongratsSystem;
import com.brodavi.epicspacestunts.systems.DeathThroesSystem;
import com.brodavi.epicspacestunts.systems.GameManager;
import com.brodavi.epicspacestunts.systems.GunControlSystem;
import com.brodavi.epicspacestunts.systems.ImpatienceSystem;
import com.brodavi.epicspacestunts.systems.InstructionSystem;
import com.brodavi.epicspacestunts.systems.KeyCaptureSystem;
import com.brodavi.epicspacestunts.systems.MotionControlSystem;
import com.brodavi.epicspacestunts.systems.MovementSystem;
import com.brodavi.epicspacestunts.systems.RenderSystem;
import com.brodavi.epicspacestunts.systems.ScoreSystem;
import com.brodavi.epicspacestunts.systems.ScoreDisplaySystem;
import com.brodavi.epicspacestunts.systems.ScoreMultiplierDisplaySystem;
import com.brodavi.epicspacestunts.systems.StartCountdownDisplaySystem;
import com.brodavi.epicspacestunts.systems.TimerSystem;
import com.brodavi.epicspacestunts.systems.TwinkleSystem;
import com.brodavi.epicspacestunts.systems.HighScoreDisplaySystem;
import com.brodavi.epicspacestunts.systems.ShieldControlSystem;
import com.brodavi.epicspacestunts.systems.SystemPriorities;
import com.brodavi.epicspacestunts.systems.YouMadeItSystem;

import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.DisplayObjectContainer;
import nme.geom.Rectangle;
import nme.media.Sound;
import nme.ui.Keyboard;

class EpicSpaceStunts
{
    private var mainStage : DisplayObjectContainer;
	private var world : Sprite;
	private var hud : Sprite;

    private var engine : Engine;
    private var tickProvider : FrameTickProvider;
    private var creator : EntityCreator;
    private var keyPoll : KeyPoll;
    private var config : GameConfig;
    private var gameState : GameState;
    private var timer : Timer;
	private var score : Score;

    public function new( mainStage : DisplayObjectContainer, width : Int, height : Int )
    {
        this.mainStage = mainStage;

        prepare( width, height );
    }

    private function prepare( width : Int, height : Int ) : Void
    {
		world = new Sprite();
        hud = new Sprite();

		mainStage.addChild( world );
		mainStage.addChild( hud );

        engine = new Engine();

        config = new GameConfig();
        config.width = width;
        config.height = height;

		gameState = new GameState();
		gameState.state = SPLASH00;

		SoundManager.init( gameState );
		SoundManager.playMenu();

		timer = new Timer();
		timer.timeLeft = -1;
		timer.maxTime = 100;

		score = new Score();
		score.currentScore = 0;
		score.highScore = 0;

        creator = new EntityCreator( engine, config, gameState, timer );
        keyPoll = new KeyPoll( mainStage.stage );

		var clickListener = new Sprite( );
		clickListener.graphics.beginFill(0x421489);
		clickListener.graphics.drawRect(0,0,config.width,config.height);
		clickListener.graphics.endFill();
		clickListener.alpha = 0;
		clickListener.mouseEnabled = false;
		mainStage.addChild(clickListener);

        engine.addSystem( new GameManager( creator, config, gameState, timer, score ), SystemPriorities.preUpdate );
        engine.addSystem( new ImpatienceSystem( gameState, keyPoll, timer, clickListener ), SystemPriorities.update );
        engine.addSystem( new KeyCaptureSystem( keyPoll, gameState, config ), SystemPriorities.update );
        engine.addSystem( new MotionControlSystem( gameState, keyPoll ), SystemPriorities.update );
        engine.addSystem( new GunControlSystem( keyPoll, gameState, creator ), SystemPriorities.update );
        engine.addSystem( new ShieldControlSystem( keyPoll, gameState ), SystemPriorities.update );
        engine.addSystem( new BoostControlSystem( keyPoll, gameState ), SystemPriorities.update );
        engine.addSystem( new BulletAgeSystem( creator ), SystemPriorities.update );
        engine.addSystem( new CongratsSystem( config, gameState ), SystemPriorities.update );
        engine.addSystem( new DeathThroesSystem( creator, gameState  ), SystemPriorities.update );
        engine.addSystem( new YouMadeItSystem( gameState  ), SystemPriorities.update );
        engine.addSystem( new ScoreDisplaySystem( gameState, score ), SystemPriorities.update );
        engine.addSystem( new ScoreMultiplierDisplaySystem( gameState, score ), SystemPriorities.update );
		engine.addSystem( new StartCountdownDisplaySystem( gameState ), SystemPriorities.update );
        engine.addSystem( new HighScoreDisplaySystem( gameState, score ), SystemPriorities.update );
        engine.addSystem( new ScoreSystem( score, gameState ), SystemPriorities.update );
        engine.addSystem( new TimerSystem( timer, gameState ), SystemPriorities.update );
        engine.addSystem( new InstructionSystem( gameState ), SystemPriorities.update );
        engine.addSystem( new ButtonSystem( gameState ), SystemPriorities.update );
        engine.addSystem( new MovementSystem( config, gameState, score, world ), SystemPriorities.move );
        engine.addSystem( new CollisionSystem( creator, score, gameState ), SystemPriorities.resolveCollisions );
        engine.addSystem( new AnimationSystem( ), SystemPriorities.animate );
        engine.addSystem( new TwinkleSystem( gameState ), SystemPriorities.animate );
        engine.addSystem( new RenderSystem( world, hud ), SystemPriorities.render );
    }

    public function start() : Void
    {
        tickProvider = new FrameTickProvider( mainStage );
        tickProvider.add( engine.update );
        tickProvider.start();
    }
}
