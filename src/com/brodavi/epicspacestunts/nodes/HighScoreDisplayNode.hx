package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.components.HighScoreDisplay;

class HighScoreDisplayNode extends Node<HighScoreDisplayNode>
{
	public var display : Display;
	public var position : Position;
	public var score : HighScoreDisplay;
}
