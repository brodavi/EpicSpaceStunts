package com.brodavi.epicspacestunts;

import ash.core.Engine;
import ash.core.Entity;
import ash.fsm.EntityStateMachine;

import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Animation;
import com.brodavi.epicspacestunts.components.Asteroid;
import com.brodavi.epicspacestunts.components.Boost;
import com.brodavi.epicspacestunts.components.Bullet;
import com.brodavi.epicspacestunts.components.Button;
import com.brodavi.epicspacestunts.components.Coin;
import com.brodavi.epicspacestunts.components.Collision;
import com.brodavi.epicspacestunts.components.Congrats;
import com.brodavi.epicspacestunts.components.Countdown;
import com.brodavi.epicspacestunts.components.DeathThroes;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Gun;
import com.brodavi.epicspacestunts.components.GunControls;
import com.brodavi.epicspacestunts.components.Instruction;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.MotionControls;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.components.ScoreDisplay;
import com.brodavi.epicspacestunts.components.ScoreMultiplierDisplay;
import com.brodavi.epicspacestunts.components.HighScoreDisplay;
import com.brodavi.epicspacestunts.components.StartCountdown;
import com.brodavi.epicspacestunts.components.Shield;
import com.brodavi.epicspacestunts.components.ShieldControls;
import com.brodavi.epicspacestunts.components.ShieldIndicator;
import com.brodavi.epicspacestunts.components.ShieldIndicatorText;
import com.brodavi.epicspacestunts.components.Spaceship;
import com.brodavi.epicspacestunts.components.Star;
import com.brodavi.epicspacestunts.components.Text;
import com.brodavi.epicspacestunts.graphics.AsteroidView;
import com.brodavi.epicspacestunts.graphics.BulletView;
import com.brodavi.epicspacestunts.graphics.CoinView;
import com.brodavi.epicspacestunts.graphics.CountdownView;
import com.brodavi.epicspacestunts.graphics.ScoreView;
import com.brodavi.epicspacestunts.graphics.SpaceshipDeathView;
import com.brodavi.epicspacestunts.graphics.SpaceshipView;

import nme.display.Shape;
import nme.display.Sprite;
import nme.ui.Keyboard;

class EntityCreator
{
    private var engine : Engine;
    private var config : GameConfig;
	private var gameState : GameState;
	private var timer : Timer;

    public function new( engine : Engine, config : GameConfig, gameState : GameState, timer : Timer )
    {
        this.engine = engine;
        this.config = config;
		this.gameState = gameState;
		this.timer = timer;
    }

    public function destroyEntity( entity : Entity ) : Void
    {
        engine.removeEntity( entity );
    }

	public function createStar( layer : Int ) : Entity
	{
		var starShape : Shape = new Shape();
		starShape.graphics.beginFill( 0xffffff );
		starShape.graphics.drawRect( 0,0,Std.int(Math.random()*4),Std.int(Math.random()*4) );
		starShape.graphics.endFill();
		starShape.alpha = layer==1?1:0.5;

		var star : Entity = new Entity()
			.add( new Star( layer ) )
			.add( new Position( Math.random()*800 - 80, Math.random()*600 - 60, 0 ) )
			.add( new Motion( 0, 0, 0, 0, 0 ) )
			.add( new Display( starShape, false ) );
		engine.addEntity( star );
		return star;
	}

	public function createCoin( ) : Entity
	{
		var coinView = new CoinView();
		var coin : Entity = new Entity()
			.add( new Coin( ) )
			.add( new Position( Math.random()*800 - 80, Math.random()*600 - 60, 0 ) )
			.add( new Collision( 15, 0 ) )
			.add( new Motion( 0, 0, 0, 0, 0 ) )
			.add( new Display( coinView, false ) )
			.add( new Animation( coinView ) );
		engine.addEntity( coin );
		return coin;
	}

    public function createAsteroid( radius : Float, x : Float, y : Float ) : Entity
    {
		var speed : Float = 20;
        var asteroid : Entity = new Entity()
			.add( new Asteroid() )
			.add( new Position( x, y, 0 ) )
			.add( new Collision( radius, 0 ) )
			.add( new Motion(
				( Math.random() - 0.5 ) * speed, // x velocity
				( Math.random() - 0.5 ) * speed, // y velocity
				Math.random() * 2 - 1, // angular velocity
				150, // max velocity
				0 ) ) // damping
			.add( new Display( new AsteroidView( radius ), false ) );
        engine.addEntity( asteroid );

        return asteroid;
    }

