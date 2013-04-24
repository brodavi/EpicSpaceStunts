package com.brodavi.epicspacestunts.components;

import nme.display.DisplayObject;

class Display
{
    public var displayObject : DisplayObject = null;
	public var hud : Bool;

    public function new( displayObject : DisplayObject, hud : Bool )
    {
        this.displayObject = displayObject;
		this.hud = hud;
    }
}
