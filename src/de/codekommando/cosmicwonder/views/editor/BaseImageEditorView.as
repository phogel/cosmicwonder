package de.codekommando.cosmicwonder.views.editor
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import avmplus.FLASH10_FLAGS;
	
	import caurina.transitions.Tweener;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.infrastructure.TouchRotationMover;
	import de.codekommando.cosmicwonder.states.AppState;
	import de.codekommando.cosmicwonder.views.ButtonWrapper;
	import de.codekommando.cosmicwonder.views.CustomButton;
	
	public class BaseImageEditorView extends MovieClip
	{
		
		private var userImageContainer:Sprite = new Sprite();
		private var editorContainer:Sprite = new Sprite();
		private var galaxyContainer:Sprite = new Sprite();
		private var userImage:Bitmap;
		private var galaxy:Bitmap;
		private var effectPreviews:EffectPreviews2 = new EffectPreviews2();
		private var cosmicPreviews:CosmicPreviews2 = new CosmicPreviews2();
		private var imageEditing:ImageEditing2 = new ImageEditing2();
		private var returnBtn:CustomButton;
		private var saveBtn:CustomButton;
		private var model:WonderModel;
		private var controller:WonderController;
		private var rotator:TouchRotationMover = new TouchRotationMover();
		
		private var touchSensitive:Sprite = new Sprite();
		
		
		
		public function BaseImageEditorView()
		{
			trace('ImageEditorMainView()');
			model = WonderModel.getInstance();
			controller = WonderController.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(editorContainer);
			
			editorContainer.name="editorContainer";
			galaxyContainer.name="galaxyContainer";
			userImageContainer.name="userImageContainer";
			
			touchSensitive.alpha = 0;
			
			editorContainer.addChild(userImageContainer);
			editorContainer.addChild(galaxyContainer);
			
			addChild(touchSensitive);
			addChild(cosmicPreviews);
			addChild(effectPreviews);
			addChild(imageEditing);
			
			returnBtn = new CustomButton(Languages.BACK);
			returnBtn.scaleX = returnBtn.scaleY = (0.8 * model.globalScale);
			
			saveBtn = new CustomButton(Languages.SAVE);
			saveBtn.scaleX = saveBtn.scaleY = (0.8 * model.globalScale);
			
			addChild(returnBtn);
			addChild(saveBtn);
			
			rotator.init( galaxyContainer, touchSensitive, rotatorClicked );
			
			stageResize();
		}
		
		public function readyForLoad():void {
			controller.addEventListener("stageResize", stageResize);
			
			model.addEventListener('newUserBitmap', insertBitmap);
			model.addEventListener('galaxyChange', insertGalaxy);
			model.addEventListener('effectChange', changeEffect);
			
			saveBtn.addEventListener(MouseEvent.CLICK, saveImage);
			returnBtn.addEventListener(MouseEvent.CLICK, returnToMain);

			imageEditing.readyForLoad();
			this.mouseEnabled = this.mouseChildren = true;
		}
		
		
		public function unload():void {
			controller.removeEventListener("stageResize", stageResize);
			
			model.removeEventListener('newUserBitmap', insertBitmap);
			model.removeEventListener('galaxyChange', insertGalaxy);
			model.removeEventListener('effectChange', changeEffect);
			
			saveBtn.removeEventListener(MouseEvent.CLICK, saveImage);
			returnBtn.removeEventListener(MouseEvent.CLICK, returnToMain);

			
			if(userImage){
				userImageContainer.removeChild(userImage)
				userImage.bitmapData.dispose();
			}
			userImage = null;
			if(galaxy)galaxyContainer.removeChild(galaxy);
			galaxy = null;
			this.mouseEnabled = this.mouseChildren = false;
		}
		
		
		private function returnToMain(e:MouseEvent = null):void{
			model.app_state = AppState.HOMEPAGE;
		}
		private function saveImage(e:MouseEvent = null):void{
			model.app_state = AppState.SAVING;
			TweenLite.delayedCall(0.5, controller.saveImage, [this.editorContainer]);
		}
		private function insertBitmap(e:Event):void
		{
			if(userImage)userImageContainer.removeChild(userImage)
			userImage = null;
			userImage = model.userBitmap;
			userImage.x = userImage.width / -2;
			userImage.y = userImage.height / -2;
			userImageContainer.addChildAt( userImage, 0 );
			
			switch(model.userBitmapOrientation){
				case "ROTATED_LEFT":
					userImageContainer.rotation = 90;
					break;
				case "ROTATED_RIGHT":
					userImageContainer.rotation = 270;
					break;
				case "UPSIDE_DOWN":
					userImageContainer.rotation = 180;
					break;
				default:
					userImageContainer.rotation = 0;
					break;
			}
			
			//trace("userImage rotated to "  + userImageContainer.rotation);
			
			if(!galaxy){
				insertGalaxy();
			}
			stageResize();
		}
		private function insertGalaxy(e:Event = null):void {
			if(galaxy)galaxyContainer.removeChild(galaxy)
			galaxy = null;
			galaxy = model.currentGalaxyImage;
			model.currentGalaxyStage = galaxy;
			
			galaxy.x = galaxy.width / -2;
			galaxy.y = galaxy.height / -2;
			galaxyContainer.addChild(galaxy);
			
			galaxy.blendMode = model.currentEffect();
			controller.setGalaxyMatrix();
			controller.setGalaxyAlpha();
			model.switchingGalaxy = false;
		}
		private function changeEffect(e:Event):void {
			if(galaxy)galaxy.blendMode = model.currentEffect();
		}
		
		
		
		private function rotatorClicked(en:Boolean):void
		{
			effectPreviews.mouseEnabled = !en;
			effectPreviews.mouseChildren = !en;
			effectPreviews.visible = !en;
			cosmicPreviews.mouseEnabled = !en;
			cosmicPreviews.mouseChildren = !en;
			cosmicPreviews.visible = !en;
			imageEditing.mouseChildren = !en;
			imageEditing.mouseEnabled = !en;
			imageEditing.visible = !en;
			saveBtn.visible = !en;
			returnBtn.visible = !en;
			effectPreviews.visibleContents = !en;
			if(!en){
				imageEditing.visibleContents = false;
			}
		}
		
		private function hideRest(e:MouseEvent):void {
		}
		
		
		
		
		private function drawRect(tgt:Sprite):void {
			var gfx:Graphics = tgt.graphics;
			gfx.beginFill(0x123456);
			gfx.drawRect(0, 0, model.thumbWidth, model.stageHeight );
			gfx.endFill();
			tgt.alpha = 0;
		}
		
		
		private function stageResize(e:Event = null):void {
			galaxyContainer.x = model.stageWidth / 2;
			galaxyContainer.y = model.stageHeight / 2;
			userImageContainer.x = model.stageWidth / 2;
			userImageContainer.y = model.stageHeight / 2;
			
			effectPreviews.x = model.stageWidth;
			effectPreviews.y = model.stageHeight / 2;
			
			var gfx:Graphics = touchSensitive.graphics;
			gfx.clear();
			gfx.beginFill(0x123456);
			gfx.drawRect(0,0,model.stageWidth, model.stageHeight );
			gfx.endFill();
			
			cosmicPreviews.y = model.stageHeight - ( 100*model.globalScale );

			returnBtn.x = ( 10 * model.globalScale );
			returnBtn.y = ( 10 * model.globalScale );
			
			saveBtn.x = model.stageWidth - saveBtn.width + ( 10 * model.globalScale);
			saveBtn.y = ( 10 * model.globalScale );

			imageEditing.stageResize();
			cosmicPreviews.stageResize();
		}
		
		
	}
}