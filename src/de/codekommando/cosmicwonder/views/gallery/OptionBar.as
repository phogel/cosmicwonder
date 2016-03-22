package de.codekommando.cosmicwonder.views.gallery
{
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.views.CustomButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class OptionBar extends Sprite
	{
		public var returnBtn:CustomButton;
		
		
		public function OptionBar(){
			
			returnBtn = new CustomButton( Languages.BACK );
			returnBtn.name = "returnBtn";
			returnBtn.mouseChildren = false;
			returnBtn.scaleX = returnBtn.scaleY = (0.7 * WonderModel.getInstance().globalScale);
			returnBtn.y = returnBtn.x = (10 * WonderModel.getInstance().globalScale);
			addChild(returnBtn);
			
			super();
			
		}
	}
}