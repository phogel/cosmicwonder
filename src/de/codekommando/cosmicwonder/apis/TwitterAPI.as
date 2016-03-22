package de.codekommando.cosmicwonder.apis
{
	import com.swfjunkie.tweetr.Tweetr;
	import com.swfjunkie.tweetr.events.TweetEvent;
	import com.swfjunkie.tweetr.oauth.OAuth;
	import com.swfjunkie.tweetr.oauth.events.OAuthEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class TwitterAPI extends EventDispatcher
	{
		
		public var tweetr:Tweetr;
		private var oauth:OAuth;
		
		public function TwitterAPI(target:IEventDispatcher=null)
		{
			super(target);
			tweetr = new Tweetr();
			
			tweetr = new Tweetr();
			tweetr.addEventListener(TweetEvent.COMPLETE, handleTweetEvent);
			tweetr.addEventListener(TweetEvent.FAILED, handleTweetEvent);
			
			oauth = new OAuth();
			oauth.addEventListener(OAuthEvent.COMPLETE, handleOAuthEvent);
			oauth.addEventListener(OAuthEvent.ERROR, handleOAuthEvent);
			
			oauth.consumerKey = "0thPIQZMjYicurvXqa5jfg";
			oauth.consumerSecret = "qoaz0fl5hbDgGRaPAS9qCYXgx4naniiAa9Vp21c4";
			
		}
		
		
		private function handleTweetEvent(event:TweetEvent):void
		{
			switch (event.type)
			{
				case TweetEvent.COMPLETE:
				{
					trace("update should be made");
					break;
				}
				case TweetEvent.FAILED:
				{
					trace("something went terribly wrong..");
					break;
				}
			}
		}
		
		
		private function handleOAuthEvent(event:OAuthEvent):void
		{
			switch (event.type)
			{
				case OAuthEvent.COMPLETE:
				{
					if (event.url)
					{
						navigateToURL(new URLRequest(event.url));
					}
					else
					{
						tweetr.oAuth = oauth;
						trace("tweetr received oauth instance..");
					}
					break;
				}
				case OAuthEvent.ERROR:
				{
					break;
				}
			}
		}
	}
}