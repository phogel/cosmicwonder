package de.codekommando.cosmicwonder.apis
{
	import be.nascom.flash.net.upload.UploadPostHelper;
	
	import com.facebook.graph.FacebookMobile;
	import com.facebook.graph.utils.FacebookDataUtils;
	import com.sbhave.openUrl.URLUtils;
	
	import de.codekommando.cosmicwonder.WonderModel;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.InvokeEvent;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	public class FacebookAuth extends EventDispatcher
	{
		
		public var token:String = "";
		public var dt:Date;
		
		
		public function FacebookAuth(target:IEventDispatcher=null)
		{
			super(target);
			NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, onInvoke );
			var diskCache:SharedObject = SharedObject.getLocal("diskCache");
			token = diskCache.data["token"];
			dt = diskCache.data["expDate"];
		}
		
		
		public var APP_ID:String = "396497197042192";
				
		protected function authorize(appId:String,extPerm:Array,forceBrowser:Boolean=false):void {
			var url:String = "fbauth://authorize";
			var isFbAppAvailable:Boolean = URLUtils.instance.canOpenUrl(url);
			var ops:URLVariables = new URLVariables();
			ops["client_id"] = appId;
			ops["type"] = "user_agent";
			ops["redirect_uri"] = "fbconnect://success";
			ops["display"] = "touch";
			ops["sdk"] = "ios";
			if(extPerm != null && extPerm.length > 0)
				ops["scope"] = extPerm.join(",");
			if(!isFbAppAvailable || forceBrowser){
				url = "https://m.facebook.com/dialog/oauth";
				ops["redirect_uri"] = "fb"+appId+"://authorize";
			}
			var req:URLRequest = new URLRequest(url);
			req.data = ops;
			req.method = URLRequestMethod.GET;
			navigateToURL(req);
		}
		
		
		
		protected function onInvoke(e:InvokeEvent):void{
			
			var str:String = e.arguments[0];
			if(str && str.indexOf("fb"+APP_ID+"://") != -1 )
			{
				
				var vars:URLVariables = FacebookDataUtils.getURLVariables(e.arguments[0]);
				var accessToken:String = vars.access_token;
				if(!accessToken || accessToken == ""){
					var err:String = vars.error;
					
					if(err && err == "service_disabled_use_browser"){
						authorize(APP_ID,["read_stream"],true);
						trace('service disabled, use browser');
					}
						
					else if (err && err == "service_disabled"){
						// We cant use SSO at all use the old FacebookMobile.init() and FacebookMobile.login()
						trace('service disabled');
					}
					
					var errCode:String = vars.error_code;
					var userDidCancel:Boolean = !errCode && (!err || err == "access_denied");
					
					if(userDidCancel){
						// User cancelled the login and authentication
						trace('user cancelled authentication');
					}
				} else{ // Login was successful
					trace('login was successful');
					var expiresIn:int = int(vars.expires_in);
					
					if(expiresIn != 0){ // Everything went just well
						var expDate:Date = new Date();
						expDate.seconds += expiresIn;
						dt = expDate;
						token = accessToken;
						
						// Store FB details in LSO
						trace('fb details expire in: ' + expDate);
						var diskCache:SharedObject = SharedObject.getLocal("diskCache");
						diskCache.data["token"] = accessToken;
						diskCache.data["expDate"] = expDate;
						diskCache.flush();
						diskCache.close();
						diskCache = null;
						
						initAPI();
					}
				}
			}
		}
		
		
		
		protected function postPicture():void {
			trace('uploading picture');
			var pic:Object = new Object();
			pic.message = "";
			if(bitmap){
				pic.source = bitmap;
			} else {
				pic.source = pictureToPost;
			}
			pic.fileName = "WONDERPHILE";
			FacebookMobile.api( "/me/photos", picturePosted, pic, "POST");
		}
		protected function picturePosted(result:Object, fail:Object):void{
			if(null == fail){
				trace('image posted ok: ' + result);
				pictureToPost = null;
				WonderModel.getInstance().dispatchEvent(new Event('facebookPostComplete', true));
			} else {
				WonderModel.getInstance().dispatchEvent(new Event('facebookPostFailed', true));
				if(fail.error.message){
					trace('error posting image! ' + fail.error.message + ' ' + fail.error.type + ' ' +fail.error.code);
				} else {
					trace(fail.error);
				}
			}
		}
		
		
		protected var pictureToPost:ByteArray;
		protected var bitmap:Bitmap;
		public function tryPostPicture(p:ByteArray = null, img:Bitmap = null):void {
			pictureToPost = p;
			bitmap = img;
			if(token && dt && dt.time > (new Date()).time) {
				initAPI();
			} else {
				authorize(APP_ID,["publish_stream"]);
			}
		}
		
		protected function initAPI():void {
			FacebookMobile.init(APP_ID, apiInitOK, token);
		}
		
		protected function apiInitOK(session:Object, error:Object):void {
			postPicture();
		}
		
	}
}