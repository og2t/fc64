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
	import flash.events.Event;
	import net.blog2t.util.BitmapDebugGUI;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class BitmapDebugTest extends Sprite
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		[Embed(source="memshot.png")]
		private var Memshot:Class;
		
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function BitmapDebugTest(stageInit:Boolean = true) 
		{
			if (stageInit) addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			
			var bitmapDebugGUI:BitmapDebugGUI = new BitmapDebugGUI(new Memshot().bitmapData);
			addChild(bitmapDebugGUI);
			bitmapDebugGUI.x = 100;
			bitmapDebugGUI.y = 100;
			
			var info:Info = new Info();
			addChild(info);
			info.x = 100;
			info.y = 356;
		}

		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		
		public function init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
				
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}