package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.nodes.InstructionNode;
import com.brodavi.epicspacestunts.GameState;

class InstructionSystem extends ListIteratingSystem<InstructionNode>
{
	private var gameState : GameState;
	private var logoCountdown : Float;

    public function new( gameState : GameState )
    {
        super( InstructionNode, updateNode );
		this.gameState = gameState;
		this.logoCountdown = 6;
    }

    private function updateNode( instruction : InstructionNode, time : Float ) : Void
    {
		if ( gameState.state == PLAYING || gameState.state == GAMEOVER ) return;

		var instructionbmp = instruction.display.displayObject;

		if ( gameState.state == SPLASH00 && instruction.instruction.id == SPLASH00 )
			{
				if ( logoCountdown > 0 )
					{
						logoCountdown -= time;
						instructionbmp.alpha = Math.sin( logoCountdown * 0.7 );
					}
				else
					{
						gameState.state = SPLASH01;
						logoCountdown = 3;
					}
			}

		else if ( gameState.state == SPLASH01 && instruction.instruction.id == SPLASH01 )
			{
				if ( logoCountdown > 0 )
					{
						logoCountdown -= time;
						instructionbmp.alpha = Math.cos( logoCountdown * 0.5 );
					}
				instructionbmp.visible = true;
			}

		else if ( gameState.state == instruction.instruction.id && instruction.instruction.id != CONFIG00 )
			{
				instructionbmp.alpha = 1;
				instructionbmp.visible = true;
			}
		else if ( instruction.instruction.id == CONFIG00 && ( gameState.state == SETLEFT || gameState.state == SETRIGHT || gameState.state == SETBOOST || gameState.state == SETFIRE || gameState.state == SETSHIELD ) )
					{
						instructionbmp.visible = true;
					}
		else instructionbmp.visible = false;
    }
}
