package de.codekommando.cosmicwonder.views
{
	import de.codekommando.cosmicwonder.WonderController;
	import de.codekommando.cosmicwonder.WonderModel;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class StatusWindow extends Sprite
	{
		private var model:WonderModel = WonderModel.getInstance();
		private var message:CosmicTextWrapper = new CosmicTextWrapper("");
		private var spinner:StarSpinner = new StarSpinner();
		
		private var bg:Sprite = new Sprite();
		
		private var progressBar:ProgressBar = new ProgressBar();
		
		private var ldrTimer:Timer;
		
		public var yesbtn:ButtonWrapper;
		private var nobtn:ButtonWrapper;
		
		public function StatusWindow()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		protected function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(bg);
			bg.graphics.beginFill(0x000000, 0.6);
			bg.graphics.drawRect(0,0,100, 100);
			bg.graphics.endFill();
			
			
			addChild(message);
			message.scaleX = message.scaleY = (0.5 * model.globalScale);
			message.align = "left";
			
			yesbtn = new ButtonWrapper(Languages.YES);
			yesbtn.name = "yesbtn";
			yesbtn.mouseChildren = false;
			
			nobtn = new ButtonWrapper(Languages.NO);
			nobtn.name = "nobtn";
			nobtn.mouseChildren = false;
			
			spinner.cacheAsBitmap = true;
			spinner.visible = false;
			
			progressBar.visible = false;
			progressBar.scaleX = progressBar.scaleY =  model.globalScale;
			addChild(progressBar);
			
			nobtn.y = yesbtn.y = message.y + (60 * model.globalScale);
			nobtn.scaleX = yesbtn.scaleX = (0.8 * model.globalScale);
			addChild(nobtn);
			addChild(yesbtn);
			
			announce();
			stageResize();
			WonderController.getInstance().addEventListener("stageResize", stageResize);
		}
		
		public function announce(s:String = ""):void {
			if(s == "") {
				showYesNo = bg.visible = spinner.visible = message.visible = false;
				stopLoadPercentage();
				progressBar.percent = 0;
			} else {
				bg.visible = spinner.visible = message.visible = true;
				message.text = s;
				stageResize();
			}
		}
		
		
		public function set showYesNo(b:Boolean):void
		{
			nobtn.visible = yesbtn.visible = b;
		}
		
		
		public function loadPercentage():void {
			ldrTimer = new Timer(500);
			ldrTimer.addEventListener(TimerEvent.TIMER, viewLoadPercentage);
			ldrTimer.start();
			progressBar.percent = 0;
			progressBar.visible = true;
		}
		private function viewLoadPercentage(e:TimerEvent):void {
			//trace('converted ' + model.encodeProgress + '%');
			progressBar.percent = model.encodeProgress;
		}
		public function stopLoadPercentage():void {
			if(ldrTimer){
				ldrTimer.reset();
				ldrTimer.removeEventListener(TimerEvent.TIMER, stopLoadPercentage);
				ldrTimer = null;
			}
			if(progressBar)
			{
				progressBar.percent = 0;
				progressBar.visible = false;
			}
		}
		
		
		public function stageResize(e:Event = null):void {
			bg.width = model.stageWidth;
			bg.height = model.stageHeight;
			
			spinner.x = model.stageWidth / 2;
			spinner.y = model.stageHeight / 2;
			message.x = ( model.stageWidth - message.width ) / 2;
			message.y = (model.stageHeight - message.height) / 2 ;
			progressBar.y = message.y + message.height + 10;
			progressBar.x = (model.stageWidth - progressBar.width) / 2;
			
			yesbtn.x = Math.round((model.stageWidth / 2) - yesbtn.width);
			nobtn.x = (model.stageWidth / 2) + (model.space * 2);
			yesbtn.y = nobtn.y = message.y + message.height + model.space;
		}
		
	}
}