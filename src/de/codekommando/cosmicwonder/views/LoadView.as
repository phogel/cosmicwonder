package de.codekommando.cosmicwonder.views
{
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class LoadView extends MovieClip
	{
		
		private var controller:WonderController = WonderController.getInstance();
		private var model:WonderModel = WonderModel.getInstance();
		
		private var bmp:BitmapLoader;
		
		private var progress:ProgressBar = new ProgressBar;
		
		public function LoadView(){
			super();
			
			controller.addEventListener("stageResize", stageResize);
			progress.scaleX = progress.scaleY = WonderModel.getInstance().globalScale;
			
			progress.x = (WonderModel.getInstance().stageWidth - progress.width) / 2;
			progress.percent = 0;
			progress.visible = false;
			
			bmp = new BitmapLoader("loadview_logo.png", movebmp);
			addChild(bmp);
			addChild(progress);
		}
		
		public function percent(s:Number):void {
			progress.percent = s;
		}
		
		protected function movebmp():void {
			bmp.y = Math.round((model.stageHeight - bmp.height) / 2.5);
			bmp.x = Math.round((model.stageWidth - bmp.width) / 2);
			progress.y = bmp.height + bmp.y;
			progress.x = Math.round((model.stageWidth - progress.width) / 2);
			progress.visible = true;
			//trace("bmp moved to " + bmp.x + 'x' + bmp.y + ' height=' + bmp.height);
		}
		
		public function unload():void {
			removeChild(bmp);
			removeChild(progress);
			bmp = null;
			progress = null;
		}
		
		
		
		protected function stageResize(e:Event):void {
			if(bmp){
				movebmp();
			}
		}
	}
}