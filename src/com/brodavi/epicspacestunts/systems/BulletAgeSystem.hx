package com.brodavi.epicspacestunts.systems;

import ash.tools.ListIteratingSystem;
import com.brodavi.epicspacestunts.EntityCreator;
import com.brodavi.epicspacestunts.components.Bullet;
import com.brodavi.epicspacestunts.nodes.BulletAgeNode;

class BulletAgeSystem extends ListIteratingSystem<BulletAgeNode>
{
    private var creator : EntityCreator;

    public function new( creator : EntityCreator )
    {
        super( BulletAgeNode, updateNode );
        this.creator = creator;
    }

    private function updateNode( node : BulletAgeNode, time : Float ) : Void
    {
        var bullet : Bullet = node.bullet;
        bullet.lifeRemaining -= time;
        if ( bullet.lifeRemaining <= 0 )
        {
            creator.destroyEntity( node.entity );
        }
    }
}
