package  classes.tabMenu // This class creates buttons with the incoming title and font size for the Calculator
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import classes.Theme;
	
	public class CalcBtn extends Sprite
	{
		private var _theme:Theme; // Reference to the Theme class
		private var _button:SimpleButton; // Object that holds the button
		private var _title:String; // Text to be displayed on the button
		private var _tField:TextField; // TextField to hold the button title
		private var _tfTitle:TextFormat; // Format of the button title
		private var _size:Number; // Size of the text to be displayed
		private var _calcBtn:Sprite; // Library reference to the up state of the button
		private var _calcBtnOver:Sprite; // Library reference to the over state of the button

		public function CalcBtn(theme:Theme, btnTitle:String, size:Number = 18)
		{
			// Set argument vars
			_theme = theme;
			_title = btnTitle;
			_size = size;
			
			// Create and set objects
			_calcBtn = new Sprite;
			_calcBtnOver = new Sprite;
			
			init();
			buildBtns();
		}
		
		// Builds the up and over versions of the buttons
		private function init():void
		{
			// Calc button up
			var calcBtnBmd:BitmapData = new BitmapData(120, 30, true, _theme.calcBtnColor);
			var calcBtnBm:Bitmap = new Bitmap(calcBtnBmd);
			
			var calcBtnTextureBmd:BitmapData = new BitmapData(120, 30, true, 0xFF000000);
			calcBtnTextureBmd.noise(10, 1, 12, 7); // Adds film grain texture to the background
			var calcBtnTextureBm:Bitmap = new Bitmap(calcBtnTextureBmd);
			
			calcBtnTextureBm.blendMode = BlendMode.ADD; // Blends background color with texture
			
			_calcBtn.addChild(calcBtnBm);
			_calcBtn.addChild(calcBtnTextureBm);
			
			// Calc button over
			var calcBtnOverBmd:BitmapData = new BitmapData(120, 30, true, _theme.calcBtnColor);
			var calcBtnOverBm:Bitmap = new Bitmap(calcBtnOverBmd);
			
			var calcBtnOverTextureBmd:BitmapData = new BitmapData(120, 30, true, 0xFF000000);
			calcBtnOverTextureBmd.noise(10, 1, 12, 7); // Adds film grain texture to the background
			var calcBtnOverTextureBm:Bitmap = new Bitmap(calcBtnOverTextureBmd);
			
			calcBtnOverTextureBm.blendMode = BlendMode.ADD; // Blends background color with texture
			
			_calcBtnOver.addChild(calcBtnOverBm);
			_calcBtnOver.addChild(calcBtnOverTextureBm);
		}
		
		private function buildBtns():void
		{
			_button = new SimpleButton;
			_button.upState = _calcBtn;
			_button.overState = _calcBtnOver;
			_button.downState = _calcBtnOver;
			_button.hitTestState = _calcBtn;
			_button.filters = [new DropShadowFilter(3, 45, 0x000000)];
			addChild(_button);
			
			_tfTitle = new TextFormat;
			_tfTitle.font= "Verdana, Arial, Times";
			_tfTitle.size = _size;
			_tfTitle.color = 0xffffff;
			_tfTitle.align = "center";
			
			_tField = new TextField;
			_tField.text = _title;
			_tField.antiAliasType = AntiAliasType.ADVANCED;
			_tField.autoSize = TextFieldAutoSize.CENTER;
			_tField.setTextFormat(_tfTitle);
			_tField.mouseEnabled = false;
			addChild(_tField);
			
			_button.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_button.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			setPosition();
		}
		
		// Centers textField inside of button on init and on mouse over
		private function setPosition():void
		{
			_tField.x = (_button.width / 2) - (_tField.width / 2);
		  	_tField.y = (_button.height / 2) - (_tField.height / 2);
		}
		
		// Handles the drop shadow on mouse over
		private function onMouseOver(e:MouseEvent):void
		{
			_button.filters = [new DropShadowFilter(5, 45, 0x000000)];
		}
		
		// Handles the drop shadow on mouse out
		private function onMouseOut(e:MouseEvent):void
		{
			_button.filters = [new DropShadowFilter(3, 45, 0x000000)];
		}
	}
}