package com.brodavi.epicspacestunts;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

class Main extends Sprite
{
  private var epicspacestunts : EpicSpaceStunts;

  public function new()
  {
    super();
    addEventListener( Event.ENTER_FRAME, onAddedToStage );
  }

  private function onAddedToStage( event : Event ) : Void
  {
    removeEventListener( Event.ENTER_FRAME, onAddedToStage );
    this.epicspacestunts = new EpicSpaceStunts( this, stage.stageWidth, stage.stageHeight );
    this.epicspacestunts.start();
  }
}
