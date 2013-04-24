package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.MotionControls;
import com.brodavi.epicspacestunts.components.Position;

class MotionControlNode extends Node<MotionControlNode>
{
    public var control : MotionControls;
    public var position : Position;
    public var motion : Motion;
}
