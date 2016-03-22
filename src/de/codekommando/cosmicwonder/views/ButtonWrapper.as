package de.codekommando.cosmicwonder.views
{
	
	import flash.display.BlendMode;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ButtonWrapper extends ResponsiveButton
	{
		
		protected var btn:SkinnedButton;
		public function ButtonWrapper(txt:String) {
			
			btn = new SkinnedButton()
			
			btn.txt.autoSize = TextFieldAutoSize.LEFT;
			//btn.txt2.autoSize = TextFieldAutoSize.LEFT;
			btn.txt.text = txt.toUpperCase();
			//btn.txt2.text = txt.toUpperCase();
			btn.txt.y += 3;
			//btn.txt2.y += 3;
			btn.txt.defaultTextFormat = format();
			//btn.txt2.defaultTextFormat = format();
			btn.txt.setTextFormat(format());
			//btn.txt2.setTextFormat(format());
			//btn.background.width = btn.txt.textWidth + (btn.txt.x * 2);
			
			addChild(btn);
			cacheAsBitmap = true;
			//setInterval(changeBlend, 2000);
			super();
			blendmOdes = [
				BlendMode.ADD,
				BlendMode.ALPHA,
				BlendMode.DARKEN,
				BlendMode.DIFFERENCE,
				BlendMode.ERASE,
				BlendMode.HARDLIGHT,
				BlendMode.INVERT,
				BlendMode.LIGHTEN,
				BlendMode.MULTIPLY,
				BlendMode.OVERLAY,
				BlendMode.SCREEN,
				BlendMode.SUBTRACT
			];
			
			this.blendMode = BlendMode.ADD;
		}
		private var blendmOdes:Array;
		private var curblend:int = -1;
		private function changeBlend():void
		{
			curblend++;
			if(curblend >= blendmOdes.length) curblend = 0;
			this.blendMode = blendmOdes[curblend];
			trace('blendMode changed to ' + this.blendMode);
		}
		
		
		
		protected function format():TextFormat {
			var tf:TextFormat = new TextFormat();
			tf.letterSpacing = -3;
			//tf.font = WonderModel.getInstance().font;
			return tf;
		}
		
		override public function set width(nr:Number):void {
		//	btn.background.width = nr;
			btn.txt.width = nr - 20;
			//btn.txt2.width = nr - 20;
		}
		public function set color(c:uint):void {
			btn.txt.textColor = c;
		}
		
	}
}