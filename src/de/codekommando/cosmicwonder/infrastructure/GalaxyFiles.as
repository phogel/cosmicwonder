package de.codekommando.cosmicwonder.infrastructure
{
	
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.views.editor2.GalaxyImage;
	import de.codekommando.cosmicwonder.views.editor2.GalaxyThumb;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	
	public class GalaxyFiles
	{
		
		private static var _count:int = 24;

		public static function get count():int
		{
			return _count;
		}

		public static function set count(value:int):void
		{
			_count = value;
		}

		
		private static var galaxies:Dictionary = new Dictionary;
		private static var thumbs:Dictionary = new Dictionary;
		
		public static function getGalaxy(id:int):GalaxyImage
		{
			if(!galaxies[id]){
				galaxies[id] = loadAsset( id.toString(), WonderModel.getInstance().galaxyDims );
			}
			return galaxies[id];
		}
		
		public static function getGalaxyThumb(id:int):GalaxyThumb
		{
			if(!thumbs[id]){
				thumbs[id] = new GalaxyThumb(
					loadAsset("thumbs/"+id.toString(), WonderModel.getInstance().thumbWidth),
					id
				);
			}
			return thumbs[id];
		}
		
		
		private static function loadAsset(src:String, dim:int):GalaxyImage
		{
			var gi:GalaxyImage = new GalaxyImage("bitmaps/galaxies/" + src + ".jpg", dim, dim );
			return gi;
		}
		
		
	}
}