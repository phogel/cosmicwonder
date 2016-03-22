package de.codekommando.cosmicwonder.views.editor2
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import de.codekommando.cosmicwonder.views.parts.Shadow;
	import de.codekommando.cosmicwonder.views.parts.Triangle;

	public class PreviewScroller extends AbstractSprite
	{
		
		
		protected var views:Sprite = new Sprite();
		protected var viewArray:Array;
		protected var bg:Sprite;
		
		protected var shadow:Shadow;
		
		public function PreviewScroller()
		{
			super();
			
			bg = new Sprite();
			addChild(bg);
			
			bg.graphics.beginFill(0);
			bg.graphics.drawRect(0,0, model.thumbWidth, model.thumbWidth);
			bg.graphics.endFill();
			
			bg.addEventListener(MouseEvent.MOUSE_UP, touchOut);
			views.addEventListener(MouseEvent.MOUSE_DOWN, touchIn);
			
			addChild(views);
			
			shadow = new Shadow();
			addChild(shadow);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stageResize();
		}
		
		
		protected var originMouseY:int = 0;
		protected var lastMouseY:int = 0;
		protected var lastIntervalMouseY:int = 0;
		protected var intarval:int = 0;
		
		
		protected function touchIn(e:MouseEvent):void
		{
			lastMouseY = mouseY;
			lastIntervalMouseY = mouseY;
			originMouseY = stage.mouseY;
			killSnapper();
			addEventListener(Event.ENTER_FRAME, followMouse);
			clearInterval(intarval);
			intarval = setInterval(acceleratorizor, 50);
		}
		
		protected function touchOut(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, followMouse);
			clearInterval(intarval);
			addEventListener(Event.ENTER_FRAME, snapperRock);
		}
		
		protected function snapperRock(e:Event):void
		{
			if(acceleration > 60) { acceleration = 60; }
			acceleration /= 1.16;
			moveYTo(acceleration);
			if(acceleration < 0.4 && acceleration > -0.4)
			{
				acceleration = 0;
				killSnapper();
			}
		}
		protected function killSnapper():void
		{
			clearInterval(intarval);
			removeEventListener(Event.ENTER_FRAME, followMouse);
			removeEventListener(Event.ENTER_FRAME, snapperRock);
		}
		
		protected function acceleratorizor():void {
			acceleration = lastIntervalMouseY - mouseY;
			lastIntervalMouseY = mouseY;
			trace('acceleretaroizer: ' + acceleration);
		}
		
		
		protected var acceleration:Number = 0;
		
		protected var currentActive:int = 0;
		protected function followMouse(e:Event):void {
			moveYTo( lastMouseY - mouseY );
			lastMouseY = mouseY;
		}
		
		protected function moveYTo(dir:int):void
		{
			if(this.y - dir < 0 && this.y - dir > (this.height * -1) + model.stageHeight)
			{
				this.y -= dir;
				this.y = int(this.y);
			}
		}
		
		override protected function stageResize(e:Event=null):void
		{
			if(this.y < (this.height * -1) + model.stageHeight)
			{
				this.y = (this.height * -1) + model.stageHeight;
			}
			bg.height = shadow.height = model.stageHeight;
		}
		
		
		override public function set y(value:Number):void
		{
			views.y = value;
			
			var p:Point;
			var dispo:DisplayObject;
			for(var i:int = 0; i < viewArray.length; i++)
			{
				dispo = viewArray[i];
				p = dispo.localToGlobal( new Point(0, 0) );
				//trace('item' + i + ': ' + p.y + ' ' + dispo.y);
				dispo.visible = p.y > -model.thumbWidth && p.y < model.stageHeight;
			}
		}
		
		override public function get y():Number {
			return views.y;
		}
		
		override public function get height():Number
		{
			return viewArray.length * (model.thumbWidth + model.space);
		}
	}
}