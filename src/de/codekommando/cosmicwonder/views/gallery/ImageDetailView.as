package de.codekommando.cosmicwonder.views.gallery
{
	
	
	
	import com.adobe.images.PNGEncoder;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GestureEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.ByteArray;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.states.AppState;
	
	import nl.imotion.utils.asyncprocessor.AsyncProcessor;
	
	import utils.PNGFilteredEncoder;
	
	
	public class ImageDetailView extends Sprite
	{
		private var model:WonderModel = WonderModel.getInstance();
		private var controller:WonderController = WonderController.getInstance();
		public var current:int = 0;
		
		private var image1:Bitmap;
		public var image2:Bitmap;
		private var image3:Bitmap;
		private var imageContainer:Sprite = new Sprite();
		
		private var status:StatusScreen = new StatusScreen();
		
		private var leftbound:Boolean = true;
		private var rightbound:Boolean = true;
		
		private var shareBar:ShareBar = new ShareBar();
		
		public function ImageDetailView(){
			super();
			addChild( imageContainer );
			addChild( shareBar );
			addChild( status );
			status.visible = false;
		}
		
		
		// -------------------------
		// loadAfterSwipe
		// -------------------------
		
		
		public function initWith( id:int ):void {
			loadAfterSwipe(id);
		}
		
		private function loadAfterSwipe( id:int ):void {
			while ( imageContainer.numChildren > 0) {
				imageContainer.removeChildAt(0);
			}
			
			for(var i:int = 0; i < model.savedImages.length; i++){
				if(i < current-1 || i > current+1){
					if(null != bitmapCache[i]){
						Bitmap(bitmapCache[i]).bitmapData.dispose();
					}
					bitmapCache[i] = null;
				}
			}
			
			leftbound = true;
			rightbound = true;
			
			current = id;
			
			image1 = giveImage(current-1);		
			image2 = giveImage(current);		
			image3 = giveImage(current+1);		

			if(image1) {
				bitmapCache[current-1] = image1;
				reposition(image1);
				image1.x = getXTargetOf(image1) - model.stageWidth;
				imageContainer.addChild(image1);
				leftbound = false;
			}
			if(image2) {
				bitmapCache[current] = image2;
				reposition(image2);
				image2.x = getXTargetOf(image2);
				imageContainer.addChild(image2);
			}
			if(image3) {
				bitmapCache[current+1] = image3;
				reposition(image3);
				image3.x = getXTargetOf(image3) + model.stageWidth;
				imageContainer.addChild(image3);
				rightbound = false;
			}
			
			System.pauseForGCIfCollectionImminent(0.75);
			enableMouseActions(true);
			trace('-------------------------');
		}
		private function giveImage(_current:int):Bitmap {
			if(bitmapCache[_current]){
				trace('returning bitmap from cache');
				return bitmapCache[_current];
			} else if(_current >= 0 && _current < model.savedImages.length) {
				trace('re-generate bitmap ' + _current)
				var data:Array = model.savedImageById(_current);
				if(data[1] == model.stageWidth || data[2] == model.stageWidth ){
					//var bmdata:BitmapData = controller.bitmapDataFromByteArray( data[0], data[1], data[2] );
					//var bmdata:BitmapData = controller.bitmapDataFromByteArray(controller.byteArrayFromDocuments(data[0]), data[1], data[1]);
					var bp:Bitmap = new DocumentBitmap(data);
					return bp;
				}
			}
			return null;
		}
		
		
		
		
		
		//---------------------------
		// FOLLOWINGS
		//---------------------------
		
		
		
		private var followX:int = 0;
		private var followXStart:int = 0;
		private var followDirection:String = "";
		private var movedback:Boolean = false;
		
		private function startFollow(e:MouseEvent):void {
			if(image1)TweenLite.killTweensOf(image1);
			if(image2)TweenLite.killTweensOf(image2);
			if(image3)TweenLite.killTweensOf(image3);
			
			
			followXStart = mouseX;
			followX = mouseX;
			followDirection = "";
			movedback = false;
			addEventListener(Event.ENTER_FRAME, following);
		}
		private function following(e:Event):void {
			var stepped:int = mouseX - followX;
			followX = mouseX;
			switch(followDirection ) {
				case "left":
					if( stepped > 0) {
						movedback = true;
					}
					break;
				case "":
					if(stepped > 20 || stepped < -20) {
						followDirection = stepped > 0 ? "right" : "left";
					}
					break;
				case "right":
					if( stepped < 0) {
						movedback = true;
					}
					break;
			}
			if(image1)image1.x += stepped;
			if(image2)image2.x += stepped;
			if(image3)image3.x += stepped;
		}
		private function endFollow(e:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, following);
			
			if(followDirection == "") {
				if(e.type != MouseEvent.MOUSE_OUT) {
					var al:Number = shareBar.alpha == 1 ? 0 : 1;
					TweenLite.killTweensOf(shareBar);
					if(al == 1)shareBar.visible = true;
					TweenLite.to(shareBar, 0.4, {alpha:al, onComplete:setShareBarVisibility, onCompleteParams:[al == 1]});
					snapBack();
				}
			} else {
				enableMouseActions(false);
				var img2x:Number = image2.x + getXTargetOf(image2);
				if(!movedback) {
					if( followDirection == "left" ) {
						next();
					} else {
						prev();
					}
				} else {
					// check moved direction from position
					switch ( true ) {
						case img2x < model.stageWidth / -2:
							next();
							break;
						case img2x > model.stageWidth / 2:
							prev();
							break;
						default:
							snapBack();
							break;
					}
				}
				followDirection = "";
			}
		}
		
		private function setShareBarVisibility(v:Boolean):void {
			shareBar.visible = v;
		}
		
		private function snapBack():void {
			
			if(image1)TweenLite.to(image1, 0.3, {x:getXTargetOf(image1) - model.stageWidth});
			if(image2)TweenLite.to(image2, 0.3, {x:getXTargetOf(image2), onComplete:enableMouseActions, onCompleteParams:[true]});
			if(image3)TweenLite.to(image3, 0.3, {x:getXTargetOf(image3) + model.stageWidth});
			
		}
		
		private function getXTargetOf(img:Bitmap):int {
			if(img.width < img.height && model.orientation == "landscape") {
				return Math.round((model.stageWidth - img.width) / 2);
			} else {
				return 0;
			}
		}
		
		private function next( e:MouseEvent = null ):void {
			if(rightbound) {
				snapBack();
			} else {
				imageContainer.setChildIndex( image3, imageContainer.numChildren-1);
				
				TweenLite.to(image3, 0.3, {x:getXTargetOf(image3)});
				TweenLite.to(image2, 0.3, {x:getXTargetOf(image2)-model.stageWidth, onComplete:triggerSwipe, onCompleteParams:[1]});
			}
		}
		private function prev( e:MouseEvent = null ):void {
			if(leftbound) {
				snapBack();
			} else {
				imageContainer.setChildIndex( image1, imageContainer.numChildren-1);
				TweenLite.to(image1, 0.3, {x:getXTargetOf(image1)});
				TweenLite.to(image2, 0.3, {x:getXTargetOf(image2) + model.stageWidth, onComplete:triggerSwipe, onCompleteParams:[-1]});
			}
		}
		private function enableMouseActions(doit:Boolean):void {
			imageContainer.mouseChildren = imageContainer.mouseEnabled = doit;
		}
		
		
		private var bitmapCache:Array = new Array;
		private function triggerSwipe(dir:int):void {
			TweenLite.delayedCall(0.2, loadAfterSwipe, [current+dir]);
		}
		
		
		//-------------------------------
		// initialisation
		//-------------------------------
		
		
		public function load():void {
			imageContainer.addEventListener( MouseEvent.MOUSE_DOWN, startFollow );
			imageContainer.addEventListener( MouseEvent.MOUSE_UP, endFollow );
			imageContainer.addEventListener( MouseEvent.MOUSE_OUT, endFollow );
				
			shareBar.addEventListener(MouseEvent.CLICK, doShare);
			status.addEventListener(MouseEvent.CLICK, doShare);

			controller.addEventListener("stageResize", stageResize);
			stageResize();
		}
		
		public function unload():void {
			controller.removeEventListener("stageResize", stageResize);
			if(hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, following);
			}
			imageContainer.removeEventListener( MouseEvent.MOUSE_DOWN, startFollow );
			imageContainer.removeEventListener( MouseEvent.MOUSE_UP, endFollow );
			imageContainer.removeEventListener( MouseEvent.MOUSE_OUT, endFollow );
			shareBar.removeEventListener(MouseEvent.CLICK, doShare);
			status.removeEventListener(MouseEvent.CLICK, doShare);
			
			while ( imageContainer.numChildren > 0) {
				imageContainer.removeChildAt( 0 );
			}
			image1 = null;
			image2 = null;
			image3 = null;
		}
		
		
		
		// ------------------------------
		// sharing
		// ------------------------------
		
		private function doShare(e:MouseEvent):void {
			switch( e.target.name ) {
				/*case "facebook":
					trace('doShare')
					enableMouseActions(false);
					model.addEventListener('facebookPostComplete', fbShareComplete);
					model.addEventListener('facebookPostFailed', fbShareComplete);
					status.message = Languages.CONVERTING;
					TweenLite.delayedCall(0.2, convertImageAndPost);
					break;*/
				case "reedit":
					controller.initImageEditingWith( new Bitmap( Bitmap(bitmapCache[current]).bitmapData.clone() ) );
					break;
				case "deletebtn":
					status.message = Languages.REALLYDELETE;
					status.showButtons = true;
					break;
				case "okbtn":
					if(controller.deleteImageFromGallery(current)){
						var bmp:Bitmap = bitmapCache[current];
						bmp.bitmapData.dispose();
						bitmapCache.splice(current, 1);
						if(current < 0){
							current = 0;
						} else if(current >= model.savedImages.length) {
							current = model.savedImages.length - 1;
						}
						
						// reset thumbnail list
						model.generatedGalleryThumbnails = [];
						if(model.savedImages.length == 0){
							model.app_state = AppState.HOMEPAGE;
						} else {
							initWith(current);
						}
					}
					status.message = "";
				case "cancelbtn":
					status.message = "";
					break;
				case "cameraroll":
					controller.saveInCameraRoll(this.image2.bitmapData);
					break;
			}
		}
		
		
		private function convertImageAndPost():void {
			var ba:ByteArray = PNGFilteredEncoder.encode(this.image2.bitmapData);
/*			var bounds:Rectangle = new Rectangle(0, 0, this.image2.width / this.image2.scaleX, this.image2.height / this.image2.scaleY);
			trace(' image bounds: ' + bounds)
			var ba:ByteArray = this.image2.bitmapData.getPixels(bounds);*/
			trace(' byte array len ' + ba.length);
			TweenLite.delayedCall(0.5, uploadConvertedImage, [ba]);
		}
		private function uploadConvertedImage(jpeg:ByteArray):void {
			status.message = Languages.UPLOADING;
			TweenLite.delayedCall(0.2, controller.postBytesToFacebook, [jpeg]);
		}
		private function uploadBitmap():void {
			status.message = Languages.UPLOADING;
			TweenLite.delayedCall(0.2, controller.postBitmapToFacebook2, [this.image2] );
		}
		
		private function fbShareComplete(e:Event):void {
			model.removeEventListener('facebookPostComplete', fbShareComplete);
			model.removeEventListener('facebookPostFailed', fbShareComplete);
			enableMouseActions(true);
			status.message = "";
			switch(e.type){
				case 'facebookPostComplete':
					trace('fb post done');
					break;
				case 'facebookPostFailed':
					trace('fb post failed');
					break;
			}
		}
		
		//_--------------------------
		// resize
		//_--------------------------
		
		
		private function stageResize(e:Event= null):void {

			shareBar.y = model.stageHeight - model.thumbWidth;
			shareBar.stageResize();
			status.stageResize();
			
			if(image3){
				TweenLite.killTweensOf(image3);
				reposition(image3);
				image3.x = model.stageWidth;
			}
			if(image2){
				TweenLite.killTweensOf(image2);
				reposition(image2);
				image2.x = Math.round((model.stageWidth - image2.width) / 2);
			}
			if(image1){
				TweenLite.killTweensOf(image1);
				reposition(image1);
				image1.x = -model.stageWidth;
			}
		}
		
		private function reposition(bitmap:Bitmap):void {
			if(model.orientation == "portrait"){
				bitmap.width = model.stageWidth;
				bitmap.scaleY = bitmap.scaleX;
			} else {
				bitmap.height = model.stageHeight;
				bitmap.scaleX = bitmap.scaleY;
			}
			bitmap.y = Math.round((model.stageHeight - bitmap.height)/2);
		}
									   
	}
}