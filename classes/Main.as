/*******
Copyright 2012 by Matthew Whitehead and Spiffy Home Tours.  All rights reserved.
*******/

package classes // This class creates and puts all of the objects together on the stage
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.plugins.*;
	import classes.slideMenu.SlideMenu;
	import classes.tabMenu.TabMenu;
	import classes.events.SlideIdEvent;
	import classes.events.NavEvent;
	import classes.events.PicEvent;
	import classes.events.InfoEvent;
	import classes.events.TabMenuEvent;
	import classes.events.ParamEvent;
	import classes.events.TransitionsEvent;
	import classes.events.ImgPreloadEvent;
	import classes.events.ThumbDispatchEvent;
	import classes.events.ImgPanEvent;
	import classes.events.ButtonManagerEvent;
	import classes.events.TextBoxesEvent;
	
	public class Main extends Sprite
	{
		private var _xmlPath:String = "config.xml"; // Path to XML doc
		private var _xmlData:Param; // Object to store loaded XML info
		private var _infoError:InfoError; // Reference to the InfoError class
		private var _theme:Theme; // Reference to the Theme class
		private var _preloader:Preloader; // Reference to the Preloader class
		private var _imgPreload:ImgPreload; // Reference to the ImgPreload class
		private var _imgDisplay:ImgDisplay; // Reference to the ImgDisplay class
		private var _slideMenu:SlideMenu; // Reference to the SlideMenu class
		private var _textBoxes:TextBoxes; // Reference to the TextBoxes class
		private var _tabMenu:TabMenu; // Reference to the TapMenu class
		private var _music:Music; // Reference to the Music class
		private var _background:Sprite; // Reference to the Background in the Library
		private var _frame:Sprite; // Reference to the frame in the Library
		private var _navBar:Sprite; // Reference to the navBar in the Library
		private var _greyCover:Sprite; // Used to dim the background when a tab menu page is called
		private var _detailPic:Sprite; // Used to hold the detail picture sent from InteractivePic
		private var _infoBox:Sprite; // Used to hold the info text box sent from InteractiveText
		private var _slideNum:int; // Reference to which img is currently loaded
		
		// Settable vars
		private var _startId:int; // Reference to which img gets loaded first
		private var _prevSlide:int; // Reference to which img is currently loaded
		private var _bgWidth:Number; // Width of the background
		private var _bgHeight:Number; // Height of the background
		private var _navBarWidth:Number; // Width of the nav bar, should be width of image mask
		private var _navBarHeight:Number; // Height of the nav bar
		private var _navBarX:Number; // X position of the navBar
		private var _navBarY:Number; // Y position of the navBar
		private var _imgDisplayX:Number; // X position of the ImgDisplay
		private var _imgDisplayY:Number; // Y position of the ImgDisplay
		private var _maskWidth:Number; // Width of the ImgDisplay mask
		private var _maskHeight:Number; // Height of the ImgDisplay mask
		private var _slideMenuX:Number; // X position of the slideMenu
		private var _slideMenuY:Number; // Y position of the slideMenu
		private var _tabMenuX:Number; // X position of the tabMenu
		private var _tabMenuY:Number; // Y position of the tabMenu
		private var _fromPlayBtn:Boolean; // Flag to notify imgDisplay if the call to change the image comes from the play button
		private var _greyCoverOn:Boolean; // Flag used to tell if the slideshow is paused via the TabMenu
		private var _detailPicInUse:Boolean; // Flag used to tell if the detail picture is displayed or not
		private var _infoBoxInUse:Boolean; // Flag used to tell if the info text box is displayed or not

		public function Main() 
		{
			_xmlData = new Param(_xmlPath); // Creates new Param object to store XML info
			_xmlData.addEventListener(ParamEvent.XML_LOAD_COMPLETE, xmlLoaded); // Listen for xml loaded in Param
			_xmlData.addEventListener(ParamEvent.ERROR, onDataError); // Listen for error in Param xml loading
			
			TweenPlugin.activate([TransformAroundCenterPlugin, TransformMatrixPlugin]); // This is where any TweenMax pulgins get activated
		}
		
		// When the xml file can not be loaded
		private function onDataError(errorEvent:ParamEvent):void
		{
			_infoError = new InfoError(errorEvent.errorText); // If there is a loading error in Param this will show
			addChild(_infoError);
		}
		
		// After the xml is loaded this function instantiates the Preloader and sets the vars
		private function xmlLoaded(paramEvent:ParamEvent):void
		{
			_theme = new Theme(_xmlData);
			_preloader = new Preloader(_xmlData, _theme);
			addChild(_preloader);
			
			// Settable vars
			_startId = Math.round(_xmlData.numOfImages / 2 - 1);
			_prevSlide = _startId;
			_bgWidth = _xmlData.bgWidth;
			_bgHeight = _xmlData.bgHeight;
			_navBarWidth = _xmlData.navBarWidth;
			_navBarHeight = _xmlData.navBarHeight;
			_navBarX = _xmlData.navBarX;
			_navBarY = _xmlData.navBarY;
			_imgDisplayX = _xmlData.imgDisplayX;
			_imgDisplayY = _xmlData.imgDisplayY;
			_maskWidth = _xmlData.maskWidth;
			_maskHeight = _xmlData.maskHeight;
			_slideMenuX = _xmlData.slideMenuX;
			_slideMenuY = _xmlData.slideMenuY;
			_tabMenuX = _xmlData.tabMenuX;
			_tabMenuY = _xmlData.tabMenuY;
			_greyCoverOn = false;
			_infoBoxInUse = false;
					
			_xmlData.removeEventListener(ParamEvent.ERROR, onDataError);
			_xmlData.removeEventListener(ParamEvent.XML_LOAD_COMPLETE, xmlLoaded);
			
			init();
		}

		// Calls all of the build functions and keeps the Preloader on top until its removed
		private function init():void 
		{
			buildImgPreload();
			buildBackground();
			buildImgDisplay();
			buildNavBar();
			buildSlideMenu();
			buildTextBoxes();
			buildMusic();
			buildTabMenu();
			setChildIndex(_preloader, this.numChildren -1);
		}
		
		// **** Build methods ****
		
		private function buildImgPreload():void
		{
			_imgPreload = new ImgPreload(_xmlData, _theme, _startId);
			_imgPreload.addEventListener(ImgPreloadEvent.IMG_PRELOAD_COMPLETE, startTour);
			_imgPreload.addEventListener(ImgPreloadEvent.IMG_PRELOAD_PROGRESS, setPercent);
			_imgPreload.addEventListener(ThumbDispatchEvent.SEND_CENTER_THUMB, setCenter);
			_imgPreload.addEventListener(ThumbDispatchEvent.SEND_TOP_THUMB, setTop);
			_imgPreload.addEventListener(ThumbDispatchEvent.SEND_BOTTOM_THUMB, setBottom);
		}
		
		private function buildBackground():void
		{
			var bgColorBmd:BitmapData = new BitmapData(_bgWidth, _bgHeight, true, _theme.bgColor);
			var bgColorBm:Bitmap = new Bitmap(bgColorBmd);
			
			var bgTextureBmd:BitmapData = new BitmapData(_bgWidth, _bgHeight, true, 0xFF000000);
			bgTextureBmd.noise(10, 1, 12, 7); // Adds film grain texture to the background
			var bgTextureBm:Bitmap = new Bitmap(bgTextureBmd);
			bgTextureBm.blendMode = BlendMode.ADD; // Blends background color with texture
			
			var shadowBmd:BitmapData = new BitmapData(_bgWidth, _bgHeight, true, 0xFF040404); // Creates a drop shadow behind the background
			var shadowBm:Bitmap = new Bitmap(shadowBmd);
			shadowBm.x = 3;
			shadowBm.y = 3;
			
			addChild(shadowBm);
			addChild(bgColorBm);
			addChild(bgTextureBm);
		}
		
		private function buildImgDisplay():void
		{
			_imgDisplay = new ImgDisplay(_xmlData, _imgPreload.imgArray, _startId);
			_imgDisplay.x = _imgDisplayX;
			_imgDisplay.y = _imgDisplayY;
			_imgDisplay.filters = [new DropShadowFilter(5, 45, 0x000000)]; // Adds drop shadow to object
			_imgDisplay.addEventListener(ImgPanEvent.STOP_SLIDE_SHOW, pauseOnImgPan); // Listen for click on transitioning image
			_imgDisplay.addEventListener(TransitionsEvent.TRANS_SLIDE_MENU, nextThumb); // Listen for change in Transitions
			_imgDisplay.addEventListener(TextBoxesEvent.MOVE_RM_LABEL, moveRmLabel); // Listen for new x pos in Transitions
			_imgDisplay.addEventListener(NavEvent.SEND_SLIDENUM, onNavBtn); // Listen for click in InteractiveNav
			_imgDisplay.addEventListener(PicEvent.SEND_PIC, addDetailPic); // Listen for click in InteractivePic
			_imgDisplay.addEventListener(PicEvent.REMOVE_PIC, removeDetailPicEvent); // Listen for closing of InteractivePic
			_imgDisplay.addEventListener(InfoEvent.SEND_INFO_BOX, addInfoBox); // Listen for click in InteractiveText
			_imgDisplay.addEventListener(InfoEvent.REMOVE_INFO_BOX, removeInfoBoxEvent); // Listen for closing of InteractiveText box
			addChild(_imgDisplay);
		}
		
		private function buildNavBar():void
		{			
			var navBarBmd:BitmapData = new BitmapData(_navBarWidth, _navBarHeight, true, _theme.navBarColor);
			var navBarBm:Bitmap = new Bitmap(navBarBmd);			
			
			navBarBm.alpha = .60;
			navBarBm.x = _navBarX;
			navBarBm.y = _navBarY;
			
			addChild(navBarBm);
		}
		
		private function buildSlideMenu():void
		{
			_slideMenu = new SlideMenu(_xmlData, _theme, _startId);
			_slideMenu.x = _slideMenuX;
			_slideMenu.y = _slideMenuY;
			_slideMenu.addEventListener(SlideIdEvent.CHANGE_IMG, changeImg); // Listen for id change in ThumbManager
			_slideMenu.addEventListener(ButtonManagerEvent.PAUSE_BUTTON_DOWN, stopOnPauseBtn); // Listen for the pause button being pressed in SlideMenu
			addChild(_slideMenu);
		}
		
		private function buildTextBoxes():void
		{
			_textBoxes = new TextBoxes(_xmlData, _theme, _imgPreload.imgArray, _startId);
			addChild(_textBoxes);
		}
		
		private function buildMusic():void
		{
			_music = new Music(_xmlData, _theme);
			addChild(_music);
		}
		
		private function buildTabMenu():void
		{
			_tabMenu = new TabMenu(_xmlData, _theme);
			_tabMenu.x = _tabMenuX;
			_tabMenu.y = _tabMenuY;
			_tabMenu.addEventListener(TabMenuEvent.MENU_CLICK, pauseOnTabMenu);
			_tabMenu.addEventListener(TabMenuEvent.REMOVE_COVER, resumeOnTabMenu);
			addChild(_tabMenu);
			
			_greyCover = new Sprite;
			_greyCover.graphics.beginFill(0x1A1A1A);
			_greyCover.graphics.drawRect(0, 0, _bgWidth, _bgHeight);
			_greyCover.graphics.endFill();
		}
		
		// **** API methods ****
		// These methods are the event handlers that get used when an event from inside the tour bubbles up and calls them
		// They also direct any vars or function calls back down into the diffrent parts of the tour
		
		// Takes call from ThumbManager to change the img in imgDisplay and the room label text in TextBoxes
		private function changeImg(slideIdEvent:SlideIdEvent)
		{
			_slideNum = slideIdEvent.slideNum; // Retrieves slideNum from event get method
			_fromPlayBtn = slideIdEvent.fromPlayBtn; // Retrieves fromPlayBtn from event get method
			_textBoxes.changeRoomLabel(_slideNum); // Call to change the room label text in TextBoxes
			_imgDisplay.changeImg(_slideNum, _prevSlide, _fromPlayBtn); // Call to change img in ImgDisplay, passes slideNum, updated prevSlide, and notifies method if call is from the play button
			_prevSlide = _slideNum; // Update the prevSlide number for next call
			removeInfoBox(); // If an info text box is open when img is changed, close it
			removeDetailPic(); // If a detail picture is open when img is changed, close it
		}
		
		// Makes the SlideMenu transition to the next thumb after its done transitioning in Transitions
		private function nextThumb(transitionsEvent:TransitionsEvent):void
		{
			_slideMenu.nextThumb();
		}
		
		// Called if a vert pano used in Transitions is thinner than the mask width, resets the x position of the room label in TextBoxes
		private function moveRmLabel(textBoxesEvent:TextBoxesEvent):void
		{
			_textBoxes.moveRoomLabel(textBoxesEvent.rmLabelPos);
		}
		
		// Called after certain number of images load in ImgPreload, tweens out Preloader, starts initial transition, and starts music
		private function startTour(imgPreloadEvent:ImgPreloadEvent):void
		{
			TweenMax.to(_preloader, 4, {alpha:.75, onComplete:removePreloader});
			_preloader.remove();
			_imgDisplay.startTour();
			_music.startMusic();
		}
		
		// Pauses the transition if the image is clicked, turns off the slideshow so the buttons change to their not playing state
		private function pauseOnImgPan(imgPanEvent:ImgPanEvent):void
		{
			if(_xmlData.isPlaying)
			{
				_slideMenu.turnOffSlideShow();
			}
		}
		
		// Stops the transition of the image when the pause button is pressed
		private function stopOnPauseBtn(buttonManagerEvent:ButtonManagerEvent):void
		{
			_imgDisplay.stopImgTween();
		}		
		
		// Pauses the transition of the image when a TabMenu page is called, if a page is already out, the grey cover stays put
		private function pauseOnTabMenu(tabMenuEvent:TabMenuEvent):void
		{
			if(_greyCoverOn)
			{
				return;
			}
			
			else
			{
				addChildAt(_greyCover, getChildIndex(_tabMenu));
				_greyCoverOn = true;
				_imgDisplay.pauseOnTabMenu();
				_imgDisplay.filters = []; // Removes drop shadow from object
				removeInfoBox();
				removeDetailPic();
				TweenMax.to(_greyCover, .75, {alpha:.40});
			}
		}
		
		// Restarts slide show when the TabMenu navigates back to the photo gallery
		private function resumeOnTabMenu(tabMenuEvent:TabMenuEvent):void
		{
			_imgDisplay.resumeOnTabMenu();
			_imgDisplay.filters = [new DropShadowFilter(5, 45, 0x000000)]; // Adds drop shadow to object
						
			TweenMax.to(_greyCover, .75, {alpha:0, onComplete:removeCover});
		}
		
		// Remove the greyCover once it is done tweening out
		private function removeCover():void
		{
			removeChild(_greyCover);
			_greyCoverOn = false;
		}
		
		// Takes call from InteractiveNav and changes the SlideMenu and inturn the img displayed
		private function onNavBtn(navEvent:NavEvent):void
		{
			_slideMenu.onNavBtn(navEvent.slideNum);
		}
				
		// Event parameter workaround for removeDetailPic function
		private function removeDetailPicEvent(picEvent:PicEvent):void
		{
			removeDetailPic();
		}
		
		// Remove the detail picture from the stage if it is already in use
		private function removeDetailPic():void
		{
			if(_detailPicInUse)
			{
				removeChild(_detailPic);
				_detailPicInUse = false;
			}
		}
		
		// Takes call from InteractivePic and adds it to the stage
		private function addDetailPic(picEvent:PicEvent):void
		{
			removeInfoBox(); // Removes the info box if one is open
			
			if(_detailPicInUse) // If a detail picture is already open, remove it and add the new one
			{
				removeDetailPic();
				
				_detailPic = picEvent.detailPic;
				_detailPic.x = _imgDisplayX + (_maskWidth / 2) - (_detailPic.width / 2);
				_detailPic.y = _imgDisplayY + (_maskHeight / 2) - (_detailPic.height / 2);
				addChildAt(_detailPic, getChildIndex(_tabMenu));
				
				_detailPicInUse = true;
			}
			
			else
			{
				_detailPic = picEvent.detailPic;
				_detailPic.x = _imgDisplayX + (_maskWidth / 2) - (_detailPic.width / 2);
				_detailPic.y = _imgDisplayY + (_maskHeight / 2) - (_detailPic.height / 2);
				addChildAt(_detailPic, getChildIndex(_tabMenu));
				
				_detailPicInUse = true;
			}
		}
	
		// Event parameter workaround for removeInfoBox function
		private function removeInfoBoxEvent(infoEvent:InfoEvent):void
		{
			removeInfoBox();
		}
		
		// Remove the info box from the stage if it is already in use
		private function removeInfoBox():void
		{
			if(_infoBoxInUse)
			{
				removeChild(_infoBox);
				_infoBoxInUse = false;
			}
		}
				
		// Takes call from InteractiveText and adds it to the stage using the imgDisplay positions
		private function addInfoBox(infoEvent:InfoEvent):void
		{
			removeDetailPic(); // Removes the detail pic if one is open
			
			if(_infoBoxInUse) // If an info box is already open, remove it and add the new one
			{
				removeInfoBox();
				
				_infoBox = infoEvent.infoBox;
				_infoBox.x = _imgDisplayX;
				_infoBox.y = _imgDisplayY;
				addChildAt(_infoBox, getChildIndex(_tabMenu));
				
				_infoBoxInUse = true;
			}
			
			else
			{
				_infoBox = infoEvent.infoBox;
				_infoBox.x = _imgDisplayX;
				_infoBox.y = _imgDisplayY;
				addChildAt(_infoBox, getChildIndex(_tabMenu));
				
				_infoBoxInUse = true;
			}
		}
		
		// Retrieves center thumb and counter from event and passes them to the SlideMenu to then be passed to ThumbManager
		private function setCenter(thumbDispatchEvent:ThumbDispatchEvent):void
		{
			_slideMenu.setCenterThumb(thumbDispatchEvent.sentThumb, thumbDispatchEvent.sentCounter);
		}
		
		// Retrieves top set of thumbs and counter from event and passes them to the SlideMenu to then be passed to ThumbManager
		private function setTop(thumbDispatchEvent:ThumbDispatchEvent):void
		{
			_slideMenu.setTopThumbs(thumbDispatchEvent.sentThumb, thumbDispatchEvent.sentCounter);
		}
		
		// Retrieves bottom set of thumbs and counter from event and passes them to the SlideMenu to then be passed to ThumbManager
		private function setBottom(thumbDispatchEvent:ThumbDispatchEvent):void
		{
			_slideMenu.setBottomThumbs(thumbDispatchEvent.sentThumb, thumbDispatchEvent.sentCounter);
		}
		
		// Set the percent text in the Preloader
		private function setPercent(imgPreloadEvent:ImgPreloadEvent):void
		{
			_preloader.setPercent(_imgPreload.percLoaded);
		}
		
		// Called after certain number of images load and the Preloader's opening animations run
		private function removePreloader():void
		{
			removeChild(_preloader);
			_imgPreload.removeEventListener(ImgPreloadEvent.IMG_PRELOAD_COMPLETE, startTour);
			_imgPreload.removeEventListener(ImgPreloadEvent.IMG_PRELOAD_PROGRESS, setPercent);
		}
	}
}