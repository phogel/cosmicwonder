package de.codekommando.cosmicwonder.views.gallery
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import com.cache.util.ImageEdit;
	import com.greensock.TweenLite;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ThumbnailView extends Sprite
	{
		
		private var model:WonderModel = WonderModel.getInstance();
		private var controller:WonderController = WonderController.getInstance();
		
		private var views:MovieClip = new MovieClip;
		private var movey:int = 0;
		private var moveStartY:int = 0;
		private var moveSpeed:Number = 0;
		private var prevMouseY:int = -1;
		private var clickedThumb:MovieClip;
		
		public function ThumbnailView() {
			ColorShortcuts.init();
			views.name = "views";
			addChild(views);
			super();
		}
		
		protected function build():void {
			views.y = 0;
			
			for( var i:int = 0; i < model.generatedGalleryThumbnails.length; i++ ) {
				var bmp:Bitmap = new Bitmap( model.generatedGalleryThumbnails[i] );
				bmp.pixelSnapping = PixelSnapping.ALWAYS;
				var thmb:MovieClip = new MovieClip();
				thmb.addChild(bmp);
				thmb.mouseChildren = false;
				thmb.cacheAsBitmap = true;
				thmb.addEventListener( MouseEvent.MOUSE_DOWN, followMouse );
				thmb.id = i;
				views.addChild(thmb);
			}
			realignThumbs();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function realignThumbs():void {
			var xoff:int = 0;
			var yoff:int = 0;
			var xCount:int = model.orientation == "portrait" ? 3 : 5;
			for (var i:int = 0; i < views.numChildren; i++){
				var thmb:MovieClip = views.getChildAt(i) as MovieClip;
				if(xoff > xCount) {
					xoff = 0;
					yoff++;
				}
				thmb.x = xoff * thmb.width;
				thmb.y = yoff * thmb.width;
				xoff++;
			}
		}
		
		private function followMouse ( e:MouseEvent ):void {
			//trace('followMouse');
			Tweener.removeTweens(views);
			movey = e.stageY;
			moveStartY = views.y;
			if( e.target is MovieClip ) {
				e.target.addEventListener(MouseEvent.MOUSE_UP, mouseUpState);
				e.target.addEventListener(MouseEvent.MOUSE_OUT, mouseUpState);
				Tweener.addTween( e.target, {_brightness:-1} );
			}
			addEventListener( Event.ENTER_FRAME, moveContents );
		}
		private function moveContents(e:Event):void {
			var ny:int = moveStartY - (movey - stage.mouseY);
			views.y = ny;
			moveSpeed = (prevMouseY - stage.mouseY) / model.globalScale;
			prevMouseY = stage.mouseY;
		}
		private function unfollowMouse ( e:MouseEvent):void {
			if( e.stageY - movey < 20 && e.stageY - movey > -20 ) {
				model.gallerySelectedImage = e.target.id;
				model.gallery_state = "detail";
			} else {
				keepAcceleration();
			}
			removeEventListener( Event.ENTER_FRAME, moveContents );
		}
		
		private function keepAcceleration():void {
			//trace('keepAcceleration');
			TweenLite.killTweensOf( views );
			var max:int = 250;
			var addToY:int;
			var ny:int;
			addToY = moveSpeed * max / 100;
			ny = views.y - addToY;
			if(ny < (model.stageHeight - views.height)) {
				ny = model.stageHeight - views.height;
			} else if( ny > 0) {
				ny = 0;
			}
			
			if( views.height < model.stageHeight ) {
				ny = 0;
			}
			TweenLite.to( views, 0.4, {y:ny} );
		}
		
		
		
		
		private function mouseUpState( e:MouseEvent ):void {
			e.target.removeEventListener(MouseEvent.MOUSE_UP, mouseUpState);
			e.target.removeEventListener(MouseEvent.MOUSE_OUT, mouseUpState);
			Tweener.addTween( e.target, {_brightness:0} );
		}
		
		
		
		public function load():void {
			views.addEventListener( MouseEvent.MOUSE_UP, unfollowMouse );
			controller.addEventListener('galleryThumbsLoaded', startBuilding);
			controller.loadGalleryThumbnails();
		}
		protected function startBuilding(e:Event):void {
			controller.removeEventListener('galleryThumbsLoaded', startBuilding);
			trace('thumbs loaded, build')
			build();
		}
		
		public function unload():void {
			Tweener.removeAllTweens();
			unloadThumbs();
			views.removeEventListener( MouseEvent.MOUSE_UP, unfollowMouse );
			controller.removeEventListener("stageResize", stageResize);
		}
		
		private function unloadThumbs():void {
			while(views.numChildren > 0) {
				var obj:MovieClip = views.getChildAt(0) as MovieClip;
				obj.removeEventListener( MouseEvent.MOUSE_DOWN, followMouse );
				views.removeChild(obj);
				obj = null;
			}
		}
		
		
		public function stageResize(e:Event = null):void {
			trace("tghumabaisld view stageResize");
			var gfx:Graphics = views.graphics;
			gfx.beginFill(0x234512, 0);
			gfx.drawRect(0,0,model.stageWidth,model.stageHeight);
			gfx.endFill();
			realignThumbs();
		}
		
	}
}