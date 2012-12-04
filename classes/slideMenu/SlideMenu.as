package classes.slideMenu // This class is the main class for the SlideMenu, it builds and adds the main functionality
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import classes.Param;
	import classes.Theme;
	import classes.events.ButtonManagerEvent;
	import classes.events.ParamEvent;
	import classes.events.ScrollbarEvent;
	import classes.events.ThumbManagerEvent;
	import classes.events.ThumbEvent;
	
	public class SlideMenu extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _thumbManager:ThumbManager; // A reference to the ThumbManager instance
		private var _buttonManager:ButtonManager; // A reference to the ButtonManager instance
		private var _scrollbar:Scrollbar; // A reference to the Scrollbar instance
		private var _menuMask:Sprite; // Masks menu too keep it flowing off stage
		private var _startId:int; // Reference to which img gets loaded first
		
		// Settable vars
		private var _slideMenuWidth:Number; // SlideMenu width
		private var _slideMenuHeight:Number;  // SlideMenu height
		private var _scrollbarX:Number; // The position of the Scrollbar on the X axis
		private var _scrollbarY:Number; // The position of the Scrollbar on the Y axis
		
		public function SlideMenu(xmlData:Param, theme:Theme, startId:int)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			_startId = startId;
			
			// Settable vars
			_slideMenuWidth = _xmlData.slideMenuWidth;
			_slideMenuHeight = _xmlData.slideMenuHeight;
			_scrollbarX = _xmlData.scrollbarXPosition;
			_scrollbarY = _xmlData.scrollbarYPosition;
			
			disable();
			init();
		}
		
		private function init():void
		{
			buildThumbManager();
			buildScrollbar();
			buildButtonManager();
		}
		
		// Create the ThumbManager instance
		private function buildThumbManager():void
		{
			_thumbManager = new ThumbManager(_xmlData, _theme, _startId);
			_thumbManager.addEventListener(ThumbManagerEvent.TRANSITION_COMPLETE, enable); // Listen for trans complete in ThumbManager
			_thumbManager.addEventListener(ThumbManagerEvent.TRANSITION_START, imgTransStart); // Listen for trans start in ThumbManager
			_thumbManager.addEventListener(ThumbManagerEvent.IMAGE_CLICKED, turnOffSlideShowEvent); // Listen for img clicked in ThumbManager
			addChild(_thumbManager);
			
			setMask();
		}
		
		// Creates and sets mask for the Thumbmanager
		private function setMask():void
		{
			_menuMask = new Sprite;
			_menuMask.graphics.beginFill(0x000000);
			_menuMask.graphics.drawRect(0, 0, _slideMenuWidth, _slideMenuHeight);
			_menuMask.graphics.endFill();
			_thumbManager.mask = _menuMask;
			addChild(_menuMask);
		}
		
		// When the image transition starts stop the slideshow
		private function imgTransStart(thumbManagerEvent:ThumbManagerEvent):void
		{
			if(_scrollbar !=  null)
			{
				_scrollbar.setHandlerPosition(thumbManagerEvent.id, true);
			}
		}
		
		// Create the Scrollbar instance
		private function buildScrollbar():void
		{
			_scrollbar =  new Scrollbar(_xmlData, _theme);
			_scrollbar.x = _scrollbarX;
			_scrollbar.y = _scrollbarY;
			_scrollbar.addEventListener(ScrollbarEvent.CHANGE, onScrollbarChange); // Listen for change in Scrollbar
			addChild(_scrollbar);
		}
		
		// When Scrollbar changes, change the SlideMenu order
		private function onScrollbarChange(scrollbarEvent:ScrollbarEvent):void
		{
			_thumbManager.gotoThumb(scrollbarEvent.id);
			turnOffSlideShow();
		}
		
		// Create the ButtonManager instance
		private function buildButtonManager():void
		{
			_buttonManager = new ButtonManager(_xmlData, _theme);
			_buttonManager.addEventListener(ButtonManagerEvent.NEXT_BUTTON_DOWN, onNextButtonPressed);
			_buttonManager.addEventListener(ButtonManagerEvent.PREV_BUTTON_DOWN, onPrevButtonPressed);
			_buttonManager.addEventListener(ButtonManagerEvent.PLAY_BUTTON_DOWN, onPlayButtonPressedEvent);
			_buttonManager.addEventListener(ButtonManagerEvent.PAUSE_BUTTON_DOWN, onPauseButtonPressed);
			addChild(_buttonManager);
		}
		
		// When next button is pressed navigate to the next thumb
		private function onNextButtonPressed(buttonManagerEvent:ButtonManagerEvent):void
		{
			_thumbManager.gotoNextThumb();
			_xmlData.setIsPlaying = false;
		}
		
		// When previous button is pressed navigate to the next thumb
		private function onPrevButtonPressed(buttonManagerEvent:ButtonManagerEvent):void
		{
			_thumbManager.gotoPrevThumb();
			_xmlData.setIsPlaying = false;
		}
		
		// When next pause button is pressed stop the slide show and current image transition
		private function onPauseButtonPressed(buttonManagerEvent:ButtonManagerEvent):void
		{
			_xmlData.setIsPlaying = false;
		}
		
		// Event parameter workaround for onPlayButtonPressed function
		private function onPlayButtonPressedEvent(buttonManagerEvent:ButtonManagerEvent):void
		{
			onPlayButtonPressed();
		}
		
		// Event parameter workaround for turnOffSlideShow function
		private function turnOffSlideShowEvent(thumbManagerEvent:ThumbManagerEvent):void
		{
			turnOffSlideShow();
		}
		
		// If the slide show is playing, turn it off if a thumb is clicked, the Scrollbar is moved, or the image is dragged
		public function turnOffSlideShow():void
		{
			if(_xmlData.isPlaying)
			{
				_buttonManager.turnPlayBtnOff();
			}
			
			_xmlData.setIsPlaying = false;
		}
		
		// Takes call from InteractiveNav via the Main and changes the SlideMenu and inturn the img displayed
		public function onNavBtn(slideNum:int):void
		{
			_thumbManager.gotoThumb(slideNum);
			turnOffSlideShow();
		}
		
		// When play button is pressed, start the slideshow by restarting the current image
		public function onPlayButtonPressed():void
		{
			_thumbManager.gotoNextThumb(true); // True notifies ThumbManager that the call is coming from the user clicking the play btn
			_xmlData.setIsPlaying = true;
		}
				
		// When the image is done transitioning, Transitions sends event to Main, Main calls nextThumb()
		public function nextThumb():void
		{
			if(_xmlData.isPlaying)
			{
				_thumbManager.gotoNextThumb();
			}
		}
		
		// Enable all mouse events
		private function enable(thumbManagerEvent:ThumbManagerEvent):void
		{
			this.mouseChildren = true;
		}
		
		// Disable all mouse events
		private function disable():void
		{
			this.mouseChildren = false;
		}
		
		public function setCenterThumb(img:DisplayObject, counter:int):void
		{
			_thumbManager.setCenter(img, counter);
		}
		
		public function setTopThumbs(img:DisplayObject, counter:int):void
		{
			_thumbManager.setTop(img, counter);
		}
		
		public function setBottomThumbs(img:DisplayObject, counter:int):void
		{
			_thumbManager.setBottom(img, counter);
		}
	}
}