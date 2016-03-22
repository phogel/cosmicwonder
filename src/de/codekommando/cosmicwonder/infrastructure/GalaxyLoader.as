package de.codekommando.cosmicwonder.infrastructure
{
	import com.greensock.TweenLite;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.views.BitmapLoader;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class GalaxyLoader extends EventDispatcher
	{
		
		private var controller:WonderController;
		private var model:WonderModel;
		
		public var perc:int = 0;
		
		public function GalaxyLoader(target:IEventDispatcher=null)
		{
			super(target);
			controller = WonderController.getInstance();
		}
		
		public function initGalaxies(e:Event):void {
			controller.addEventListener("galaxyLoadComplete", loadNextGalaxy);
			TweenLite.delayedCall(0.2, controller.loadGalaxyFile);
		}
		private function loadNextGalaxy(e:Event):void {
			if(model.galaxyRAWs.length == model.galaxyFiles.length){
				controller.removeEventListener("galaxyLoadComplete", loadNextGalaxy);
				loadMainBitmaps();
			} else {
				perc = model.galaxyFiles.length * 100 / (model.galaxyRAWs.length + 2);
				TweenLite.delayedCall(0.2, controller.loadGalaxyFile);
			}
		}
		
		
		private function loadMainBitmaps():void {
			model.wonderlogo = new BitmapLoader("app_main_logo2.png", bitmapLoaded);
			model.appbg = new BitmapLoader("app_background2.png", bitmapLoaded);
		}
		
		private var bitmapsLoaded:int = 0;
		private function bitmapLoaded():void {
			bitmapsLoaded++;
			perc = (model.galaxyFiles.length + bitmapsLoaded) * 100 / (model.galaxyRAWs.length + 2)
			if(bitmapsLoaded >= 2){
				dispatchEvent(
			}
		}
	}
	
}