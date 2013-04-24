package com.brodavi.epicspacestunts.nodes;

import ash.core.Node;
import com.brodavi.epicspacestunts.components.Coin;
import com.brodavi.epicspacestunts.components.Collision;
import com.brodavi.epicspacestunts.components.Position;

class CoinCollisionNode extends Node<CoinCollisionNode>
{
    public var coin : Coin;
    public var position : Position;
    public var collision : Collision;
}
