package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.nodes.StarNode;

class TwinkleSystem extends ListIteratingSystem<StarNode>
{
	private var gameState : GameState;

    public function new( gameState : GameState )
    {
        super( StarNode, updateNode );
		this.gameState = gameState;
    }

    private function updateNode( star : StarNode, time : Float ) : Void
    {
		if ( gameState.state != PLAYING ) return;

		else
			{
				star.display.displayObject.width = Math.random() * 4;
				star.display.displayObject.height = Math.random() * 4;
			}
    }
}
