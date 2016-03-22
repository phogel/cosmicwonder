package de.codekommando.cosmicwonder.views.editor
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import de.codekommando.cosmicwonder.WonderModel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	
	public class GalaxyThumb extends Sprite
	{
		public var title:String = "";
		public var id:int = 0;
		public var image:Bitmap;
		
		public function GalaxyThumb(b:BitmapData, _title:String, _id:int)
		{
			FilterShortcuts.init();
			title = _title;
			id = _id;
			image = new Bitmap(b);
			image.pixelSnapping = PixelSnapping.ALWAYS;
			addChild(image);
			image.x = image.width/-2;
			image.y = image.height/-1.3;
			
			Tweener.addTween(this, {_DropShadow_blurX:20, _DropShadow_blurY:20});
		}
	}
}