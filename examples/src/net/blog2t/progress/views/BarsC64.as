/*---------------------------------------------------------------------------------------------

	[AS3] PieChart
	=======================================================================================

	VERSION HISTORY:
	v0.1	Born on 2008-06-11

	USAGE:

	TODOs:

	DEV IDEAS:

	KNOWN ISSUES:

---------------------------------------------------------------------------------------------*/

package net.blog2t.progress.views
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.Event;
	import net.blog2t.progress.IProgressView;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class BarsC64 extends Sprite implements IProgressView
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		private const colors:Array = [
			0xff000000, 0xffffffff, 0xffe04040, 0xff60ffff, 
			0xffe060e0, 0xff40e040, 0xff4040e0, 0xffffff40,
			0xffe0a040, 0xff9c7448, 0xffffa0a0, 0xff545454,
			0xff888888, 0xffa0ffa0, 0xffa0a0ff, 0xffc0c0c0
		];

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		private var canvas:Shape = new Shape();
		private var currentProgress:Number = 0;
		private var destProgress:Number = 0;
		
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function BarsC64() 
		{
			addChild(canvas);
			addEventListener(Event.ADDED_TO_STAGE, setup);
		}
		
		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////
		
		public function start():void
		{
			addEventListener(Event.ENTER_FRAME, refresh);
			autoAlphaFadeIn();
		}
		
		public function stop():void
		{
			autoAlphaFadeOut();
		}
		
		public function finished(delay:Number = 0.25):void
		{
			//TweenLite.delayedCall(0.25, stop);
			stop();
		}
		
		public function updateProgress(loaded:Number):void
		{
			destProgress = loaded;
		}
	
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////

		private function refresh(event:Event):void
		{
			currentProgress += (destProgress - currentProgress) * 0.3;
						
			canvas.graphics.clear();
						
			for (var i:int = 0; i < 40; i++)
			{
				var posY:int = Math.random() * stage.stageHeight;
				canvas.graphics.lineStyle(int(Math.random() * 20) + 5, colors[int(Math.random() * colors.length)], 3 - currentProgress);
				canvas.graphics.moveTo(0, posY);
				canvas.graphics.lineTo(stage.stageWidth, posY);
				canvas.graphics.endFill();
			}
		}
		
		public function setup(event:Event):void
		{
			visible = false;
			alpha = 0;
		}
		
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		
		public function stageResize(event:Event = null):void
		{
			if (stage)
			{
				canvas.x = 0;
				canvas.y = 0;
			}
		}
		
		public function autoAlphaFadeIn(inertia:Number = 0.3):void
		{
			_alphaFadeSpeed = inertia;

			addEventListener(Event.ENTER_FRAME, autoAlphaInOEF, false, 0, true);
			removeEventListener(Event.ENTER_FRAME, autoAlphaOutOEF);
		}

		public function autoAlphaFadeOut(inertia:Number = 0.3):void
		{
			_alphaFadeSpeed = inertia;

			addEventListener(Event.ENTER_FRAME, autoAlphaOutOEF, false, 0, true);
			removeEventListener(Event.ENTER_FRAME, autoAlphaInOEF);
		}
		
		private var _alphaFadeSpeed:Number = 0.3;

		private function autoAlphaInOEF(event:Event):void
		{
			alpha += (1.0 - alpha) * _alphaFadeSpeed;
			visible = alpha > 0;

			if (alpha > 0.98)
			{
				alpha = 1.0;
				removeEventListener(event.type, arguments.callee);
			}
		}		

		private function autoAlphaOutOEF(event:Event):void
		{
			alpha += (0.0 - alpha) * _alphaFadeSpeed;

			if (alpha < 0.01)
			{
				removeEventListener(event.type, arguments.callee);
				removeEventListener(Event.ENTER_FRAME, refresh);
				visible = false;
			}
		}
		
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////////////////////
		// PROTOTYPES /////////////////////////////////////////////////////////////////////////

	}
	// END OF CLASS ///////////////////////////////////////////////////////////////////////////
}