	public function createInstruction( url : String, id : State )
	{
		var pos;

		if ( id == SPLASH00 ) pos = new Position( 40, 40, 0 );
		else if ( id == INSTRUCTIONS05 ) pos = new Position( 80, 60, 0 );
		else if ( id == SPLASH01 || id == CREDITS00 || id == CONFIG00 || id == MENU ) pos = new Position( 0, 0, 0 );
		else pos = new Position( 120, 80, 0 );

		var instruction : Entity = new Entity()
			.add( new Instruction( id ) )
			.add( pos )
			.add( new Display( new nme.display.Bitmap( nme.Assets.getBitmapData( url ) ), true ) );
		engine.addEntity( instruction );

		return instruction;
	}

	public function createHyperlink( x : Float, y : Float, text : String, size : Float, url : String )
	{
		var bmpFont : BitmapFont = new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 );
		bmpFont.text = text;
		bmpFont.width = text.length*8*size;
		bmpFont.height = 8*size;

		var thesprite : Sprite = new Sprite();
		thesprite.addChild( bmpFont );
		thesprite.graphics.beginFill( 0x444444 );
		thesprite.graphics.drawRect( 0, 0, thesprite.width, thesprite.height );
		thesprite.graphics.endFill();

		thesprite.addEventListener( nme.events.MouseEvent.CLICK, function(e) {
			SoundManager.playButton();
			nme.Lib.getURL( new nme.net.URLRequest( url ), "_new" );
		} );

