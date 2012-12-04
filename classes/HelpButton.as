package classes // This class will take a string and use it for the text of a help button
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
	import flash.text.AntiAliasType;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	public class HelpButton extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _helpText:String; // Var to store incoming String that loads into helpPanel
		private var _helpPanel:Sprite; // The object that is opened on helpButton click and holds helpPanelBg and border
		private var _helpPanelBg:Sprite; // The object that creates the background for the text
		private var _helpPanelBorder:Sprite; // The object behind the helpPanel that creates the border
		private var _helpTextField:TextField; // The TextField that holds the incoming helpText
		private var _tfHelpText:TextFormat; // Format for the helpText
		private var _helpBtn:SimpleButton; // The button that is initially displayed
		private var _helpBtnUp:Sprite; // Library reference to the up state of the help button
		private var _helpBtnOver:Sprite; // Library reference to the over state of the help button
		private var _closeBtn:SimpleButton; // Object that becomes the close button
		private var _closeBtnUp:Sprite; // Library reference to the up state of the close button
		private var _closeBtnOver:Sprite; // Library reference to the over state of the close button
		
		// Settable vars
		private var _helpBoxOpen:Boolean; // Flag used to determine if the helpPanel is open
		private var _scale:Number; // The scale at which the helpPanel starts from while tweening to full scale
		private var _helpPanelWidth:Number; // Width of the helpPanel
		
		public function HelpButton(xmlData:Param, theme:Theme, helpText:String)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			_helpText = helpText;
			
			// Settable vars
			_helpBoxOpen = false;
			_scale = _xmlData.scale;
			_helpPanelWidth = _xmlData.helpPanelWidth;
			
			// Create and set objects
			_helpBtnUp = _theme.helpBtnUp;
			_helpBtnOver = _theme.helpBtnOver;
			
			_closeBtnUp = _theme.closeBtnUp;
			_closeBtnOver = _theme.closeBtnOver;
			
			init();
			buildHelpPanel();
		}
		
		private function init():void
		{
			// Setup the text format for the text
			_tfHelpText = new TextFormat;
			_tfHelpText.font = "Verdana, Arial, Times";
			_tfHelpText.size = 15;
			_tfHelpText.color = 0xFFFFFF;
			_tfHelpText.align = "left";
			_tfHelpText.leftMargin = 5;
			
			// Assigns the help button its states
			_helpBtn = new SimpleButton;
			_helpBtn.upState = _helpBtnUp;
			_helpBtn.overState = _helpBtnOver;
			_helpBtn.downState = _helpBtnOver;
			_helpBtn.hitTestState = _helpBtnUp;
			addChild(_helpBtn);
			
			// Assigns the close button its states
			_closeBtn = new SimpleButton;
			_closeBtn.upState = _closeBtnUp;
			_closeBtn.overState = _closeBtnOver;
			_closeBtn.downState = _closeBtnOver;
			_closeBtn.hitTestState = _closeBtnUp;
			_closeBtn.filters = [new DropShadowFilter(3, 45, 0x000000)];
			
			// Add Event listeners
			_helpBtn.addEventListener(MouseEvent.CLICK, clickHandler);
		}
			
		private function buildHelpPanel():void
		{
			// Set up the TextField
			_helpTextField = new TextField;
			_helpTextField.text = _helpText;
			_helpTextField.antiAliasType = AntiAliasType.ADVANCED;
			_helpTextField.autoSize = TextFieldAutoSize.LEFT;
			_helpTextField.wordWrap = true;
			_helpTextField.setTextFormat(_tfHelpText);
			_helpTextField.width = _helpPanelWidth - _closeBtn.width - 15; // The 15 adds padding to the right edge of the text
			
			// Build the graphic that serves as the backgound for the helpPanel
			var bgColorBmd:BitmapData = new BitmapData(_helpPanelWidth, _helpTextField.height + 8, true, _theme.helpPanelBgColor);
			var bgColorBm:Bitmap = new Bitmap(bgColorBmd);
			
			var bgTextureBmd:BitmapData = new BitmapData(_helpPanelWidth, _helpTextField.height + 8, true, 0xFF000000);
			bgTextureBmd.noise(10, 1, 12, 7); // Adds film grain texture to the background
			var bgTextureBm:Bitmap = new Bitmap(bgTextureBmd);
			bgTextureBm.blendMode = BlendMode.ADD; // Blends background color with texture
			
			_helpPanelBg = new Sprite;
			_helpPanelBg.addChild(bgColorBm);
			_helpPanelBg.addChild(bgTextureBm);
			
			// Build the helpPanel background that shows up as a border on the helpPanel
			_helpPanelBorder = new Sprite;
			_helpPanelBorder.graphics.lineStyle(1, 0xFFFFFF);
			_helpPanelBorder.graphics.moveTo(_helpPanelBg.x, _helpPanelBg.y + _helpPanelBg.height);
			_helpPanelBorder.graphics.lineTo(_helpPanelBg.x, _helpPanelBg.y);
			_helpPanelBorder.graphics.lineTo(_helpPanelBg.x + _helpPanelBg.width, _helpPanelBg.y);
			
			// Puts the helpPanel backgound and border together
			_helpPanel = new Sprite;
			_helpPanel.addChild(_helpPanelBg);
			_helpPanel.addChild(_helpPanelBorder);
			_helpPanel.scaleX = _scale;
			_helpPanel.scaleY = _scale;
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			_helpPanel.x = (_helpBtn.width / 2) - (_helpPanel.width / 2);
			_helpPanel.y = (_helpBtn.height / 2) - (_helpPanel.height / 2);
			addChild(_helpPanel);
			
			TweenMax.to(_helpPanel, .50, {transformAroundCenter:{scaleX:1, scaleY:1}, ease:Back.easeOut, onComplete:openHelpBox});
			//TweenMax.to(_helpBtn, .25, {transformAroundCenter:{scaleX:1, scaleY:1}}); // Returns helpBtn to scale
		}
		
		private function openHelpBox():void
		{
			_closeBtn.x = _helpPanelBg.width - (_closeBtn.width + 5); // The 5 adds padding from the edges
			_closeBtn.y = 5;
			_closeBtn.addEventListener(MouseEvent.CLICK, closeHelpBoxEvent);
			
			_helpPanel.addChild(_helpTextField); // Add the helpTextField to the helpPanel after the helpPanel tweens open
			_helpPanel.addChild(_closeBtn); // Add the closeBtn to the helpPanel after the helpPanel tweens open
			
			_helpBoxOpen = true; // Sets flag to true so if they are still open when the parent closes, the parent class can call closeHelpBox
		}
		// Event parameter workaround for closeHelpBox function
		private function closeHelpBoxEvent(e:MouseEvent)
		{
			closeHelpBox();
		}
		
		public function closeHelpBox():void
		{
			if(_helpBoxOpen)
			{
				TweenMax.to(_helpPanel, .25, {transformAroundCenter:{scaleX:_scale, scaleY:_scale}, onComplete:removeHelpBox});
				_helpPanel.removeChild(_helpTextField);
			}
			
			_helpBoxOpen = false; // Resets flag so as to avoid any errors if closeHelpBox is called while no boxes are open
		}
		
		private function removeHelpBox():void
		{
			_closeBtn.removeEventListener(MouseEvent.CLICK, closeHelpBox);
			removeChild(_helpPanel); // Removes the helpPanel and its children
		}
		
	}
}