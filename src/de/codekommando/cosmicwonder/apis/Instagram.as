package de.codekommando.cosmicwonder.apis 
{
	import instagrAS3.data.DataParser;
	import instagrAS3.events.InstagramEvent;
	import instagrAS3.oauth.OAuth;
	import instagrAS3.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * ...
	 * @author pbordachar
	 */
	
	public class Instagram extends EventDispatcher
	{
		
		protected static const API_URL:String = "https://api.instagram.com/v1/";
		
		private var _loader:URLLoader;
		private var _dataType:String;
		private var _oauth:OAuth;
		private var _data:*;
		
		public static const USER_SELF_FEED				:String		= "userFeed";

		public static const USER_INFOS					:String		= "userInfos";
		public static const USER_SEARCH					:String		= "userSearch";
		public static const USER_MEDIA_RECENT			:String		= "userRecent";
		
		public static const PHOTO_INFOS					:String		= "photoInfos";
		public static const PHOTO_SEARCH				:String		= "photoSearch";
		public static const PHOTO_POPULAR				:String		= "photoPopular";
		
		public static const LOCATION_INFOS				:String 	= "locationInfos";
		public static const LOCATION_SEARCH				:String 	= "locationSearch";
		public static const LOCATION_MEDIA_RECENT		:String 	= "locationRecent";
		
		public static const TAG_INFOS					:String		= "tagInfos";
		public static const TAG_SEARCH					:String		= "tagSearch";
		public static const TAG_MEDIA_RECENT			:String		= "tagRecent";
		
		public static const GEOGRAPHY_RECENT			:String		= "geographyRecent";
		
		
		public function Instagram() {}
		
		public function get dataType():String
		{
			return _dataType;
		}	
		
		public function get oauth():OAuth
		{
			return _oauth;
		}

		public function set oauth(value:OAuth):void
		{
			_oauth = value;
		}
		
		// - - -
		
		private final function requestData( url:String, type:String = "GET", args:Array = null, params:String = "" ):void
		{
			trace( type + " - request: " + url );
			MonsterDebugger.trace(this, type + " - request: " + url);
			
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, dataLoaded );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var request:URLRequest;
			
			if (type == "GET" )
			{
				if ( url.lastIndexOf("?") == -1 )
				{
					request = new URLRequest( url + "?access_token=" + _oauth.accessToken + params );
				}
				else
				{
					request = new URLRequest( url + "&access_token=" + _oauth.accessToken + params );
				}
				
				request.method = "GET";
			}
			
			else if ( type == "POST" )
			{
				var urlVars:URLVariables = new URLVariables();
				
				if ( args )
				{
					for each ( var obj:Object in args )
					{
						urlVars[obj["name"]] = obj["val"]; 
					}
				}
				
				urlVars.oauth_token = _oauth.accessToken;
				
				request	= new URLRequest( url );
				request.data = urlVars;
				request.method = type;
				
				_loader.dataFormat = URLLoaderDataFormat.TEXT;	
			}
			else
			{
				request = new URLRequest( url + "?client_id=" + _oauth.consumerKey + "&client_secret=" + _oauth.consumerSecret );
			}
			
			//trace( request.url );
			
			_loader.load( request );
		}
		
		protected function httpStatusHandler(event:HTTPStatusEvent):void
		{
			trace( "httpStatusHandler" );
			
			MonsterDebugger.trace(this, event );
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			trace( "ioErrorHandler" );
			
			MonsterDebugger.trace(this, event );
		}
		
		protected function dataLoaded(event:Event):void
		{
			trace( "dataLoaded" );
			
			MonsterDebugger.trace(this, JSON.decode( _loader.data ) );
			
			switch( _dataType )
			{
				case PHOTO_INFOS:
				
					_data = DataParser.parsePhoto( JSON.decode( _loader.data ) );
					break;
				
				case PHOTO_SEARCH:
				case PHOTO_POPULAR:
				case USER_SELF_FEED:
				case USER_MEDIA_RECENT:
				case LOCATION_MEDIA_RECENT:
				case TAG_MEDIA_RECENT:
				case GEOGRAPHY_RECENT: // ?
				
					_data = DataParser.parsePhotoArray( JSON.decode( _loader.data ) );
					break;
					
				case LOCATION_INFOS:
				
					_data = DataParser.parseLocation( JSON.decode( _loader.data ) );
					break;
					
				case LOCATION_SEARCH:
				
					_data = DataParser.parseLocationArray( JSON.decode( _loader.data ) );
					break;
					
				case TAG_INFOS:
				
					_data = DataParser.parseTag( JSON.decode( _loader.data ) );
					break;
					
				case TAG_SEARCH:
				
					_data = DataParser.parseTagArray( JSON.decode( _loader.data ) );
					break;
					
				case USER_INFOS:
				
					_data = DataParser.parseUser( JSON.decode( _loader.data ) );
					break;
					
				case USER_SEARCH:
				
					_data = DataParser.parseUserArray( JSON.decode( _loader.data ) );
					break;
			}
			
			dispatchEvent( new InstagramEvent ( InstagramEvent.REQUEST_COMPLETE, _data ) );
		}
		
		protected function statusError(event:HTTPStatusEvent):void
		{
			trace( "statusError" );
			
			MonsterDebugger.trace(this, event );
			MonsterDebugger.trace(this, event.target.data );
		}
		
		// - - - by scopes
		
		///////////////////////////
		///////  B A S I C  ///////
		///////////////////////////
		
		// GET /users/self/feed
		
		public function getFeed( params:String=""):void
		{
			_dataType = USER_SELF_FEED;
			requestData( API_URL + "users/self/feed/", "GET", null, params );
		}
		
		// GET /users/search
		
		public function getUserSearch( params:String="" ):void
		{
			_dataType = USER_SEARCH;
			requestData( API_URL + "users/search/", "GET", null, params );
		}
		
		// GET /users/{user-id}
		
		public function getUser( userID:String = "self" ):void
		{
			_dataType = USER_INFOS;
			requestData( API_URL + "users/" + userID + "/" );
		}
		
		// GET /users/{user-id}/media/recent
		
		public function getUserRecent( userID:String = "self", params:String="" ):void
		{
			_dataType = USER_MEDIA_RECENT;
			requestData( API_URL + "users/" + userID + "/media/recent/", "GET", null, params );
		}
		
		// GET /media/{media-id}
		
		public function getPhoto( photoID:String, params:String="" ):void
		{
			_dataType = PHOTO_INFOS;
			requestData( API_URL + "media/" + photoID + "/", "GET", null, params );
		}
		
		// GET /media/search
		
		public function getPhotoSearch( params:String = "" ):void
		{
			_dataType = PHOTO_SEARCH;
			requestData( API_URL + "media/search/", "GET", null, params );
		}
		
		// GET /media/popular
		
		public function getPhotoPopular():void
		{
			_dataType = PHOTO_POPULAR;
			requestData( API_URL + "media/popular/" );
		}
		
		// GET /locations/{location-id}
		
		public function getLocation( locID:String, params:String="" ):void
		{
			_dataType = LOCATION_INFOS;
			requestData( API_URL + "locations/" + locID + "/", "GET", null, params );
		}
		
		// GET /locations/{location-id}/media/recent
		
		public function getLocationRecent ( locID:String, params:String="" ):void
		{
			_dataType = LOCATION_MEDIA_RECENT;
			requestData( API_URL + "locations/" + locID + "/media/recent/", "GET", null, params );
		}
		
		// GET /locations/search
		
		public function getLocationSearch ( params:String="" ):void
		{
			_dataType = LOCATION_SEARCH;
			requestData( API_URL + "locations/search/", "GET", null, params );
		}
		
		// GET /tags/{tag-name}
		
		public function getTag( tagID:String, params:String="" ):void
		{
			_dataType = TAG_INFOS;
			requestData( API_URL + "tags/" + tagID + "/", "GET", null, params );
		}
		
		// GET /tags/{tag-name}/media/recent
		
		public function getTagRecent( tagID:String, params:String="" ):void
		{
			_dataType = TAG_MEDIA_RECENT;
			requestData( API_URL + "tags/" + tagID + "/media/recent/", "GET", null, params );
		}
		
		// GET /tags/search
		
		public function getTagSearch( params:String="" ):void
		{
			_dataType = TAG_SEARCH;
			requestData( API_URL + "tags/search/", "GET", null, params );
		}
		
		// GET /geographies/{id}/media/recent
		
		public function getGeographyRecent( id:String="", params:String = "" ):void
		{
			_dataType = GEOGRAPHY_RECENT;
			requestData( API_URL + "geographies/" + id + "/media/recent/", "GET", null, params );
		}
		
		/////////////////////////////////////////
		///////  R E L A T I O N S H I P  ///////
		/////////////////////////////////////////
		
		// ---- scope = relationship
		// GET /users/{user-id}/follows
		// GET /users/{user-id}/followed-by
		// GET /users/self/requested-by
		// GET /users/{user-id}/relationship
		// POST /users/{user-id}/relationship
		
		/////////////////////////////////
		///////  C O M M E N T S  ///////
		/////////////////////////////////
		
		// ---- scope = comments
		// GET /media/{media-id}/comments
		// POST /media/{media-id}/comments
		// DELETE /media/{media-id}/comments/{comment-id}
		
		/////////////////////////
		///////  L I K E  ///////
		/////////////////////////
		
		// ---- scope = like
		// GET /media/{media-id}/likes/
		// POST /media/{media-id}/likes/
		// DELETE /media/{media-id}/likes/

	}

}