/*---------------------------------------------------------------------------------------------

	[AS3] BitmapDebugTest
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

package
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import net.blog2t.display.BitmapDebugger;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class BitmapDebugTest extends Sprite
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		[Embed(source="memshot.png")]
		private var Memshot:Class;
		
		private var memBitmap:Bitmap;
		private var debugBitmap:Bitmap;
		
		private var bitmapDebugger:BitmapDebugger;
		
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function BitmapDebugTest(stageInit:Boolean = true) 
		{
			if (stageInit) addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			
			memBitmap = new Memshot();
			bitmapDebugger = new BitmapDebugger(memBitmap.bitmapData);
			
			debugBitmap = new Bitmap(bitmapDebugger.outputBmpData);
			addChild(debugBitmap);
			debugBitmap.x = 100;
			debugBitmap.y = 100;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.CLICK, mouseClick, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			
			bitmapDebugger.scale = 31;
			bitmapDebugger.pixelX = 0;
			bitmapDebugger.pixelY = 0;
			bitmapDebugger.draw();
		}

		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////
		
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		
		public function init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
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
			
			bitmapDebugger.draw();
		}
		
		private function mouseMove(event:MouseEvent):void
		{
			bitmapDebugger.pixelX = mouseX - debugBitmap.x;
			bitmapDebugger.pixelY = mouseY - debugBitmap.y;
			bitmapDebugger.draw();
		}
		
		private function mouseClick(event:MouseEvent):void
		{
			bitmapDebugger.pixelX = mouseX - debugBitmap.x;
			bitmapDebugger.pixelY = mouseY - debugBitmap.y;
			bitmapDebugger.draw();
		}
		
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}