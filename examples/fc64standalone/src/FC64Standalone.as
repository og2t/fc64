/*---------------------------------------------------------------------------------------------

	[AS3] FC64Standalone
	=======================================================================================

	Copyright (c) 2009 blog2t.net
	All Rights Reserved

	VERSION HISTORY:
	v0.1	Born on 2009-11-11

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
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import components.FC64;
	import core.events.CPUResetEvent;
	import core.events.OSInitializedEvent;
	import c64.events.DebuggerEvent;
	import c64.events.FrameRateInfoEvent;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class FC64Standalone extends Sprite
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		private var fc64:FC64;
		
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function FC64Standalone(stageInit:Boolean = true) 
		{
			if (stageInit) addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////
		
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		
		public function init(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			fc64 = new FC64();
			fc64.addEventListener("cpuReset", onCPUReset, false, 0, true);
			/*fc64.addEventListener("frameRateInfo§", onFrameRateInfo, false, 0, true);*/
			/*fc64.addEventListener("stop", onStop, false, 0, true);*/
			addChild(fc64);
			fc64.renderer.start();
			//fc64.cpu.reset();
		}
		
		private function onLoadPRG(e:Event):void
		{
			/*var ba:ByteArray = ByteArray(e.target.data);
			// get start address
			ba.endian = Endian.LITTLE_ENDIAN;
			var startAddress:int = ba.readShort();
			// copy contents
			var addr:int = startAddress;
			for(var i:uint = 0x02; i < ba.length; i++) {
				fc64.mem.write(addr++, ba[i]);
			}
			if(startAddress == 0x0801) {
				// run command
				var charsInBuffer:uint = fc64.mem.read(0xc6);
				if(charsInBuffer < fc64.mem.read(0x0289) - 4) {
					var keyboardBuffer:uint = 0x0277 + charsInBuffer + 1;
					fc64.mem.write(keyboardBuffer++, 82); // R
					fc64.mem.write(keyboardBuffer++, 85); // U
					fc64.mem.write(keyboardBuffer++, 78); // N
					fc64.mem.write(keyboardBuffer++, 13); // Return
					fc64.mem.write(0xc6, charsInBuffer + 5);
				}
			} else {
				fc64.cpu.pc = startAddress;
			}
			software.enabled = true;
			software.selectedIndex = -1;
			loadButton.enabled = false;
			state = "normal";*/
		}
		
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		
		private function onCPUReset(e:CPUResetEvent):void
		{
			trace("reset");
			fc64.cpu.setBreakpoint(0xA483, 255);
			//fc64.renderer.start();
		}
		
		private function onStop(e:DebuggerEvent):void
		{
			trace("onStop", e);
			if (e.breakpointType == 255)
			{
				/*if (state == "loading")
				{
					var fileName:String = software.selectedItem.filename;
					var request:URLRequest = new URLRequest(fileName);
					var loader:URLLoader = new URLLoader();
					loader.dataFormat = URLLoaderDataFormat.BINARY;
					loader.addEventListener(Event.COMPLETE, onLoadPRG);
					loader.load(request);
				} else {
					software.enabled = true;
				}*/
				//fc64.renderer.start();
			}
		}
		
		private function onFrameRateInfo(e:FrameRateInfoEvent):void
		{
			trace(e.frameTime + " ms/frame, " + e.fps + " fps");
		}
		
		private function onOSInitialized(e:OSInitializedEvent):void
		{
		}
		
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}