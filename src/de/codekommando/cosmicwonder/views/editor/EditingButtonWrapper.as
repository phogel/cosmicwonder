package de.codekommando.cosmicwonder.views.editor
{
	import flash.display.MovieClip;
	
	public class EditingButtonWrapper extends MovieClip {
		public var mc:*;
		public function EditingButtonWrapper(_mc:*) {
			mc = _mc;
			addChild(mc);
			super();
		}
		
		public function reset():void {
			mc.indicator.alpha = 0.5;
		}
		public function pressed():void {
			if(mc.indicator.alpha < 1){
				mc.indicator.alpha += 0.25;
			} else {
				mc.indicator.alpha = 0.25;
			}
		}
		public function get value():Number {
			return mc.indicator.alpha;
		}
		public function set active(ok:Boolean):void {
			mc.indicator.alpha = ok ? 1 : 0;
			this.alpha = ok ? 1 : 0.6;
		}
		public function get active():Boolean {
			return mc.indicator.alpha > 0;
		}
	}
}