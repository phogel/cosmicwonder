package de.codekommando.cosmicwonder.infrastructure
{
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.sensors.Accelerometer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class OrientationWatcher extends EventDispatcher
	{
		
		public static const ORIENTATION_CHANGE:String = "orientationChange";
		public var currentOrientation:String = StageOrientation.DEFAULT
		private var firstCheckOrientation:String = StageOrientation.DEFAULT;
		private var myConst:Number = Math.sin(Math.PI/4);
		private var accl:Accelerometer;
		private var inter:int;
		private var inter2:int;
		private var currenAcceleromResult:String;
		private var checkFrequency:int = 300;
		private var stage:Stage;
		
		
		public function OrientationWatcher(_stage:Stage)
		{
			stage = _stage;
			if (Accelerometer.isSupported) {
				accl = new Accelerometer();
				accl.setRequestedUpdateInterval(100);
			} else {
				trace("Accelerometer feature not supported!!");
			}
		}
		
		
		public function set active(val:Boolean):void {
			if (inter2){
				clearInterval(inter2);
			}
			if (val) {
				if (! accl.hasEventListener(AccelerometerEvent.UPDATE)){
					accl.addEventListener(AccelerometerEvent.UPDATE, getAcceleromOrientation);
				}
				currentOrientation = currenAcceleromResult;
				inter2 = setInterval(checkOrientation, checkFrequency);
			} else {
				if (accl.hasEventListener(AccelerometerEvent.UPDATE)){
					accl.removeEventListener(AccelerometerEvent.UPDATE, getAcceleromOrientation);
				}
			}
			
		}
		
		
		private function checkOrientation():void {
			firstCheckOrientation = currenAcceleromResult;
			if (inter){
				clearInterval(inter);
			}
			if (currentOrientation != firstCheckOrientation) {
				inter = setInterval(confirmOrientation, checkFrequency/3);
			}
		}
		
		
		private function confirmOrientation():void{
			if (inter){
				clearInterval(inter);
			}
			var secondCheckOrientation:String = currenAcceleromResult;
			if (firstCheckOrientation == secondCheckOrientation){
				currentOrientation = firstCheckOrientation;
				dispatchEvent(new Event(ORIENTATION_CHANGE));
			}
		}
		
		
		private function getAcceleromOrientation(e:AccelerometerEvent):void{
			
			if (Math.abs(e.accelerationZ) > myConst){
				return;
			}
			
			/*if (e.accelerationX > 0 && e.accelerationY >  -  myConst && e.accelerationY < myConst) {
				currenAcceleromResult =  StageOrientation.ROTATED_LEFT;
			} else if ( e.accelerationY >= myConst) {
				currenAcceleromResult =  StageOrientation.DEFAULT;
			} else if (e.accelerationX < 0 && e.accelerationY > -myConst && e.accelerationY < myConst) {
				currenAcceleromResult =  StageOrientation.ROTATED_RIGHT;
			} else if (e.accelerationY <= myConst) {
				currenAcceleromResult =  StageOrientation.UPSIDE_DOWN;
			} else {
				currenAcceleromResult = StageOrientation.UNKNOWN;
			}*/
			//trace(e.accelerationX, e.accelerationY);
			
		}
	}
}