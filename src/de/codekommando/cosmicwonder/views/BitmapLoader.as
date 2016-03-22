package de.codekommando.cosmicwonder.views
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import de.codekommando.cosmicwonder.WonderModel;

	public class BitmapLoader extends Loader {
		
		private var source:String = "";
		private var model:WonderModel = WonderModel.getInstance();
		private var onComplete:Function;
		public function BitmapLoader(src:String, completed:Function = null) {
			source = src;
			onComplete = completed;
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, setSmoothing);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ohError);
			this.load(new URLRequest("bitmaps/" + model.sourcePath + "/" + src)); 
		}
		public var smoothing:Boolean = true;
		private function setSmoothing(e:Event):void {
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ohError);
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, setSmoothing);
			Bitmap(this.content).smoothing = smoothing;
			if(null != onComplete){
				onComplete();
				onComplete = null;
			}
		}
		private function ohError(e:IOErrorEvent):void {
			throw new Error("failed: " + source);
		}
	}
}