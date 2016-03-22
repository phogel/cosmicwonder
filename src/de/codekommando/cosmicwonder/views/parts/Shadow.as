package de.codekommando.cosmicwonder.views.parts
{
	import de.codekommando.cosmicwonder.Assets;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Shadow extends Sprite
	{
		
		private var shadow:Bitmap;
		
		public function Shadow()
		{
			super();
			shadow = new Assets["shadow"];
			addChild(shadow);
			this.mouseChildren = this.mouseEnabled = false;
		}
		override public function set height(value:Number):void
		{
			shadow.height = value;
		}
		override public function get height():Number
		{
			return shadow.height;
		}
	}
}