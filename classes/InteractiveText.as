package classes // This class creates an interactive button on its parent image to display a text box
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import classes.events.InfoEvent;
	
	public class InteractiveText extends Sprite
	{
		private var _theme:Theme; // Reference to the Theme class
		private var _Xpos:Number; // Incoming x position of the interactive button
		private var _Ypos:Number; // Incoming y position of the interactive button
		private var _data:String; // Reference to the data used to create the interactivity, in this case a string of text
		private var _infoPanel:Sprite; // The object that is opened on helpButton click and holds helpPanelBg and border
		private var _infoPanelBg:Sprite; // The object that creates the background for the text
		private var _infoTextField:TextField; // The TextField that holds the incoming info
		private var _tfInfo:TextFormat; // Format for the info box
		private var _button:SimpleButton; // Object that becomes the interactive button
		private var _btnUp:Sprite; // Library reference to the up state of the interactive button
		private var _btnOver:Sprite; // Library reference to the over state of the interactive button
		private var _closeBtn:SimpleButton; // Object that becomes the close button
		private var _closeBtnUp:Sprite; // Library reference to the up state of the close button
		private var _closeBtnOver:Sprite; // Library reference to the over state of the close button
		
		// Settable vars
		private var _infoBoxOpen:Boolean; // Flag used to determine if the info box is open
		private var _infoPanelWidth:Number; // Width of the info box

		public function InteractiveText(theme:Theme, Xpos:Number, Ypos:Number, data:String)
		{
			// Set argument vars
			_theme = theme;
			_Xpos = Xpos;
			_Ypos = Ypos;
			_data = data;
			
			// Settable vars
			_infoBoxOpen = false;
			_infoPanelWidth = 275;
			
			// Create and set objects
			_btnUp = _theme.infoBtnUp;
			_btnOver = _theme.infoBtnOver;
			_closeBtnUp = _theme.closeBtnUp;
			_closeBtnOver = _theme.closeBtnOver;
			
			init();
			buildInfoPanel();
		}
		
		private function init():void
		{
			// Setup the text format for the text
			_tfInfo = new TextFormat;
			_tfInfo.font = "Verdana, Arial, Times";
			_tfInfo.size = 14;
			_tfInfo.color = 0xFFFFFF;
			_tfInfo.align = "left";
			_tfInfo.leftMargin = 5;
			
			// Assign the info button its states
			_button = new SimpleButton;
			_button.upState = _btnUp;
			_button.overState = _btnOver;
			_button.downState = _btnOver;
			_button.hitTestState = _btnUp;
			addChild(_button);
			
			// Assign the close button its states
			_closeBtn = new SimpleButton;
			_closeBtn.upState = _closeBtnUp;
			_closeBtn.overState = _closeBtnOver;
			_closeBtn.downState = _closeBtnOver;
			_closeBtn.hitTestState = _closeBtnUp;
			_closeBtn.filters = [new DropShadowFilter(3, 45, 0x000000)]; // Adds drop shadow to object
			
			_button.addEventListener(MouseEvent.CLICK, onClick);
			
			this.x = _Xpos;
			this.y = _Ypos;
		}
		
		private function buildInfoPanel():void
		{
			// Set up the TextField
			_infoTextField = new TextField;
			_infoTextField.text = _data;
			_infoTextField.antiAliasType = AntiAliasType.ADVANCED;
			_infoTextField.autoSize = TextFieldAutoSize.LEFT;
			_infoTextField.wordWrap = true;
			_infoTextField.setTextFormat(_tfInfo);
			_infoTextField.width = _infoPanelWidth - _closeBtn.width - 10; // The 10 adds padding to the right edge of the text
			
			// Build the graphic that serves as the backgound for the infoPanel
			_infoPanelBg = new Sprite;
			_infoPanelBg.graphics.beginFill(_theme.helpPanelBgColor, .60);
			_infoPanelBg.graphics.drawRect(0, 0, _infoPanelWidth, 1);
			_infoPanelBg.graphics.endFill();
			
			// Puts the infoPanel backgound inside container object
			_infoPanel = new Sprite;
			_infoPanel.addChild(_infoPanelBg);
		}
		
		// Handles the mouse click on the info button
		private function onClick(e:MouseEvent):void
		{
			if(_infoBoxOpen) // If the box is already open, info button will act like close button when clicked
			{
				closeInfoBox();
			}
			
			else
			{
				var infoPanelMinHeight:Number = _closeBtn.height + 10; // Set a minimum height to the info box
				
				dispatchEvent(new InfoEvent(InfoEvent.SEND_INFO_BOX, _infoPanel, true)); // Dispatch to Main to add in correct position
				
				if(_infoTextField.height < infoPanelMinHeight)
				{
					TweenMax.to(_infoPanelBg, .75, {height: infoPanelMinHeight, ease:Back.easeOut, onComplete:openInfoBox});
				}
				
				else
				{
					TweenMax.to(_infoPanelBg, .75, {height: _infoTextField.height + 5, ease:Back.easeOut, onComplete:openInfoBox});
				}
			}
		}
		
		// Opens the info box and adds the text and close button
		private function openInfoBox():void
		{
			_closeBtn.x = _infoPanelBg.width - (_closeBtn.width + 5); // The 5 adds padding from the right edge of the panel background
			_closeBtn.y = 5;
			_closeBtn.addEventListener(MouseEvent.CLICK, closeInfoBoxEvent);
			
			_infoPanel.addChild(_infoTextField);
			_infoPanel.addChild(_closeBtn)
			_infoPanel.addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			_infoBoxOpen = true;
		}
		
		// Event parameter workaround for closeInfoBox function
		private function closeInfoBoxEvent(e:MouseEvent)
		{
			closeInfoBox();
		}
		
		// Tweens info box closed
		private function closeInfoBox():void
		{
			TweenMax.to(_infoPanelBg, .5, {height: 1, onComplete:removeInfoBox});
			_infoPanel.removeChild(_infoTextField);
			_infoPanel.removeChild(_closeBtn);
			
			_infoBoxOpen = false; // Resets flag when removed from stage via InfoEvent dispatch
		}
		
		// Dispatches event to tell Main to remove the info box once its transitioned out
		private function removeInfoBox():void
		{
			dispatchEvent(new InfoEvent(InfoEvent.REMOVE_INFO_BOX, _infoPanel, true)); // Dispatch to Main to remove the info box
		}
		
		// Resets info box if its still open when the img transitions, plus removes event listeners
		private function removed(e:Event):void
		{
			if(_infoBoxOpen) // This is basically the closeInfoBox func but called only when that func is bypassed because of img trans
			{
				_infoPanelBg.height = 1;
				_infoPanel.removeChild(_infoTextField);
				_infoPanel.removeChild(_closeBtn);
				_infoBoxOpen = false; // Resets flag when removed from stage via the img transitioning
			}
			
			_infoPanel.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			_closeBtn.removeEventListener(MouseEvent.CLICK, closeInfoBox);
		}
	}
}