		var button : Entity = new Entity()
			.add( new Position( x - bmpFont.width/2, y - bmpFont.height/2, 0 ) )
			.add( new Button( ) )
			.add( new Text( text ) )
			.add( new Display( thesprite, true ) );
		engine.addEntity( button );
		return button;
	}

	public function createButton( x : Float, y : Float, text : String, size : Float, onClick : Dynamic )
	{
		var bmpFont : BitmapFont = new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 );
		bmpFont.text = text;
		bmpFont.width = text.length*8*size;
		bmpFont.height = 8*size;

		var btnsprite : Sprite = new Sprite();

		btnsprite.addEventListener( nme.events.MouseEvent.MOUSE_UP, function(e) {
			SoundManager.playButton();
			btnsprite.visible = false;
			btnsprite.graphics.clear();
			btnsprite.graphics.beginFill( 0xaaaaaa );
			// (x : Float, y : Float, width : Float, height : Float, topLeftRadius : Float, topRightRadius : Float, bottomLeftRadius : Float, bottomRightRadius : Float)
			#if ( html5 || linux || android )
			btnsprite.graphics.drawRoundRect( 0, 0, btnsprite.width + 20, btnsprite.height + 20, 10, 10 );
			#else
			btnsprite.graphics.drawRoundRectComplex( 0, 0, btnsprite.width + 20, btnsprite.height + 20, 10,10,10,10 );
			#end
			btnsprite.graphics.endFill();
			btnsprite.graphics.beginFill( 0x999999 );
			#if ( html5 || linux || android )
			btnsprite.graphics.drawRoundRect( 5, 5, btnsprite.width - 10, btnsprite.height - 10, 10, 10 );
			#else
			btnsprite.graphics.drawRoundRectComplex( 5, 5, btnsprite.width - 10, btnsprite.height - 10, 10,10,10,10 );
			#end
			btnsprite.graphics.endFill();
			onClick(e);
		} );

		btnsprite.addEventListener( nme.events.MouseEvent.MOUSE_OUT, function(e) {
			btnsprite.graphics.clear();
			btnsprite.graphics.beginFill( 0xaaaaaa );
			#if ( html5 || linux || android )
			btnsprite.graphics.drawRoundRect( 0, 0, btnsprite.width + 20, btnsprite.height + 20, 10, 10 );
			#else
			btnsprite.graphics.drawRoundRectComplex( 0, 0, btnsprite.width + 20, btnsprite.height + 20, 10,10,10,10 );
			#end
			btnsprite.graphics.endFill();
			btnsprite.graphics.beginFill( 0x999999 );
			#if ( html5 || linux || android )
			btnsprite.graphics.drawRoundRect( 5, 5, btnsprite.width - 10, btnsprite.height - 10, 10, 10 );
			#else
			btnsprite.graphics.drawRoundRectComplex( 5, 5, btnsprite.width - 10, btnsprite.height - 10, 10,10,10,10 );
			#end
			btnsprite.graphics.endFill();
		} );


		btnsprite.addEventListener( nme.events.MouseEvent.MOUSE_DOWN, function(e) {
			btnsprite.graphics.beginFill( 0xcccccc );
			#if ( html5 || linux || android )
			btnsprite.graphics.drawRoundRect( -10, -10, btnsprite.width + 20, btnsprite.height + 20, 10, 10 );
			#else
			btnsprite.graphics.drawRoundRectComplex( -10, -10, btnsprite.width + 20, btnsprite.height + 20, 10,10,10,10 );
			#end
			btnsprite.graphics.endFill();
			btnsprite.graphics.beginFill( 0x999999 );
			#if ( html5 || linux || android )
			btnsprite.graphics.drawRoundRect( -5, -5, btnsprite.width - 10, btnsprite.height - 10, 10, 10 );
			#else
			btnsprite.graphics.drawRoundRectComplex( -5, -5, btnsprite.width - 10, btnsprite.height - 10, 10,10,10,10 );
			#end
			btnsprite.graphics.endFill();
		} );

		btnsprite.addChild( bmpFont );

		btnsprite.graphics.beginFill( 0xaaaaaa );
		#if ( html5 || linux || android )
		btnsprite.graphics.drawRoundRect( 0, 0, btnsprite.width + 20, btnsprite.height + 20, 10, 10 );
		#else
		btnsprite.graphics.drawRoundRectComplex( 0, 0, btnsprite.width + 20, btnsprite.height + 20, 10,10,10,10 );
		#end
		btnsprite.graphics.endFill();
		btnsprite.graphics.beginFill( 0x999999 );
		#if ( html5 || linux || android )
		btnsprite.graphics.drawRoundRect( 5, 5, btnsprite.width - 10, btnsprite.height - 10, 10, 10 );
		#else
		btnsprite.graphics.drawRoundRectComplex( 5, 5, btnsprite.width - 10, btnsprite.height - 10, 10,10,10,10 );
		#end
		btnsprite.graphics.endFill();


		bmpFont.x = btnsprite.width/2 - bmpFont.width/2;
		bmpFont.y = btnsprite.height/2 - bmpFont.height/2;

		var button : Entity = new Entity()
			.add( new Position( x - btnsprite.width/2, y - btnsprite.height/2, 0 ) )
			.add( new Button( ) )
			.add( new Text( text ) )
			.add( new Display( btnsprite, true ) );
		engine.addEntity( button );
		return button;
	}

	public function createShieldIndicatorText( ) : Entity
	{
		var shieldIndicatorTextBmp = new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 );
		shieldIndicatorTextBmp.text = "SHIELD";

		var shieldIndicatorText : Entity = new Entity()
			.add( new Position( config.width/2 - 25, 20, 0 ) )
			.add( new ShieldIndicatorText( ) )
			.add( new Display( shieldIndicatorTextBmp, true ) );

		engine.addEntity( shieldIndicatorText );
		return shieldIndicatorText;
	}

	public function createShieldIndicator( ) : Entity
	{
		var indicatorShape = new nme.display.Shape();
		indicatorShape.graphics.beginFill(0xffffff);
		indicatorShape.graphics.drawRect(0,0,150,4);
		indicatorShape.graphics.endFill();

		var shieldIndicator : Entity = new Entity()
			.add( new Position( config.width/2 - 150/2, 29, 0 ) )
			.add( new ShieldIndicator( ) )
			.add( new Display( indicatorShape, true ) );
		engine.addEntity( shieldIndicator );
		return shieldIndicator;
	}

    public function createSpaceship() : Entity
    {
        var spaceship : Entity = new Entity();
        var fsm : EntityStateMachine = new EntityStateMachine( spaceship );

        fsm.createState( "playing" )
			// ( velocityX : Float, velocityY : Float, angularVelocity : Float, maxVelocity : Float, damping : Float )
			.add( Motion ).withInstance( new Motion( 0, 0, 0, gameState.difficulty==EASY?150:gameState.difficulty==NORMAL?300:400, 0.95 ) )
			// ( left : UInt, right : UInt, accelerate : UInt, accelerationRate : Float, rotationRate : Float )
			.add( MotionControls ).withInstance( new MotionControls( config.leftKey, config.rightKey, config.boostKey, 600, 4.5 ) )
			.add( Shield ).withInstance( new Shield( ) )
			.add( ShieldControls ).withInstance( new ShieldControls( config.shieldKey ) )
			.add( Boost ).withInstance( new Boost( ) )
			.add( Gun ).withInstance( new Gun( 8, 0, 0.3, 2 ) )
			.add( GunControls ).withInstance( new GunControls( config.fireKey ) )
			.add( Collision ).withInstance( new Collision( 8, 45 ) )
			.add( Display ).withInstance( new Display( new SpaceshipView(), false ) );

        var deathView : SpaceshipDeathView = new SpaceshipDeathView();
        fsm.createState( "destroyed" )
			.add( DeathThroes ).withInstance( new DeathThroes( 3 ) )
			.add( Display ).withInstance( new Display( deathView, false ) )
			.add( Animation ).withInstance( new Animation( deathView ) );

        spaceship.add( new Spaceship( fsm ) ).add( new Position( config.width/2, config.height/2, 0 ) );

        fsm.changeState( "playing" );

		spaceship.get( Display ).displayObject.addChild( spaceship.get( Shield ).display );
		spaceship.get( Display ).displayObject.addChild( spaceship.get( Boost ).display );

        engine.addEntity( spaceship );

        return spaceship;
    }

    public function createUserBullet( gun : Gun, parentPosition : Position ) : Entity
    {
        var cos : Float = Math.cos( parentPosition.rotation );
        var sin : Float = Math.sin( parentPosition.rotation );
		var speed : Float = 450;
        var bullet : Entity = new Entity()
			.add( new Bullet( gun.bulletLifetime ) )
			.add( new Position(
                cos * gun.offsetFromParent.x - sin * gun.offsetFromParent.y + parentPosition.position.x,
                sin * gun.offsetFromParent.x + cos * gun.offsetFromParent.y + parentPosition.position.y, 0 ) )
			.add( new Collision( 0, 0 ) )
			.add( new Motion( cos * speed, sin * speed, 0, speed, 0 ) )
			.add( new Display( new BulletView(), false ) );
        engine.addEntity( bullet );
        return bullet;
    }

	public function createCongrats( text : String, maxTime : Float ) : Entity
	{
		var bitmapfont : BitmapFont = new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 );
		bitmapfont.text = text;
		bitmapfont.alpha = 0.5;

		var colorTrans : nme.geom.ColorTransform = new nme.geom.ColorTransform( Math.random() * 0.5 + 0.5, Math.random() * 0.5 + 0.5, Math.random()  * 0.5 + 0.5 );
		bitmapfont.bitmapData.colorTransform( bitmapfont.bitmapData.rect, colorTrans );

		var congrats : Entity = new Entity()
			.add( new Congrats( text, maxTime ) )
			.add( new Text( text ) )
			.add( new Position( 0, 0, 0 ) )
			.add( new Display( bitmapfont, false ) );
		congrats.get( Display ).displayObject.visible = false;
		congrats.get( Display ).displayObject.width = 0;
		congrats.get( Display ).displayObject.height = 0;
		engine.addEntity( congrats );

		return congrats;
	}

	public function createHighScoreTF( ) : Entity
	{
		var score : Entity = new Entity()
			.add( new Display( new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 ), true ) )
			.add( new HighScoreDisplay( ) )
			.add( new Position( 400, 60, 0 ) )
			.add( new Motion( 0, 0, 0, 1000, 0 ) );
		engine.addEntity( score );

		return score;
	}

	public function createScoreTF( ) : Entity
	{
		var score : Entity = new Entity()
			.add( new Display( new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 ), true ) )
			.add( new ScoreDisplay( ) )
			.add( new Position( 400, 20, 0 ) )
			.add( new Motion( 0, 0, 0, 1000, 0 ) );
		engine.addEntity( score );

		return score;
	}

	public function createScoreMultiplierTF( ) : Entity
	{
		var scoreMulti : Entity = new Entity()
			.add( new Display( new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 ), true ) )
			.add( new ScoreMultiplierDisplay( ) )
			.add( new Position( 400, 5, 0 ) );
		engine.addEntity( scoreMulti );

		return scoreMulti;
	}

	public function createStartCountdown() : Entity
	{
		var countdownbmp = new BitmapFont( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 );
		countdownbmp.text = "1";
		countdownbmp.visible = false;
		countdownbmp.width = 0;
		countdownbmp.height = 0;
		var countdown : Entity = new Entity()
			.add( new Display( countdownbmp, true ) )
			.add( new Position( 300, 220, 0 ) )
			.add( new StartCountdown( ) );
		engine.addEntity( countdown );

		return countdown;
	}

	public function createCountdownTF( ) : Entity
	{
		var countdown : Entity = new Entity()
			.add( new Display( new CountdownView(), true ) )
			.add( new Position( 20, 20, 0 ) )
			.add( new Countdown( 0 ) )
			.add( new Motion( 0, 0, 0, 1000, 0 ) );
		engine.addEntity( countdown );
		return countdown;
	}
}
