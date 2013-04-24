package com.brodavi.epicspacestunts.graphics;

class CountdownView extends BitmapFont
{
  public function new( )
  {
	  // fontURL:String, width:Int, height:Int, chars:String, charsPerRow:Int, xSpacing:Int = 0, ySpacing:Int = 0, xOffset:Int = 0, yOffset:Int = 0
	  super( "assets/8x8font.png", 8, 8, BitmapFont.TEXT_SET1 + "#", 127, 0, 0, 32*8, 0 );
	  text = "Time Left: 10";
	  x = 0;
	  y = 0;
  }
}
