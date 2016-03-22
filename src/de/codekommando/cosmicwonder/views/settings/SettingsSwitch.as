package de.codekommando.cosmicwonder.views.settings
{
	import de.codekommando.cosmicwonder.views.CosmicTextWrapper;
	import de.codekommando.cosmicwonder.views.ResponsiveButton;
	
	public class SettingsSwitch extends ResponsiveButton
	{
		
		private var title:CosmicTextWrapper;
		private var icon:CheckIcon = new CheckIcon();
		public function SettingsSwitch(txt:String)
		{
			title = new CosmicTextWrapper(txt);
			title.scaleX = title.scaleY = 0.5;
			addChild(icon);
			addChild(title);
			title.x = 90;
			title.y = 40;
			super();
		}
		private var _value:Boolean;

		public function get value():Boolean
		{
			return _value;
		}

		public function set value(val:Boolean):void
		{
			_value = val;
			icon.checked.visible = val;
		}

	}
}