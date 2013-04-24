package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.EntityCreator;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.components.Shield;
import com.brodavi.epicspacestunts.nodes.ShieldControlNode;

class ShieldLimitSystem extends ListIteratingSystem<ShieldControlNode>
{
	private var gameState : GameState;

    public function new( gameState : GameState )
    {
        super( ShieldAgeNode, updateNode );
		this.gameState = gameState;
    }

    private function updateNode( node : ShieldControlNode, time : Float ) : Void
    {
        var shield : Shield = node.shield;
        shield.lifeRemaining -= time * gameState.difficulty==EASY?0.5:gameState.difficulty==NORMAL?1:1.5;
        if ( shield.lifeRemaining <= 0 )
        {
            creator.destroyEntity( node.entity );
        }
    }
}
