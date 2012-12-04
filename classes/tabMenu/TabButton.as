package classes.tabMenu // This class creates the tab buttons for the TabMenu
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import classes.Theme;
	
	public class TabButton extends Sprite
	{
		private var _theme:Theme; // Reference to the Theme class
		private var _tabBtn:SimpleButton; // Object that becomes a tab in the TabMenu
		private var _btnUp:Sprite; // Up state of the tab button
		private var _btnOver:Sprite; // Over state of the tab button
		private var _btnActive:Sprite; // Active state of the tab button
		private var _btnText:String; // Incoming name of the button
		
		// Settable vars
		private var _btnUpColor:uint; // Color of the tab in up mode
		private var _btnOverColor:uint; // Color of the tab in over mode
		private var _btnActiveColor:uint; // Color of the tab when selected
		private var _btnHeight:Number; // Height of the tab buttons
		private var _horiPad:Number; // Horizontal padding of the button text
		

		public function TabButton(theme:Theme, btnText:String) 
		{
			// Set argument vars
			_theme = theme;
			_btnText = btnText;
			
			// Settable vars
			_btnUpColor = _theme.tabBtnUpColor;
			_btnOverColor = _theme.tabBtnOverColor;
			_btnActiveColor = _theme.bgColor;
			_btnHeight = 31;
			_horiPad = 12;
			
			buildBtn();
		}
		
		// Builds the tab button objects for use in the TabMenu
		private function buildBtn():void
		{
			// Create button vars
			var btnUpText:TextField = new TextField;
			var btnOverText:TextField = new TextField;
			var btnActiveText:TextField = new TextField;
			var tfBtnText:TextFormat = new TextFormat;
			
			_btnUp = new Sprite;
			_btnOver = new Sprite;
			_btnActive = new Sprite;
			
			tfBtnText.font = "Verdana, Arial, Times";
			tfBtnText.size = 14;
			tfBtnText.color = 0xFFFFFF;
			tfBtnText.align = "center";
			
			// Instantiate the text fields and set their text
			btnUpText.text = _btnText;
			btnUpText.antiAliasType = AntiAliasType.ADVANCED;
			btnUpText.autoSize = TextFieldAutoSize.LEFT;
		  	btnUpText.setTextFormat(tfBtnText);
			btnUpText.mouseEnabled = false;
			
			btnOverText.text = _btnText;
			btnOverText.antiAliasType = AntiAliasType.ADVANCED;
			btnOverText.autoSize = TextFieldAutoSize.LEFT;
		  	btnOverText.setTextFormat(tfBtnText);
			btnOverText.mouseEnabled = false;
			
			btnActiveText.text = _btnText;
			btnActiveText.antiAliasType = AntiAliasType.ADVANCED;
			btnActiveText.autoSize = TextFieldAutoSize.LEFT;
		  	btnActiveText.setTextFormat(tfBtnText);
			btnActiveText.mouseEnabled = false;
			
			_btnUp.addChild(buildBtnBg(btnUpText.width + _horiPad, _btnUpColor));
			_btnUp.addChild(btnUpText);
			
			_btnOver.addChild(buildBtnBg(btnOverText.width + _horiPad, _btnOverColor));
			_btnOver.addChild(btnOverText);
			
			_btnActive.addChild(buildBtnBg(btnUpText.width + _horiPad, _btnActiveColor));
			_btnActive.addChild(btnActiveText);
			
			// Position the text fields on the button backgrounds
			btnUpText.x = (_btnUp.width / 2) - (btnUpText.width / 2);
			btnUpText.y = (_btnUp.height / 2) - (btnUpText.height / 2);
			btnOverText.x = (_btnOver.width / 2) - (btnOverText.width / 2);
			btnOverText.y = (_btnOver.height / 2) - (btnOverText.height / 2);
			btnActiveText.x = (_btnActive.width / 2) - (btnActiveText.width / 2);
			btnActiveText.y = (_btnActive.height / 2) - (btnActiveText.height / 2);
			
			// Set the SimpleButton's states with the completed Sprites
			_tabBtn = new SimpleButton;
			_tabBtn.upState = _btnUp;
			_tabBtn.overState = _btnOver;
			_tabBtn.downState = _btnOver;
			_tabBtn.hitTestState = _btnUp;
			addChild(_tabBtn);
		}
		
		// Builds the background for the tab buttons and returns them
		private function buildBtnBg(bgWidth:Number, bgColor:uint):Sprite
		{
			var btnBg:Sprite = new Sprite;
			var bgColorBmd:BitmapData = new BitmapData(bgWidth, _btnHeight, false, bgColor);
			var bgColorBm:Bitmap = new Bitmap(bgColorBmd);
			
			var bgTextureBmd:BitmapData = new BitmapData(bgWidth, _btnHeight, true, 0xFF000000);
			bgTextureBmd.noise(10, 1, 12, 7); // Adds film grain texture to the background
			var bgTextureBm:Bitmap = new Bitmap(bgTextureBmd);
			
			bgTextureBm.blendMode = BlendMode.ADD; // Blends background color with texture
			
			btnBg.addChild(bgColorBm);
			btnBg.addChild(bgTextureBm);
			
			return(btnBg);
		}
		
		public function activeColor():void
		{
			_tabBtn.upState = _btnActive;
			_tabBtn.overState = _btnActive;
			_tabBtn.downState = _btnActive;
		}
		
		public function nonActiveColor():void
		{
			_tabBtn.upState = _btnUp;
			_tabBtn.overState = _btnOver;
			_tabBtn.downState = _btnOver;
		}
	}
}