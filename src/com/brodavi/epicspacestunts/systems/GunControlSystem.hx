package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.EntityCreator;
import com.brodavi.epicspacestunts.components.Gun;
import com.brodavi.epicspacestunts.components.GunControls;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.nodes.GunControlNode;
import nme.ui.Keyboard;

class GunControlSystem extends ListIteratingSystem<GunControlNode>
{
    private var keyPoll : KeyPoll;
	private var gameState : GameState;
    private var creator : EntityCreator;

    public function new( keyPoll : KeyPoll, gameState : GameState, creator : EntityCreator )
    {
        super( GunControlNode, updateNode );
        this.keyPoll = keyPoll;
		this.gameState = gameState;
        this.creator = creator;
    }

    private function updateNode( node : GunControlNode, time : Float ) : Void
    {
		if ( gameState.state != PLAYING ) return;

        var control : GunControls = node.control;
        var position : Position = node.position;
        var gun : Gun = node.gun;

        gun.shooting = keyPoll.isDown( control.trigger ) || defaultAndShift();
        gun.timeSinceLastShot += time;
        if ( gun.shooting && gun.timeSinceLastShot >= gun.minimumShotInterval )
        {
			SoundManager.playShoot();
            creator.createUserBullet( gun, position );
            gun.timeSinceLastShot = 0;
        }
    }

	private inline function defaultAndShift()
	{
		return gameState.defaultControls && keyPoll.isDown( Keyboard.SHIFT );
	}

}
