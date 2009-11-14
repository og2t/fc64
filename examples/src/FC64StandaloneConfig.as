/*---------------------------------------------------------------------------------------------

	[AS3] FC64StandaloneConfig and preloader
	=======================================================================================

	VERSION HISTORY:
	v0.1	Born on 1/10/2009 as a result of long term preloading experiments in AS3

	USAGE:

	TODOs:

	DEV IDEAS:

	KNOWN ISSUES:

---------------------------------------------------------------------------------------------*/

package
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display.StageQuality;
	import flash.system.Capabilities;

	import net.blog2t.progress.views.BarsC64;
	import net.blog2t.progress.IProgressView;
	import net.blog2t.loading.PreloaderHelper;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	public class FC64StandaloneConfig extends MovieClip
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////

		public const MainClass:String = "FC64Standalone";
		public static const progressView:BarsC64 = new BarsC64();

		// MEMBERS ////////////////////////////////////////////////////////////////////////////

		private var preloaderHelper:PreloaderHelper = new PreloaderHelper(progressView, root.loaderInfo, stage, this);
				
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function FC64StandaloneConfig()
		{
			stop();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.MEDIUM;
			//stage.showDefaultContextMenu = false;
			stage.frameRate = 60;

			// add and center preloader
			addChild(progressView);
			progressView.stageResize();
			
			// set flashvars here to test (works only in IDE)
			if (Capabilities.playerType == "External")
			{
				preloaderHelper.setFlashVar("prgURL", "http://intros.c64.org/inc_download.php?iid=283");
			}
		}
	}
}