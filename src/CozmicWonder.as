package
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.views.BaseView;
	
	import net.hires.debug.Stats;
	
	[SWF(width="641", height="960", backgroundColor="#000000", frameRate="60")]
	
	public class CozmicWonder extends Sprite
	{
		
		protected var model:WonderModel;
		protected var controller:WonderController;
		protected var baseview:BaseView;
		
		protected var w:Number = 641;
		protected var h:Number = 961;
		
		[Embed(source='Default.png')]
		protected var bg:Class;
		
		[Embed(source='Default-568h@2x.png')]
		protected var bgi4:Class;
		
		[Embed(source="Default-Portrait.png")]
		protected var bgipad:Class;
		
		protected var background:Bitmap;
		
		public function CozmicWonder()
		{
			super();
			model = new WonderModel();
			
			model.fx = new Vector.<String>();
			model.fx.push(
				BlendMode.ADD,
				BlendMode.DARKEN,
				BlendMode.DIFFERENCE,
				BlendMode.HARDLIGHT,
				BlendMode.LIGHTEN,
				BlendMode.OVERLAY,
				BlendMode.SCREEN,
				BlendMode.SUBTRACT
			);
			
			
			controller = new WonderController();
			Languages.init();
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		protected function init(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			trace('init');
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			/*
			
			remove the below stageResize for app export!
			
			stageResize();
			*/
			stage.addEventListener(Event.RESIZE, stageResize);
		}
		
		protected var firstResize:Boolean = true;
		protected var scndResize:Boolean = true;
		protected function stageResize(e:Event = null):void {
			
			rewriteSizes();
			trace('stage: ' + stage.stageWidth + 'x' + stage.stageHeight);
			if(firstResize) {
				model.loadSharedObject();
				controller.moveSOPictureToDocuments();
				firstResize = false;
				/*} else if(scndResize) {*/
				scndResize = false;
				buildBaseViewIfNotYetBuilt();
			} else {
				regularStageResize();
			}
				
		}
		
		protected function rewriteSizes():void
		{
			model.fullscreenWidth = stage.fullScreenWidth;
			model.fullscreenHeight = stage.fullScreenHeight;
			model.stageWidth = stage.stageWidth;
			model.stageHeight = stage.stageHeight;
		}
		
		protected function usePhoneSizes():void
		{
			model.thumbWidth = Math.round(model.shorterEnd / 4);
			model.galleryThumbWidth = Math.round(model.shorterEnd / 4);
		}
		
		protected function useTabletSizes():void
		{
			model.thumbWidth = Math.round(model.shorterEnd / 6);
			model.galleryThumbWidth = Math.round(model.shorterEnd / 6);
		}
		
		protected function regularStageResize():void
		{
			
			//trace('new stage dims: ' +  model.stageWidth + ' x ' + model.stageHeight);
			if(background)
			{
				background.y = (model.stageHeight - background.height) / 2;
				background.x = (model.stageWidth - background.width) / 2;
			}
			controller.stageResize();
		}
		
		
		protected function buildBaseViewIfNotYetBuilt():void
		{
			trace('buildBaseViewIfNotYetBuilt');
			if(!baseview)
			{
				rewriteSizes();
				switch(model.sourcePath)
				{
					case "iphone4":
						background = new bgi4();
						background.y = (model.longerEnd - 1136) / 2;
						usePhoneSizes();
						break;
					case "iphone3gs":
						background = new bg();
						usePhoneSizes();
						break;
					case "ipad2":
					case "ipad3":
						background = new bgipad();
						background.width = model.shorterEnd;
						background.height = model.longerEnd;
						useTabletSizes();
						break;
					default:
						usePhoneSizes();
						background = new bgi4();
						break;
				}
				addChildAt(background, 0);
				//trace('sourcePath: ' + model.sourcePath);
				//trace('thumbWidth: ' + model.thumbWidth);
				
				model.globalScale = model.shorterEnd / 640;
				
				initBaseView();
			}
		}
		
		
		
		protected function initBaseView():void {
			trace('sourcePath = ' + model.sourcePath);
			trace('globalScale = ' + model.globalScale);
			trace('thumbWidth = ' + model.thumbWidth);
			trace('shorterEnd = ' + model.shorterEnd);
			baseview = new BaseView();
			addChild(baseview);
			baseview.addEventListener("initComplete", initComplete);
			var sts:Stats = new Stats();
			sts.scaleX = sts.scaleY = 1.2;
			addChild(sts);
		}
		
		protected function initComplete(e:Event):void
		{
			baseview.removeEventListener("initComplete", initComplete);
			removeChild(background);
			background.bitmapData.dispose();
			background = null;
		}
		
		
		
	}
}