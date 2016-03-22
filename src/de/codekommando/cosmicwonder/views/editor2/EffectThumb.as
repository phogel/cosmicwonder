package de.codekommando.cosmicwonder.views.editor2
{
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.views.ResponsiveBitmapButton;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	
	public class EffectThumb extends ResponsiveBitmapButton
	{
		
		public var id:int = 0;
		private var _image:Bitmap = new Bitmap();
		
		[Embed(source='/bitmaps/cwlogo.jpg')]
		private var logobmp:Class;
		
		private var logo:Bitmap;
		
		private var effect:String;
		
		public function EffectThumb(_effect:String, _id:int)
		{
			
			logo = new logobmp();
			logo.height = logo.width = WonderModel.getInstance().thumbWidth;
			addChild(logo);
			
			effect = _effect;
			
			id = _id;
		}
		
		public function set image(b:Bitmap):void
		{
			if(logo){
				logo.bitmapData.dispose();
			}
			logo = new logobmp();
			logo.height = logo.width = WonderModel.getInstance().thumbWidth;
			addChild(logo);
			
			if(downstate){
				downstate.bitmapData.dispose();
				downstate = null;
			}
			if(upstate){
				upstate.bitmapData.dispose();
				upstate = null;
			}
			
			if(_image && _image.stage){
				removeChild(_image);
				_image.bitmapData.dispose();
				_image = null;
			}
			//trace( 'EffectThumb:image' );
			_image = b;
			_image.pixelSnapping = PixelSnapping.ALWAYS;
			//_image.x = _image.width / -2;
			//_image.y = _image.height / -2;
			_image.blendMode = effect;
			addChild(_image);
		}
	}
}