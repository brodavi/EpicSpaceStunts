package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Gun;
import com.brodavi.epicspacestunts.components.GunControls;
import com.brodavi.epicspacestunts.components.Position;

class GunControlNode extends Node<GunControlNode>
{
    public var control : GunControls;
    public var gun : Gun;
    public var position : Position;
}
