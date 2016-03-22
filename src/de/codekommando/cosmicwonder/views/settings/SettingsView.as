package de.codekommando.cosmicwonder.views.settings
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.states.AppState;
	import de.codekommando.cosmicwonder.views.ButtonWrapper;
	
	public class SettingsView extends MovieClip
	{
		
		private var controller:WonderController = WonderController.getInstance();
		private var model:WonderModel = WonderModel.getInstance();
		
		private var returnBtn:ButtonWrapper;
		
		private var saveOnOff:SettingsSwitch;
		private var saveCameraRollOnOff:SettingsSwitch;
		
		private var items:Sprite = new Sprite();
		
		public function SettingsView(){
			super();
			returnBtn = new ButtonWrapper( Languages.BACK );
			returnBtn.name = "returnBtn";
			returnBtn.mouseChildren = false;
			returnBtn.addEventListener(MouseEvent.CLICK, returnToMain);
			returnBtn.scaleX = returnBtn.scaleY = (0.8 * model.globalScale);
			returnBtn.x = returnBtn.y = (10 * model.globalScale);
			addChild(returnBtn);
			
			addChild(items);
			
			saveOnOff = new SettingsSwitch(Languages.SAVE_IN_GALLERY);
			saveOnOff.scaleX = saveOnOff.scaleY = model.globalScale;
			saveCameraRollOnOff = new SettingsSwitch(Languages.SAVE_IN_CAMERAROLL);
			saveCameraRollOnOff.y = saveOnOff.height - (20 * model.globalScale);
			saveCameraRollOnOff.scaleX = saveCameraRollOnOff.scaleY = model.globalScale;
			items.addChild(saveOnOff);
			items.addChild(saveCameraRollOnOff);
			addListener(saveCameraRollOnOff as Sprite);
			addListener(saveOnOff as Sprite);
			
			stageChange();
			updateValues();
		}
		
		private function addListener(tgt:Sprite):void {
			tgt.addEventListener(MouseEvent.MOUSE_DOWN, btnClick);
		}
		private function btnClick(e:Event):void {
			switch (e.currentTarget) {
				case saveOnOff:
					saveOnOff.value = !saveOnOff.value;
					controller.saveToGallery(saveOnOff.value);
					if(!saveCameraRollOnOff.value && !saveOnOff.value) {
						controller.saveToCameraRoll(true);
					}
					break;
				case saveCameraRollOnOff:
					saveCameraRollOnOff.value = !saveCameraRollOnOff.value;
					controller.saveToCameraRoll(saveCameraRollOnOff.value);
					if(!saveOnOff.value && !saveCameraRollOnOff.value) {
						controller.saveToGallery(true);
					}
					break;
			}
			updateValues();
		}
		
		public function init():void {
			
		}
		public function readyForLoad():void {
			trace('settingsView::readyForLoad');
			updateValues();
		}
		private function returnToMain(e:MouseEvent):void {
			model.app_state = AppState.HOMEPAGE;
		}
		
		
		private function updateValues():void {
			saveOnOff.value = model.saveInGallery;
			saveCameraRollOnOff.value = model.saveInCameraRoll;
		}
		
		
		public function stageChange():void {
			items.x = (model.stageWidth - items.width) / 2;
			items.y = (model.stageHeight - items.height) / 1.15;
		}
		
	}
}