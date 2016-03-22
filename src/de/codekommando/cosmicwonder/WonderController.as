package de.codekommando.cosmicwonder
{
	import com.cache.util.ImageEdit;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PixelSnapping;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.CameraRollBrowseOptions;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.Timer;
	
	import caurina.transitions.ColorMatrix;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import de.codekommando.cosmicwonder.states.AppState;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.IFD;
	
	import org.bytearray.decoder.JPEGDecoder;
	
	public class WonderController extends EventDispatcher {
		protected var model:WonderModel;

		protected static var _instance:WonderController;
		public static function getInstance():WonderController
		{
			if(!_instance)
			{
				_instance = new WonderController();
			}
			return _instance;
		}
		public static function set instance(value:WonderController):void
		{
			_instance = value;
		}
		
		
		
		// ----------------
		// Constructor
		// ----------------
		
		
		public function WonderController(target:IEventDispatcher=null)
		{
			instance = this;
			FilterShortcuts.init();
			model = WonderModel.getInstance();
			super(target);
			
		}

		
		
		
		
		
		

		
		public function getCopyOf(bd:Bitmap):BitmapData
		{
			//trace('getCopyOf');
			return ImageEdit.getResizedBitmapData( bd.bitmapData, bd.width, bd.height, 'ImageEdit.resizeCrop', false );
		}
		
		
		// -------------------------
		//       G A L L E R Y
		// -------------------------
		
		
		public function deleteImageFromGallery(id:int):Boolean {
			var narray:Array = [];
			var deleted:Boolean = false;
			for (var i:int = 0; i < model.savedImages.length; i++){
				if(id!=i){
					narray.push(model.savedImages[i]);
				} else {
					trace('deleteImageFromGallery:'+id+' complete');
					var f:File = model.docDir.resolvePath(model.savedImages[i][0]);
					f.deleteFile();
					f = null;
					deleted = true;
					
				}
			}
			model.savedImages = narray;
			return deleted;
		}
		
		
		public function byteArrayFromBitmapData(bmd:BitmapData):ByteArray {
			var bounds:Rectangle = new Rectangle(0, 0, model.stageWidth, model.stageHeight);
			var pixels:ByteArray = bmd.getPixels(bounds);
			pixels.compress();
			return pixels;
		}
		public function bitmapDataFromByteArray(b:ByteArray, w:int = 0, h:int = 0):BitmapData {
			
			if(w==0)w=model.stageWidth;
			if(h==0)h=model.stageHeight;
			
			trace('JPG DECODE---------------');
			traceStartTime();
			var decoder:JPEGDecoder = new JPEGDecoder(b);
			var returner:BitmapData = new BitmapData(decoder.width, decoder.height, false, 0x000000);
			traceEndTime();
			returner.setVector ( returner.rect, decoder.pixels );
			return returner;
			
		}
		
		public function loadGalleryThumbnails():void {
			generateNextGalleryThumb();
		}
		
		
		protected function bitmapScaled(do_source:BitmapData, tw:Number, th:Number, original_width:int, original_height:int):BitmapData {
			
			var src_rect:Rectangle = new Rectangle();
			var mat:Matrix = new Matrix();
			src_rect.y = 0;
			src_rect.x = 0;
			if( original_width > original_height ){
				var rotator:Matrix = new Matrix;
				rotator.rotate(90);
				src_rect.width = src_rect.height = original_height;
//				do_source. reset width & height
				do_source.draw(do_source, rotator,  null, null, null, true);
			} else {
				src_rect.width = src_rect.height = original_width;
			}
			trace(src_rect.x + 'x' + src_rect.y, do_source.width + 'x' + do_source.height, src_rect.width + 'x' + src_rect.height, original_width + 'x' + original_height);
			var cropped:BitmapData = new BitmapData(src_rect.width, src_rect.height);
			cropped.copyPixels(do_source, src_rect, new Point(0,0));
			src_rect = null;
			mat.scale(tw/cropped.width, th/cropped.height);
			
			var bmpd_draw:BitmapData = new BitmapData(tw, th, false);
			bmpd_draw.draw(cropped, mat,  null, null, null, true);
			
			cropped.dispose();
			cropped = null;

			return bmpd_draw;
		}

		
		protected function generateNextGalleryThumb():void {
			if(model.savedImages.length > model.generatedGalleryThumbnails.length){
				var img:Array = model.savedImages[model.generatedGalleryThumbnails.length];
				var ldr:Loader = loaderFromDocuments(img[0]);
				ldr.addEventListener(IOErrorEvent.IO_ERROR, thumbLoadFail, false, 0, true);
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbLoaded, false, 0, true);     
			} else {
				dispatchEvent(new Event('galleryThumbsLoaded'));
			}
		}
		protected function thumbLoadFail(e:Error):void {
			trace(e);
		}
		protected function thumbLoaded(e:Event):void {
			var ldr:LoaderInfo = LoaderInfo(e.currentTarget);
			ldr.loader.removeEventListener(IOErrorEvent.IO_ERROR, thumbLoadFail, false);
			ldr.removeEventListener(Event.COMPLETE, thumbLoaded, false);
			var bmd:BitmapData = ImageEdit.getResizedBitmapData(Bitmap(ldr.content).bitmapData, model.galleryThumbWidth, model.galleryThumbWidth, ImageEdit.RESIZE_CROP, true);
			model.generatedGalleryThumbnails.push(bmd);
			TweenLite.delayedCall(0.1, generateNextGalleryThumb);
		}
		
		
		
		
		
		
		protected function fileStreamRead(e:Event):void {
			var fs:FileStream = e.currentTarget as FileStream;
			fs.removeEventListener(Event.COMPLETE, fileStreamRead);
			
		}
		
		public function destroyGalleryThumbnails():void {
			if(model.generatedGalleryThumbnails.length > 0) {
				for ( var i:int = 0; i < model.generatedGalleryThumbnails.length; i++) {
					BitmapData(model.generatedGalleryThumbnails[i]).dispose();
					model.generatedGalleryThumbnails[i] = null;
				}
				model.generatedGalleryThumbnails = new Array();
				System.gc();
			}
		}
		
		
		
		
		
		// -------------------------
		//    S E T T I N G S
		// -------------------------

		public function saveToCameraRoll(b:Boolean):void {
			model.saveInCameraRoll = b;
		}
		public function saveToGallery(b:Boolean):void {
			model.saveInGallery = b;
		}
		
		
		// -------------------------
		//    C A M E R A  R O L L
		// -------------------------
		
		protected var mediaSource:CameraRoll;
		protected var cameraSource:CameraUI;
		protected var imageLoader:Loader; 
		
		public var image:BitmapData;
		
		protected var savePreviewBitmap:Bitmap;
		
		
		public function takePicture():void {
			if( CameraUI.isSupported ) {
				cameraSource = new CameraUI();
				cameraSource.addEventListener( MediaEvent.COMPLETE, imageSelected );
				cameraSource.addEventListener( Event.CANCEL, browseCanceled );
				cameraSource.addEventListener( ErrorEvent.ERROR, mediaError );
				cameraSource.launch( MediaType.IMAGE );
			} else {
				useRandomLocalPicture();
			}
		}
		
		public function loadimage():void
		{
			trace( "Controller::loadimage()" );
			if( CameraRoll.supportsBrowseForImage )
			{
				mediaSource = new CameraRoll();
				var browseOptions:CameraRollBrowseOptions = new CameraRollBrowseOptions();
				browseOptions.origin = new Rectangle(model.stageWidth / 6, model.stageHeight / 6);
				
				mediaSource.addEventListener( MediaEvent.SELECT, imageSelected );
				mediaSource.addEventListener( Event.CANCEL, browseCanceled );
				mediaSource.browseForImage();
			}
			else
			{
				useRandomLocalPicture();
			}
		}
		
		protected function useRandomLocalPicture():void {
			var lclImgs:Array = [
				"IMG_1156.JPG",
				"IMG_1245.JPG",
				"IMG_1689.jpg",
				"IMG_2402.jpg"
			];
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, imageLoaded );
			imageLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, imageLoadFailed );
			imageLoader.load(new URLRequest("bitmaps/"+lclImgs[Math.floor(Math.random()*lclImgs.length)]));
			
			log( "Browsing in camera roll unsupported." );
		}
		
		protected var dataSource:IDataInput;
		protected var exif:ExifInfo;
		protected var imagePromise:MediaPromise;
		protected function imageSelected( event:MediaEvent ):void
		{
			log( "Image selected..." );
			
			imagePromise = event.data;
			imageLoader = new Loader();

			dataSource = imagePromise.open();
			
			if( imagePromise.isAsync )
			{
				
				log( "Asynchronous media promise." );
				var eventSource:IEventDispatcher = dataSource as IEventDispatcher;           
				eventSource.addEventListener( Event.COMPLETE, onMediaLoaded );         
			}
			else
			{
				log( "Synchronous media promise." );
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
				imageLoader.loadFilePromise( imagePromise );
				extractImage();
			}
		}
		
		protected function onMediaLoaded( event:Event ):void {
			trace("Media load complete");
			var eventSource:IEventDispatcher = dataSource as IEventDispatcher;
			eventSource.removeEventListener( Event.COMPLETE, onMediaLoaded );         
			readMediaData();
		}
		
		protected function readMediaData():void
		{
			var data:ByteArray = new ByteArray();
			
			dataSource.readBytes( data );
			
			exif = new ExifInfo(data);
			
			model.userBitmapOrientation = getOrientation(exif.ifds.primary)
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			imageLoader.loadFilePromise(imagePromise);
		}
		
		protected function browseCanceled( event:Event ):void{
			log( "Image browse canceled." );
			cancelImage();
		}
		protected function mediaError( e:ErrorEvent ):void {
			cancelImage();
		}
		
		protected function imageLoaded( event:Event ):void{
			log( "Image loaded asynchronously." );
			imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
			extractImage();
		}
		
		protected function imageLoadFailed( event:Event ):void
		{
			log( "Image load failed." );
			cancelImage();
		}
		
		
		
		protected function extractImage():void {
			log("extractImage");
			
			initImageEditingWith( Bitmap(imageLoader.content) );
		}
		
		public function initImageEditingWith(nb:Bitmap):void
		{
			var w:int = nb.width;
			var newW:Number = 1;
			var h:int = nb.height;
			var newH:Number = 1;
			
			if(model.orientation == "landscape"){
				newW = model.stageWidth;
			} else {
				newW = model.stageHeight;
			}
			newH = Math.round(h * (newW / w));

			
			model.userBitmap = new Bitmap(ImageEdit.getResizedBitmapData( nb.bitmapData, newW, newH, "ImageEdit.resizeCrop", true));
			model.userBitmap.pixelSnapping = PixelSnapping.ALWAYS;
			resetUserBitmapEdit();
			
			model.app_state = AppState.IMAGEEDITING;
			model.dispatchEvent(new Event('newUserBitmap'));
			
		}
		
		
		protected function log(msg:String):void {
			trace(msg);
		}
		protected function cancelImage(e:* = null):void {
			returnHomeEvent();
		}

		
		protected var fileStream:FileStream;
		protected var bitmapDataForCameraRoll:BitmapData;
		protected var saveImageData:Array;
		public function saveImage(mc:DisplayObject):void {
			
			bitmapDataForCameraRoll = bmdSnapshot(mc);
			saveImageData = ["", model.stageWidth, model.stageHeight]
			
			//Initialize the Objects with proper paths.
			//cacheDir= new File(str +"/\.\./Library/Caches");
			//tempDir = new File(str +"/\.\./tmp");
			
			
			if(model.saveInGallery || model.saveInCameraRoll){
				bitmapDataToJPEGByteArray(bitmapDataForCameraRoll, jpgEncodeComplete);
			}
			if(!model.saveInCameraRoll) {
				deleteBitmapDataForCameraRoll();
			}
		}
		protected function jpgEncodeComplete(e:Event):void {
			trace('jpgEncodeComplete');
			endProgressMonitor();
			traceEndTime();
			if( model.saveInGallery ) {
				saveImageData[0] = saveInDocuments(imgEncoded);
				saveInSavedImages(saveImageData);
			}
			saveInCameraRollOrComplete();
		}

		protected function nextFilename():String {

			var nameParts:Array = ["0000"];
			if(model.savedImages.length > 0){
				nameParts = model.savedImages[model.savedImages.length - 1][0].split("_")[1].split(".");
			}
			var imgid:int = int(nameParts[0]);
			trace('retrieved namePart ' + imgid);

			imgid++;
			var imgreturn:String = imgid.toString();
			while(imgreturn.length < 4){imgreturn = "0" + imgreturn;}
			trace('imgreturn = ' + imgreturn);
			return "wonder_"+imgreturn+".jpg";
		}
		
		public function saveInDocuments(bytes:ByteArray):String {
			
			var filename:String = nextFilename();
			
			trace('saveInDocuments::' +  filename);
			
			fileStream = new FileStream();
			fileStream.open(File.documentsDirectory.resolvePath(filename), FileMode.WRITE);  
			fileStream.writeBytes(bytes);
			fileStream = null;
			
			return filename;
		}
		
		public function saveInSavedImages(imgData:Array):void {
			model.savedImages.push(imgData);
			model.flushLSO();
		}
		
		protected function saveInCameraRollOrComplete():void {
			if( model.saveInCameraRoll && CameraRoll.supportsAddBitmapData ){
				saveInCameraRoll(bitmapDataForCameraRoll);
			} else {
				trace('do not save in camera roll!');
				saveComplete();
			}
		}
		
		protected function deleteBitmapDataForCameraRoll():void {
			if(bitmapDataForCameraRoll != null){
				trace('deleting bitmapForCameraRoll');
				bitmapDataForCameraRoll.dispose();
				bitmapDataForCameraRoll = null;
			}
		}
		
		
		public function saveInCameraRoll(bmp:BitmapData):void {
			trace('saveInCameraRoll');
			if( CameraRoll.supportsAddBitmapData ){
				trace('saving in CameraRoll');
				if(!mediaSource){
					mediaSource = new CameraRoll;
				}
				mediaSource.addEventListener(Event.COMPLETE, onSave);
				mediaSource.addEventListener(ErrorEvent.ERROR, onSaveFail);
				try {
					mediaSource.addBitmapData(bmp);
				} catch(E:Error) {
					trace('cannot save in CameraRoll');
				}
			}
		}
		protected function onSaveFail(e:ErrorEvent):void {
			mediaSource.removeEventListener(ErrorEvent.ERROR, onSaveFail);
			mediaSource.removeEventListener(Event.COMPLETE, onSave);
			trace('could not save because application is not allowed to access camera roll');
			deleteImageForSave();
			if(model.app_state == AppState.SAVING){
				model.app_state = AppState.IMAGEEDITING;
			}
		}
		
		protected function onSave(e:Event):void {
			mediaSource.removeEventListener(ErrorEvent.ERROR, onSaveFail);
			mediaSource.removeEventListener(Event.COMPLETE, onSave);
			trace("image saved");
			saveComplete();
		}
		private function deleteImageForSave():void {
			deleteBitmapDataForCameraRoll();
			imgEncoded = null;
			imgData = null;
			System.gc();
		}
		protected function saveComplete():void {
			trace('saveComplete from state: ' + model.app_state);
			deleteImageForSave();
			if(model.app_state != AppState.GALLERY){
				if( model.savedImages.length > 0 ) {
					model.app_state = AppState.SAVE_COMPLETE;
				} else {
					model.app_state = AppState.IMAGEEDITING;
				}
			}
		}
		
		public function openLatestImageInGallery():void {
			model.app_state = AppState.GALLERY;
			model.gallerySelectedImage = (model.savedImages.length - 1).toString();
			model.gallery_state = AppState.DETAIL;
		}
		protected function returnHomeEvent():void {
			trace('returnHomeEvent')
			model.app_state = AppState.HOMEPAGE;
		}
		
		public function byteArrayFromDocuments(src:String):ByteArray {
			
			var ba:ByteArray = new ByteArray();
			var file:File = model.docDir.resolvePath(src);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			fs.readBytes(ba);
			fs.close();
			return ba;
		}
		
		public function loaderFromDocuments(src:String):Loader {
			trace('loaderFromDocuments:' + src);
			var f:File = model.docDir.resolvePath(src);

			if (f.exists == true) {
				var _urlRequest:URLRequest = new URLRequest(f.url);
				var loader:Loader = new Loader;
				loader.load(_urlRequest);
				loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{ trace(e) });
				//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, ImageLoaded, false, 0, true);     
				_urlRequest = null;
				return loader;
			} else {
				trace('loaderFromDocuments: FILE NOT FOUND');
			}
			return null;

		}
		
		
		
		public function snapShot(mc:DisplayObject):Bitmap{
			var bmpData:BitmapData = new BitmapData(model.stageWidth, model.stageHeight, true, 0x00000000);
			var bmp:Bitmap = new Bitmap(bmpData);
			return bmp;
		}
		public function bmdSnapshot(mc:DisplayObject):BitmapData {
			var bmpData:BitmapData = new BitmapData(model.stageWidth, model.stageHeight, true, 0x00000000);
			bmpData.draw(mc);
			return bmpData;
		}
		
		
		
		
		
		// ---------------------------
		// updating from 1.0.0 to 1.1.0
		// ---------------------------
		
		public function moveSOPictureToDocuments():void {
			
			var savedImage:Array;
			var found:Boolean = false;
			for(var j:int = 0; j < model.savedImages.length; j++){
				savedImage = model.savedImages[j];
				if(savedImage[0] is ByteArray){
					found = true;
					break;
				}
			}
			//model.traceSavedImages();
			
			if(found) {
				trace('delete lso saved images');
				/*var oldSavedImages:Array = model.savedImages;
				model.userImagesToConvert = oldSavedImages.length;
				model.userImagesConverted = 0;
				model.savedImages = new Array();
				for(var i:int = 0; i < oldSavedImages.length; i++){
					savedImage = oldSavedImages[i];
					if(savedImage[0] is ByteArray){
						trace ('found bytearray! converting ');
						model.savedImages.push(
							[
							saveInDocuments(bitmapDataToJPEGByteArray(bitmapDataFromByteArray(savedImage[0], savedImage[1], savedImage[2]))),
							savedImage[1],
							savedImage[2]
							]
						);
						model.userImagesConverted++;
						trace('added #' + model.userImagesConverted + ' to saved images: ' + model.savedImages[i][0] + ' ' + model.savedImages[i][1] + 'x' + model.savedImages[i][2]);
					} else {
						model.savedImages.push(savedImage);
					}
				}*/
				model.savedImages = new Array();
			}
			// move up inside bracket
		}
		
		
		
		
		public function setGalaxyMatrix():void
		{
			if(!model.settingMatrix){
				model.settingMatrix = true;
				var matrix:ColorMatrix = new ColorMatrix();
				matrix.setContrast(( 80 * model.contrast ) - 40);
				matrix.setBrightness(( 100 * model.brightness ) - 50);
				editingTarget.filters = [new ColorMatrixFilter(matrix.matrix)];
				applyBlur();
				model.settingMatrix = false;
			}
		}
		public function applyBlur():void {
			Tweener.addTween(editingTarget, {_Blur_blurX:10 * model.blur, _Blur_blurY:10 * model.blur, _Blur_quality:1});
		}
		
		public function setGalaxyScale(s:Number):void
		{
			model.currentGalaxyStage.scaleX = model.currentGalaxyImage.scaleY  = s;
		}
		public function setGalaxyAlpha():void
		{
			model.currentGalaxyStage.alpha = model.galaxyAlpha;
		}
		
		
		public function alpha2(a:Number):void{
			model.alpha2 = a;
			editingTarget.alpha  = a;
		}
		public function blur(b:Number):void {
			model.blur = b;
			applyBlur();
		}
		public function rotation2(r:Number):void
		{
			var rt:int = 0;
			switch(true) {
				case r > .75:
					rt = 270;
					break;
				case r > .5:
					rt = 180;
					break;
				case r > .25:
					rt = 90;
					break;
			}
			model.rotation2 = rt;
			editingTarget.parent.rotation = r * 360;
			trace('current rotation: ' + editingTarget.parent.rotation);
		}
		
		public function brightness(b:Number):void {
			model.brightness = b;
			setGalaxyMatrix();
		}
		public function contrast(c:Number):void {
			model.contrast = c;
			setGalaxyMatrix();
		}
		public function portrait():void {
			model.editingGalaxy = true;
		}
		public function galaxy():void {
			model.editingGalaxy = false;
		}
		
		
		public function resetUserBitmapEdit():void {
			var prevMode:Boolean = model.editingGalaxy;
			model.editingGalaxy = false;
			//model.rotation2(isportrait ? 0 : 0.25);
			resetBitmap();
			model.editingGalaxy = true;
			resetBitmap();
			model.editingGalaxy = prevMode;
		}
		protected function resetBitmap():void {
			model.brightness = .5;
			model.contrast = .5;
			model.alpha2 = 1;
			if(editingTarget) {
				editingTarget.filters = [];
			}
		}
		
		
		protected function get editingTarget():* {
			return model.editingGalaxy ? model.currentGalaxyStage : model.userBitmap;
		}
		
		protected var imgData:ByteArray;
		protected var imgEncoded:ByteArray;
		public function bitmapDataToJPEGByteArray(b:BitmapData, callback:Function):void {
			
			imgData = b.getPixels(b.rect);
			imgEncoded = new ByteArray();
			imgData.position = 0;
			
			trace('JPG ENCODE----------------');
			traceStartTime();
			startProgressMonitor();

			model.jpeglib.encodeAsync(callback, imgData, imgEncoded, b.width, b.height, 100);
		}
		
		
		protected var progressMonitor:Timer;
		protected function encodeProgress(e:TimerEvent):void {
			model.encodeProgress = Math.round(imgData.position/imgData.length*100);
		}
		public function startProgressMonitor():void {
			progressMonitor = new Timer(500);
			progressMonitor.addEventListener(TimerEvent.TIMER, encodeProgress);
			progressMonitor.start();
		}
		public function endProgressMonitor():void {
			if(progressMonitor){
				progressMonitor.reset();
				progressMonitor.removeEventListener(TimerEvent.TIMER, encodeProgress);
			}
			progressMonitor = null;
		}
		
		
		
		// ---------------------
		// STAGE RESIZING
		// ---------------------
		
		public function stageResize():void {
			dispatchEvent(new Event("stageResize"));
		}
		
		// ---------------------
		// FACEBOOK POSTING
		// ---------------------
		
		
		public function postBytesToFacebook(bytes:ByteArray):void {
			trace('post to facebook');
			model.facebookapi.APP_ID = model.FB_APP_ID;
			model.facebookapi.tryPostPicture(bytes);
		}

		public function postBitmapToFacebook(jpeg:ByteArray):void {
			model.facebookapi.APP_ID = model.FB_APP_ID;
			model.facebookapi.tryPostPicture(jpeg);
			//model.facebookapi.tryPostPicture(null, b);
		}
		
		public function postBitmapToFacebook2(b:Bitmap):void {
			model.facebookapi.APP_ID = model.FB_APP_ID;
			model.facebookapi.tryPostPicture(null, b);
		}
		
		
		
		
		// ----------
		// getOrientation
		// ----------
		
		protected function getOrientation(ifd:IFD):String{
			var str:String = "";
			for (var entry:String in ifd) {
				if(entry == "Orientation"){
					str = ifd[entry];
				}
			}
			
			switch(str){
				case "1": //normal
					str = "NORMAL";
					break;
				case "3": //rotated 180 degrees (upside down)
					str = "UPSIDE_DOWN";
					break;
				case "6": //rotated 90 degrees CW
					str = "ROTATED_LEFT"
					break;
				case "8": //rotated 90 degrees CCW
					str = "ROTATED_RIGHT"
					break;
				case "9": //unknown
					str = "UNKNOWN"
					break;
			}
			return str;
		}
		
		
		
		protected var startTime:Number;
		protected function traceStartTime():void {
			trace('started at: ' + new Date().minutes + ':' + new Date().seconds + ':' + new Date().milliseconds);
			startTime = new Date().time;

		}
		protected function traceEndTime():void {
			var encodeTime:Number = (new Date().time - startTime);
			trace('finished after s: ' + encodeTime / 1000);
		}
		
	}
	
}