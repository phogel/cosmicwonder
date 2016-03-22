package de.codekommando.cosmicwonder.views.gallery
{
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.views.CosmicTextWrapper;
	
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ShareButton extends Sprite
	{
		private var model:WonderModel = WonderModel.getInstance();
		
		private var bg:Sprite = new Sprite;
		private var tf:CosmicTextWrapper;
		
		public function ShareButton(tx:String)
		{
			super();
			var gfx:Graphics = bg.graphics;
			gfx.beginFill(0x000000, 0.7);
			gfx.drawRect(0,0,100,100);
			gfx.endFill();
			bg.cacheAsBitmap = true;
			
			addChild(bg);
			
			tf = new CosmicTextWrapper(tx);
			tf.scaleX = tf.scaleY = (0.5 * model.globalScale);
			tf.color = 0xcccccc;
			addChild(tf);
			tf.x = model.galleryThumbWidth + model.space;
			tf.y = (model.galleryThumbWidth - tf.height ) / 2;
			mouseChildren = false;
			
			
			addEventListener(MouseEvent.MOUSE_OVER, hilite, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, delite, false, 0, true);
			
			stageResize();
		}
		
		private function hilite(e:MouseEvent):void {
			tf.color = 0xffffff;
		}
		private function delite(e:MouseEvent):void {
			tf.color = 0xaaaaaa;
		}
		
		public function stageResize():void {
			bg.width = model.stageWidth;
			bg.height = model.galleryThumbWidth;
		}
	}
}