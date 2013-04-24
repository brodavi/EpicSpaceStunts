package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import com.brodavi.epicspacestunts.GameState;
import com.brodavi.epicspacestunts.graphics.BitmapFont;
import com.brodavi.epicspacestunts.nodes.CongratsNode;
import com.brodavi.epicspacestunts.nodes.SpaceshipCollisionNode;

class CongratsSystem extends System
{
	private var config : GameConfig;
	private var gameState : GameState;
	private var congrats : NodeList<CongratsNode>;
	private var spaceships : NodeList<SpaceshipCollisionNode>;

    public function new( config : GameConfig, gameState : GameState )
    {
        super();
		this.config = config;
		this.gameState = gameState;
    }

	override public function addToEngine( engine : Engine ) : Void
	{
		spaceships = engine.getNodeList( SpaceshipCollisionNode );
		congrats = engine.getNodeList( CongratsNode );
	}

    override public function update( time : Float ) : Void
    {
		if ( !( gameState.state == PLAYING || gameState.state == GAMEOVER || gameState.state == DEATHTHROES || gameState.state == YOUMADEIT ) ) 
			{
				for ( congrat in congrats )
					{
						congrat.display.displayObject.visible = false;
						congrat.display.displayObject.width = 0;
						congrat.display.displayObject.height = 0;
					}
			}

		for ( congrat in congrats )
			{
				var bitmapFont = cast( congrat.display.displayObject, BitmapFont );
				if ( bitmapFont.visible )
					{
						if ( congrat.congrats.text == "WIPEOUT!" )
							{
								congrat.position.position.y -= 1;
								congrat.position.position.x -= 4;
								bitmapFont.width += Math.random()*5+5;
								bitmapFont.height += Math.random()*2+1;
								congrat.position.position.x += Math.random() * 5 - 2.5;
								congrat.position.position.y += Math.random() * 5 - 2.5;
							}
						else if ( congrat.congrats.text == "You Made It!" )
							{
								congrat.position.position.x -= 2;
								congrat.position.position.y += 0.4 * Math.random()<0.5?-1:1;
								bitmapFont.width*=1.02;
								bitmapFont.height*=1.02;
							}
						else if ( bitmapFont.width == 0 )
							{
								bitmapFont.width = congrat.text.text.length * 8;
								bitmapFont.height = 8;
							}
						congrat.position.position.x += Math.random() * 5 - 2.5;
						congrat.position.position.y += Math.random() * 5 - 2.5;
						congrat.congrats.timeLeft -= time;
					}

				if ( congrat.congrats.timeLeft <= 0 )
					{
						bitmapFont.visible = false;
						bitmapFont.width = 0;
						bitmapFont.height = 0;
					}
			}
    }

	override public function removeFromEngine( engine : Engine ) : Void
	{
		spaceships = null;
		congrats = null;
	}
}
