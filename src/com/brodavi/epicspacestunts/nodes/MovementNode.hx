package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.Position;

class MovementNode extends Node<MovementNode>
{
    public var position : Position;
    public var motion : Motion;
}
