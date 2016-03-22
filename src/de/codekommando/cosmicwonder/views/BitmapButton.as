package de.codekommando.cosmicwonder.views
{
	public class BitmapButton extends ResponsiveButton
	{
		
		protected var image:BitmapLoader;
		public function BitmapButton(src:String)
		{
			super();
			image = new BitmapLoader(src, onc);
		}
		protected function onc():void {
			addChild(image);
		}
	}
}