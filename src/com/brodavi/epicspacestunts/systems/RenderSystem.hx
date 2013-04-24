package com.brodavi.epicspacestunts.systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.nodes.RenderNode;

class RenderSystem extends System
{
	public var container : DisplayObjectContainer;
	public var hud : DisplayObjectContainer;

	private var nodes : NodeList<RenderNode>;

	public function new( container : DisplayObjectContainer, hud : DisplayObjectContainer )
	{
		super();
		this.container = container;
		this.hud = hud;
	}

	override public function addToEngine( engine : Engine ) : Void
	{
		nodes = engine.getNodeList( RenderNode );
		for( node in nodes )
		{
			addToDisplay( node );
		}
		nodes.nodeAdded.add( addToDisplay );
		nodes.nodeRemoved.add( removeFromDisplay );
	}

	private function addToDisplay( node : RenderNode ) : Void
	{
		if ( node.display.hud )
			{
				hud.addChild( node.display.displayObject );
			}
		else container.addChild( node.display.displayObject );
	}

	private function removeFromDisplay( node : RenderNode ) : Void
	{
		if ( node.display.hud )
			{
				hud.removeChild( node.display.displayObject );
			}
		else container.removeChild( node.display.displayObject );
	}

	override public function update( time : Float ) : Void
	{
		var node : RenderNode;
		var position : Position;
		var display : Display;
		var displayObject : DisplayObject;

		for( node in nodes )
		{
			display = node.display;
			displayObject = display.displayObject;
			position = node.position;

			displayObject.x = position.position.x;
			displayObject.y = position.position.y;
			displayObject.rotation = position.rotation * 180 / Math.PI;
		}
	}

	override public function removeFromEngine( engine : Engine ) : Void
	{
		nodes = null;
	}
}
