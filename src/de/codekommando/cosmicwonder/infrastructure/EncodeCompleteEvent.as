package de.codekommando.cosmicwonder.infrastructure
{
	import flash.events.Event;
	
	public class EncodeCompleteEvent extends Event
	{
		public function EncodeCompleteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable)package
			{
				import flash.events.Event;
				import flash.utils.ByteArray;
				
				public class EncodeCompleteEvent extends Event
				{
					public static const COMPLETE:String='encodeCompleteEvent';
					
					private var image:ByteArray;
					
					public function EncodeCompleteEvent(data:ByteArray, bubbles:Boolean=false, cancelable:Boolean=false)
					{
						super(COMPLETE, bubbles, cancelable);
						image=data;
					}
					
					public function get data():ByteArray
					{
						return image;
					}
					
					override public function clone() : Event
					{
						return new EncodeCompleteEvent(image,bubbles,cancelable);
					}
				}
			}
			
}