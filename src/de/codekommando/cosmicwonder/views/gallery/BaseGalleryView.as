package de.codekommando.cosmicwonder.views.gallery
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.states.AppState;
	
	public class BaseGalleryView extends Sprite
	{
		
		private var model:WonderModel;
		private var controller:WonderController;
		
		private var detailView:ImageDetailView;
		private var overview:ThumbnailView;
		private var optionBar:OptionBar;
		
		private var spinner:StarSpinner = new StarSpinner();
		
		public function BaseGalleryView() {
			
			model  = WonderModel.getInstance();
			controller = WonderController.getInstance();

			overview = new ThumbnailView();
			optionBar = new OptionBar();
			detailView  = new ImageDetailView();
			
			spinner.cacheAsBitmap = true;
			spinner.visible = false;
			overview.y = (80 * model.globalScale);
			addChild(detailView);
			addChild(overview);
			addChild(optionBar);
			addChild(spinner);
			
			optionBar.addEventListener(MouseEvent.CLICK, optionClick);
			super();
		}
		
		public function readyForLoad():void {
			controller.addEventListener("stageResize", stageResize);
			if(model.gallery_state == "thumbnail"){
				detailView.visible = false;
			}
			overview.visible = false;
			optionBar.visible = false;
			spinner.visible = true;
			stageResize();
		}
		
		public function init():void {
			stateChange();
			model.addEventListener('galleryStateChange', stateChange);
		}
		
		
		public function unload():void {
			controller.removeEventListener("stageResize", stageResize);
			detailView.visible = false;
			overview.visible = false;
			optionBar.visible = false;
			overview.unload();
			detailView.unload();
			model.removeEventListener('galleryStateChange', stateChange);
		}
		
		private function stateChange(e:Event = null):void {
			optionBar.visible = true;
			switch (model.gallery_state) {
				case "thumbnail":
					this.mouseChildren = this.mouseEnabled = false;
					detailView.visible = false;
					detailView.unload();
					spinner.visible = true;
					overview.addEventListener(Event.COMPLETE, showOverview);
					overview.load();
					break;
				case "detail":
					this.mouseChildren = this.mouseEnabled = true;
					overview.visible = false;
					overview.unload();
					spinner.visible = false;
					detailView.visible = true;
					detailView.load();
					detailView.initWith( int(model.gallerySelectedImage) );
					break;
			}
		}
		private function showOverview(e:Event):void {
			overview.removeEventListener(Event.COMPLETE, showOverview);
			this.mouseChildren = this.mouseEnabled = true;
			overview.visible = true;
			spinner.visible = false;
		}
		
		private function optionClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "returnBtn":
					if(model.gallery_state=="thumbnail") {
						model.app_state = AppState.HOMEPAGE;
					} else {
						model.gallery_state = AppState.THUMBNAILS;
					}
					break;
			}
		}
		
		
		override public function set visible(value:Boolean):void {
			//trace('galleryViewVisible = ' + value);
			if(!value) {
				detailView.unload();
				overview.unload();
				controller.destroyGalleryThumbnails();
			}
			overview.visible = value;
			detailView.visible = value;
			optionBar.visible = value;
		}
		
		
		
		
		public function stageResize(e:Event = null):void {
			spinner.x = model.stageWidth / 2;
			spinner.y = model.stageHeight / 2;
			spinner.scaleX = spinner.scaleY = model.globalScale;
			overview.stageResize();
		}
	}
}