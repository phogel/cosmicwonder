package de.codekommando.cosmicwonder.views.gallery {
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.views.CosmicTextWrapper;
	import de.codekommando.cosmicwonder.views.CustomButton;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class StatusScreen extends Sprite {
		
		private var msg:CosmicTextWrapper;
		
		private var model:WonderModel = WonderModel.getInstance();
		
		private var okbtn:CustomButton;
		private var cancelbtn:CustomButton;
		
		private var sprites:Sprite = new Sprite();
		
		public function StatusScreen(){
			super();
			ColorShortcuts.init();
			
			msg = new CosmicTextWrapper("");
			msg.scaleX = msg.scaleY = (0.5 * model.globalScale);
			sprites.addChild(msg);

			okbtn = new CustomButton(Languages.OK);
			okbtn.bgcolor( 0xff3333, 0.6);
			okbtn.name = "okbtn";
			okbtn.mouseChildren = false;
			
			cancelbtn = new CustomButton(Languages.CANCEL);
			cancelbtn.name = "cancelbtn";
			cancelbtn.mouseChildren = false;
			
			
			
			cancelbtn.scaleX = okbtn.scaleX = cancelbtn.scaleY = okbtn.scaleY = (0.8 * model.globalScale);
			
			okbtn.y = cancelbtn.y = msg.y + (60 * model.globalScale);
			sprites.addChild(okbtn);
			sprites.addChild(cancelbtn);
			
			addChild(sprites);
			stageResize();
		}
		
		public function set message(s:String):void {
			this.visible = s != "";
			msg.text = s;
			showButtons = false;
			stageResize();
		}
		public function set showButtons(b:Boolean):void {
			okbtn.visible = cancelbtn.visible = b;
		}
		
		
		public function stageResize():void {
			okbtn.x = Math.round((msg.width - okbtn.width - cancelbtn.width) / 2);
			cancelbtn.x = okbtn.x + okbtn.width + (10 * model.globalScale);
			
			sprites.x = (model.stageWidth - sprites.width) / 2;
			sprites.y = (model.stageHeight - (sprites.height * model.globalScale)) / 2;
			var gfx:Graphics = this.graphics;
			graphics.clear();
			gfx.beginFill(0x000000, 0.5);
			gfx.drawRect(0,0,model.stageWidth,model.stageHeight);
			gfx.endFill();
		}
		
		
	}
}