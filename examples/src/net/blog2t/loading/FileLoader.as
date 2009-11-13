/*---------------------------------------------------------------------------------------------

	[AS3] FileLoader
	=======================================================================================

	VERSION HISTORY:
	v0.1	Born on 2008/8/14

	USAGE:

	TODOs:

	DEV IDEAS:

	KNOWN ISSUES:

---------------------------------------------------------------------------------------------*/

package net.blog2t.loading
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.events.HTTPStatusEvent;

	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class FileLoader extends EventDispatcher
	{
		// MEMBERS ////////////////////////////////////////////////////////////////////////////

		public static const ERROR:String = "loadError";
		
		private var loader:URLLoader = new URLLoader();
		private var httpHeader:URLRequestHeader = new URLRequestHeader("pragma", "no-cache");
		private var callback:Function;

		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////

		public function FileLoader():void
		{
		}

		public function load(filePath:String, callback:Function, noCache:Boolean = false):void
		{
			this.callback = callback;
			
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, onFileLoaded);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);

			var httpRequest:URLRequest = new URLRequest(filePath);
			
			if (noCache)
			{
				httpRequest.requestHeaders.push(httpHeader);
				httpRequest.method = URLRequestMethod.GET;
				httpRequest.data = new URLVariables("noCache=" + Number(new Date().getTime()));
			}
			
			loader.load(httpRequest);
		}
		
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		
		private function onFileLoaded(event:Event):void
		{
			callback(event.target.data);
		}
		
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("___ LOADING ERROR ___: " + event.text);
			dispatchEvent(new Event(FileLoader.ERROR));
		}
		
		private function onHTTPStatus(event:HTTPStatusEvent):void
		{
			trace("___ HTTP STATUS ___: " + event);
		}
		
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		
		// HELPERS ////////////////////////////////////////////////////////////////////////////
		// PROTOTYPES /////////////////////////////////////////////////////////////////////////

	}
	// END OF CLASS ///////////////////////////////////////////////////////////////////////////
}