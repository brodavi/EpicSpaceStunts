package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.graphics.BitmapFont;
import com.brodavi.epicspacestunts.nodes.StartCountdownNode;

import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.ui.Keyboard;

class ImpatienceSystem extends System
{
	var engine : Engine;
	var gameState : GameState;
	var keyPoll : KeyPoll;
	var timer : Timer;
	var clickListener : Sprite;
	var startCountdown : NodeList<StartCountdownNode>;

	public function new( gameState : GameState, keyPoll : KeyPoll, timer : Timer, clickListener : Sprite )
    {
        super( );
		this.gameState = gameState;
		this.keyPoll = keyPoll;
		this.timer = timer;
		this.clickListener = clickListener;
    }

	override public function addToEngine( engine : Engine ) : Void
	{
		startCountdown = engine.getNodeList( StartCountdownNode );
	}

	private function skip( e : MouseEvent ) : Void
	{
		// started game.. counting down
		if ( gameState.state == COUNTDOWN )
			{
				for ( countdown in startCountdown )
					{
						countdown.startCountdown.timeLeft = -1; // ends countdown, starts game
					}
			}

		// just crashed
		if ( gameState.state == DEATHTHROES )
			{
				gameState.state = GAMEOVER;
			}

		clickListener.mouseEnabled = false;
	}

	private var spaceup : Bool = false;
	override public function update( time : Float ) : Void
    {
		if ( gameState.state == MENU || gameState.state == GAMEOVER || gameState.state == SPLASH00 || gameState.state == SPLASH01 || gameState.state == INSTRUCTIONS05 )
			{
				if ( spaceup && keyPoll.isDown( Keyboard.SPACE ) ) // just down
					{
						gameState.state = switch (gameState.state) { // copy of 'got it' button functionality
							case SPLASH00: SPLASH01;
							case SPLASH01: INSTRUCTIONS05;
							//case INSTRUCTIONS00: INSTRUCTIONS01;
							//case INSTRUCTIONS01: INSTRUCTIONS02;
							//case INSTRUCTIONS02: INSTRUCTIONS03;
							case INSTRUCTIONS05: MENU;
							case MENU: COUNTDOWN;
							case GAMEOVER: COUNTDOWN;
							default: ERROR;
						};

						if ( gameState.state == COUNTDOWN )
							{
								if ( !SoundManager.isMute )
									{
										SoundManager.stopMenu();
										SoundManager.playTrack01();
									}
								timer.timeLeft = timer.maxTime;
							}
						spaceup = false;
					}
				else if ( keyPoll.isUp( Keyboard.SPACE ) )
					{
						spaceup = true;
					}
			}

		if ( gameState.state == COUNTDOWN || gameState.state == DEATHTHROES )
			{
				if ( spaceup && keyPoll.isDown( Keyboard.SPACE ) )
					{
						skip( new MouseEvent( MouseEvent.CLICK ) );
						spaceup = false;
					}
				else if ( keyPoll.isUp( Keyboard.SPACE ) )
					{
						spaceup = true;
					}

				if ( !clickListener.mouseEnabled )
					{
						clickListener.mouseEnabled = true;

						if ( !clickListener.hasEventListener( MouseEvent.CLICK ) )
							{
								clickListener.addEventListener( MouseEvent.CLICK, skip );
							}
					}
			}

		else clickListener.mouseEnabled = false;
    }

	override public function removeFromEngine( engine : Engine ) : Void
	{
		startCountdown = null;
	}
}
