package com.brodavi.epicspacestunts.systems;

import com.eclecticdesignstudio.motion.Actuate;
import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.nodes.ScoreMultiplierDisplayNode;
import com.brodavi.epicspacestunts.graphics.BitmapFont;

class ScoreMultiplierDisplaySystem extends ListIteratingSystem<ScoreMultiplierDisplayNode>
{
	private var score : Score;
	private var gameState : GameState;

    public function new( gameState : GameState, score : Score )
    {
        super( ScoreMultiplierDisplayNode, updateNode );
		this.score = score;
		this.gameState = gameState;
    }

    private function updateNode( scoremultidisp : ScoreMultiplierDisplayNode, time : Float ) : Void
    {
		var scoremultibmp = cast(scoremultidisp.display.displayObject, BitmapFont);

		if ( gameState.state != PLAYING && gameState.state != GAMEOVER && gameState.state != DEATHTHROES && gameState.state != PAUSED && gameState.state != COUNTDOWN )
			{
				scoremultibmp.visible = false;
				return; // hah cheater
			}
		else scoremultibmp.visible = true;

		if ( scoremultibmp.text != "Multiplier: x" + score.multiplier )
			{
				scoremultibmp.text = "Multiplier: x" + score.multiplier;
			}
    }
}
