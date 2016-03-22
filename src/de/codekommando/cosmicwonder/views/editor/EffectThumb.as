package de.codekommando.cosmicwonder.views.editor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	
	public class EffectThumb extends Sprite
	{

		public var id:int = 0;
		private var _image:Bitmap = new Bitmap();
		
		public function EffectThumb(_effect:String, _id:int)
		{
			id = _id;
			this.blendMode = _effect;
		}
		
		public function set image(b:Bitmap):void
		{
			//trace( 'EffectThumb:image' );
			_image = b;
			_image.pixelSnapping = PixelSnapping.ALWAYS;
			//_image.x = _image.width / -2;
			//_image.y = _image.height / -2;
			addChild(_image);
		}
	}
}