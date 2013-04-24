package com.brodavi.epicspacestunts.systems;

import ash.core.System;
import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;

class YouMadeItSystem extends System
{
	private var gameState : GameState;
	private var countDown : Float;

    public function new( gameState : GameState )
    {
        super( );
		this.gameState = gameState;
		this.countDown = 5;
    }

    public override function update( time : Float ) : Void
    {
		if ( gameState.state == YOUMADEIT )
			{
				if ( countDown > 0 )
					{
						countDown -= time;
					}
				else
					{
						gameState.state = GAMEOVER;
						countDown = 5;
					}
			}
    }
}
