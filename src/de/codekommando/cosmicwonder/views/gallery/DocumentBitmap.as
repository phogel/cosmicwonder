package de.codekommando.cosmicwonder.views.gallery
{
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class DocumentBitmap extends Bitmap
	{
		
		private var controller:WonderController = WonderController.getInstance();
		private var model:WonderModel = WonderModel.getInstance();
		private var loader:Loader;
		
		public function DocumentBitmap(imgData:Array, bitmapData:BitmapData=null, pixelSnapping:String="always", smoothing:Boolean=false)
		{
			loader = controller.loaderFromDocuments(imgData[0]);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);     
			
			bitmapData = new BitmapData(imgData[1], imgData[2], false, 0x000000);
			super(bitmapData, pixelSnapping, smoothing);
		}
		protected function imgLoaded(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded, false);     
			this.bitmapData = Bitmap(loader.content).bitmapData;
		}
	}
}