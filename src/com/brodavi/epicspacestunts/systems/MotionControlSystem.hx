package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.MotionControls;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.nodes.MotionControlNode;
import nme.ui.Keyboard;

class MotionControlSystem extends ListIteratingSystem<MotionControlNode>
{
    private var keyPoll : KeyPoll;
	private var gameState : GameState;

    public function new( gameState : GameState, keyPoll : KeyPoll )
    {
        super( MotionControlNode, updateNode );
        this.keyPoll = keyPoll;
		this.gameState = gameState;
    }

	private var keysup : Bool = false;
    private function updateNode( node : MotionControlNode, time : Float ) : Void
    {
		if ( gameState.state != PLAYING ) return;

        var control : MotionControls = node.control;
        var position : Position = node.position;
        var motion : Motion = node.motion;

		// always move forward
		if ( Math.abs( motion.velocity.x ) < motion.maxVelocity )
		motion.velocity.x += Math.cos( position.rotation ) * control.accelerationRate * 0.7 * time;
		if ( Math.abs( motion.velocity.y ) < motion.maxVelocity )
		motion.velocity.y += Math.sin( position.rotation ) * control.accelerationRate * 0.7 * time;

        if ( keyPoll.isDown( control.left ) || defaultAndA() )
        {
            position.rotation -= control.rotationRate * time;
        }

        if ( keyPoll.isDown( control.right ) || defaultAndD() )
        {
            position.rotation += control.rotationRate * time;
        }
    }

	private inline function defaultAndA()
	{
		return gameState.defaultControls && keyPoll.isDown( Keyboard.A );
	}

	private inline function defaultAndD()
	{
		return gameState.defaultControls && keyPoll.isDown( Keyboard.D );
	}

}
