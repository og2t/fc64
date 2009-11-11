package net.blog2t.display.progress
{
	import flash.events.Event;
	
	public interface IProgressView
	{
		function start():void;
		function stop():void;
		function updateProgress(loaded:Number):void;
		function finished(delay:Number = 0.25):void;
		function stageResize(event:Event = null):void;
	}
}