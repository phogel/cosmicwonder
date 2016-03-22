package de.codekommando.cosmicwonder.views.editor2
{
	import de.codekommando.cosmicwonder.infrastructure.GalaxyFiles;
	import de.codekommando.cosmicwonder.views.editor2.EffectThumb;
	import de.codekommando.cosmicwonder.views.parts.Shadow;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class EffectPreviews extends PreviewScroller
	{
		
		public function EffectPreviews()
		{
			viewArray = new Array;
			
			super();
			
			shadow.scaleX = -1;
			shadow.x = shadow.width;
		}
		
		override protected function init(e:Event):void
		{
			trace('EffectPreviews:init');
			model.addEventListener('galaxyChange', rebuildEffectPreview);
			
			var et:EffectThumb;
			for ( var i:int = 0; i < model.fx.length; i++ )
			{
				et = new EffectThumb( model.fx[i], i );
				views.addChild( et );
				viewArray.push( et );
				et.addEventListener(MouseEvent.MOUSE_UP, touchOut);
				et.y = (et.height + model.space) * i;
			}
			
			rebuildEffectPreview();
			
			super.init(e);
			
		}
		
		
		public function rebuildEffectPreview(e:Event = null):void {
			var resBmp:Bitmap = GalaxyFiles.getGalaxyThumb(model.currentGalaxy).image.bitmap;
			var thumb:EffectThumb;
			
			if(resBmp){
				for ( var i:int = 0; i < viewArray.length; i++ ){
					thumb = viewArray[i];
					thumb.image = new Bitmap( controller.getCopyOf( resBmp ) );
				}
			}
			
		}
		
		override protected function touchOut(e:MouseEvent):void {
			if(originMouseY - 20 < stage.mouseY && originMouseY + 20 > stage.mouseY)
			{
				if(e.currentTarget != bg){
					trace(' select effect ');
					model.currentEffectId = EffectThumb(e.currentTarget).id;
				} else {
					trace('wrong out target');
				}
			} else {
				trace('moved');
			}
			super.touchOut(e);
		}
		
		override public function get width():Number
		{
			return model.thumbWidth;
		}
		
	}
}