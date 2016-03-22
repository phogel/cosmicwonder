package de.codekommando.cosmicwonder.views.editor2
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.FilterShortcuts;
	
	import de.codekommando.cosmicwonder.views.editor.EditingButtonWrapper;
	import de.codekommando.cosmicwonder.views.parts.Shadow;

	public class EditingButtons extends AbstractSprite
	{
		
		public static var EDITING_STAGE:String = "rerenderEditingStage";
		
		private var contrast:EditingButtonWrapper;
		private var brightness:EditingButtonWrapper;
		private var alpha2:EditingButtonWrapper;
		private var rotation2:EditingButtonWrapper;
		private var image:EditingButtonWrapper;
		private var galaxy:EditingButtonWrapper;
		private var blur:EditingButtonWrapper;
		private var move:EditingButtonWrapper;
		private var erase:EditingButtonWrapper;
		
		private var buttons:Sprite;
		private var ss:SettingsSprite = new SettingsSprite();
		public var clickTargetName:String = "";
		
		private var bg:Shape;
		
		private var shd:Sprite;
		
		public function EditingButtons()
		{
			super();
			FilterShortcuts.init();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bg = new Shape;
			addChild(bg);
			
			buttons  = new Sprite();
			contrast = makeButtonOutOf(new ContrastBtn, "contrast");
			brightness = makeButtonOutOf(new BrighterLayer,"brightness");
			alpha2 = makeButtonOutOf(new AlphaBtn,"alpha2");
			rotation2 = makeButtonOutOf(new RotateBtn,"rotation2");
			blur = makeButtonOutOf(new BlurBtn, "blur");
			addChild(buttons);

			shd = new Shadow();
			shd.height = model.longerEnd;
			shd.y = shd.width;
			shd.rotation = 270;
			shd.x = model.longerEnd / -2;
			addChild(shd);
			shd.mouseChildren = shd.mouseEnabled = false;
			
			
			image = makeButtonOutOf(new ImageBtn, "galaxy", false);
			galaxy = makeButtonOutOf(new GalaxyBtn, "portrait", false);
			move = makeButtonOutOf( new MoveBtn, "move", false);
			erase = makeButtonOutOf( new EraseBtn, "erase", false);
			
			//ImageBtn(image.mc).title.text = Languages.IMAGE.toUpperCase();
			addChild(image);
			
			//GalaxyBtn(galaxy.mc).title.text = Languages.GALAXY.toUpperCase();
			addChild(galaxy);
			addChild(move);
			addChild(erase);
			
			/*var minorScale:Number = model.globalScale;
			trace('scale buttons to ' + minorScale);
			move.scaleX = move.scaleY = image.scaleY = image.scaleX = galaxy.scaleX = galaxy.scaleY -= minorScale;
			*/
			move.y = galaxy.y = image.y = (-image.height/2) - ( 20 * model.globalScale );
			move.active = move.mouseChildren = false;
			erase.active = erase.mouseChildren = false;
			erase.y = move.y;
			
			buttons.x = buttons.width / -2;
			buttons.y = contentHeight / 2;
			
			Tweener.addTween(buttons, {_DropShadow_blurX:10, _DropShadow_blurY:10, _DropShadow_distance:3, _DropShadow_alpha:0.5, _DropShadow_inner:true});
			Tweener.addTween(image, {_DropShadow_blurX:10, _DropShadow_blurY:10, _DropShadow_distance:3, _DropShadow_alpha:0.5, _DropShadow_inner:true});
			Tweener.addTween(galaxy, {_DropShadow_blurX:10, _DropShadow_blurY:10, _DropShadow_distance:3, _DropShadow_alpha:0.5, _DropShadow_inner:true});
			
			showCurrentEditTarget();
			
			stageResize();
		}
		
		override public function readyForLoad():void {
			super.readyForLoad();
			stageResize();
		}
		
		public function set showme(tf:Boolean):void {
			buttons.visible = tf;
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
					if(!model.settingMatrix){ // dont do the same thing five million times
						ct.pressed();
						trace('vlaue: ' + ct.value)
						controller[ct.name](ct.value);
					}
					renderEvent();
					break;
				case blur:
				case rotation2:
					ct.pressed();
					controller[ct.name](ct.value-0.25);
					renderEvent();
					break;
				case move:
				case erase:
					clickTargetName = e.currentTarget.name;
					break;
			}
		}
		
		private function renderEvent():void
		{
			dispatchEvent( new Event( EDITING_STAGE ) );
		}
		
		private function showCurrentEditTarget():void {
			galaxy.active = model.editingGalaxy;
			image.active = !model.editingGalaxy;
			/*if((galaxy.active && model.editingGalaxy && buttons.visible) || (image.active && !model.editingGalaxy && buttons.visible)) {
				buttons.visible = false;
			} else {
				buttons.visible = true;
			}*/
		}
		private function makeEnabled(tgt:DisplayObjectContainer):void {
			tgt.mouseEnabled = true;
		}
		
		public function set galaxyImageSelectorVisibility(value:Boolean):void {
			if(value) {
				TweenLite.to( image, 0.1, {x:imageXIn} );
				TweenLite.to( galaxy, 0.1, {x:galaxyXIn} );
			} else {
				TweenLite.to( image, 0.1, {x:imageXOut} );
				TweenLite.to( galaxy, 0.1, {x:galaxyXOut} );
			}
		}
		public function set moveVisibility(value:Boolean):void {
			TweenLite.to( move, 0.1, {x: value ? moveIn : moveOut } );
			TweenLite.to( erase, 0.1, {x: value ? moveIn - erase.width : moveOut - erase.width } );
		}
		
		
		override protected function stageResize(e:Event=null):void
		{
			bg.graphics.clear();
			bg.graphics.beginFill(0);
			bg.graphics.drawRect(0,0,model.stageWidth + (10 * model.gap), contentHeight);
			bg.graphics.endFill();
			bg.x = bg.width / -2;
			
			TweenLite.killTweensOf(image);
			TweenLite.killTweensOf(galaxy);
			TweenLite.killTweensOf(move);
			
			move.x = moveIn;
			erase.x = moveIn - erase.width;
			galaxy.x = galaxyXOut;
			image.x = imageXOut;
		}
		
		protected function get moveIn():int {
			return (model.stageWidth / 2) - (move.width / 2) - model.gap;
		}
		protected function get moveOut():int {
			return (model.stageWidth / 2) + (move.width * 2);
		}
		protected function get galaxyXIn():int {
			return (model.stageWidth / -2) + (galaxy.width / 2) + model.gap;
		}
		protected function get imageXIn():int {
			return galaxyXIn + galaxy.width + model.gap;
		}
		protected function get galaxyXOut():int {
			return imageXOut - galaxy.width - model.gap;
		}
		protected function get imageXOut():int {
			return (model.stageWidth / -2) - image.width - model.thumbWidth;
		}
		
		private var _state:String = "idle";
		public function get state():String {
			return _state;
		}
		public function set state(value:String):void {
			_state = value;
			move.active = value == "move";
			erase.active = value == "erase";
			if(state == "erase"){
				erase.x = move.x;
				move.visible = false;
				erase.visible = true;
			} else if(state == "move") {
				move.visible = true;
				erase.visible = false;
				erase.x = moveIn - erase.width;
			} else {
				erase.visible = move.visible = true;
				erase.x = moveIn - erase.width;
			}
			galaxyImageSelectorVisibility = state == "move";
			showme = state == "idle";
		}
		
		private var lx:int = 0;
		private function makeButtonOutOf(itm:*, nm:String, autoAdd:Boolean = true):EditingButtonWrapper {
			var btn:EditingButtonWrapper = new EditingButtonWrapper(itm);
			btn.reset();
			btn.cacheAsBitmap = true;
			btn.mouseChildren = false;
			btn.name = nm;
			btn.addEventListener( MouseEvent.MOUSE_DOWN, btnClicked );
			btn.height = (model.thumbWidth / 1.5);
			btn.scaleX = btn.scaleY;
			if(autoAdd){
				buttons.addChild(btn);
			}
			btn.x = (btn.width * lx) + (btn.width / 2);
			lx++;
			return btn;
		}
		
		public function get contentHeight():int {
			return model.thumbWidth / 1.5;
		}
	}
}