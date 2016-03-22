package instagrAS3.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author tiago.dias
	 */
	
	public class OAuthEvent extends Event
	{
		public static const SUCCESS		:String 	= "success";
		public static const ERROR		:String		= "error";
				
		public function OAuthEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event 
		{
			return new OAuthEvent(type);
		}
	}
}