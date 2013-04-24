package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Button;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.components.Text;

class ButtonNode extends Node<ButtonNode>
{
	public var congrats : Button;
	public var display : Display;
	public var position : Position;
	public var text : Text;
}
