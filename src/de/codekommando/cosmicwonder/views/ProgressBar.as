package de.codekommando.cosmicwonder.views
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class ProgressBar extends Sprite
	{
		
		private var bgBar:Sprite = new Sprite;
		private var topperBar:Sprite = new Sprite;
		private var progressBar:Sprite = new Sprite;
		public function ProgressBar() {
			super();
			var graf:Graphics = bgBar.graphics;
			graf.beginFill(0xffffff);
			graf.drawRoundRect(-4,-4,208,16, 4);
			graf.endFill();
			
			var graf2:Graphics = topperBar.graphics;
			graf2.beginFill(0x000000);
			graf2.drawRoundRect(-2,-2,204,12, 2);
			graf2.endFill();
			
			var graf3:Graphics = progressBar.graphics;
			graf3.beginFill(0xffffff);
			graf3.drawRect(0,0,200,8);
			graf3.endFill();
			
			addChild(bgBar);
			addChild(topperBar);
			addChild(progressBar);
		}
		
		
		public function set percent(n:Number):void {
			progressBar.scaleX = n / 100;
		}
		
	}
}