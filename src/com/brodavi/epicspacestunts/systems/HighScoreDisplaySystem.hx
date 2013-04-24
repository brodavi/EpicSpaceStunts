package com.brodavi.epicspacestunts.systems;

import com.eclecticdesignstudio.motion.Actuate;
import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.nodes.HighScoreDisplayNode;
import com.brodavi.epicspacestunts.graphics.BitmapFont;

class HighScoreDisplaySystem extends ListIteratingSystem<HighScoreDisplayNode>
{
	private var score : Score;
	private var gameState : GameState;
	private var animating : Bool;

    public function new( gameState : GameState, score : Score )
    {
        super( HighScoreDisplayNode, updateNode );
		this.score = score;
		this.gameState = gameState;
    }

    private function updateNode( scoredisp : HighScoreDisplayNode, time : Float ) : Void
    {
		var scorebmp = cast(scoredisp.display.displayObject, BitmapFont);

		if ( gameState.state != PLAYING && gameState.state != GAMEOVER && gameState.state != DEATHTHROES && gameState.state != PAUSED && gameState.state != COUNTDOWN )
			{
				scorebmp.visible = false;
				return; // hah cheater
			}
		else scorebmp.visible = true;

		if ( scorebmp.text != "High Score: " + Std.int(score.highScore) )
			{
				scorebmp.text = "High Score: " + Std.int(score.highScore);
			}

		if ( gameState.state == GAMEOVER && !animating )
			{
				Actuate.tween(scorebmp, 0.1, { width:scorebmp.text.length*8*4, height:8*4 }).onComplete( function() {
					Actuate.tween(scoredisp.position.position, 1, { x:640/2 - scorebmp.width/2, y:100 }).onComplete(function(){
						animating = false;
					});
				});
				animating = true; // should put inside scoredisp?
			}

		else if ( gameState.state == PLAYING && !animating )
			{
				Actuate.tween(scorebmp, 0.5, { width:scorebmp.text.length*8*2, height:8*2 });
				Actuate.tween(scoredisp.position.position, 0.5, {x:340, y:50}).onComplete(function(){
					animating = false;
				});
				animating = true;
			}
    }
}
