package de.codekommando.cosmicwonder.infrastructure
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ChildAdder extends EventDispatcher
	{
		public function ChildAdder(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		protected static var onComplete:Function;
		protected static var childs:Array;
		protected static var target:DisplayObjectContainer;
		public static function addChildrenTo(tgt:MovieClip, children:Array, complete:Function):void {
			target = tgt;
			childs = children;
			onComplete = complete;
			addNext();
		}
		
		
	}
}