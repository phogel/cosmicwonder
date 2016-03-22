package de.codekommando.cosmicwonder
{
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	
	import cmodule.aircall.CLibInit;
	
	import de.codekommando.cosmicwonder.apis.FacebookAuth;
	import de.codekommando.cosmicwonder.infrastructure.GalaxyFiles;
	import de.codekommando.cosmicwonder.infrastructure.Languages;
	import de.codekommando.cosmicwonder.views.BitmapLoader;
	import de.codekommando.cosmicwonder.views.editor2.GalaxyImage;
	

	public class WonderModel extends EventDispatcher
	{
		
		public static const RETRIGGER_FULLSCREEN:String = "retriggerFullscreen";
		
		public var USEMOUSE:Boolean = true;
		
		public var islite:Boolean = false;
		
		private var _stageWidth:int = 640;
		public function get stageWidth():int {
			return _stageWidth;
		}

		public function set stageWidth(value:int):void {
			_stageWidth = value;
		}

		public var stageHeight:int = 960;
		public var fullscreenWidth:int = 640;
		public var fullscreenHeight:int = 960;
		public var globalScale:Number = 1;
		
		public function get gap():int {
			return 20 * globalScale;
		}
		
		public function get longerEnd():int
		{
			return stageWidth > stageHeight ? stageWidth : stageHeight;
		}
		public function get shorterEnd():int
		{
			return stageWidth < stageHeight ? stageWidth : stageHeight;
		}
		
		

		public function get space():int
		{
			return 10 * globalScale;
		}

		
		public var thumbWidth:int = 200;
		public var galleryThumbWidth:int = 110;
		
		public function get galaxyDims():int
		{
			if(stageWidth > stageHeight){
				return stageWidth;
			} else {
				return stageHeight;
			}
		}
		
		
		protected var _app_state:String = "home";
		
		public var jpeginit:CLibInit = new CLibInit();
		public var jpeglib:Object;
		
		// If the File falls under point 2 of rejection note
		public var cacheDir:File = File.cacheDirectory;
		// If the new File falls under point 3 of rejection note
		public var tempDir:File = File.userDirectory;
		public var docDir:File = File.documentsDirectory;

		public var encodeProgress:Number = 0;
		
		// ------------------
		//  Constructor
		// ------------------
		
		protected static var instance:WonderModel;
		public static function getInstance():WonderModel
		{
			if(instance)
			{
				return instance;
			}
			else
			{
				instance = new WonderModel();
				return instance;
			}
		}
		
		public function WonderModel(target:IEventDispatcher=null)
		{
			instance = this;
			jpeglib = jpeginit.init();
			super(target);
		}
		
		
		public function get sourcePath():String {
			switch (stageWidth){
				case 640:
				case 960:
				case 1136:
				case 1134:
					return "iphone4";
					break;
				case 320:
				case 480:
					return "iphone3gs";
					break;
				case 1536:
				case 2048:
					return "ipad3";
					break;
				case 768:
				case 1024:
					return "ipad2";
					break;
				case 1334:
				case 750:
					return "iphone6";
				case 1242:
				case 2208:
					return "iphone6plus";
				default:
					return "iphone4";
					break;
			}
		}
		
		
		
		// ------------------
		// SharedObject
		// ------------------
		
		protected var handsetData:SharedObject;
		protected const dataname:String = "KOZMIKS";
		
		public function loadSharedObject():void {
			
			handsetData = SharedObject.getLocal(dataname);
			if(!handsetData.data.hasOwnProperty('settings')){
				handsetData.data['settings'] = {"saveincameraroll":true, "saveingallery":true};
				trace('create settings');
			} else {
				trace('using existing settings');
			}
			
		}
		
		public function get userSettings():Object {
			return handsetData.data['settings'];
		}
		public function set userSettings(o:Object):void {
			handsetData.data['settings'] = o;
			flushLSO();
		}
		public function set saveInGallery(b:Boolean):void {
			userSettings.saveingallery = b;
		}
		public function get saveInGallery():Boolean {
			if(userSettings.hasOwnProperty('saveingallery') && userSettings.saveingallery) {
				return true;
			} else {
				return false;
			}
		}
		public function set saveInCameraRoll(b:Boolean):void {
			userSettings.saveincameraroll = b;
		}
		public function get saveInCameraRoll():Boolean {
			if(userSettings.hasOwnProperty('saveincameraroll') && userSettings.saveincameraroll) {
				return true;
			} else {
				return false;
			}
		}
		
		
		
		public var USEBOGUSSAVES:Boolean = false;
		
		
		public var compressedByteArrays:Array = new Array;
		
		
		
		public function get savedImages():Array {
			if(!handsetData.data['createdImages']) {
				trace('create createdImages');
				handsetData.data['createdImages'] = new Array();
			}
			return handsetData.data['createdImages'];
		}
		public function set savedImages(a:Array):void {
			handsetData.data['createdImages'] = a;
			flushLSO();
			traceSavedImages();
		}
		public function flushLSO():void {
			handsetData.flush();
		}
		public function savedImageById( id:int ):Array { // type can be ByteArray or BitmapData
			if( id < savedImages.length && id >= 0 ) {
				return savedImages[id];
			} else {
				return null;
			}
		}

		public function traceSavedImages():void {
			for(var i:int = 0; i < savedImages.length; i++){
				trace('--img--:' + savedImages[i][0]);
			}
		}

		
		
		
		public var userImagesToConvert:uint = 0;
		public var userImagesConverted:uint = 0;
		
		protected var _generatedGalleryThumbnails:Array = new Array();
		public function get generatedGalleryThumbnails():Array {
			return _generatedGalleryThumbnails;
		}
		public function set generatedGalleryThumbnails(value:Array):void {
			_generatedGalleryThumbnails = value;
		}

		
		// ---------------------
		// Bitmaps
		// .------------------_-
		
		public var wonderlogo:BitmapLoader;
		public var appbg:BitmapLoader;
		
		
		//**************
		// Image Editing Vars
		//**************
		
		public var switchingGalaxy:Boolean = false;
		
		
		public var editingGalaxy:Boolean = false;
		
		protected var _contrast:Number = 0;
		public var contrastUser:Number = 0;
		public function get contrast():Number
		{
			if(editingGalaxy) {
				return _contrast;
			} else {
				return contrastUser;
			}
		}
		public function set contrast(value:Number):void
		{
			if( editingGalaxy ) {
				_contrast = value;
			} else {
				contrastUser = value;
			}
		}

		protected var _brightness:Number = .5;
		protected var brightnessUser:Number = .5;
		public function get brightness():Number
		{
			if(editingGalaxy) {
				return _brightness;
			} else {
				return brightnessUser;
			}
		}
		public function set brightness(value:Number):void
		{
			if(editingGalaxy) {
				_brightness = value;
			} else {
				brightnessUser = value;
			}
		}

		public var galaxyAlpha:Number = 1;
		public var alphaUser:Number = 1;
		public function get alpha2():Number {
			if(editingGalaxy) {
				return galaxyAlpha;
			} else {
				return alphaUser;
			}
		}
		public function set alpha2(n:Number):void {
			if(editingGalaxy) {
				galaxyAlpha = n;
			} else {
				alphaUser = n;
			}
		}

		public var blurUser:Number = 0;
		public var blurGalaxy:Number = 0;
		public function get blur():Number {
			if(editingGalaxy){
				return blurGalaxy;
			} else {
				return blurUser;
			}
		}
		public function set blur(n:Number):void {
			if(editingGalaxy) {
				blurGalaxy = n;
			} else {
				blurUser = n;
			}
		}
		
		
		protected var _rotation2:Number = 0;
		public var rotationUser:Number = 0;
		public function get rotation2():Number {
			if(editingGalaxy) {
				return _rotation2;
			} else {
				return rotationUser;
			}
		}
		public function set rotation2(n:Number):void {
			if(editingGalaxy) {
				_rotation2 = n;
			} else {
				rotationUser = n;
			}
		}
		
		
		
		// _-------------
		//  APP STATE
		// _--------------
		
		
		public function get app_state():String{
			return _app_state;
		}

		public function set app_state(value:String):void {
			if( value != _app_state ) {
				_app_state = value;
				dispatchEvent(new Event('stateChange'));
			}
		}
		
		
		// -----------------
		// Bitmap chosen
		// -----------------
		
		protected var _userBitmap:Bitmap;

		public function get userBitmap():Bitmap
		{
			return _userBitmap;
		}

		public function set userBitmap(value:Bitmap):void
		{
			_userBitmap = value;
			if(value)_userBitmap.smoothing = true;
		}
		
		public var imageToSave:Bitmap;
		
		public var userBitmapOrientation:String = "NORMAL";
		
		protected var _currentGalaxy:int = 0;

		public function get currentGalaxy():int
		{
			return _currentGalaxy;
		}

		public function set currentGalaxy(value:int):void
		{
			if(value != _currentGalaxy) {
				switchingGalaxy = true;
				_currentGalaxy = value;
				dispatchEvent( new Event('galaxyChange') );
			} else {
				//dispatchEvent( new Event('unfoldEffects') );
			}
		}
		
		public function get currentGalaxyImage():GalaxyImage
		{
			return GalaxyFiles.getGalaxy(_currentGalaxy);
		}
		
		public var currentGalaxyStage:GalaxyImage;
		
		
		
		public var settingMatrix:Boolean = false;
		
		
		/**
		 * 
		 * Gallery States
		 * 
		 **/
		protected var _gallery_state:String = "thumbnail";
		public function get gallery_state():String
		{
			return _gallery_state;
		}
		public function set gallery_state(value:String):void
		{
			if(value != _gallery_state){
				_gallery_state = value;
				dispatchEvent( new Event('galleryStateChange') );
			}
		}
		
		public var gallerySelectedImage:String = "0";
		
		
		
		
		
		// --------------------------
		// facebook api
		// --------------------------
		public var facebookapi:FacebookAuth = new FacebookAuth();
		public const FB_APP_ID:String = "396497197042192";
		
		
		// --------------------------
		// orientation 
		// --------------------------
		public function get orientation():String {
			return stageWidth < stageHeight ? "portrait" : "landscape";
		}
		
		
		
		// --------------------------
		// font 
		// --------------------------
		
		public function get font():String {
			if(Languages.locale == "ja"){
				return new ARIALBOLD().fontName;
			} else {
				return new ARIALBOLDERING().fontName;
			}
		}
		
		
		/**
		 * 
		 * init()
		 *  
		 **/
		
		public function init():void {
			trace("Model::init");
			
		}
		
		public var fx:Vector.<String>;
		/*= new Vector.<String>(
			BlendMode.ADD,
			BlendMode.DARKEN,
			BlendMode.DIFFERENCE,
			BlendMode.HARDLIGHT,
			BlendMode.LIGHTEN,
			BlendMode.OVERLAY,
			BlendMode.SCREEN,
			BlendMode.SUBTRACT
		);*/
		protected var _currentEffectId:int = 0;

		public function get currentEffectId():int
		{
			return _currentEffectId;
		}

		public function set currentEffectId(value:int):void
		{
			if(value != _currentEffectId)
			{
				_currentEffectId = value;
				dispatchEvent( new Event('effectChange') );
			}
		}
		
		
		public function currentEffect():String
		{
			return fx[_currentEffectId];
		}
		
		
		
	}
}