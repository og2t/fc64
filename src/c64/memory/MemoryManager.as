/*---------------------------------------------------------------------------------------------

	[AS3] MemoryManager
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

package c64.memory
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import core.memory.IMemoryManager;
	import c64.memory.MemoryManagerBase;
	import flash.display.BitmapData;
	
	import flash.filters.ColorMatrixFilter;
	
	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class MemoryManager extends MemoryManagerBase implements IMemoryManager, IEventDispatcher
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		public static const MEMBANK_KERNAL:int = 5; // "kernal";
		public static const MEMBANK_BASIC:int = 6; // "basic";
		public static const MEMBANK_CHARACTER:int = 7; // "character";

		// MEMBERS ////////////////////////////////////////////////////////////////////////////
		
		private var _cellValuesBmpData:BitmapData = new BitmapData(256, 256, false, 0x000000);
		private var _readCellsBmpData:BitmapData = new BitmapData(256, 256, false, 0x000000);
		private var _writtenCellsBmpData:BitmapData = new BitmapData(256, 256, false, 0x000000);
		
		private var decayFilter:ColorMatrixFilter = new ColorMatrixFilter([
			1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, 0.95, 0
		]);
		
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
	
		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////

		override public function write(address:uint, value:int):void
		{
			super.write(address, value);
			
			var row:int = address >> 8;
			var col:int = address & 0xff;
			
			_cellValuesBmpData.setPixel(col, row, value << 16 | value << 8 | value);
			_writtenCellsBmpData.setPixel(col, row, 0xFF0000);
		}
		
		override public function read(address:uint):int
		{
			_readCellsBmpData.setPixel(address & 0xff, address >> 8, 0x00FF00);
			return super.read(address);
		}
		
		public function decayReadCells():void
		{
			_readCellsBmpData.applyFilter(_readCellsBmpData, _readCellsBmpData.rect, _readCellsBmpData.rect.topLeft, decayFilter);
			//_readCellsBmpData.fillRect(_readCellsBmpData.rect, 0x000000)
		}

		public function decayWrittenCells():void
		{
			_writtenCellsBmpData.applyFilter(_writtenCellsBmpData, _writtenCellsBmpData.rect, _writtenCellsBmpData.rect.topLeft, decayFilter);
			//_writtenCellsBmpData.fillRect(_writtenCellsBmpData.rect, 0x000000);
		}
		
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////

		public function get cellValuesBmpData():BitmapData
		{
			return _cellValuesBmpData;
		}
		
		public function get readCellsBmpData():BitmapData
		{
			return _readCellsBmpData;
		}
		
		public function get writtenCellsBmpData():BitmapData
		{
			return _writtenCellsBmpData;
		}
		
		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}