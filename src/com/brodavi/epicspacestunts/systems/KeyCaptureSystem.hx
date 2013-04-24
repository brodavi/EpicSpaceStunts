package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import com.brodavi.epicspacestunts.GameState;
import nme.ui.Keyboard;

class KeyCaptureSystem extends System
{
    private var keyPoll : KeyPoll;
	private var gameState : GameState;
	private var config : GameConfig;

    public function new( keyPoll : KeyPoll, gameState : GameState, config : GameConfig )
    {
        super( );
        this.keyPoll = keyPoll;
		this.gameState = gameState;
		this.config = config;
    }

    override public function update( time : Float ) : Void
    {
		if ( gameState.state != SETLEFT && gameState.state != SETRIGHT &&  gameState.state != SETBOOST &&  gameState.state != SETSHIELD &&  gameState.state != SETFIRE ) return;

		for ( key in 0...255 ) // all the keys on the keyboard?
		//for ( key in Reflect.fields( Keyboard ) ) // all the keys on the keyboard?
			{
				if ( keyPoll.isDown( key ) )
					{
						switch ( gameState.state )
							{
								//case SPLASH00,PLAYING,MENU,INSTRUCTIONS05,GAMEOVER,ERROR,DEATHTHROES,YOUMADEIT,CREDITS00,COUNTDOWN,CONFIG00: return;
								case SETLEFT:
									{
										config.leftKey = key;
										gameState.state = CONFIG00;
									}
								case SETRIGHT:
									{
										config.rightKey = key;
										gameState.state = CONFIG00;
									}
								case SETBOOST:
									{
										config.boostKey = key;
										gameState.state = CONFIG00;
									}
								case SETFIRE:
									{
										config.fireKey = key;
										gameState.state = CONFIG00;
									}
								case SETSHIELD:
									{
										config.shieldKey = key;
										gameState.state = CONFIG00;
									}
								default:
									return;
							}
					}
			}
	}
}
