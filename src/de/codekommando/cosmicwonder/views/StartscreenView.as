package de.codekommando.cosmicwonder.views
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.states.AppState;
	
	
	public class StartscreenView extends Sprite
	{
		
		
		
		private var controller:WonderController;
		private var model:WonderModel;
		
		private var startBtn:ButtonWrapper;
		private var galleryBtn:ButtonWrapper;
		private var settingsBtn:ButtonWrapper;
		
		private var cwicon:BitmapLoader;
		private var ckmicon:BitmapLoader;
		
		private var camera:BitmapButton;
		private var cameraroll:BitmapButton;
		
		public function StartscreenView()
		{
			super();
			controller = WonderController.getInstance();
			model = WonderModel.getInstance();
			
			startBtn = new ButtonWrapper(Languages.CREATE);
			startBtn.name = "startBtn";
			startBtn.addEventListener(MouseEvent.CLICK, startIt);
			//addChild(startBtn);
			
			galleryBtn = new ButtonWrapper( Languages.GALLERY );
			galleryBtn.name = "galleryBtn";
			addChild(galleryBtn);
			
			settingsBtn = new ButtonWrapper( Languages.SETTINGS );
			settingsBtn.name = "settingsBtn";
			settingsBtn.addEventListener( MouseEvent.CLICK, openSettings);
			//settingsBtn.rotation = -2;
			addChild(settingsBtn);
			
			camera = new BitmapButton("camera.png");
			cameraroll = new BitmapButton("cameraroll.png");
			cameraroll.addEventListener(MouseEvent.CLICK, startIt);
			camera.addEventListener(MouseEvent.CLICK, startIt);
			addChild(camera);
			addChild(cameraroll);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		} 
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			ckmicon = new BitmapLoader("ckmicon.png", adjustAfterLoad);
			cwicon = new BitmapLoader("cosmicwondericon.png", adjustAfterLoad);
			ckmicon.smoothing = true;
			cwicon.smoothing = true;
			addChild(ckmicon);
			addChild(cwicon);
			
			stageResize();
			controller.addEventListener("stageResize", stageResize);
		}
		
		public function readyForLoad():void {
			if(model.savedImages.length > 0){
				galleryBtn.addEventListener( MouseEvent.CLICK, openGallery);
				galleryBtn.alpha = 1;
				galleryBtn.mouseEnabled = galleryBtn.mouseChildren = true;
			} else {
				galleryBtn.alpha = 0.5;
				galleryBtn.mouseEnabled = galleryBtn.mouseChildren = false;
			}
		}
		public function unload():void {
			galleryBtn.removeEventListener( MouseEvent.CLICK, openGallery);
		}
		
		
		private function startIt(e:MouseEvent):void
		{
			model.app_state = AppState.LOADING;
			if(e.currentTarget == camera) {
				controller.takePicture();
			} else {
				controller.loadimage();
			}
		}
		private function openGallery(e:MouseEvent):void {
			model.app_state = AppState.GALLERY;
		}
		private function openSettings(e:MouseEvent):void {
			model.app_state = AppState.SETTINGS;
		}
		
		private function adjustAfterLoad():void {
			ckmicon.y = model.stageHeight - ckmicon.height - (10 * model.globalScale);
			if(stage.stageHeight > stage.stageWidth){
				ckmicon.x = ( model.stageWidth - ckmicon.width) / 2;
			} else {
				ckmicon.x = ( model.stageWidth - ckmicon.width) - (10* model.globalScale);
			}
			cwicon.x = ( model.stageWidth - cwicon.width) / 2;
			cwicon.y = (10 * model.globalScale);
			
			camera.x = (model.stageWidth / 2) - camera.width - model.gap;
			cameraroll.x = (model.stageWidth / 2);
		}
		
		
		private function stageResize(e:Event = null):void {
			settingsBtn.scaleX = settingsBtn.scaleY = (0.8  * model.globalScale);
			settingsBtn.x = 20 * model.globalScale;
			settingsBtn.y = model.stageHeight - settingsBtn.height - (20 * model.globalScale);
			
			startBtn.scaleX = startBtn.scaleY = (2 * model.globalScale);
			startBtn.x = (model.stageWidth - startBtn.width) / 2;
			startBtn.y = (model.stageHeight / 2) + (60 * model.globalScale);
			
			galleryBtn.scaleX = galleryBtn.scaleY = (1.3 * model.globalScale);
			galleryBtn.x = (model.stageWidth - galleryBtn.width) / 2;
			galleryBtn.y = startBtn.y + startBtn.height + model.gap;
			
			
			camera.y = cameraroll.y = (model.stageHeight / 2) - (model.gap);
			cameraroll.y += model.gap - 10;
			
			adjustAfterLoad();
		}
	}
}