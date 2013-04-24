package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Shield;
import com.brodavi.epicspacestunts.components.ShieldControls;
import com.brodavi.epicspacestunts.components.Position;

class ShieldControlNode extends Node<ShieldControlNode>
{
    public var control : ShieldControls;
    public var shield : Shield;
    public var position : Position;
}
