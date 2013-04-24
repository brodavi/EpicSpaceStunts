package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.graphics.BitmapFont;
import com.brodavi.epicspacestunts.nodes.StartCountdownNode;

class StartCountdownDisplaySystem extends ListIteratingSystem<StartCountdownNode>
{
	var gameState : GameState;

    public function new( gameState : GameState )
    {
        super( StartCountdownNode, updateNode );
		this.gameState = gameState;
    }

    private function updateNode( node : StartCountdownNode, time : Float ) : Void
    {
		var countbmp = cast(node.display.displayObject, BitmapFont);
		var timeLeft = node.startCountdown.timeLeft;

		if ( gameState.state == COUNTDOWN && timeLeft > 0 )
			{
				countbmp.visible = true;

				if ( timeLeft > 3 )
					{
						countbmp.text = "3";
					}
				else if ( timeLeft > 2 )
					{
						countbmp.text = "2";
					}
				else if ( timeLeft > 1 )
					{
						countbmp.text = "1";
					}
				else if ( timeLeft > 0 )
					{
						node.position.position.x -= 2;
						node.position.position.y -= 0.3;
						countbmp.text = "GO!";
					}
				countbmp.width++;
				countbmp.height++;

				node.position.position.x -= 0.5;
				node.position.position.y -= 0.5;

				node.startCountdown.timeLeft -= time; // cannot be timeLeft because it is just a copy, apparently
			}

		// countdown's over .. reset
        if ( gameState.state == COUNTDOWN && timeLeft < 0 )
			{
				gameState.state = PLAYING;
				countbmp.visible = false;
				countbmp.width = 0;
				countbmp.height = 0;
				node.position.position.x = 300;
				node.position.position.y = 220;
			}
    }
}
