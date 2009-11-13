/*---------------------------------------------------------------------------------------------

	[AS3] BitmapDebugger
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

package net.blog2t.display
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.misc.Convert;
	import flash.geom.Matrix;
	import net.blog2t.math.Range;
	import flash.utils.getTimer;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class BitmapDebugger extends Sprite
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		private var _sizeX:int;
		private var _sizeY:int;
		
		private var _scale:int = 1;
		private var _pixelX:Number = 0;
		private var _pixelY:Number = 0;

		private var _outputBmpData:BitmapData;
		
		private var inputBmpData:BitmapData;
		private var matrix:Matrix = new Matrix();
		private var debugBox:MovieClip;
		
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function BitmapDebugger(inputBmpData:BitmapData, sizeX:int = -1, sizeY:int = -1)
		{
			this.inputBmpData = inputBmpData;
			_sizeX = sizeX;
			_sizeY = sizeY;
			
			if (_sizeX == -1) _sizeX = inputBmpData.width;
			if (_sizeY == -1) _sizeY = inputBmpData.height;
			
			_outputBmpData = new BitmapData(_sizeX, _sizeY, false, 0x000000);
		}

		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////
		
		public function draw():void
		{
			matrix.identity();
			matrix.scale(_scale, _scale);
			var offsetX:int = _pixelX * (_scale - (1 - _scale / _sizeX));
			var offsetY:int = _pixelY * (_scale - (1 - _scale / _sizeY));
			matrix.translate(-offsetX, -offsetY);
			
			_outputBmpData.fillRect(_outputBmpData.rect, 0x000000);
			_outputBmpData.draw(inputBmpData, matrix);
			
			var boxScale:Number = _scale / 100;

			if (_scale > 16 && _scale < 20) debugBox = new DebugBoxValue();
			else if (_scale > 20) debugBox = new DebugBoxAddress();

			if (_scale > 16)
			{
				var visibleSquaresX:int = _sizeX / _scale + 2;
				var visibleSquaresY:int = _sizeY / _scale + 2;

				var readX:int = Range.mapInt(_pixelX, 0, _sizeX, 0, _sizeX - _sizeX / _scale + 1);
				var readY:int = Range.mapInt(_pixelY, 0, _sizeY, 0, _sizeY - _sizeY / _scale + 1);

				//var boxMatrix:Matrix = new Matrix();
				//FIXME	optimize this shit
				// draw / colorize also background when scale > 16
				
				//have MCs in assets.swf
				//create separate class with mouse activation
				
				var bitmapRealWidth:int = _sizeX * _scale;
				var bitmapRealHeight:int = _sizeY * _scale;
				var squaresX:int = (-bitmapRealWidth - offsetX) % _scale;
				var squaresY:int = (-bitmapRealHeight - offsetY) % _scale;

				var time:Number = getTimer();

				for (var y:int = 0; y < visibleSquaresY; y++)
				{
					for (var x:int = 0; x < visibleSquaresX; x++)
					{
						matrix.identity();
						matrix.scale(boxScale, boxScale);
						matrix.translate(squaresX + x * _scale, squaresY + y * _scale);
						if (debugBox.addressTF) debugBox.addressTF.text = Convert.toHex((readY + y) * 0x100 + readX + x, 4);
						debugBox.valueTF.text = Convert.toHex(inputBmpData.getPixel(readX + x, readY + y) & 0xff, 2);
						_outputBmpData.draw(debugBox, matrix, null, "difference");
					}
				}
				
				trace(getTimer() - time, "ms");
			}
		}
		
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
				
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		
		public function get outputBmpData():BitmapData
		{
			return _outputBmpData;
		}

		public function get pixelX():Number
		{
			return _pixelX;
		}
		
		public function set pixelX(value:Number):void
		{
			_pixelX = Math.min(Math.max(0, value), _sizeX - 1);
		}
		
		public function get pixelY():Number
		{
			return _pixelY;
		}

		public function set pixelY(value:Number):void
		{
			_pixelY = Math.min(Math.max(0, value), _sizeY - 1);
		}
		
		public function get scale():int
		{
			return _scale;
		}
		
		public function set scale(value:int):void
		{
			if (value < 1 || value > 255) return;
			_scale = value;
		}

		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}