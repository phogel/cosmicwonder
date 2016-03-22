package instagrAS3.data
{
	import instagrAS3.data.items.Tag;
	import instagrAS3.data.items.User;
	import instagrAS3.data.items.Photo;
	import instagrAS3.data.items.Location;
	
	import instagrAS3.adobe.serialization.json.JSON;
	
	import flash.net.SharedObject;

	/**
	 * ...
	 * @author pbordachar
	 */
	
	public class DataParser
	{			
		
		// P U B L I C
		
		public static function parseUser( obj:Object ):User
		{
			var userInfo:User = getInfosUser( obj );
			
			return userInfo;
		}

		public static function parseUserArray( obj:Object ):Array
		{
			var arr:Array = new Array();
			for ( var i:int = 0, nb:int = obj.data.length; i < nb;  i++ )
			{
				var userInfo:User = getInfosUser( obj.data[ i ] );
				arr.push( userInfo );
			}
			return arr;
		}
			
		public static function parsePhoto( obj:Object ):Photo
		{
			var photo:Photo = getInfosPhoto( obj.data );
			return photo;
		}
		
		public static function parsePhotoArray( obj:Object ):Array
		{
			var arr:Array = new Array();
			for ( var i:int = 0, nb:int = obj.data.length; i < nb;  i++ )
			{
				var photo:Photo = getInfosPhoto( obj.data[ i ] );
				arr.push( photo );
			}
			return arr;
		}
		
		public static function parseLocation( obj:Object ):Location
		{
			var location:Location = getInfosLocation( obj.data );
			return location;
		}
		
		public static function parseLocationArray( obj:Object ):Array
		{
			var arr:Array = new Array();
			for ( var i:int = 0, nb:int = obj.data.length; i < nb;  i++ )
			{
				var location:Location = getInfosLocation( obj.data[ i ] );
				arr.push( location );
			}
			return arr;
		}
		
		public static function parseTag( obj:Object ):Tag
		{
			var tag:Tag = getInfosTag( obj.data );
			return tag;
		}
		
		public static function parseTagArray( obj:Object ):Array
		{
			var arr:Array = new Array();
			for ( var i:int = 0, nb:int = obj.data.length; i < nb;  i++ )
			{
				var tag:Tag = getInfosTag( obj.data[ i ] );
				arr.push( tag );
			}
			return arr;
		}
		
		// I N T E R N A L
		
		internal static function getInfosUser( obj:Object ):User
		{
			var objet:Object = ( obj.data != null ) ? obj.data : obj; 
			
			var userInfo:User 		= new User();
			userInfo.id				= objet.id;
			userInfo.userName 		= objet.username;
			userInfo.fullName 		= objet.full_name != null ? objet.full_name : "";
			userInfo.firstName 		= objet.first_name != null ? objet.first_name : "";
			userInfo.lastName 		= objet.last_name != null ? objet.last_name : "";
			userInfo.photo 			= objet.profile_picture;
			
			if ( objet.counts != null ) 
			{
				userInfo.followedBy 	= objet.counts.followed_by;
				userInfo.follows 		= objet.counts.follows;
				userInfo.nbMedia 		= objet.counts.media;
			}
			
			return userInfo; 
		}
		
		internal static function getInfosPhoto( obj:Object ):Photo
		{
			var photo:Photo = new Photo();
			photo.id = obj.id;
			photo.type = obj.type;
			photo.creation = obj.created_time;
			photo.thumbnail = obj.images.thumbnail.url != null ? obj.images.thumbnail.url : "";
			photo.std_res = obj.images.standard_resolution.url != null ? obj.images.standard_resolution.url : "";
			photo.low_res = obj.images.low_resolution.url != null ? obj.images.low_resolution.url : "";
			photo.caption = obj.caption != null ? obj.caption.text : "";
			photo.link = obj.link;
			photo.likes = obj.location != null ? obj.likes.count : -1;
			photo.user = getInfosUser( obj.user );
			photo.location = obj.location != null ? getInfosLocation( obj.location ) : null;
			photo.tags = ( obj.tags != null ) ? obj.tags : null;
			photo.filter = obj.filter;
			//photo.comments
			
			trace( photo.std_res );
			trace( "likes :" + photo.likes )

			return photo; 
		}
		
		internal static function getInfosLocation( obj:Object ):Location
		{
			var location:Location = new Location();
			location.id = obj.id;
			location.latitude = obj.latitude != null ? obj.latitude : NaN;
			location.longitude = obj.longitude != null ? obj.longitude : NaN;
			location.name = obj.name;
			
			return location;
		}
		
		internal static function getInfosTag( obj:Object ):Tag
		{
			var tag:Tag = new Tag();
			tag.count = obj.media_count;
			tag.name = obj.name;
			
			return tag;
		}
	
	}
}