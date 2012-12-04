package classes.slideMenu // This class will create and manage the buttons functionality
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.filters.DropShadowFilter;
	import classes.Param;
	import classes.Theme;
	import classes.events.ButtonManagerEvent;

	public class ButtonManager extends Sprite
	{
		private var _xmlData:Param;; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _label:TextField; // TextField that becomes the label for the slideshow play and pause buttons
		private var _slash:TextField; // TextField to hold the slash inbetween the play and pause buttons
		private var _labelFormat:TextFormat; // Format of the label text
		
		// Button vars
		private var _nextButton:SimpleButton; // Object that becomes the next button
		private var _nextButtonUp:Sprite; // Library reference to up state of the next button
		private var _nextButtonOver:Sprite; // Library reference to over state of the next button
		private var _prevButton:SimpleButton; // Object that becomes the previous button
		private var _prevButtonUp:Sprite; // Library reference to up state of the previous button
		private var _prevButtonOver:Sprite; // Library reference to over state of the previous button
		private var _playText:TextField // TextField that becomes the play button
		private var _playTextFormat:TextFormat; // Format of the play text
		private var _pauseText:TextField; // TextField that becomes the pause button
		private var _pauseTextFormat:TextFormat; // Format of the pause text
		
		// Settable vars
		private var _isPlaying:Boolean; // Flag used to check if the slide show is running or not
		private var _nextButtonX:Number; // X position for the next button
		private var _nextButtonY:Number; // Y position for the next button
		private var _prevButtonX:Number; // X position for the prev button
		private var _prevButtonY:Number; // Y position for the prev button
		private var _playPauseX:Number; // X position for the play and pause buttons
		private var _playPauseY:Number; // Y position for the play and pause buttons
				 
		public function ButtonManager(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_isPlaying = _xmlData.isPlaying;
			_nextButtonX = _xmlData.nextButtonX;
			_nextButtonY = _xmlData.nextButtonY;
			_prevButtonX = _xmlData.prevButtonX;
			_prevButtonY = _xmlData.prevButtonY;
			_playPauseX = _xmlData.playPauseX;
			_playPauseY = _xmlData.playPauseY;
			
			init();
			navBtnSetup();
			playPauseBtnSetup();
			setPlayButtonIcon();
		}
		
		// Create and setup the text formats
		private function init():void
		{
			_labelFormat = new TextFormat;
			_labelFormat.font = "Verdana, Arial, Times";
			_labelFormat.size = 15;
			_labelFormat.color = 0xFFFFFF;
			_labelFormat.align = "left";
			
			_playTextFormat = new TextFormat;
			_playTextFormat.font = "Verdana, Arial, Times";
			_playTextFormat.size = 14;
			_playTextFormat.color = 0xFFFFFF;
			_playTextFormat.align = "left";
			
			_pauseTextFormat = new TextFormat;
			_pauseTextFormat.font = "Verdana, Arial, Times";
			_pauseTextFormat.size = 14;
			_pauseTextFormat.color = 0xFFFFFF;
			_pauseTextFormat.align = "left";
		}
		
		// Create and setup next and previous buttons
		private function navBtnSetup():void
		{
			_nextButtonUp = _theme.nextButtonUp;
			_nextButtonOver = _theme.nextButtonOver;
			_prevButtonUp = _theme.prevButtonUp;
			_prevButtonOver = _theme.prevButtonOver;
			
			_nextButton = new SimpleButton;
			_nextButton.upState = _nextButtonUp;
			_nextButton.overState = _nextButtonOver;
			_nextButton.downState = _nextButtonOver;
			_nextButton.hitTestState = _nextButtonUp;
			_nextButton.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			_nextButton.addEventListener(MouseEvent.CLICK, nextPrev);
			
			_prevButton = new SimpleButton;
			_prevButton.upState = _prevButtonUp;
			_prevButton.overState = _prevButtonOver;
			_prevButton.downState = _prevButtonOver;
			_prevButton.hitTestState = _prevButtonUp;
			_prevButton.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			_prevButton.addEventListener(MouseEvent.CLICK, nextPrev);
			
			_nextButton.x = _nextButtonX;
			_nextButton.y = _nextButtonY;
			
			_prevButton.x = _prevButtonX;
			_prevButton.y = _prevButtonY;

			addChild(_nextButton);
			addChild(_prevButton);
		}
		
		// Create and setup the play pause text buttons
		private function playPauseBtnSetup():void
		{
			var mainContainer:Sprite = new Sprite;
			var playContainer:Sprite = new Sprite;
			var pauseContainer:Sprite = new Sprite;
			
			_label = new TextField;
			_label.text = "SLIDESHOW:";
			_label.antiAliasType = AntiAliasType.ADVANCED;
		 	_label.autoSize = TextFieldAutoSize.LEFT;
		  	_label.setTextFormat(_labelFormat);
			_label.mouseEnabled = false;
			
			_playText = new TextField;
			_playText.text = "Play";
			_playText.antiAliasType = AntiAliasType.ADVANCED;
		 	_playText.autoSize = TextFieldAutoSize.LEFT;
		  	_playText.setTextFormat(_playTextFormat);
			
			playContainer.addChild(_playText);
			playContainer.x = _label.width;
			playContainer.y = _label.y;
			playContainer.buttonMode = true;
			playContainer.mouseChildren = false;
						
			_slash = new TextField;
			_slash.text = "/";
			_slash.antiAliasType = AntiAliasType.ADVANCED;
			_slash.autoSize = TextFieldAutoSize.LEFT;
			_slash.setTextFormat(_labelFormat);
			_slash.mouseEnabled = false;
			_slash.x = _label.width + _playText.width - 2;
			_slash.y = _label.y;
			
			_pauseText = new TextField;
			_pauseText.text = "Pause";
			_pauseText.antiAliasType = AntiAliasType.ADVANCED;
		 	_pauseText.autoSize = TextFieldAutoSize.LEFT;
		  	_pauseText.setTextFormat(_pauseTextFormat);
			
			pauseContainer.addChild(_pauseText);
			pauseContainer.x = _label.width + _playText.width + _slash.width - 4;
			pauseContainer.y = _label.y;
			pauseContainer.buttonMode = true;
			pauseContainer.mouseChildren = false;
			
			mainContainer.addChild(_label);
			mainContainer.addChild(playContainer);
			mainContainer.addChild(_slash);
			mainContainer.addChild(pauseContainer);			
			mainContainer.x = _playPauseX;
			mainContainer.y = _playPauseY;
			addChild(mainContainer);
			
			playContainer.addEventListener(MouseEvent.CLICK, onPlayPause);
			pauseContainer.addEventListener(MouseEvent.CLICK, onPlayPause);
		}
		
		// Switch the underline between the play and pause buttons depending on if isPlaying is true or false
		private function setPlayButtonIcon():void
		{
			if(_isPlaying)
			{
				_playTextFormat.underline = true;
				_pauseTextFormat.underline = false;
				
				_playText.setTextFormat(_playTextFormat);
				_pauseText.setTextFormat(_pauseTextFormat);
			}
			
			else
			{
				_playTextFormat.underline = false;
				_pauseTextFormat.underline = true;
				
				_playText.setTextFormat(_playTextFormat);
				_pauseText.setTextFormat(_pauseTextFormat);
			}
		}
		
		// Used by SlideMenu to change the play pause buttons underline
		public function turnPlayBtnOff():void
		{
			_playTextFormat.underline = false;
			_pauseTextFormat.underline = true;
			_isPlaying = false;
				
			_playText.setTextFormat(_playTextFormat);
			_pauseText.setTextFormat(_pauseTextFormat);
		}
		
		// When one of the buttons are pressed, dispatch corresponding events
		private function nextPrev(e:MouseEvent):void
		{
			if(e.currentTarget == _nextButton)
			{
				dispatchEvent(new ButtonManagerEvent(ButtonManagerEvent.NEXT_BUTTON_DOWN)); // Dispatch to SlideMenu to advance next img
				
				if(_isPlaying)
				{
					_isPlaying = false;
					setPlayButtonIcon();
				}
			}
			
			else if(e.currentTarget == _prevButton)
			{
				dispatchEvent(new ButtonManagerEvent(ButtonManagerEvent.PREV_BUTTON_DOWN)); // Dispatch to SlideMenu to go back to last img
				
				if(_isPlaying)
				{
					_isPlaying = false;
					setPlayButtonIcon();
				}
			}
		}
		
		// Stop slideshow if isPlaying is true otherwise start it, also allows play and pause to switch roles if they're already selected
		private function onPlayPause(e:MouseEvent):void
		{
			if(_isPlaying)
			{
				dispatchEvent(new ButtonManagerEvent(ButtonManagerEvent.PAUSE_BUTTON_DOWN, true)); // Dispatch to SlideMenu and Main to stop slideshow
				_isPlaying = false;
				setPlayButtonIcon();
			}
			
			else
			{
				dispatchEvent(new ButtonManagerEvent(ButtonManagerEvent.PLAY_BUTTON_DOWN)); // Dispatch to SlideMenu to start slideshow
				_isPlaying = true;
				setPlayButtonIcon();
			}
		}
	}
}