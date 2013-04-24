package com.brodavi.epicspacestunts.graphics;

import nme.display.Shape;

class BulletView extends Shape
{
  public function new()
  {
    super();
    graphics.beginFill( 0xFFFFFF );
    graphics.drawCircle( 0, 0, 2 );
  }
}
