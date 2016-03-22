package de.codekommando.cosmicwonder.views
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.states.AppState;
	import de.codekommando.cosmicwonder.views.editor2.ImageEditorBase;
	import de.codekommando.cosmicwonder.views.gallery.BaseGalleryView;
	import de.codekommando.cosmicwonder.views.settings.SettingsView;
	
	public class BaseView extends Sprite
	{
		private var model:WonderModel;
		private var views:Sprite = new Sprite();
		private var startScreen:StartscreenView;
		private var imageEditor:ImageEditorBase;
		private var statusWindow:StatusWindow;
		private var galleryView:BaseGalleryView;
		private var settingsView:SettingsView;

		
		
		private var wonderlogo:BitmapLoader;
		
		public function BaseView()
		{
			model = WonderModel.getInstance();
			model.addEventListener(WonderModel.RETRIGGER_FULLSCREEN, retriggerFSHandler);
			
			startScreen = new StartscreenView();
			imageEditor = new ImageEditorBase();
			galleryView = new BaseGalleryView();
			statusWindow = new StatusWindow();
			settingsView = new SettingsView();
			
			loadMainBitmaps();
		}
		private function loadMainBitmaps():void {
			model.wonderlogo = new BitmapLoader("cwlogo.png", bitmapLoaded);
			model.appbg = new BitmapLoader("app_background2.jpg", bitmapLoaded);
		}
		
		private var bitmapsLoaded:int = 0;
		private function bitmapLoaded():void {
			bitmapsLoaded++;
			if(bitmapsLoaded >= 2)init();
		}
		
		private function init():void
		{
			wonderlogo = model.wonderlogo;
			
			addChild(model.appbg);
			addChild(wonderlogo);
			
			views.addChild(startScreen);
			addChild(views);
			
			WonderController.getInstance().addEventListener("stageResize", stageResize);
			
			imageEditor.visible  = false;
			galleryView.visible = false;
			settingsView.visible = false;
			
			childQueue = [ imageEditor, galleryView, statusWindow, settingsView];
			
			this.mouseEnabled = this.mouseChildren = false;
			addNext();
		}
		
		protected var childQueue:Array;
		protected function addNext():void {
			stageResize();
			
			if(childQueue.length > 0){
				childQueue[0].addEventListener(Event.ADDED_TO_STAGE, waitToAddNext);
				views.addChild(childQueue[0]);
				childQueue.splice(0,1);
			} else{
				childQueue = null;
				onAddComplete();
			}
		}
		protected function waitToAddNext(e:Event):void {
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, waitToAddNext);
			TweenLite.delayedCall(0.05, addNext);
		}
		
		
		private function onAddComplete():void {
			this.mouseEnabled = this.mouseChildren = true;
			
			dispatchEvent(new Event('initComplete'));
			
			model.addEventListener( 'stateChange', stateChangeHandler );
			model.app_state = AppState.HOMEPAGE;
		}
		
		private function stateChangeHandler( e:Event ):void {
			trace('stateChange = ' + model.app_state);
			retriggerFSHandler(e);
			
			if(model.app_state != AppState.SETTINGS){
				settingsView.visible = false;
			}
			if(model.app_state != AppState.GALLERY){
				galleryView.visible = false;
				galleryView.unload();
			}
			if(model.app_state != AppState.HOMEPAGE){
				startScreen.visible = false;
				startScreen.unload();
			}
			statusWindow.announce();

			if(model.app_state != AppState.SAVING && model.app_state != AppState.IMAGEEDITING && model.app_state != AppState.SAVE_COMPLETE)
			{
				imageEditor.visible = false;
				imageEditor.unload();
			}
			
			if(this[model.app_state] && this[model.app_state] is Function) {
				this[model.app_state]();
			}
		}
		
		private function homepage(e:Event = null):void {
			startScreen.visible = true;
			startScreen.readyForLoad();
			if(wonderlogo.alpha != 1)
			{
				TweenLite.to(wonderlogo, 1, {alpha:1});
			}
			System.gc();
		}
		private function imageEditing(e:Event = null):void {
			imageEditor.visible = true;
			imageEditor.readyForLoad();
		}
		
		private function saveComplete():void
		{
			statusWindow.announce( Languages.VIEW_IN_GALLERY );
			statusWindow.showYesNo = true;
			statusWindow.addEventListener(MouseEvent.CLICK, statusWindowClick);
		}
		
		private function saving():void {
			statusWindow.announce( Languages.SAVING );
			statusWindow.loadPercentage();
		}
		private function loading():void {
			TweenLite.to(wonderlogo, 0.6, {alpha:0.3});
			statusWindow.announce( Languages.LOADING );
		}
		private function gallery():void {
			galleryView.visible = true;
			galleryView.readyForLoad();
			TweenLite.to(wonderlogo, 0.6, {alpha:0.3, onComplete:galleryView.init});
		}
		private function settings():void {
			settingsView.visible = true;
			TweenLite.to(wonderlogo, 0.6, {alpha:0.6, onComplete:settingsView.init});
			settingsView.readyForLoad();
		}
		
		private function statusWindowClick(e:MouseEvent):void
		{
			statusWindow.removeEventListener(MouseEvent.CLICK, statusWindowClick);
			if( e.target.name == "yesbtn" )
			{
				trace('click to yes' );
				WonderController.getInstance().openLatestImageInGallery();
			} else {
				trace('click to rest' );
				model.app_state = AppState.IMAGEEDITING;
			}
		}
		
		
		
		public function stageResize(e:Event = null):void {

			model.appbg.x = (model.stageWidth - model.appbg.width) / 2;
			model.appbg.y = (model.stageHeight - model.appbg.height) / 2;
			
			wonderlogo.x = (model.stageWidth - wonderlogo.width) / 2;
			wonderlogo.y = ((model.stageHeight - wonderlogo.height) / 2);
			
			settingsView.stageChange();
		}
		
		private function retriggerFSHandler(e:Event):void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
	}
}