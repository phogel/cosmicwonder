package de.codekommando.cosmicwonder.views.editor2
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
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
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
		
		
		private var onComplete:Function;
		public function init(tgt:DisplayObject, sensitiveMC:DisplayObject, completeCall:Function):void
		{
			this.rotar = sensitiveMC;
			this.targetMC = tgt;
			this.onComplete = completeCall;
			this.USEMOUSE = model.USEMOUSE;
			if(USEMOUSE){
				rotar.addEventListener(MouseEvent.MOUSE_DOWN, rotar_touchStart);
			} else {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				rotar.addEventListener(TouchEvent.TOUCH_BEGIN, rotar_touchStart);
			}
		}
		public function unload():void{
			if(USEMOUSE){
				rotar.removeEventListener(MouseEvent.MOUSE_DOWN, rotar_touchStart);
			}else{
				rotar.removeEventListener(TouchEvent.TOUCH_BEGIN, rotar_touchStart);
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
		
		private var lastpress:int = 0;
		
		private var firstTouchEvent:TouchEvent;
		private var secondTouchEvent:TouchEvent;
		private var initialDistance:Number;
		private var initialPixelDistance:Number;
		private var originalScale:Number = 1;
		
		protected function rotar_touchStart(e:*):void {
			trace('rotarTouchStart');
			clearInterval(clearint);
			
			targetMC = model.editingGalaxy ? model.currentGalaxyStage : model.userBitmap;
			if(USEMOUSE){
				initMoveFollow(e);
				firstPress = new Point(e.stageX, e.stageX);
				rotar.addEventListener(MouseEvent.MOUSE_UP, rotar_touchEnd);
				rotar.addEventListener(MouseEvent.MOUSE_OUT, rotar_touchEnd);
			}else{
				if(e.isPrimaryTouchPoint){
					initMoveFollow(e);
					firstPress = new Point(e.stageX, e.stageY);
					firstTouchEvent = e;
					rotar.addEventListener(TouchEvent.TOUCH_END, rotar_touchEnd);
					rotar.addEventListener(TouchEvent.TOUCH_ROLL_OUT, rotar_touchEnd);
				}else if(pressId == -1){
					pressPoint2 = new Point(e.stageX,e.stageY);
					secondTouchEvent = e;
					pressId = e.touchPointID;
					initialDistance = getDistance();
					initialPixelDistance = getPixelDistance();
					if(targetMC.parent)
					{
						originalScale = targetMC.parent.scaleX;
					}
				}
			}
		}
		protected function initMoveFollow(e:*):void {
			
			lastpress = new Date().time;
			
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
					firstTouchEvent = e;
					//if(pressId == -1)
					//{
						followMouse(e);
					//}
				}else if(e.touchPointID == pressId){
					secondTouchEvent = e;
					/*
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
					*/
					
					var distance:Number = (initialPixelDistance - getPixelDistance()) * -1;
					//trace('add to scale: ' + ( distance / 100) );
					
					if(targetMC.parent){
						//targetMC.parent.scaleY += (distance / 100);
						targetMC.parent.scaleY = originalScale + (distance / 100);
						if(targetMC.parent.scaleY > 2.5){
							targetMC.parent.scaleY = 2.5;
						}
						targetMC.parent.scaleX = targetMC.parent.scaleY;
					}
					

				}
			}
		}
		protected function followMouse(e:*):void {
			
			targetMC.parent.x -= lastMouseX - e.localX;
			targetMC.parent.y -= lastMouseY - e.localY;
			
			lastMouseX = e.localX;
			lastMouseY = e.localY;
		}
		
		private var clearint:int = 0;
		public function rotar_touchEnd(e:*):void {
			if(USEMOUSE){
				rotar.removeEventListener(MouseEvent.MOUSE_MOVE, rotar_touchMove);
				rotar.removeEventListener(MouseEvent.MOUSE_UP, rotar_touchEnd);
				rotar.removeEventListener(MouseEvent.MOUSE_OUT, rotar_touchEnd);
				completeTimeout();
			}else{
				if(e.isPrimaryTouchPoint){
					rotar.removeEventListener(TouchEvent.TOUCH_END, rotar_touchEnd);
					rotar.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, rotar_touchEnd);
					rotar.removeEventListener(TouchEvent.TOUCH_MOVE, rotar_touchMove);
					completeTimeout();
				}
			}
			pressId = -1;
			
		}
		
		
		protected function completeTimeout():void {
			//trace('completeTimeout');
			//clearInterval(clearint);
			//clearint = setInterval(completeHandler, 1000);
			var nowpress:int = new Date().time;
			
			if(nowpress - lastpress < 150)
			{
				completeHandler();
			}
			
		}
		
		protected function completeHandler():void
		{
			trace('completeHandler');
			clearInterval(clearint);
			unload();
			onComplete();
		}
		
		
		private function getDistance():Number {
			return Math.sqrt( ( firstTouchEvent.stageX - secondTouchEvent.stageX ) * ( firstTouchEvent.stageX - secondTouchEvent.stageX ) + ( firstTouchEvent.stageY - secondTouchEvent.stageY ) * ( firstTouchEvent.stageY - secondTouchEvent.stageY ) );
		}
		private function getPixelDistance():Number {
			return ((getDistance() * initialDistance) / (model.longerEnd * 2));
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