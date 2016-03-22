package de.codekommando.cosmicwonder.views
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class CosmicTextWrapper extends Sprite
	{
		private var tf:CosmicText = new CosmicText();
		private var _align:String = "left";
		private var textFormat:TextFormat = new TextFormat();
		public function CosmicTextWrapper(t:String){
			ColorShortcuts.init();
			super();
			color = 0xffffff;
			tf.txt.autoSize = "left";
			letterSpacing = -4;
			text = t;
			tf.txt.cacheAsBitmap = true;
			addChild(tf);
			cacheAsBitmap = true;
		}
		
		public function set text(s:String):void {
			tf.txt.text = s;
		}
		public function get text():String {
			return tf.txt.text;
		}
		public function set color(c:uint):void {
			tf.txt.textColor = c;
		}
		public function set align(a:String):void {
			tf.txt.autoSize = a;
		}
		public function set letterSpacing(v:Number):void {
			textFormat.letterSpacing = v;
			tf.txt.setTextFormat(textFormat);
		}
	}
}