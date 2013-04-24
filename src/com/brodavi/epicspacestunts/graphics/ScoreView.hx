package com.brodavi.epicspacestunts.graphics;

class ScoreView extends BitmapFont
{
  public function new( )
  {
	  super( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 );
	  text = "Score: 0";
	  x = 0;
	  y = 0;
  }
}
