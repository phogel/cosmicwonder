package de.codekommando.cosmicwonder.views.editor
{
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Circ;
	import com.greensock.plugins.*;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Effector;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class ImageEditing2 extends Sprite
	{
		private var model:WonderModel = WonderModel.getInstance();
		private var controller:WonderController = WonderController.getInstance();
		
		private var contrast:EditingButtonWrapper;
		private var brightness:EditingButtonWrapper;
		private var alpha2:EditingButtonWrapper;
		private var rotation2:EditingButtonWrapper;
		private var image:EditingButtonWrapper;
		private var galaxy:EditingButtonWrapper;
		private var blur:EditingButtonWrapper;
		
		private var buttons:Sprite = new Sprite();
		private var ss:SettingsSprite = new SettingsSprite();
		
		public function ImageEditing2() {
			super();
			FilterShortcuts.init();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			contrast = makeButtonOutOf(new ContrastBtn, "contrast");
			brightness = makeButtonOutOf(new BrighterLayer,"brightness");
			alpha2 = makeButtonOutOf(new AlphaBtn,"alpha2");
			rotation2 = makeButtonOutOf(new RotateBtn,"rotation2");
			blur = makeButtonOutOf(new BlurBtn, "blur");
			addChild(buttons);
			
			image = makeButtonOutOf(new ImageBtn, "galaxy", false);
			galaxy = makeButtonOutOf(new GalaxyBtn, "portrait", false);
			ImageBtn(image.mc).title.text = Languages.IMAGE.toUpperCase();
			addChild(image);
			GalaxyBtn(galaxy.mc).title.text = Languages.GALAXY.toUpperCase();
			addChild(galaxy);
			
			Tweener.addTween(buttons, {_DropShadow_blurX:10, _DropShadow_blurY:10, _DropShadow_distance:3, _DropShadow_alpha:0.5, _DropShadow_inner:true});
			Tweener.addTween(image, {_DropShadow_blurX:10, _DropShadow_blurY:10, _DropShadow_distance:3, _DropShadow_alpha:0.5, _DropShadow_inner:true});
			Tweener.addTween(galaxy, {_DropShadow_blurX:10, _DropShadow_blurY:10, _DropShadow_distance:3, _DropShadow_alpha:0.5, _DropShadow_inner:true});
			//buttons.scaleX = buttons.scaleY = model.globalScale;
			generatePositions();
			
			stageResize();
			
			visibleContents = false;
		}
		private function makeButtonOutOf(itm:*, nm:String, autoAdd:Boolean = true):EditingButtonWrapper {
			var btn:EditingButtonWrapper = new EditingButtonWrapper(itm);
			btn.reset();
			btn.cacheAsBitmap = true;
			btn.mouseChildren = false;
			btn.name = nm;
			btn.scaleX = btn.scaleY = model.globalScale;
			btn.addEventListener( MouseEvent.MOUSE_DOWN, btnClicked );
			if(autoAdd){
				buttons.addChild(btn);
			}
			return btn;
		}
		private function generatePositions():void {
			var point:Point;
			buttons.graphics.lineStyle(2, 0x00CCFF, 1);
			for(var i:int = 0; i < buttons.numChildren; i++){
				var tgt:EditingButtonWrapper = buttons.getChildAt(i) as EditingButtonWrapper;
				tgt.y = ( i % 2 ? 50 * model.globalScale : 0 );
				tgt.x = ( i * (90 * model.globalScale));
				
				if(point){
					buttons.graphics.moveTo(point.x,point.y);
					buttons.graphics.lineTo(tgt.x, tgt.y);
				}
				point = new Point(tgt.x, tgt.y);
			}
		}
		private function overlapping(childId:int):Boolean {
			if(childId >= buttons.numChildren){
				return true;
			}
			for(var i:int = 0; i < buttons.numChildren; i++){
				if(i != childId){
					if(
						buttons.getChildAt(i).hitTestObject(buttons.getChildAt(childId))
						|| this.image.hitTestObject(buttons.getChildAt(childId))
						|| this.galaxy.hitTestObject(buttons.getChildAt(childId))
					) {
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function readyForLoad():void {
			showCurrentEditTarget();
			visibleContents = false;
		}
		
		
		private function btnClicked( e:MouseEvent ):void {
			var ct:EditingButtonWrapper = e.currentTarget as EditingButtonWrapper;
			switch (ct) {
				case galaxy:
				case image:
					controller[ct.name]();
					showCurrentEditTarget();
				break;
				case contrast:
				case brightness:
				case alpha2:
					if(!model.settingMatrix){
						ct.pressed();
						trace('vlaue: ' + ct.value)
						controller[ct.name](ct.value);
					}
					break;
				case blur:
				case rotation2:
					ct.pressed();
					controller[ct.name](ct.value-0.25);
					break;
			}
		}
		private function hideEvent():void {
			dispatchEvent(new Event('hideMe'));
		}
		
		
		private function showCurrentEditTarget():void {
			galaxy.active = model.editingGalaxy;
			image.active = !model.editingGalaxy;
			if((galaxy.active && model.editingGalaxy && buttons.visible) || (image.active && !model.editingGalaxy && buttons.visible)) {
				buttons.visible = false;
			} else {
				buttons.visible = true;
			}
			
			buttons.y = model.editingGalaxy ? galaxy.y : image.y;
		}
		private function makeEnabled(tgt:DisplayObjectContainer):void {
			tgt.mouseEnabled = true;
		}
		
		
		public function set visibleContents(v:Boolean):void {
			buttons.visible = v;
		}
		public function get visibleContents():Boolean {
			return buttons.visible;
		}
		
		
		public function stageResize():void {
			image.y = (model.stageHeight - image.height) / 2;
			galaxy.y = image.y + image.height;
			image.x = galaxy.x = (50 * model.globalScale);
			buttons.x = image.x + (100 * model.globalScale);
			buttons.y = (model.editingGalaxy ? galaxy.y : image.y) - (100 * model.globalScale);
		}
		
	}
}