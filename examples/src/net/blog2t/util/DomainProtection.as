/*---------------------------------------------------------------------------------------------

	[AS3] DomainProtection
	=======================================================================================

 	Idea from Boy Carper - Toybot Interactive
	(http://www.toybot.nl/blog/2008/04/07/simple-way-to-protect-your-swf-from-being-ripped/)

	VERSION HISTORY:
	v0.1	Born on 22/04/2009
	v0.2	24/4/2009	Fixed

	USAGE:

		DomainProtection.addAlowedDomain("wondermummy.co.uk");
		// or DomainProtection.addAlowedDomains(["wondermummy.co.uk", "wondermummy.com"]);

		if (DomainProtection.isStolenSWF(root.loaderInfo))
		{
			trace("This SWF is stolen. Your theft activity has been reported. Or something like that.");
		}

	TODOs:

	DEV IDEAS:

		- make allowed domains list embedable as binary data, so it's not easily accesible to decompilers 

	KNOWN ISSUES:

---------------------------------------------------------------------------------------------*/

package net.blog2t.util
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class DomainProtection
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////
		
		// MEMBERS ////////////////////////////////////////////////////////////////////////////
	
		private static var allowedDomains:Array = ["localhost", "127.0.0.1", "file://"];
	
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////

		public static function isStolenSWF(loaderInfoObject:Object):Boolean 
		{
			for(var i:int = 0; i < allowedDomains.length; i++)
			{
				if (String(loaderInfoObject.url).indexOf(allowedDomains[i]) != -1) return false;
			}
			
			return true;
		}

		public static function addAllowedDomains(domains:Array):void
		{
			allowedDomains = allowedDomains.concat(domains);
		}
		
		public static function addAlowedDomain(domain:String):void 
		{
			allowedDomains.push(domain);
		}
		
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}