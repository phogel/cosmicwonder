package de.codekommando.cosmicwonder.views
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ResponsiveButton extends Sprite
	{
		
		
		public function ResponsiveButton()
		{
			TweenPlugin.activate([ColorMatrixFilterPlugin]);
			addEventListener(MouseEvent.MOUSE_DOWN, animateDown);
			super();
		}
		
		protected function animateDown(e:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_UP, animateUp);
			TweenLite.to(this, 0, {colorMatrixFilter:{brightness:0.6} });
		}
		protected function animateUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, animateUp);
			TweenLite.to(this, 0, {colorMatrixFilter:{brightness:1} });
		}
		
		
	}
}