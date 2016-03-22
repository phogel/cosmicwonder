package de.codekommando.cosmicwonder.views
{
	
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class CustomButton extends ButtonWrapper
	{
		
		private var bg:Sprite = new Sprite();
		public function CustomButton(txt:String)
		{
			super(txt);
			addChildAt(bg,0);
			bgcolor(0x000000);
			mouseChildren = false;
		}
		
		public function bgcolor(c:uint, a:Number = 0):void {
			var gfx:Graphics = bg.graphics;
			gfx.clear();
			gfx.beginFill(c, a);
			gfx.drawRect(-20,-20,btn.txt.textWidth+50, btn.txt.textHeight+50);
			gfx.endFill();
		}
	}
}