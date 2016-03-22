package de.codekommando.cosmicwonder.views.editor2
{
	
	import de.codekommando.cosmicwonder.views.ResponsiveBitmapButton;
	
	public class GalaxyThumb extends ResponsiveBitmapButton
	{
		public var id:int = 0;
		public var image:GalaxyImage;
		
		public function GalaxyThumb(i:GalaxyImage, _id:int)
		{
			super();
			id = _id;
			image = i;
			addChild(image);
			mouseChildren = false;
		}
	}
}