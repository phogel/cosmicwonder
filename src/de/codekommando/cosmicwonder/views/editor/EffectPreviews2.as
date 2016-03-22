package de.codekommando.cosmicwonder.views.editor
{
	
	import com.cache.util.ImageEdit;
	import com.greensock.TweenLite;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.views.CosmicTextWrapper;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class EffectPreviews2 extends MovieClip
	{
		
		private var model:WonderModel;
		private var controller:WonderController;
		
		private var previewsArray:Array = [];
		private var previews:Sprite = new Sprite();
		private var sensitive:Sprite = new Sprite();
		
		
		public function EffectPreviews2()
		{
			model = WonderModel.getInstance();
			model.addEventListener('galaxyChange', rebuildEffectPreview);
			controller = WonderController.getInstance();
			
			var et:EffectThumb;
			for ( var i:int = 0; i < model.fx.length; i++ )
			{
				et = new EffectThumb( model.fx[i], i );
				et.y = (model.thumbWidth / 2) * i;
				et.scaleX = et.scaleY = 0.5;
				previews.addChild( et );
				previewsArray.push(et);
			}
			addChild(previews);
			previews.mouseChildren = false;
			previews.mouseEnabled = false;
			addChild(sensitive);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			sensitive.addEventListener(MouseEvent.MOUSE_MOVE, setEffect);
			sensitive.addEventListener(MouseEvent.MOUSE_OUT, noScale);
			sensitive.addEventListener(MouseEvent.MOUSE_UP, touchUp);
			rebuildEffectPreview();
		}
		
		private function rebuildEffectPreview(e:Event = null):void {
			var resBmp:Bitmap = model.currentGalaxyThumb;
			var thumb:EffectThumb;
			if(resBmp){
				for ( var i:int = 0; i < previewsArray.length; i++ ){
					thumb = previewsArray[i];
					thumb.image = new Bitmap( controller.getCopyOf( resBmp ) );
				}
			}
			sensitive.x = previews.x = previews.width/-2;
			sensitive.y = previews.y = previews.height/-2;
			
			sensitive.graphics.beginFill(0x000000, 0);
			sensitive.graphics.drawRect(model.thumbWidth / -2, model.thumbWidth / -2, model.thumbWidth, previews.height + (model.thumbWidth / 2));
			sensitive.graphics.endFill();
		}
		
		
		private var currentActive:int = 0;
		
		private function noScale(e:MouseEvent = null):void {
			TweenLite.killDelayedCallsTo(doSetEffect);
			rescale(model.currentEffectId);
		}
		private function touchUp(e:MouseEvent):void {
			TweenLite.killDelayedCallsTo(doSetEffect);
			setCurrentActive(sensitive.mouseY);
			doSetEffect();
		}
		private function scaleActive(e:MouseEvent = null):void {
			rescale(model.currentEffectId);
		}
		
		private function setCurrentActive(xp:int):void {
			currentActive = Math.floor(((xp + (model.thumbWidth / 2)) / sensitive.height) * (model.fx.length));
			//(model.orientation=="portrait" ? sensitive.height : sensitive.width)
			//trace(sensitive.width + 'x' + sensitive.height + ' ' + xp);
		}
		
		
		
		private function rescale(tgtid:int):void {
			var thumb:EffectThumb;
			var time:Number = 0.3;
			for ( var i:int = 0; i < previewsArray.length; i++ ){
				thumb = previewsArray[i];
				TweenLite.killTweensOf(thumb);
				switch(true){
					case i==tgtid-2:
					case i==tgtid+2:
						TweenLite.to(thumb, time, {scaleX:0.5, scaleY:0.5});
						break;
					case i==tgtid-1:
					case i==tgtid+1:
						TweenLite.to(thumb, time, {scaleX:0.75, scaleY:0.75});
						break;
					case i==tgtid:
						previews.setChildIndex(thumb, previews.numChildren - 1);
						TweenLite.to(thumb, time, {scaleX:1, scaleY:1});
						break;
					default:
						thumb.scaleX = thumb.scaleY = 0.5;
						break;
				}
				
			}
		}
		
		
		
		private function setEffect(e:MouseEvent):void {
			TweenLite.killDelayedCallsTo(doSetEffect);
			setCurrentActive(sensitive.mouseY);
			
			TweenLite.delayedCall(1, doSetEffect);
			rescale(currentActive);
		}
		private function doSetEffect():void {
			model.currentEffectId = currentActive;
			if(currentActive > model.fx.length - 1){
				model.currentEffectId = currentActive = model.fx.length - 1;
			}
			scaleActive();
		}
		
		
		public function set visibleContents(v:Boolean):void {
			previews.visible = v;
			sensitive.mouseEnabled = v;
			sensitive.mouseChildren = v;
			sensitive.visible = v;
		}
		public function get visibleContents():Boolean {
			return previews.visible;
		}
		
		
		
		
	}
}