package classes // This class is called if there's a loading error and displays an error message with instructions
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;

	public class InfoError extends Sprite
	{
		private var _errorText:String; // String to hold the incoming error text
		private var _errorTextField:TextField; // TextField to hold the errorText
		private var _errorTextFormat:TextFormat; // Format of the errorText
		private var _errorPanelWidth:Number; // Width of the displayed errorPanel
		
		public function InfoError(errorText:String)
		{
			// Set argument vars
			_errorText = errorText;
			_errorTextField = new TextField;
			_errorTextFormat = new TextFormat;
			
			// Settable var
			_errorPanelWidth = 300;
			
			init();
		}
		
		private function init():void
		{
			_errorTextFormat.font = "Century, Times, Arial";
			_errorTextFormat.size = 20;
			_errorTextFormat.color = 0x000000;
			_errorTextFormat.align = "center";
			_errorTextFormat.bold = true;
			
			_errorTextField.text = _errorText;
			_errorTextField.antiAliasType = AntiAliasType.ADVANCED;
			_errorTextField.autoSize = TextFieldAutoSize.CENTER;
			_errorTextField.wordWrap = true;
			_errorTextField.setTextFormat(_errorTextFormat);
			_errorTextField.width = _errorPanelWidth;
			_errorTextField.background = true;
			_errorTextField.backgroundColor = 0xCCCCCC;
			
			addChild(_errorTextField);
		}
	}
}