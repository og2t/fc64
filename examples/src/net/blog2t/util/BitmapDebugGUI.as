/*---------------------------------------------------------------------------------------------

	[AS3] BitmapDebugGUI
	=======================================================================================

	Copyright (c) 2009 blog2t.net
	All Rights Reserved

	VERSION HISTORY:
	v0.1	Born on 2009-11-12

	USAGE:

	TODOs:

	DEV IDEAS:

	KNOWN ISSUES:

---------------------------------------------------------------------------------------------*/

package net.blog2t.util
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import net.blog2t.util.BitmapDebugger;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class BitmapDebugGUI extends Sprite
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		private var memBitmap:Bitmap;
		private var debugBitmap:Bitmap;
		private var bitmapHolder:Sprite = new Sprite();
		private var bitmapDebugger:BitmapDebugger;
		private var outline:GlowFilter = new GlowFilter(0x888888, 1.0, 2, 2, 10, 1);
		
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function BitmapDebugGUI(inputBmpData:BitmapData, stageInit:Boolean = true) 
		{
			if (stageInit) addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);

			bitmapDebugger = new BitmapDebugger(inputBmpData);
			debugBitmap = new Bitmap(bitmapDebugger.outputBmpData);
			debugBitmap.filters = [outline];
			
			addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			addChild(debugBitmap);
			draw();
		}

		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////

		public function draw():void
		{
			bitmapDebugger.draw();
		}

		public function destroy():void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			stage.removeEventListener(MouseEvent.CLICK, stageClick);
			deactivate();
		}

		public function activate():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			outline.color = 0xCC2200;
			debugBitmap.filters = [outline];
		}

		public function deactivate():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			outline.color = 0x888888;
			debugBitmap.filters = [outline];
		}
		
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		
		public function init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.CLICK, stageClick, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
				
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		
		private function keyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == 189) bitmapDebugger.scale--;
			else if (event.keyCode == 187) bitmapDebugger.scale++;
			else if (event.keyCode == 37) bitmapDebugger.pixelX -= 0.1;
			else if (event.keyCode == 38) bitmapDebugger.pixelY -= 0.1;
			else if (event.keyCode == 39) bitmapDebugger.pixelX += 0.1;
			else if (event.keyCode == 40) bitmapDebugger.pixelY += 0.1;
			else if (event.keyCode == 0x30) bitmapDebugger.scale = 1;
			else if (event.keyCode == 27) deactivate();
			draw();
		}
		
		private function mouseMove(event:MouseEvent):void
		{
			bitmapDebugger.pixelX = mouseX;
			bitmapDebugger.pixelY = mouseY;
			draw();
		}
		
		private function mouseWheel(event:MouseEvent):void
		{
			bitmapDebugger.scale += event.delta;
			draw();
		}
		
		private function mouseClick(event:MouseEvent):void
		{
			bitmapDebugger.pixelX = mouseX;
			bitmapDebugger.pixelY = mouseY;
			draw();
		}
		
		private function stageClick(event:MouseEvent):void
		{
			if (event.target != event.currentTarget) activate(); else deactivate();
		}
		
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}