package de.codekommando.cosmicwonder.infrastructure
{
	import avmplus.USE_ITRAITS;
	
	import caurina.transitions.Tweener;
	
	import de.codekommando.cosmicwonder.WonderModel;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class TouchRotationMover
	{
		
		
		private var USEMOUSE:Boolean;
		
		
		private var model:WonderModel;
		public function TouchRotationMover()
		{
			model = WonderModel.getInstance();
		}
		/* ============================
		
		R O T A T I O N T O U C H E S
		
		============================ */
		
		
		private var callOnActive:Function;
		public function init(tgt:DisplayObject, sensitiveMC:DisplayObject, activeCall:Function):void
		{
			this.rotar = sensitiveMC;
			this.targetMC = tgt;
			this.callOnActive = activeCall;
			this.USEMOUSE = model.USEMOUSE;
			if(USEMOUSE){
				rotar.addEventListener(MouseEvent.MOUSE_DOWN, rotar_touchStart);
			} else {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				rotar.addEventListener(TouchEvent.TOUCH_BEGIN, rotar_touchStart);
			}
		}
		
		
		private var initX:int = 0;
		private var initY:int = 0;
		private var lastMouseX:int = 0; 
		private var lastMouseY:int = 0;
		private var leftBounds:Number = 0;
		private var rightBounds:Number = 0;
		private var bottomBounds:Number = 0;
		private var topBounds:Number = 0;
		private var firstPress:Point = new Point();
		private var pressPoint2:Point = new Point();
		private var pressId:int = -1;
		
		public var targetMC:DisplayObject;
		public var rotar:DisplayObject;
		
		
		
		protected function rotar_touchStart(e:*):void {
			targetMC = model.editingGalaxy ? model.currentGalaxyStage : model.userBitmap;
			if(USEMOUSE){
				callOnActive(true);
				initMoveFollow(e);
				firstPress = new Point(e.stageX, e.stageX);
				rotar.addEventListener(MouseEvent.MOUSE_UP, rotar_touchEnd);
				rotar.addEventListener(MouseEvent.MOUSE_OUT, rotar_touchEnd);
			}else{
				if(e.isPrimaryTouchPoint){
					callOnActive(true);
					initMoveFollow(e);
					firstPress = new Point(e.stageX, e.stageY);
					rotar.addEventListener(TouchEvent.TOUCH_END, rotar_touchEnd);
					rotar.addEventListener(TouchEvent.TOUCH_ROLL_OUT, rotar_touchEnd);
				}else if(pressId == -1){
					pressPoint2 = new Point(e.stageX,e.stageY);
					pressId = e.touchPointID;
				}
			}
		}
		protected function initMoveFollow(e:*):void {
			initX = e.localX;
			initY = e.localY;
			lastMouseX = e.localX;
			lastMouseY = e.localY;
			
			leftBounds = (targetMC.width - model.stageWidth) * -1;
			rightBounds = 0;
			topBounds = (targetMC.height - model.stageHeight) * -1;
			bottomBounds = 0;
			
			if(USEMOUSE){
				rotar.addEventListener(MouseEvent.MOUSE_MOVE, rotar_touchMove);
			}else{
				rotar.addEventListener(TouchEvent.TOUCH_MOVE, rotar_touchMove);
			}
		}
		
		
		protected function rotar_touchMove(e:*):void { //TouchEvent
			if(USEMOUSE){
				followMouse(e);
			}else{
				if(e.isPrimaryTouchPoint){
					followMouse(e);
				}else if(e.touchPointID == pressId){
					
					var scaleFactor:Number = ((pressPoint2.y - e.stageY) / 200);

					
					if(targetMC.parent){
						targetMC.parent.scaleY += scaleFactor;
						if(targetMC.parent.scaleY > 2.5){
							targetMC.parent.scaleY = 2.5;
						}
						targetMC.parent.scaleX = targetMC.parent.scaleY;
					}

					pressPoint2.y = e.stageY;
					
					leftBounds = (targetMC.width - model.stageWidth) * -1;
					rightBounds = 0;
					topBounds = (targetMC.height - model.stageHeight) * -1;
					bottomBounds = 0;
					
				}
			}
		}
		protected function followMouse(e:*):void {
			
			targetMC.parent.x -= lastMouseX - e.localX;
			targetMC.parent.y -= lastMouseY - e.localY;
			
			lastMouseX = e.localX;
			lastMouseY = e.localY;
		}
		
		
		protected function rotar_touchEnd(e:*):void {
			if(USEMOUSE){
				callOnActive(false);
				rotar.removeEventListener(MouseEvent.MOUSE_MOVE, rotar_touchMove);
				rotar.removeEventListener(MouseEvent.MOUSE_UP, rotar_touchEnd);
				rotar.removeEventListener(MouseEvent.MOUSE_OUT, rotar_touchEnd);
			}else{
				if(e.isPrimaryTouchPoint){
					callOnActive(false);
					rotar.removeEventListener(TouchEvent.TOUCH_MOVE, rotar_touchMove);
				}
			}
			pressId = -1;
		}
		
		
		protected function updateScales():void {
			//wonderizer1.img2centered.scaleX = wonderizer2.img2centered.scaleX = wonderizer1.img2centered.scaleY = wonderizer2.img2centered.scaleY = wonderizer.img2centered.scaleX = wonderizer.img2centered.scaleY;
			//if(wonderizer.img2){
			//	wonderizer1.img2.x = wonderizer2.img2.x = wonderizer.img2.x;
			//	wonderizer1.img2.y = wonderizer2.img2.y = wonderizer.img2.y;
				//wonderizer1.img2.scaleX = wonderizer1.img2.scaleY = wonderizer2.img2.scaleX = wonderizer2.img2.scaleY = wonderizer.img2.scaleX;
				//wonderizer1.img1.scaleX = wonderizer1.img1.scaleY = wonderizer2.img1.scaleX = wonderizer2.img1.scaleY = wonderizer.img1.scaleX;
			//}
		}
	}
}