package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.EntityCreator;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.nodes.DeathThroesNode;

class DeathThroesSystem extends ListIteratingSystem<DeathThroesNode>
{
    private var creator : EntityCreator;
	private var gameState : GameState;

    public function new( creator : EntityCreator, gameState : GameState )
    {
        super( DeathThroesNode, updateNode );
        this.creator = creator;
		this.gameState = gameState;
    }

    private function updateNode( node : DeathThroesNode, time : Float ) : Void
    {
		if ( gameState.state == PLAYING )
			{
				gameState.state = DEATHTHROES;
			}

        node.death.countdown -= time;

        if ( node.death.countdown <= 0 )
			{
				gameState.state = GAMEOVER;
			}
    }
}
