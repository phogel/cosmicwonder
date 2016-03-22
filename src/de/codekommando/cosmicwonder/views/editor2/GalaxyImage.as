package de.codekommando.cosmicwonder.views.editor2
{
	import com.cache.util.ImageEdit;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class GalaxyImage extends Sprite
	{
		
		private var bg:Sprite;
		private var loader:Loader;
		public var bitmap:Bitmap;
		
		public var loaded:Boolean = false;
		
		public function GalaxyImage(src:String, wdth:int, hght:int)
		{
			super();
			
			bg = new Sprite;
			bg.graphics.beginFill(0);
			bg.graphics.drawRect(0,0,wdth,hght);
			bg.graphics.endFill();
			addChild(bg);
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, assetLoadComplete);
			loader.load(new URLRequest(src));
		}
		
		private function assetLoadComplete(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, assetLoadComplete);
			var bmp:Bitmap = Bitmap(loader.content);
			bitmap = new Bitmap(
				ImageEdit.getResizedBitmapData( bmp.bitmapData, bg.width, bg.height, "ImageEdit.resizeCrop", true)
			);
			addChild(bitmap);
			loaded = true;
			
			dispatchEvent(e);
			
			bmp = null;
			loader = null;
		}
		
	}
}