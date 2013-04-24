package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Congrats;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Text;
import com.brodavi.epicspacestunts.components.Position;

class CongratsNode extends Node<CongratsNode>
{
	public var congrats : Congrats;
	public var display : Display;
	public var position : Position;
	public var text : Text;
}
