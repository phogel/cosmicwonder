package de.codekommando.cosmicwonder.infrastructure
{
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import flash.display.DisplayObject;

	public class Effector
	{
		public function Effector()
		{
		}
		
		private static var inited:Boolean =  false;
		public static function darken(obj:DisplayObject, on:Boolean = true):void {
			if(!inited){
				ColorShortcuts.init();
				inited = true;
			}
			if(on){
				//trace('switch ' + obj.name + ' on');
				Tweener.addTween(obj, {_brightness:-0.5, time:0.5});
			}else{
				//trace('switch ' + obj.name + ' off');
				Tweener.addTween(obj, {_brightness:0, time:0.5});
			}
		}
	}
}