package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Bullet;
import com.brodavi.epicspacestunts.components.Collision;
import com.brodavi.epicspacestunts.components.Motion;
import com.brodavi.epicspacestunts.components.Position;


class BulletCollisionNode extends Node<BulletCollisionNode>
{
    public var bullet : Bullet;
    public var motion : Motion;
    public var position : Position;
    public var collision : Collision;
}
