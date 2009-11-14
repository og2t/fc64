/*---------------------------------------------------------------------------------------------

	[AS3] PreloaderHelper beta
	=======================================================================================

	VERSION HISTORY:
	v0.1	Born on 2009/10/1
	v0.2	22/4/2009	Added domain protection
						Added stageResize method for preloader


	USAGE:

		The class will handle self preloading the SWF.
		Needs to be instantiated from the Document Class (config) as example shows:
		
		progressView has to implement IProgressView;
		
		public class SomeMovieConfig extends MovieClip
		{
			// this class has to be exported in frame one, all other classes need to be exported in frames > 1 for correct preloading
			public const MainClass:String = "com.somedomain.MainClass";
			// usually URL(s) where the SWF will be deployed (use null for domain independent)
			private const ALLOWED_DOMAINS:Array = ["somedomain.com"];

			private const progressView:PieChart = new PieChart();
			private var preloaderHelper:PreloaderHelper = new PreloaderHelper(progressView, root.loaderInfo, stage, this, ALLOWED_DOMAINS);

			public function SomeMovieConfig()
			{
				stop();

				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				stage.showDefaultContextMenu = false;
				stage.frameRate = 30;

				// add preloader
				addChild(progressView);
				progressView.stageResize();

				// set flashvars here to test (works only in IDE)
				if (Capabilities.playerType == "External")
				{
					//preloaderHelper.setFlashVar("debug", true);
					//preloaderHelper.setFlashVar("navAutoHide", true);
				}
			}
		}	
			

	TODOs:

	DEV IDEAS:

	KNOWN ISSUES:

---------------------------------------------------------------------------------------------*/

package net.blog2t.loading
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import net.blog2t.progress.IProgressView;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
    import flash.display.DisplayObject;

	import net.blog2t.util.DomainProtection;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class PreloaderHelper extends Sprite
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		private var isFirstCheck:Boolean = false;
		private var stageCheckCount:int = 0;

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		private var progressView:IProgressView;
				
		private var loaderInfoObject:Object;
		private var stageRef:Stage;
		private var timeline:Object;
		private var flashvars:Object = {};
				
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function PreloaderHelper(progressView:IProgressView, loaderInfoObject:Object, stageRef:Stage, timeline:Object, domains:Array = null)
		{
			this.progressView = progressView;
			this.loaderInfoObject = loaderInfoObject;
			this.stageRef = stageRef;
			this.timeline = timeline;
			
			if (domains)
			{
				DomainProtection.addAllowedDomains(domains);
				
				if (DomainProtection.isStolenSWF(loaderInfoObject))
				{
					trace("Sorry but this SWF is stolen. Your theft activity has been reported.");
					return;
				}
			}

			checkStageDimensions();
		}
				
		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////

		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////

		/**
		 *	Prevent FF3 bug when stage size dimensions are not defined straight after movie init
		 */
		private function checkStageDimensions():void
		{
			if (!stageRef.stageWidth || !stageRef.stageHeight)
			{
				if (stageCheckCount < 10) setTimeout(checkStageDimensions, 100);
				stageCheckCount ++;	
			} else {
				addProgressCheck();
			}
		}

		private function initMainClass():void
		{
			var mainClass:Class = Class(getDefinitionByName(timeline.MainClass));

			// apply flash vars
			var derivedFlashVars:Object = LoaderInfo(loaderInfoObject).parameters;
			for (var flashVar:Object in derivedFlashVars)
			{
				trace(flashVar + ":", derivedFlashVars[flashVar], "[" + typeof derivedFlashVars[flashVar] + "]");
				flashvars[flashVar] = derivedFlashVars[flashVar];
			}
				
			var mainClassInstance:Object = new mainClass(flashvars);
			timeline.addChildAt(mainClassInstance as DisplayObject, 0);
		}

		private function startMain():void
		{
			timeline.nextFrame();
			initMainClass();
		}

		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////

		private function addProgressCheck():void
		{
			addEventListener(Event.ENTER_FRAME, monitorProgress);
			stageRef.addEventListener(Event.RESIZE, progressView.stageResize, false, 0, true);
			progressView.stageResize();
		}

		private function removeProgressCheck():void
		{
			removeEventListener(Event.ENTER_FRAME, monitorProgress);
			stageRef.removeEventListener(Event.RESIZE, progressView.stageResize);
		}

		private function monitorProgress(event:Event):void
		{
			if (loadedBytes > 0 && loadingProgress != false)
			{
				if (loadingProgress == 1 && !isFirstCheck)
				{
					// SWF is cached locally
					removeProgressCheck();
					startMain();
				} else { 
				
					// SWF not cached so show PreloaderHelper
					if (!isFirstCheck) progressView.start();
				
					if (loadedFrames < framesTotal)
					{
						// preloading in progress, update progress percent
						progressView.updateProgress(loadingProgress);
			
					} else {
						// preloading has finished
						progressView.updateProgress(1);
						progressView.finished();
						removeProgressCheck();
						
						setTimeout(startMain, 500);
					}
				}
				
				isFirstCheck = true;
			}	
		}

		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		
		private function get loadingProgress():Number
		{
			return loadedBytes / totalBytes;
		}
		
		private function get loadedBytes():Number
		{
			return loaderInfoObject.bytesLoaded;
		}
		
		private function get totalBytes():Number
		{
			return loaderInfoObject.bytesTotal;
		}
		
		private function get loadedFrames():Number
		{
			return timeline.framesLoaded;
		}
		
		private function get framesTotal():Number
		{
			return timeline.totalFrames;
		}
		
		// HELPERS ////////////////////////////////////////////////////////////////////////////
		
		public function setFlashVar(key:String, value:*):void
		{
			flashvars[key] = value;
		}
		
		// PROTOTYPES /////////////////////////////////////////////////////////////////////////

	}
	// END OF CLASS ///////////////////////////////////////////////////////////////////////////
}
