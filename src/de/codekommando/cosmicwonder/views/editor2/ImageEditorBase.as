package de.codekommando.cosmicwonder.views.editor2
{
	
	import com.greensock.TweenLite;
	import com.hurlant.crypto.symmetric.NullPad;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import de.codekommando.cosmicwonder.states.AppState;
	
	public class ImageEditorBase extends AbstractSprite
	{
		
		private var galaxyPreviews:GalaxyPreviews;
		private var effectPreviews:EffectPreviews;
		private var editorStage:EditingStage;
		private var buttons:Buttons;
		private var editingButtons:EditingButtons;
		
		private var touchSensitiveArea:Sprite;
		
		public function ImageEditorBase()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
		}
		private function addedToStageHandler(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			galaxyPreviews = new GalaxyPreviews;
			effectPreviews = new EffectPreviews;
			editingButtons = new EditingButtons;
			editorStage = new EditingStage;
			buttons = new Buttons;
			touchSensitiveArea = new Sprite;
			
			addChild(editorStage);
			addChild(touchSensitiveArea);
			addChild(galaxyPreviews);
			addChild(effectPreviews);
			addChild(editingButtons);
			addChild(buttons);
			
			stageResize();
			
		}
		
		
		private var maxrad:int = 20;
		private var originPress:Point;
		private var lastMouse:Point;
		
		private var direction:String = "";
		
		private function rotationMoveModeCompleteHandler(e:Event):void {
			state = "idle";
		}
		
		private function addTouchListeners():void {
			touchSensitiveArea.addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			touchSensitiveArea.addEventListener(MouseEvent.MOUSE_UP, releaseHandler);
		}
		private function removeTouchListeners():void {
			removeEventListener(Event.ENTER_FRAME, followTouch);
			touchSensitiveArea.removeEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			touchSensitiveArea.removeEventListener(MouseEvent.MOUSE_UP, releaseHandler);
		}
		
		private var _state:String = "idle";

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			if(value == _state) return;
			switch(_state){
				case "erase":
					editorStage.endEraseMode();
					break;
				case "move":
					editorStage.endEditMode(false);
					break;
			}
			trace('setting state from ' + _state + ' to ' + value);
			_state = value;
			editingButtons.state = value;
			switch(state){
				case "erase":
					editorStage.eraseMode( this.touchSensitiveArea );
					break;
				case "move":
					if(direction == ""){
						editorStage.editMode( this.touchSensitiveArea );
					}
					break;
			}
			state == "idle" ? addTouchListeners() : removeTouchListeners();
			effectPreviews.visible = galaxyPreviews.visible = buttons.visible = state == "idle";
			editingButtons.showme = state == "idle";
		}

		
		private function pressHandler(e:MouseEvent):void
		{
			direction = "";
			
			originPress = new Point(stage.mouseX, stage.mouseY);
			lastMouse = new Point(stage.mouseX, stage.mouseY);
			addEventListener(Event.ENTER_FRAME, followTouch);
		}
		private function followTouch(e:Event):void
		{
			var diffX:int = stage.mouseX - originPress.x;
			switch(direction)
			{
				case "x":
					editorStage.x += Math.round(stage.mouseX - lastMouse.x);
					if(editorStage.x > galaxyPreviews.width){
						editorStage.x = galaxyPreviews.width;
					} else if(editorStage.x < -effectPreviews.width) {
						editorStage.x = -effectPreviews.width;
					}
					buttons.x = editorStage.x;
					
					if(editorStage.x <= 1){
						effectPreviews.x = editorStage.x + model.stageWidth;
						effectPreviews.visible = true;
					} else {
						effectPreviews.visible = false;
					}
					
					if(editorStage.x > 0){
						galaxyPreviews.visible = true;
						galaxyPreviews.x = editorStage.x - galaxyPreviews.width;
					} else {
						galaxyPreviews.visible = false;
					}
					
					editingButtons.x = model.stageWidth / 2 + editorStage.x;
					break;
				case "y":
					editorStage.y += (stage.mouseY - lastMouse.y);
					if(editorStage.y < -editingButtons.contentHeight){
						editorStage.y = -editingButtons.contentHeight;
					} else if(editorStage.y > 0){
						editorStage.y = 0;
					}
					editingButtons.y = editorStage.y + model.stageHeight;
					buttons.y = editorStage.y;
					showHideButtons();
					break;
				case "":
					if(isXMove())
					{
						direction = "x";
					}
					else if(isYMove())
					{
						direction = "y";
					}
					break;
					
			}
			lastMouse.x = stage.mouseX;
			lastMouse.y = stage.mouseY;

		}
		
		private function releaseHandler(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, followTouch);
			var tm:Number = 0.2;
			trace('release target: ' + e.target.name + ' curTarget: ' + e.currentTarget);
			switch(true){
				case direction == "x":
					if(editorStage.x != galaxyPreviews.width && editorStage.x != -effectPreviews.width)
					{
						moveItemsToIdleState(tm);
					}
					break;
				case direction == "y":
					if(editorStage.y != -editingButtons.contentHeight)
					{
						TweenLite.to(editingButtons, tm, {y:model.stageHeight});
						TweenLite.to(editorStage, tm, {y:0});
						TweenLite.to(buttons, tm, {y:0});
						editingButtons.galaxyImageSelectorVisibility = false;
						editingButtons.moveVisibility = true;
					}
				break;
				case e.currentTarget != editingButtons && editingButtons.y == model.stageHeight:
					if(editorStage.x == 0){
						state = "move";
					} else {
						moveItemsToIdleState(tm);
						state = "idle";
					}
					break;
				case e.target.name == "move":
					state = state == "move" ? "idle" : "move";
					break;
				case e.target.name == "erase":
					state = state == "erase" ? "idle" : "erase";
					break;
				default:
					trace('release target: ' + e.target.name + ' curTarget: ' + e.currentTarget.name);
					break;
			}
		}
		private function moveItemsToIdleState(tm:Number):void {
			TweenLite.to(galaxyPreviews, tm, {x:-galaxyPreviews.width});
			TweenLite.to(editorStage, tm, {x:0});
			TweenLite.to(buttons, tm, {x:0});
			TweenLite.to(effectPreviews, tm, {x:model.stageWidth});
			TweenLite.to(editingButtons, tm, {x:model.stageWidth / 2});
		}
		private function showHideButtons():void {
			if(editingButtons.y < model.stageHeight) {
				editingButtons.galaxyImageSelectorVisibility = true;
				editingButtons.moveVisibility = false;
			} else {
				editingButtons.galaxyImageSelectorVisibility = false;
				editingButtons.moveVisibility = true;
			}
		}
		
		private function isXMove():Boolean
		{
			return (originPress.x - maxrad > stage.mouseX || originPress.x + maxrad < stage.mouseX) && editorStage.y == 0;
		}
		private function isYMove():Boolean
		{
			if(model.islite)
			{
				return false;
			}
			return (originPress.y - maxrad > stage.mouseY || originPress.y + maxrad < stage.mouseY) && editorStage.x == 0;
		}
		override public function readyForLoad():void {
			
			touchSensitiveArea.addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			touchSensitiveArea.addEventListener(MouseEvent.MOUSE_UP, releaseHandler);
			editingButtons.addEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			editingButtons.addEventListener(MouseEvent.MOUSE_UP, releaseHandler);
			
			buttons.addEventListener(MouseEvent.MOUSE_UP, buttonClick);
			editorStage.addEventListener(EditingStage.EDIT_COMPLETE, rotationMoveModeCompleteHandler);
			editingButtons.addEventListener(EditingButtons.EDITING_STAGE, rerenderEditingStageHandler);
			
			editorStage.readyForLoad();
			buttons.readyForLoad();
			galaxyPreviews.readyForLoad();
			effectPreviews.readyForLoad();
			editingButtons.readyForLoad();
			
			this.mouseEnabled = this.mouseChildren = true;
			
			stageResize();
			super.readyForLoad();
		}
		
		private function rerenderEditingStageHandler(e:Event):void
		{
			editorStage.createBitmapRepresentation();
		}
		
		
		override public function unload():void {
			
			touchSensitiveArea.removeEventListener(MouseEvent.MOUSE_DOWN, pressHandler);
			touchSensitiveArea.removeEventListener(MouseEvent.MOUSE_UP, releaseHandler);
			
			buttons.removeEventListener(MouseEvent.MOUSE_UP, buttonClick);
			editorStage.removeEventListener(EditingStage.EDIT_COMPLETE, rotationMoveModeCompleteHandler);
			editingButtons.removeEventListener(EditingButtons.EDITING_STAGE, rerenderEditingStageHandler);
			
			editorStage.unload();
			buttons.unload();
			galaxyPreviews.unload();
			effectPreviews.unload();
			editingButtons.unload();
			
			this.mouseEnabled = this.mouseChildren = false;
			super.unload();
		}
		
		override protected function stageResize(e:Event = null):void {
			trace('stageResize @ IMageEditorBase');
			effectPreviews.x = model.stageWidth;
			galaxyPreviews.x = -galaxyPreviews.width;
			editorStage.x = 0;
			editorStage.y = 0;
			buttons.x = 0;
			editingButtons.x = model.stageWidth / 2;
			editingButtons.y = model.stageHeight;
			
			var gfx:Graphics = touchSensitiveArea.graphics;
			gfx.clear();
			gfx.beginFill(0x123456, 0);
			gfx.drawRect(0,0,model.stageWidth, model.stageHeight );
			gfx.endFill();
			
		}
		
		
		
		
		private function buttonClick(e:MouseEvent):void
		{
			if(e.target.name == "saveBtn"){
				trace('save image ');
				model.app_state = AppState.SAVING;
				TweenLite.delayedCall(0.5, controller.saveImage, [this.editorStage.editorContainer]);
			}
		}
	}
}