package instagrAS3.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tiago.dias
	 */
	
	public class InstagramEvent extends Event
	{
		public static const REQUEST_COMPLETE :String = "requestcomplete";
		
		private var _data:*;
		
		public function InstagramEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public override function clone():Event 
		{
			return new InstagramEvent(type, _data);
		}
		
		public function get data():Object 
		{
			return _data;
		}
	}
}