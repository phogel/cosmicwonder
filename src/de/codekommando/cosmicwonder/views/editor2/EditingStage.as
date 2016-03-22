package de.codekommando.cosmicwonder.views.editor2
{
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	public class EditingStage extends AbstractSprite
	{
		
		public static var EDIT_COMPLETE:String = "editComplete";
		
		private var userImageContainer:Sprite = new Sprite();
		public var editorContainer:Sprite = new Sprite();
		private var galaxyContainer:Sprite = new Sprite();
		private var userImage:Bitmap;
		private var galaxy:GalaxyImage;
		
		private var bitmapRepresentation:Bitmap;
		
		public function EditingStage()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(editorContainer);
			
			editorContainer.name="editorContainer";
			galaxyContainer.name="galaxyContainer";
			userImageContainer.name="userImageContainer";
			
			editorContainer.addChild(userImageContainer);
			editorContainer.addChild(galaxyContainer);
			
		}
		
		override public function readyForLoad():void {
			controller.addEventListener("stageResize", stageResize);
			
			model.addEventListener('newUserBitmap', insertBitmap);
			model.addEventListener('galaxyChange', insertGalaxy);
			model.addEventListener('effectChange', changeEffect);
			
			this.mouseEnabled = this.mouseChildren = true;
		}
		
		private var rotator:TouchRotationMover = new TouchRotationMover();
		public function editMode(sensitiveArea:DisplayObject):void
		{
			trace('editMode');
			destroyBitmapRepresentation();
			rotator.init(
				galaxyContainer, sensitiveArea, endEditMode
			);
		}
		
		public function endEditMode(sendEvent:Boolean = true):void
		{
			//trace('endEditMode');
			createBitmapRepresentation();
			rotator.unload();
			if(sendEvent){
				dispatchEvent(new Event( EDIT_COMPLETE ));
			}
		}
		
		
		/**
		 * 
		 * ERASE MODE
		 * 
		 */
		private var drawn:Bitmap;
		private var brush:Sprite;
		private var gfx:Graphics;
		private var area:DisplayObject;
		private var _wdth:int = 200;
		private var wdth:int = 200;
		private var mtrx:Matrix = new Matrix;
		public function eraseMode(_area:DisplayObject):void {
			destroyBitmapRepresentation();
			area = _area;
			
			brush = new Sprite;
			brush.cacheAsBitmap = true;
			gfx = brush.graphics;
			wdth = _wdth * model.globalScale;
			
			area.addEventListener(MouseEvent.MOUSE_DOWN, eraseMyself);
			area.addEventListener(MouseEvent.MOUSE_UP, restoreMyself);
		}
		private var drawTimer:Timer;
		private function eraseMyself(e:MouseEvent):void {
			drawTimer = new Timer(100);
			drawTimer.addEventListener(TimerEvent.TIMER, readicate);
			drawTimer.start();
			//area.addEventListener(MouseEvent.MOUSE_MOVE, readicate);
			//trace(galaxy.x, galaxy.y, galaxyContainer.x, galaxyContainer.y);
		}
		private function readicate(e:TimerEvent):void {
			gfx.clear();
			gfx.beginGradientFill(GradientType.RADIAL, [0xfff000,0xffffff], [0.1,0],[0,255], mtrx);
			mtrx.createGradientBox(wdth,wdth,0,mouseX-(wdth/2)+(galaxyContainer.x/2),mouseY-(wdth/2));
			gfx.drawCircle(mouseX+(galaxyContainer.x/2),mouseY,width/2);
			gfx.endFill();
			galaxy.bitmap.bitmapData.draw( brush, null, null, BlendMode.ERASE, null, true);
		}
		private function restoreMyself(e:MouseEvent):void {
			//area.removeEventListener(MouseEvent.MOUSE_MOVE, readicate);
			drawTimer.removeEventListener(TimerEvent.TIMER,readicate);
			drawTimer.stop();
		}
		public function endEraseMode():void {
			area.removeEventListener(MouseEvent.MOUSE_DOWN, eraseMyself);
			drawTimer.removeEventListener(TimerEvent.TIMER,readicate);
			drawTimer.stop();
			drawTimer = null;
			area.removeEventListener(MouseEvent.MOUSE_UP, restoreMyself);
			brush = null;
			gfx = null;
			area = null;
			createBitmapRepresentation();
			//dispatchEvent(new Event( EDIT_COMPLETE ));
		}
		
		private function destroyBitmapRepresentation():void
		{
			//trace('destroyBitmapRepresentation');
			editorContainer.visible = true;
			if(bitmapRepresentation){
				if(bitmapRepresentation.stage)
				{
					removeChild(bitmapRepresentation)
				}
				bitmapRepresentation.bitmapData.dispose();
			}
		}
		public function createBitmapRepresentation():void
		{
			//trace('createBitmapRepresentation');
			destroyBitmapRepresentation();
			
			var bmd:BitmapData = new BitmapData(model.stageWidth, model.stageHeight, false, 0);
			bmd.draw(editorContainer);
			bitmapRepresentation = new Bitmap( bmd );
			bmd = null;
			addChild(bitmapRepresentation);
			
			editorContainer.visible = false;
		}
		
		
		
		override public function unload():void {
			controller.removeEventListener("stageResize", stageResize);
			
			model.removeEventListener('newUserBitmap', insertBitmap);
			model.removeEventListener('galaxyChange', insertGalaxy);
			model.removeEventListener('effectChange', changeEffect);
			
			destroyBitmapRepresentation();
			
			if(userImage){
				userImageContainer.removeChild(userImage)
				userImage.bitmapData.dispose();
			}
			userImage = null;
			if(galaxy) {
				galaxyContainer.removeChild(galaxy);
				galaxy.removeEventListener(Event.COMPLETE, galaxyLoaded);
			}
			galaxy = null;
			
			this.mouseEnabled = this.mouseChildren = true;
		}
		
		
		private function insertBitmap(e:Event):void
		{
			if(userImage)
			{
				userImage.bitmapData.dispose();
				userImageContainer.removeChild(userImage);
			}
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
			
			if(!galaxy){
				insertGalaxy();
			}
			stageResize();
		}
		private function insertGalaxy(e:Event = null):void {
			if(galaxy)
			{
				galaxyContainer.removeChild(galaxy);
			}
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
			
			if(!galaxy.loaded) {
				galaxy.addEventListener(Event.COMPLETE, galaxyLoaded);
			} else {
				createBitmapRepresentation();
			}
		}
		
		private function galaxyLoaded(e:Event):void
		{
			galaxy.removeEventListener(Event.COMPLETE, galaxyLoaded);
			createBitmapRepresentation();
		}
		
		
		private function changeEffect(e:Event):void {
			if(galaxy)galaxy.blendMode = model.currentEffect();
			galaxy.x += 1;
			galaxy.x -= 1;
			createBitmapRepresentation();
		}
		
		override protected function stageResize(e:Event = null):void {
			galaxyContainer.x = model.stageWidth / 2;
			galaxyContainer.y = model.stageHeight / 2;
			userImageContainer.x = model.stageWidth / 2;
			userImageContainer.y = model.stageHeight / 2;
			
			createBitmapRepresentation();
		}
	}
}