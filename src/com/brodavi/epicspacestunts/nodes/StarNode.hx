package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Display;
import com.brodavi.epicspacestunts.components.Star;
import com.brodavi.epicspacestunts.components.Position;

class StarNode extends Node<StarNode>
{
    public var display : Display;
    public var star : Star;
    public var position : Position;
}
