package de.codekommando.cosmicwonder.views.gallery
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ShareBar extends Sprite
	{
		
		private var model:WonderModel;
		private var controller:WonderController;
		
		//[Embed (source='bin-debug/bitmaps/IL_ShareJournaliPad.png')]
		//private var sharebtn:Class;
		
		private var sharebtn:ShareGraphic = new ShareGraphic();
		private var deletebtn:TrashGraphic = new TrashGraphic();
		
		
		private var shareitems:Sprite = new Sprite();
		private var sharedmask:Sprite = new Sprite();
		private var sharer:ShareButton;
		//private var facebook:ShareButton;
		private var cameraroll:ShareButton;
		private var reedit:ShareButton;
		
		public function ShareBar(){
			controller = WonderController.getInstance();
			model  = WonderModel.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//var shr:Bitmap = new sharebtn();
			var shr:ShareGraphic = sharebtn;
			shr.height = shr.width = model.galleryThumbWidth / 1.5;
			shr.x = (shr.width / 2) + model.space;
			
			trace('shr height: ' + shr.height + ' model.thumbwidth: ' + model.galleryThumbWidth);
			
			
			deletebtn.height = deletebtn.width = shr.height;
			shr.y = deletebtn.y = model.galleryThumbWidth / 2;
			deletebtn.name = "deletebtn";
			
			sharer = new ShareButton( "" );
		/*y	facebook = new ShareButton( Languages.FACEBOOKPOST );
			facebook.name="facebook";
			super();
			*/
			
			reedit = new ShareButton(Languages.REEDIT);
			reedit.name = "reedit";
			
			cameraroll = new ShareButton(Languages.SAVE_IN_CAMERAROLL);
			cameraroll.name = "cameraroll";
			cameraroll.y = reedit.y + reedit.height + 1;
			
			
			
			
			addChild(shareitems);
			//shareitems.addChild(facebook);
			shareitems.addChild(cameraroll);
			shareitems.addChild(reedit);
			addChild(sharer);
			addChild(shr);
			addChild(deletebtn);
			
			sharedmask.graphics.beginFill(0x000000);
			sharedmask.graphics.drawRect(0,0,shareitems.width,shareitems.height + 1);
			sharedmask.graphics.endFill();
			sharedmask.y = sharedmask.height * -1;
			addChild(sharedmask);
			shareitems.mask = sharedmask;
			
			shr.addEventListener( MouseEvent.CLICK, toggleShares );
			deletebtn.addEventListener( MouseEvent.CLICK, noFB );
		}
		
		private function noFB(e:MouseEvent):void {
			TweenLite.to( shareitems, 0.5, {y:0} );
		}
		
		private function toggleShares(e:MouseEvent):void {
			TweenLite.killTweensOf(shareitems);
			var ytgt:int = (shareitems.height * -1) - 1;
			if(shareitems.y != ytgt) {
				TweenLite.to( shareitems, 0.5, {y:ytgt, ease:Cubic.easeOut} ); // 2 items in shareitems
			} else {
				TweenLite.to( shareitems, 0.5, {y:0} );
			}
		}
		
		
		
		public function stageResize():void {
			//facebook.stageResize();
			reedit.stageResize();
			cameraroll.stageResize();
			sharer.stageResize();
			deletebtn.x =  model.stageWidth - (deletebtn.width / 2) - model.space;
			sharedmask.width = model.stageWidth;
		}
		
	}
}