package classes.tabMenu // This class handles the functionality of the TabMenu
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import classes.Param;
	import classes.Theme;
	import classes.events.TabMenuEvent;
	
	public class TabMenu extends TabMenuConstruct
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _menuPage:Sprite; // Container to hold the tab menu's pages
		private var _frameLines:Sprite; // Sprite to hold the frame lines drawn around the image and tabs
		private var _topLineY:Number; // Y pos of the line across the top of ImgDisplay, is equal to the _photoGal.y plus its height
		private var _lineWidth:Number; // Thickness of the frame lines 
		private var _pageName:String; // Used to tell the remove function which page to remove
		
		// Menu page vars
		private var _propInfoPage:PropertyInfo; // Reference to the PropertyInfo class
		private var _propMapPage:PropertyMap; // Reference to the PropertyMap class
		private var _agentInfoPage:AgentInfo; // Reference to the AgentInfo class
		private var _calcPage:Calculator; // Reference to the Calculator class
		private var _photoGalInUse:Boolean; // Flag to tell if the slide show is showing
		private var _propInfoInUse:Boolean; // Flag to tell if the property info page is on the stage
		private var _propMapInUse:Boolean; // Flag to tell if the property map page is on the stage
		private var _agentInfoInUse:Boolean; // Flag to tell if the agent info page is on the stage
		private var _calcInUse:Boolean; // Flag to tell if the calculator page is on the stage
		private var _bgInUse:Boolean; // Flag to tell if the menu page background is on the stage
		
		// Settable vars
		private var _maskWidth:Number; // Width of the image mask
		private var _maskHeight:Number; // Height of the image mask

		public function TabMenu(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			super(_xmlData, _theme);
			
			// Settable vars
			_maskWidth = xmlData.maskWidth;
			_maskHeight = xmlData.maskHeight;
			_topLineY = _photoGal.y + _photoGal.height;
			_lineWidth = 1;
			_photoGalInUse = true;
			_propInfoInUse = false;
			_propMapInUse = false;
			_agentInfoInUse = false;
			_calcInUse = false;
			_bgInUse = false;
			
			// Create and set objects
			_propInfoPage = new PropertyInfo(_xmlData, _theme);
			_propMapPage = new PropertyMap(_xmlData, _theme);
			_agentInfoPage = new AgentInfo(_xmlData, _theme);
			_calcPage = new Calculator(_xmlData, _theme);
			_frameLines = new Sprite;
			
			init();
		}
		
		// Setup inital frames lines for the tour, same as when photo gallery tab is selected, and add event listeners
		private function init():void
		{
			_frameLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
			_frameLines.graphics.moveTo(_photoGal.x, _topLineY + _maskHeight);
			_frameLines.graphics.lineTo(_photoGal.x, _photoGal.y);
			_frameLines.graphics.lineTo(_photoGal.x + _photoGal.width, _photoGal.y);
			_frameLines.graphics.lineTo(_photoGal.x + _photoGal.width, _photoGal.y + _photoGal.height);
			_frameLines.graphics.lineTo(_maskWidth, _topLineY);
			addChild(_frameLines);
			
			_photoGal.addEventListener(MouseEvent.CLICK, onPhotoGal);
			_propInfo.addEventListener(MouseEvent.CLICK, onPropInfo);
			_propMap.addEventListener(MouseEvent.CLICK, onPropMap);
			_agentInfo.addEventListener(MouseEvent.CLICK, onAgentInfo);
			_calc.addEventListener(MouseEvent.CLICK, onCalc);
			
			_photoGal.activeColor(); // Change the tab button to active color
		}
		
		// Resets the tour back to the slideshow and adjusts the frame lines accordingly
		private function onPhotoGal(e:MouseEvent):void
		{
			if(_photoGalInUse)
			{
				return;
			}
			
			else
			{
				_photoGalInUse = true; // Reset current flags
				_bgInUse = false;
				transPageOut(); // Transition the current page out
				removeGreyCover(); // The the Main to remove the grey cover
				removeChild(_menuPgBg); // Remove the menu page background
				_photoGal.activeColor(); // Change the tab button to active color
			
				_frameLines.graphics.clear(); // Clear and redraw the frame and tab lines
				_frameLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
				_frameLines.graphics.moveTo(_photoGal.x, _topLineY + _maskHeight);
				_frameLines.graphics.lineTo(_photoGal.x, _photoGal.y);
				_frameLines.graphics.lineTo(_photoGal.x + _photoGal.width, _photoGal.y);
				_frameLines.graphics.lineTo(_photoGal.x + _photoGal.width, _photoGal.y + _photoGal.height);
				_frameLines.graphics.lineTo(_maskWidth, _topLineY);
			}
		}
		
		// Loads the property info page and adjusts the frame lines accordingly
		private function onPropInfo(e:MouseEvent):void
		{
			if(_propInfoInUse) // If the page is already open, do nothing when the tab is clicked
			{
				return;
			}
			
			else
			{
				if(_pageName != _propInfoPage.PAGE_NAME) // Prevent transPageOut() from removing the page if the last page was this one
				{
					transPageOut(); // If the last page was different from this one, transition it out
				}
				
				_pageName = _propInfoPage.PAGE_NAME; // Set the current page name
				
				_photoGalInUse = false; // Set current flags
				_propInfoInUse = true;
				
				_photoGal.nonActiveColor(); // Change the photo gal tab button to its non-active color
				_propInfo.activeColor(); // Change the tab button to active color
				_propInfo.y += 1; // Move the tab 1 pixel down to hide any scaling lines
				
				_propInfoPage.addToStage(); // Call the tweening functions in the page to add it to the stage
				_propInfoPage.addEventListener(TabMenuEvent.DESTROY_PAGE, removePage); // Listen for the page transitioning completion
				addPageBg(); // Add the background to the stage for the page if its not already there
				addChild(_propInfoPage);
			
				_frameLines.graphics.clear(); // Clear and redraw the frame and tab lines
				_frameLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
				_frameLines.graphics.moveTo(_photoGal.x, _topLineY + _maskHeight);
				_frameLines.graphics.lineTo(_photoGal.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_propInfo.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_propInfo.x, _photoGal.y);
				_frameLines.graphics.lineTo(_propInfo.x + _propInfo.width, _photoGal.y);
				_frameLines.graphics.lineTo(_propInfo.x + _propInfo.width, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_maskWidth, _topLineY - _lineWidth);
				
				dispatchEvent(new TabMenuEvent(TabMenuEvent.MENU_CLICK)); // Dispatches to Main to pause slide show
			}
		}
		
		// Loads the property map page and adjusts the frame lines accordingly
		private function onPropMap(e:MouseEvent):void
		{
			if(_propMapInUse)
			{
				return;
			}
			
			else
			{
				if(_pageName != _propMapPage.PAGE_NAME)
				{
					transPageOut();
				}
				
				_pageName = _propMapPage.PAGE_NAME;
				
				_photoGalInUse = false;
				_propMapInUse = true;
				
				_photoGal.nonActiveColor();
				_propMap.activeColor();
				_propMap.y += 1;
				
				_propMapPage.addToStage();
				_propMapPage.addEventListener(TabMenuEvent.DESTROY_PAGE, removePage);
				addPageBg();
				addChild(_propMapPage);
			
				_frameLines.graphics.clear();
				_frameLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
				_frameLines.graphics.moveTo(_photoGal.x, _topLineY + _maskHeight);
				_frameLines.graphics.lineTo(_photoGal.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_propMap.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_propMap.x, _propMap.y);
				_frameLines.graphics.lineTo(_propMap.x + _propMap.width, _propMap.y);
				_frameLines.graphics.lineTo(_propMap.x + _propMap.width, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_maskWidth, _topLineY - _lineWidth);
				
				dispatchEvent(new TabMenuEvent(TabMenuEvent.MENU_CLICK)); // Dispatches to Main to pause slide show
			}
		}
		
		// Loads the agent info page and adjusts the frame lines accordingly
		private function onAgentInfo(e:MouseEvent):void
		{
			if(_agentInfoInUse)
			{
				return;
			}
			
			else
			{
				if(_pageName != _agentInfoPage.PAGE_NAME)
				{
					transPageOut();
				}
				
				_pageName = _agentInfoPage.PAGE_NAME;
				
				_photoGalInUse = false;
				_agentInfoInUse = true;
				
				_photoGal.nonActiveColor();
				_agentInfo.activeColor();
				_agentInfo.y += 1;
				
				_agentInfoPage.addToStage();
				_agentInfoPage.addEventListener(TabMenuEvent.DESTROY_PAGE, removePage);
				addPageBg();
				addChild(_agentInfoPage);
			
				_frameLines.graphics.clear();
				_frameLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
				_frameLines.graphics.moveTo(_photoGal.x, _topLineY + _maskHeight);
				_frameLines.graphics.lineTo(_photoGal.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_agentInfo.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_agentInfo.x, _agentInfo.y);
				_frameLines.graphics.lineTo(_agentInfo.x + _agentInfo.width, _agentInfo.y);
				_frameLines.graphics.lineTo(_agentInfo.x + _agentInfo.width, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_maskWidth, _topLineY - _lineWidth);
				
				dispatchEvent(new TabMenuEvent(TabMenuEvent.MENU_CLICK)); // Dispatches to Main to pause slide show
			}
		}
		
		// Loads the calculator page and adjusts the frame lines accordingly
		private function onCalc(e:MouseEvent):void
		{
			if(_calcInUse)
			{
				return;
			}
			
			else
			{
				if(_pageName != _calcPage.PAGE_NAME)
				{
					transPageOut();
				}
				
				_pageName = _calcPage.PAGE_NAME;
				
				_photoGalInUse = false;
				_calcInUse = true;
				
				_photoGal.nonActiveColor();
				_calc.activeColor();
				_calc.y += 1;
				
				_calcPage.addToStage();
				_calcPage.addEventListener(TabMenuEvent.DESTROY_PAGE, removePage);
				addPageBg();
				addChild(_calcPage);
			
				_frameLines.graphics.clear();
				_frameLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
				_frameLines.graphics.moveTo(_photoGal.x, _topLineY + _maskHeight);
				_frameLines.graphics.lineTo(_photoGal.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_calc.x, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_calc.x, _calc.y);
				_frameLines.graphics.lineTo(_calc.x + _calc.width, _calc.y);
				_frameLines.graphics.lineTo(_calc.x + _calc.width, _topLineY - _lineWidth);
				_frameLines.graphics.lineTo(_maskWidth, _topLineY - _lineWidth);
				
				dispatchEvent(new TabMenuEvent(TabMenuEvent.MENU_CLICK)); // Dispatches to Main to pause slide show
			}
		}
		
		// Calls the function in the menu pages to transition out the page
		private function transPageOut():void
		{
			switch(_pageName)
			{
				case _propInfoPage.PAGE_NAME:
					_propInfoPage.returnToTour(); // Starts tweening out process
					_propInfo.nonActiveColor(); // Changes tab color to non-active
					_propInfo.y = 0; // Resets the tab to original Y position
				break;
				case _propMapPage.PAGE_NAME:
					_propMapPage.returnToTour();
					_propMap.nonActiveColor();
					_propMap.y = 0;
				break;
				case _agentInfoPage.PAGE_NAME:
					_agentInfoPage.returnToTour();
					_agentInfo.nonActiveColor();
					_agentInfo.y = 0;
				break;
				case _calcPage.PAGE_NAME:
					_calcPage.returnToTour();
					_calc.nonActiveColor();
					_calc.y = 0;
				break;
			}
		}
		
		// Takes call from menu pages and removes them after the page is done transitioning out
		private function removePage(tabMenuEvent:TabMenuEvent):void
		{
			switch(tabMenuEvent.pageToRemove)
			{
				case _propInfoPage.PAGE_NAME:
					_propInfoInUse = false;
					_propInfoPage.removeEventListener(TabMenuEvent.DESTROY_PAGE, removePage);
					removeChild(_propInfoPage);
				break;
				case _propMapPage.PAGE_NAME:
					_propMapInUse = false;
					_propMapPage.removeEventListener(TabMenuEvent.DESTROY_PAGE, removePage);
					removeChild(_propMapPage);
				break;
				case _agentInfoPage.PAGE_NAME:
					_agentInfoInUse = false;
					_agentInfoPage.removeEventListener(TabMenuEvent.DESTROY_PAGE, removePage);
					removeChild(_agentInfoPage);
				break;
				case _calcPage.PAGE_NAME:
					_calcInUse = false;
					_calcPage.removeEventListener(TabMenuEvent.DESTROY_PAGE, removePage);
					removeChild(_calcPage);
				break;
			}
		}
		
		// Adds the page background to the stage if its not in use
		private function addPageBg():void
		{
			if(_bgInUse)
			{
				return;
			}
			
			else
			{
				addChild(_menuPgBg);
				_bgInUse = true;
			}
		}
		
		// Called when user returns to the photo gallery to remove the grey cover on the tour in the Main
		private function removeGreyCover():void
		{
			dispatchEvent(new TabMenuEvent(TabMenuEvent.REMOVE_COVER));
		}
	}
}