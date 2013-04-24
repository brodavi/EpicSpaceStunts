package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Asteroid;
import com.brodavi.epicspacestunts.components.Collision;
import com.brodavi.epicspacestunts.components.Position;
import com.brodavi.epicspacestunts.components.Motion;


class AsteroidCollisionNode extends Node<AsteroidCollisionNode>
{
    public var asteroid : Asteroid;
    public var position : Position;
    public var collision : Collision;
    public var motion : Motion;
}
