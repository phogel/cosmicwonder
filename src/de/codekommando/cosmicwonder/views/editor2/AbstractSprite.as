package de.codekommando.cosmicwonder.views.editor2
{
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class AbstractSprite extends Sprite
	{
		
		protected var controller:WonderController = WonderController.getInstance();
		protected var model:WonderModel = WonderModel.getInstance();
		
		public function AbstractSprite()
		{
			super();
		}
		
		
		
		protected function stageResize(e:Event = null):void
		{
			
		}
		
		public function readyForLoad():void
		{
			controller.addEventListener("stageResize", stageResize);
		}
		
		public function unload():void
		{
			controller.removeEventListener("stageResize", stageResize);
		}
	}
}