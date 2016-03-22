package de.codekommando.cosmicwonder.views.editor2
{
	
	import com.cache.util.ImageEdit;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.GalaxyFiles;
	import de.codekommando.cosmicwonder.views.CosmicTextWrapper;
	import de.codekommando.cosmicwonder.views.editor2.GalaxyThumb;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	public class GalaxyPreviews extends PreviewScroller
	{
		
		public function GalaxyPreviews()
		{
			
			viewArray = new Array;
			super();
		}
		override protected function init(e:Event):void{
			
			var thmb:GalaxyThumb;
			for(var i:int = 0; i < GalaxyFiles.count; i++){
				thmb = GalaxyFiles.getGalaxyThumb(i);
				views.addChild(thmb);
				viewArray.push(thmb);
				thmb.y = (thmb.height + model.space ) * (i);
				thmb.addEventListener(MouseEvent.MOUSE_UP, touchOut);
				thmb.cacheAsBitmap = true;
			}
			
			super.init(e);
		}
		
		
		override protected function touchOut(e:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, followMouse);
			if(originMouseY - 20 < stage.mouseY && originMouseY + 20 > stage.mouseY)
			{
				if(e.currentTarget != bg){
					galaxySelected(GalaxyThumb(e.currentTarget).id);
				}
			}
			super.touchOut(e);
		}
		
		private function galaxySelected( id:int ):void{
			model.currentGalaxy = id;
		}
		
		override public function get width():Number
		{
			return model.thumbWidth;
		}
		
		
		override protected function stageResize(e:Event = null):void {
			shadow.x = this.width - shadow.width;
			super.stageResize();
		}
		
	}
}
