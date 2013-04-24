package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Shield;
import com.brodavi.epicspacestunts.components.ShieldControls;
import com.brodavi.epicspacestunts.components.ShieldIndicator;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.nodes.ShieldControlNode;
import com.brodavi.epicspacestunts.nodes.ShieldIndicatorNode;
import nme.ui.Keyboard;

class ShieldControlSystem extends System
{
    private var keyPoll : KeyPoll;
	private var gameState : GameState;

	private var shieldControls : NodeList<ShieldControlNode>;
	private var shieldIndicators : NodeList<ShieldIndicatorNode>;

    public function new( keyPoll : KeyPoll, gameState : GameState )
    {
        super( );
        this.keyPoll = keyPoll;
		this.gameState = gameState;
    }

	override public function addToEngine( engine : Engine ) : Void
	{
		shieldControls = engine.getNodeList( ShieldControlNode );
		shieldIndicators = engine.getNodeList( ShieldIndicatorNode );
	}

    override public function update( time : Float ) : Void
    {

		if ( shieldControls.empty ) return; // if not initialized yet, forget I said anything
		if ( shieldIndicators.empty ) return; // if not initialized yet, forget I said anything

		var node : ShieldControlNode; 
		var shieldIndicator : ShieldIndicatorNode;
		node = shieldControls.head;
		shieldIndicator = shieldIndicators.head;

		if ( gameState.state != PLAYING && gameState.state != DEATHTHROES && gameState.state != PAUSED )
			{
				shieldIndicator.display.displayObject.alpha = 0;
				node.shield.display.alpha = 0;
				return;
			}
		else shieldIndicator.display.displayObject.alpha = 1;

        var control : ShieldControls = node.control;
        var position : Position = node.position;
        var shield : Shield = node.shield;
		var mult = gameState.difficulty==EASY?0.5:gameState.difficulty==NORMAL?1:1.5;
		shield.delayedShutoff -= time * mult;

		if ( shield.delayedShutoff > 0 ) // the shieldDelay was triggered... reduce it and keep shield on..
			{

			}

        else if ( ( keyPoll.isDown( control.shieldsUp ) || defaultAndSpace() ) && shield.timeLeft > 0 ) // shieldDelay not on, but key is and still juice
			{
				//trace( "shieldDelay not on but key is and still juice" );
				SoundManager.playShield( );
				shield.shield = true;
				shield.timeLeft -= time*1.2;
				shield.display.alpha = 0.7;
			}

		else if ( shield.delayedShutoff < 0 && shield.delayedShutoff > -1 ) // trigger shield off
			{
				shield.display.alpha = 0;
				shield.shield = false;
			}

		else if ( shield.shield && shield.delayedShutoff < 0 ) // JUST let go of shield button or JUST ran out of juice ( < -1 because -1 is trigger to turn off shield )
			{
				if ( shield.delayedShutoff < -1 )
					{
						shield.delayedShutoff = 0.1; // turn on delay
					}
			}

		else // shield is not on, key is not down, delay is not on... situation normal
			{
				shield.display.alpha = 0;
				shield.shield = false;

				if ( shield.timeLeft < shield.shieldMax )
					{
						var denom = gameState.difficulty==EASY?4:gameState.difficulty==NORMAL?8:16;
						shield.timeLeft += time / denom;
					}
			}

		shieldIndicator.display.displayObject.width = shield.timeLeft * 50;
    }

	private inline function defaultAndSpace()
	{
		return gameState.defaultControls && keyPoll.isDown( Keyboard.SPACE );
	}

	override public function removeFromEngine( engine : Engine ) : Void
	{
		shieldControls = null;
		shieldIndicators = null;
	}
}
