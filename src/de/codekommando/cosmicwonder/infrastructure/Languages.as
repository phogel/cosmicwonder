package de.codekommando.cosmicwonder.infrastructure
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.Capabilities;
	
	public class Languages extends EventDispatcher
	{
		public function Languages(target:IEventDispatcher=null)
		{
			
		}
		
		public static function init():void
		{
			//deutsch
			lang["de"]["alpha"] = "ALPHA";
			lang["de"]["ok"] = "OK";
			lang["de"]["viewingallery"] = "In Galerie ansehen?";
			lang["de"]["yes"] = "JA";
			lang["de"]["no"] = "NEIN";
			lang["de"]["deleteok"] = "Das Bild wirklich löschen?";
			lang["de"]["contrast"] = "KONTRAST";
			lang["de"]["rotation"] = "ROTATION";
			lang["de"]["back"] = "ZURÜCK";
			lang["de"]["cancel"] = "Abbrechen";
			lang["de"]["start"] = " NEU ";
			lang["de"]["fx"] = "Effekt";
			lang["de"]["galaxyfx"] = "Galaxie&FX";
			lang["de"]["galaxy"] = "Galaxie";
			lang["de"]["loading"] = "Laden...";
			lang["de"]["next"] = "Weiter";
			lang["de"]["position"] = "POSITION";
			lang["de"]["save"] = "SICHERN";
			lang["de"]["saved"] = "Gesichert.";
			lang["de"]["saving"] = "Bild wird gesichert...";
			lang["de"]["size"] = "Größe";
			lang["de"]["sizeposition"] = "Größe&Position";
			lang["de"]["gallery"] = "GALERIE";
			lang["de"]["share"] = "TEILEN";
			lang["de"]["facebook"] = "Auf Facebook posten";
			lang["de"]["sharesuccess"] = "Bild wurde erfolgreich gepostet.";
			lang["de"]["sharefail"] = "Fehler beim Posten des Bildes.";
			lang["de"]["image"] = "Foto";
			lang["de"]["settings"] = "Optionen";
			lang["de"]["saveingallery"] = "In Galerie sichern";
			lang["de"]["saveincameraroll"] = "In Fotoalbum sichern";
			lang["de"]["converting"] = "Konvertieren...";
			lang["de"]["uploading"] = "Hochladen...";
			lang["de"]["reedit"] = "Nochmal bearbeiten";
			
			// engrish
			lang["en"]["alpha"] = "ALPHA";
			lang["en"]["ok"] = "YES";
			lang["en"]["viewingallery"] = "View in Gallery?";
			lang["en"]["yes"] = "YES";
			lang["en"]["no"] = "NO";
			lang["en"]["deleteok"] = "Really delete this picture?";
			lang["de"]["rotation"] = "ROTATION";
			lang["de"]["contrast"] = "CONTRAST";
			lang["en"]["back"] = "BACK";
			lang["en"]["cancel"] = "CANCEL";
			lang["en"]["start"] = "CREATE";
			lang["en"]["fx"] = "FX";
			lang["en"]["galaxyfx"] = "GALAXY&FX";
			lang["en"]["galaxy"] = "GALAXY";
			lang["en"]["loading"] = "LOADING...";
			lang["en"]["next"] = "NEXT";
			lang["en"]["position"] = "POSITION";
			lang["en"]["save"] = "SAVE";
			lang["en"]["saved"] = "SAVED";
			lang["en"]["saving"] = "SAVING...";
			lang["en"]["size"] = "SIZE";
			lang["en"]["sizeposition"] = "SIZE&POSITION";
			lang["en"]["gallery"] = "GALLERY";
			lang["en"]["share"] = "SHARE";
			lang["en"]["sharesuccess"] = "Image posted successfully.";
			lang["en"]["sharefail"] = "Error posting image!";
			lang["en"]["facebook"] = "Post to facebook";
			lang["en"]["image"] = "Photo";
			lang["en"]["settings"] = "Settings";
			lang["en"]["saveingallery"] = "Save in gallery";
			lang["en"]["saveincameraroll"] = "Save in Camera Roll";
			lang["en"]["converting"] = "Converting...";
			lang["en"]["uploading"] = "Uploading...";
			lang["en"]["reedit"] = "Edit again";
			
			// fr
			lang["fr"]["alpha"] = "ALPHA";
			lang["fr"]["ok"] = "OK";
			lang["fr"]["viewingallery"] = "Voir dans la galerie?";
			lang["fr"]["yes"] = "OUI";
			lang["fr"]["no"] = "NON";
			lang["fr"]["deleteok"] = "Supprimer le photo?";
			lang["fr"]["contrast"] = "CONTRAST";
			lang["fr"]["rotation"] = "ROTATION";
			lang["fr"]["back"] = "RETOUR";
			lang["fr"]["cancel"] = "ANNULER";
			lang["fr"]["start"] = "CRÉER";
			lang["fr"]["fx"] = "FX";
			lang["fr"]["galaxyfx"] = "GALAXIE&FX";
			lang["fr"]["galaxy"] = "GALAXIE";
			lang["fr"]["loading"] = "CHARGEMENT...";
			lang["fr"]["position"] = "POSITION";
			lang["fr"]["save"] = "SAUVEGARDER";
			lang["fr"]["saved"] = "SAUVEGARDÉ";
			lang["fr"]["saving"] = "EN TRAIN DE SAUVEGARDER";
			lang["fr"]["size"] = "GRANDEUR";
			lang["fr"]["sizeposition"] = "POSITION&GRANDEUR";
			lang["fr"]["gallery"] = "GALERIE";
			lang["fr"]["share"] = "SHARE";
			lang["fr"]["sharesuccess"] = "L'image etait posté.";
			lang["fr"]["sharefail"] = "Erreur!";
			lang["fr"]["facebook"] = "Post sur facebook";
			lang["fr"]["image"] = "Photo";
			lang["fr"]["settings"] = "Réglages";
			lang["fr"]["saveingallery"] = "Sauvegarde dans la galerie";
			lang["fr"]["saveincameraroll"] = "Sauvegarde dans la pellicule"
			lang["fr"]["converting"] = "Conversion...";
			lang["fr"]["uploading"] = "Téléchargement...";
			lang["fr"]["reedit"] = "Modifier à nouveau";
			
			//jp
			lang["ja"]["alpha"] = "アルファ";
			lang["ja"]["ok"] = "OK";
			lang["ja"]["yes"] = "はい";
			lang["ja"]["no"] = "いいえ";
			lang["ja"]["viewingallery"] = "ギャラリーでみる？";
			lang["ja"]["deleteok"] = "このフォトをけしますか？";
			lang["ja"]["contrast"] = "コントラスト";
			lang["ja"]["rotation"] = "ロテーション";
			lang["ja"]["back"] = "もどる";
			lang["ja"]["cancel"] = "キャンセル";
			lang["ja"]["start"] = "START";
			lang["ja"]["fx"] = "エフェクト";
			lang["ja"]["galaxyfx"] = "";
			lang["ja"]["galaxy"] = "GALAXY";
			lang["ja"]["loading"] = "よみこみちゅう";
			lang["ja"]["next"] = "つぎ";
			lang["ja"]["position"] = "ばしょ";
			lang["ja"]["save"] = "セーブ";
			lang["ja"]["saved"] = "セーブしました";
			lang["ja"]["saving"] = "セーブちゅう";
			lang["ja"]["size"] = "サイズ";
			lang["ja"]["sizeposition"] = "";
			lang["ja"]["gallery"] = "ギャラリー";
			lang["ja"]["share"] = "シェアー";
			lang["ja"]["sharesuccess"] = "シェアーOK";
			lang["ja"]["sharefail"] = "シェアーエラー";
			lang["ja"]["facebook"] = "Facebookにアップする";
			lang["ja"]["image"] = "PHOTO";
			lang["ja"]["settings"] = "せってい";
			lang["ja"]["saveingallery"] = "ギャラリーにほぞん";
			lang["ja"]["saveincameraroll"] = "フォトアルバムにほぞん";
			lang["ja"]["converting"] = "へんかんちゅう";
			lang["ja"]["uploading"] = "アップロードちゅう";
			lang["ja"]["reedit"] = "もういっかいつかう";
			
			//spanish
			lang["es"]["ok"] = "VALE";
			lang["es"]["viewingallery"] = "Mirar en la galeria?";
			lang["es"]["yes"] = "SI";
			lang["es"]["no"] = "NO";
			lang["es"]["deleteok"] = "Borrar la imagen, en verdad?";
			lang["es"]["back"] = "VOLVER";
			lang["es"]["cancel"] = "CANCELAR";
			lang["es"]["start"] = " NUEVA ";
			lang["es"]["loading"] = "Carga...";
			lang["es"]["save"] = "GRABAR";
			lang["es"]["saved"] = "Grabando.";
			lang["es"]["saving"] = "Imagen está grabando";
			lang["es"]["gallery"] = "GALERÍA";
			lang["es"]["image"] = "Imagen";
			lang["es"]["settings"] = "Opciónes";
			lang["es"]["saveingallery"] = "Grabar en la galería";
			lang["es"]["saveincameraroll"] = "Grabar en el carrete";
			lang["es"]["converting"] = "Convertir...";
			lang["es"]["reedit"] = "Editar otra vez";
			
			switch(Capabilities.language)
			{
				case "de":
				case "en":
				case "fr":
				case "ja":
				case "es":
					locale = Capabilities.language;
					break;
			}
			//locale = "es";
			//trace("language inited as " + locale + " because: " + Capabilities.language);
		}
		
		private static var lang:Object = {"de":{},"en":{},"fr":{},"ja":{},"es":{}};
		
		public static var locale:String = "en";
		
		public static function get BACK():String { return lang[locale]["back"]; }
		public static function get CANCEL():String { return lang[locale]["cancel"]; }
		public static function get OK():String { return lang[locale]["ok"]; }
		public static function get REALLYDELETE():String { return lang[locale]["deleteok"]; }
		public static function get CREATE():String { return lang[locale]["start"];}
		public static function get LOADING():String { return lang[locale]["loading"];}
		public static function get IMAGE():String { return lang[locale]["image"];}
		public static function get SAVE():String { return lang[locale]["save"];}
		public static function get SAVED():String { return lang[locale]["saved"];}
		public static function get SAVING():String { return lang[locale]["saving"];}
		public static function get UPLOADING():String { return lang[locale]["uploading"];}
		public static function get GALLERY():String { return lang[locale]["gallery"];}
		public static function get SETTINGS():String { return lang[locale]["settings"];}
		public static function get SAVE_IN_GALLERY():String { return lang[locale]["saveingallery"];}
		public static function get SAVE_IN_CAMERAROLL():String { return lang[locale]["saveincameraroll"];}
		public static function get REEDIT():String { return lang[locale]["reedit"];}
		public static function get VIEW_IN_GALLERY():String { return lang[locale]["viewingallery"];}
		public static function get YES():String { return lang[locale]["yes"];}
		public static function get NO():String { return lang[locale]["no"];}
		
	}
}