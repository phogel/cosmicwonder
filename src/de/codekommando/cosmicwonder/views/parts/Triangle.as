package de.codekommando.cosmicwonder.views.parts
{
	import flash.display.Shape;
	
	public class Triangle extends Shape
	{
		public function Triangle()
		{
			super();
			graphics.beginFill(0);
			graphics.lineTo(0,50);
			graphics.lineTo(25, 25);
			graphics.lineTo(0,0);
			graphics.endFill();
			this.cacheAsBitmap = true;
		}
	}
}