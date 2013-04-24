package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Collision;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.components.Spaceship;
import com.brodavi.epicspacestunts.components.Shield;

class SpaceshipCollisionNode extends Node<SpaceshipCollisionNode>
{
    public var spaceship : Spaceship;
    public var motion : Motion;
    public var position : Position;
    public var collision : Collision;
    public var shield : Shield;
}
