package classes // This class creates an interactive button on its parent image to provide navigation to other images
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import classes.events.NavEvent;
	
	public class InteractiveNav extends Sprite
	{
		private var _theme:Theme; // Reference to the Theme class
		private var _Xpos:Number; // Incoming x position of the interactive button
		private var _Ypos:Number; // Incoming y position of the interactive button
		private var _data:int; // Reference to the data used to create the interactivity, in this case the slideNum
		private var _button:SimpleButton; // Object that becomes the interactive button
		private var _btnUp:Sprite; // Library reference to the up state of the interactive button
		private var _btnOver:Sprite; // Library reference to the over state of the interactive button

		public function InteractiveNav(theme:Theme, Xpos:Number, Ypos:Number, data:int)
		{
			// Set argument vars
			_theme = theme;
			_Xpos = Xpos;
			_Ypos = Ypos;
			_data = data;
			
			// Create and set objects
			_btnUp = _theme.navBtnUp;
			_btnOver = _theme.navBtnOver;
			
			init();
		}
		
		private function init():void
		{
			_button = new SimpleButton;
			_button.upState = _btnUp;
			_button.overState = _btnOver;
			_button.downState = _btnOver;
			_button.hitTestState = _btnUp;
			addChild(_button);
			
			_button.addEventListener(MouseEvent.CLICK, onClick);
			
			this.x = _Xpos;
			this.y = _Ypos;
		}
		
		private function onClick(e:MouseEvent):void
		{
			dispatchEvent(new NavEvent(NavEvent.SEND_SLIDENUM, _data, true)); // Dispatch to Main to change picture
		}
	}
}