package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.nodes.ButtonNode;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.graphics.BitmapFont;

class ButtonSystem extends ListIteratingSystem<ButtonNode>
{
	private var gameState : GameState;

    public function new( gameState : GameState )
    {
        super( ButtonNode, updateNode );
		this.gameState = gameState;
    }

    private function updateNode( button : ButtonNode, time : Float ) : Void
    {
		var buttonbmp = button.display.displayObject;

		buttonbmp.visible = false; // start out all hidden?

		// always have one of these two buttons visible
		if ( SoundManager.isMute )
			{
				if ( button.text.text == "Unmute" )
					{
						buttonbmp.visible = true;
					}
			}
		else if ( !SoundManager.isMute )
			{
				if ( button.text.text == "Mute" )
					{
						buttonbmp.visible = true;
					}
			}

		switch ( gameState.state )
			{
				//case ERROR, PLAYING, DEATHTHROES, YOUMADEIT, COUNTDOWN, SETLEFT, SETRIGHT, SETBOOST, SETFIRE, SETSHIELD: return;
				case PLAYING:
					{
						if ( button.text.text == "Pause" )
							{
								buttonbmp.visible = true;
							}
					}
				case PAUSED:
					{
						if ( button.text.text == "Unpause" || button.text.text == "Menu" )
							{
								buttonbmp.visible = true;
							}
					}
				case MENU, GAMEOVER: // really?
					{
						if ( button.text.text == "Easy" || button.text.text == "Normal" || button.text.text == "iNSaNE" || button.text.text == "Credits" || button.text.text == "Instructions" || button.text.text == "Configure Controls" )
							{
								buttonbmp.visible = true;
							}
						if ( button.text.text == "Epic Space Stunts | copyright 2013 | blog.brodavi.com" )
							{
								buttonbmp.visible = true;
							}
					}
				case INSTRUCTIONS05: //INSTRUCTIONS00, INSTRUCTIONS01, INSTRUCTIONS02, INSTRUCTIONS03, INSTRUCTIONS04:
					{
						if ( button.text.text == "Got It!" )
							{
								buttonbmp.visible = true;
							}
					}
				case CREDITS00:
					{
						if ( button.text.text == "Back" || button.text.text == "Kenney" || button.text.text == "incompetech.com" || button.text.text == "sandyrb" || button.text.text == "primeval_polypod" || button.text.text == "Richard Lord" || button.text.text == "BFXR" || button.text.text == "Kevin MacLeod" || button.text.text == "brodavi" )
							{
								buttonbmp.visible = true;
							}
					}
				case CONFIG00:
					{
						if ( button.text.text == "Back" || button.text.text == "Set Left" || button.text.text == "Set Right" || button.text.text == "Set Fire" || button.text.text == "Set Shield" || button.text.text == "Set Boost" )
							{
								buttonbmp.visible = true;
							}
					}
				case SPLASH01:
					{
						if ( button.text.text == "Click" )
							{
								buttonbmp.visible = true;
							}
						if ( button.text.text == "Epic Space Stunts | copyright 2013 | blog.brodavi.com" )
							{
								buttonbmp.visible = true;
							}
					}
				default:
					return;
			}
    }
}
