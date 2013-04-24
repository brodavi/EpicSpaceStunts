package com.brodavi.epicspacestunts.systems;

import com.eclecticdesignstudio.motion.Actuate;
import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.nodes.ScoreDisplayNode;
import com.brodavi.epicspacestunts.graphics.BitmapFont;

class ScoreDisplaySystem extends ListIteratingSystem<ScoreDisplayNode>
{
	private var score : Score;
	private var animating : Bool;
	private var gameState : GameState;

    public function new( gameState : GameState, score : Score )
    {
        super( ScoreDisplayNode, updateNode );
		this.score = score;
		this.gameState = gameState;
		this.animating = false;
    }

    private function updateNode( scoredisp : ScoreDisplayNode, time : Float ) : Void
    {
		var scorebmp = cast(scoredisp.display.displayObject, BitmapFont);

		if ( gameState.state != PLAYING && gameState.state != GAMEOVER && gameState.state != DEATHTHROES && gameState.state != PAUSED && gameState.state != COUNTDOWN )
			{
				scorebmp.visible = false;
				return; // hah cheater
			}
		else scorebmp.visible = true;

		if ( scorebmp.text != "Score: " + Std.int(score.currentScore) )
			{
				scorebmp.text = "Score: " + Std.int(score.currentScore);
			}

		if ( gameState.state == GAMEOVER && !animating )
			{
				Actuate.tween(scorebmp, 0.1, { width:scorebmp.text.length*8*4, height:8*4 }).onComplete( function() {
					Actuate.tween(scoredisp.position.position, 0.5, { x:640/2 - scorebmp.width/2, y:50 }).onComplete( function() {
						animating = false;
					});
				});
				animating = true;
			}

		else if ( gameState.state == PLAYING && !animating )
			{
				Actuate.tween(scorebmp, 0.5, { width:scorebmp.text.length*8*2, height:8*2 });
				Actuate.tween(scoredisp.position.position, 0.5, {x:20, y:50}).onComplete(function(){
					animating = false;
				});
				animating = true;
			}
    }
}
