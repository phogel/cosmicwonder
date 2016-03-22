package de.codekommando.cosmicwonder.views.editor
{
	
	
	import com.cache.util.ImageEdit;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.views.CosmicTextWrapper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	public class CosmicPreviews2 extends MovieClip
	{
		
		private var model:WonderModel;
		
		private var views:Sprite = new Sprite();
		private var sensitiveBackground:Sprite = new Sprite();
		private var viewArray:Array = [];
		
		public function CosmicPreviews2()
		{
			TweenPlugin.activate([TransformMatrixPlugin]);
			model = WonderModel.getInstance();
			
			addChild(views);
			views.mouseEnabled = views.mouseChildren = false;
			addChild(sensitiveBackground);
			sensitiveBackground.mouseChildren = false;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			super();
		}
		private function init(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var thmb:GalaxyThumb;
			for(var i:int = 0; i < model.galaxyFiles.length; i++){
				thmb = new GalaxyThumb(ImageEdit.getResizedBitmapData( model.galaxyFiles[i], model.thumbWidth*1.5, model.thumbWidth*1.5, "ImageEdit.resizeCrop", false), model.galaxyTitles[i], i);
				//addThumb(model.galaxyFiles[i], model.galaxyTitles[i]);
				views.addChild(thmb);
				viewArray.push(thmb);
				thmb.scaleX = thmb.scaleY = .35;
				thmb.rotation = 10;
				thmb.cacheAsBitmap = true;
			}
			views.y = (100 * model.globalScale);
			views.x = (20 * model.globalScale);
			slideTo(0, false);
			sensitiveBackground.addEventListener(MouseEvent.MOUSE_MOVE, followMouse);
			sensitiveBackground.addEventListener(MouseEvent.MOUSE_OUT, touchOut);
			sensitiveBackground.addEventListener(MouseEvent.MOUSE_UP, touchOut);
			stageResize();
		}
		
		
		private function waitAndChoose( id:int ):void {
			TweenLite.delayedCall(0.3, galaxySelected, [id]);
		}
		private function galaxySelected( id:int ):void{
			model.currentGalaxy = id;
		}
		
		private var currentActive:int = 0;
		protected function followMouse(e:MouseEvent):void {
			if(!model.switchingGalaxy){
				currentActive = Math.floor((sensitiveBackground.mouseX / model.stageWidth) * model.galaxyFiles.length);
				if(currentActive != model.currentGalaxy){
					slideTo(currentActive);
				}
			}
		}
		
		protected function touchOut(e:MouseEvent):void {
			slideTo(currentActive, false);
		}
		
		protected function slideTo( itmid:int, mousePressed:Boolean = true ):void{
			var tgt:GalaxyThumb = viewArray[itmid];
			var traverse:Number = 0.5;
			TweenLite.killDelayedCallsTo(galaxySelected);

			var yoffset:Number = mousePressed ? -10 : 0;
			
			var scaleScale:Number = model.orientation == "landscape" ? 1.5 : 1;
			
			for( var i:int = 0; i < viewArray.length; i++){
				switch(true)
				{
					case i==itmid-3:
					case i==itmid+3:
						TweenLite.to(viewArray[i], traverse, {transformMatrix:{scaleX:0.3 * scaleScale, scaleY:0.3 * scaleScale, y:0 }});
						break;
					case i==itmid-2:
					case i==itmid+2:
						TweenLite.to(viewArray[i], traverse, {transformMatrix:{scaleX:0.5, scaleY:0.5, y:yoffset}});
						break;
					case i==itmid-1:
					case i==itmid+1:
						TweenLite.to(viewArray[i], traverse, {transformMatrix:{scaleX:0.75, scaleY:0.75, y:yoffset * 2}});
						break;
					case i==itmid:
						TweenLite.to(tgt, traverse, {transformMatrix:{scaleX:1, scaleY:1, y:yoffset * 3}, onComplete:waitAndChoose, onCompleteParams:[itmid]});
						break;
					default:
						TweenLite.killTweensOf(viewArray[i]);
						viewArray[i].scaleX = viewArray[i].scaleY = 0.3  * scaleScale;
						viewArray[i].y = 0;
						break;
					
				}
			}
			views.setChildIndex(tgt, views.numChildren-1);
		}
		
		
		public function stageResize():void {
			var gfx:Graphics = sensitiveBackground.graphics;
			gfx.clear();
			gfx.beginFill(0x123456, 0);
			gfx.drawRect(0,0,model.stageWidth, model.thumbWidth);
			gfx.endFill();

			var xadd:Number = model.stageWidth / model.galaxyFiles.length;
			for(var i:int = 0; i < viewArray.length; i++){
				viewArray[i].x = i * xadd;
			}
			slideTo(currentActive, false);
		}
		
	}
}
