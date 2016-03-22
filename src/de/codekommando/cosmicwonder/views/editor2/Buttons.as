package de.codekommando.cosmicwonder.views.editor2
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.states.AppState;
	import de.codekommando.cosmicwonder.views.CustomButton;
	
	public class Buttons extends AbstractSprite
	{
		
		private var returnBtn:CustomButton;
		private var saveBtn:CustomButton;
		
		public function Buttons()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			returnBtn = new CustomButton(Languages.BACK);
			returnBtn.scaleX = returnBtn.scaleY = (0.8 * model.globalScale);
			
			saveBtn = new CustomButton(Languages.SAVE);
			saveBtn.scaleX = saveBtn.scaleY = (0.8 * model.globalScale);
			
			addChild(returnBtn);
			addChild(saveBtn);
			saveBtn.name = "saveBtn";
			
			stageResize();
		}
		
		
		override public function readyForLoad():void
		{
			super.readyForLoad();
			stageResize();
			returnBtn.addEventListener(MouseEvent.CLICK, returnToMain);
		}
		
		override public function unload():void
		{
			super.unload();
			returnBtn.removeEventListener(MouseEvent.CLICK, returnToMain);
		}
		
		private function returnToMain(e:MouseEvent = null):void{
			model.app_state = AppState.HOMEPAGE;
		}
		
		
		override protected function stageResize(e:Event = null):void
		{
			returnBtn.x = model.space;
			returnBtn.y = model.space;
			
			saveBtn.x = model.stageWidth - saveBtn.width + model.space;
			saveBtn.y = model.space;
		}
	}
}