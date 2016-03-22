package de.codekommando.cosmicwonder.views
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	public class ResponsiveBitmapButton extends ResponsiveButton
	{
		
		protected var upstate:Bitmap;
		protected var downstate:Bitmap;
		
		public function ResponsiveBitmapButton()
		{
			super();
		}
		override protected function animateDown(e:MouseEvent):void{
			stage.addEventListener(MouseEvent.MOUSE_UP, animateUp);
			
			if(!upstate)
			{
				upstate = new Bitmap( new BitmapData(this.width,this.height), "always" );
				upstate.bitmapData.draw(this);
				deleteAllExceptBitmaps();
			}
			
			if(!downstate){
				TweenLite.to(this, 0, {colorMatrixFilter:{brightness:0.6} });
				downstate = new Bitmap();
				downstate.bitmapData = new BitmapData(this.width,this.height);
				downstate.bitmapData.draw(this);
				deleteAllExceptBitmaps();
			} else {
				downstate.visible = true;
			}
		}
		override protected function animateUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, animateUp);
			
			if(downstate){
				downstate.visible = false;
			}
		}
		private function deleteAllExceptBitmaps():void
		{
			while(numChildren > 0){
				removeChildAt(0);
			}
			if(upstate){
				addChild(upstate);
			}
			if(downstate){
				addChild(downstate);
			}
		}
	}
}