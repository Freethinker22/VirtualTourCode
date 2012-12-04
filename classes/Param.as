package classes // This class gets, sets, and stores all of the data from the XML config file
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest
	import classes.events.ParamEvent;
	
	public class Param extends EventDispatcher
	{
		private var _xmlData:XML; // Object to hold the xml data from the xml config file
		private var _xmlLoader:URLLoader; // XML loader
		
// Vars are divided by their package and by what class they are mainly used in or for
	
// **** Vars for the classes package ****

		// **** Main class ****
		private var _isPlaying:Boolean; // Flag to indicate if the slide show is playing or not
		private var _neighborhoodPageURL:String; // String used for the url of the neighborhood page in the DropDownMenu
		private var _schoolsPageURL:String; // String used for the url of the schools page is the DropDownMenu
		private var _agentWebsiteURL:String // String used for the url of the agent's website
		private var _bgWidth:Number; // Width of the background
		private var _bgHeight:Number; // Height of the background
		private var _navBarWidth:Number; // Width of the nav bar, should be width of image mask
		private var _navBarHeight:Number; // Height of the nav bar
		private var _navBarX:Number; // X position of the navBar
		private var _navBarY:Number; // Y position of the navBar
		private var _imgDisplayX:Number; // X position of the imgDisplay
		private var _imgDisplayY:Number; // Y position of the imgDisplay
		private var _slideMenuX:Number; // X position of the slideMenu
		private var _slideMenuY:Number; // Y position of the slideMenu
		private var _tabMenuX:Number; // X position of the tabMenu
		private var _tabMenuY:Number; // Y position of the tabMenu
		
		// **** Theme class ****
		private var _theme:String; // String to hold the color theme of the whole tour
		
		// **** Preloader class ****
		private var _orbitSpeed:Number; // Speed at which the ball orbits on its path
		private var _leftOverlayWidth:Number; // Width of the left overlay
		private var _leftOverlayHeight:Number; // Height of the left overlay
		private var _rightOverlayWidth:Number; // Width of the right overlay
		private var _rightOverlayHeight:Number; // Height of the right overlay
		
		// **** ImgPreload class ****
		private var _numOfImages:int; // Total number of images in the xml config, also used in Scrollbar and ThumbManager
		private var _minNumOfImages:int; // Minimun number of images to load before slide show starts
		private var _topHalf:Array; // Top half of the xmlArray for the array that holds the main images
		private var _bottomHalf:Array; // Bottom half of the xmlArray for the array that holds the main images
		private var _imgArray:Array; // Array that holds all of the main images and gets passed to the ImgPreload class
		
		// **** ImgDisplay class ****
		private var _maskWidth:Number; // Width of the mask on the ImgDisplay, also used in other classes
		private var _maskHeight:Number; // Height of the mask on the ImgDisplay, also used in other classes
		
		// **** TextBoxes class****
		private var _agentInfoX:Number; // X position of the agent info text
		private var _agentInfoY:Number; // Y position of the agent info text
		private var _agentInfoBgX:Number; // X position of the agent info background
		private var _agentInfoBgY:Number; // Y position of the agent info background
		private var _agentPicX:Number; // X position of the agent's picture
		private var _agentPicY:Number; // Y position of the agent's picture
		private var _agentPicWidth:Number; // Width of the agent's picture on the tour interface
		private var _agentPicHeight:Number; // Height of the agent's picture on the tour interface
		private var _logoX:Number; // X position of the logo
		private var _logoY:Number; // Y position of the logo
		private var _propInfoX:Number; // X position of the property info text 
		private var _propInfoY:Number; // Y position of the property info text
		private var _propInfoBgX:Number; // X position of the property info background
		private var _propInfoBgY:Number; // Y position of the property info background
		private var _roomLabelX:Number; // X position of the room label text
		private var _roomLabelY:Number; // Y position of the room label text
		
		// **** Transistions class ****
		private var _pixelsPerSec:Number; // Transition speed of the images on their way into the ImgDisplay
		private var _fadeDelay:Number; // The number of seconds the image takes to fade out
		private var _horiRatioLimit:Number; // The ratio limit used to determine if the img is a horizontal panorama, also used in other classes
		private var _vertRatioLimit:Number; // The ratio limit used to determine if the img is a vertical panorama, also used in other classes
		private var _maxTransTime:Number; // Limit on the amount of seconds each transition is allowed
		private var _minTransTime:Number; // Minimum amount of seconds each transition is given
		
		// **** Image class ****
		private var _maxImgWidth:Number; // Maximum width size for non-pano images
		
		// **** HelpButton class ****
		private var _scale:Number; // The scale at which the helpPanel starts from while tweening to full scale
		private var _helpPanelWidth:Number; // Width of the helpPanel
		
		// **** Music class ****
		private var _musicAutoPlay:Boolean; // Auto play option for the tour's music
		private var _song:String; // String to hold path of incoming song
		private var _musicBtnsX:Number; // X position for the music play and pause button
		private var _musicBtnsY:Number; // Y position for the music play and pause button
		
// **** Vars for the tabMenu package ****

		// **** TabMenuConstruct class ****
		private var _menuPgBgWidth:Number; // Width of the background of all the menu pages
		private var _menuPgBgHeight:Number; // Height of the background of all the menu pages
		private var _menuPgBgX:Number; // X position of the menu page background
		private var _menuPgBgY:Number; // Y position of the menu page background

		// **** PropertyInfoConstruct class ****
		// First 5 vars used in the TextBoxes class also
		private var _stAddress:String; // Stores the street address of the property
		private var _city:String; // Stores the city of the property
		private var _state:String;  // Stores the state of the property
		private var _zipCode:String; // Stores the zip code of the property
		private var _mlsNumber:String; // Stores the MLS number of the property
		
		private var _propNumOfDetails:int; // Number of allowed data spots on the PropertyInfo page
		private var _featuresText:String; // Text for the features text area of the page
		private var _propTextSpacing:Number; // Vertical distance between the data and labels TextFields on the page
		private var _propDataLabelsX:Number; // X position of the data labels
		private var _propDataLabelsY:Number; // Y position of the data labels
		private var _propDataX:Number; // X position of the data
		private var _propDataY:Number; // Y position of the data
		private var _neighborhoodLinkX:Number; // X position of the neighborhood link
		private var _neighborhoodLinkY:Number; // Y position of the neighborhood link
		private var _schoolLinkX:Number; // X position of the school link
		private var _schoolLinkY:Number; // Y position of the school link
		private var _detailsLabelX:Number; // X position of the details column label
		private var _detailsLabelY:Number; // Y position of the details column label
		private var _featuresLabelX:Number; // X position of the features label
		private var _featuresLabelY:Number; // Y position of the features label
		private var _featuresTextX:Number; // X position of the features text box
		private var _featuresTextY:Number; // Y position of the features text box
		private var _featuresTextWidth:Number; // Available text area width
		private var _featuresTextHeight:Number; // Available text area height, also used for track height in scrollbar
		private var _featuresTrackWidth:Number; // Width of the scrollbar track
		private var _propertyInfoDetails:Array; // Array that holds the labels for the property data
		private var _propertyInfoData:Array; // Array that holds the property data input from the xml config file
		
		// **** PropertyInfo class ****
		private var _propInfoBgLinesX:Number; // X position of the property info page lines
		private var _propInfoBgLinesY:Number; // Y position of the property info page lines
		
		// **** PropertyMapConstruct class ****
		private var _mapKey:String; // String that holds the incoming Google map key
		private var _mapZoomLevel:int; // Starting position of the map zoom
		private var _mapWidth:Number; // Width of the map displayed
		private var _mapHeight:Number; // Height of the map displayed
		
		// **** PropertyMap class ****
		private var _mapX:Number; // X position of the map
		private var _mapY:Number; // Y position of the map
		
		// **** AgentInfoConstruct class ****
		// First 3 vars and agencyName are used in the TextBoxes class also
		private var _agentName:String; // Stores the agent's name
		private var _agentPhone:String; // Stores the agent's phone number
		private var _agencyName:String; // Store the agent's company name
		
		private var _numOfDetails:int; // Number of allowed data spots on the AgentInfo page
		private var _agentPicUrl:String; // URL of the agent's pic, also used in AgentPic class
		private var _agentLogoUrl:String; // URL of the agent's company logo
		private var _agentInfoPicX:Number; // X position of the picCenter point
		private var _agentInfoPicY:Number; // Y position of the picCenter point
		private var _agentLogoX:Number; // X position of the logoCenter point
		private var _agentLogoY:Number; // Y position of the logoCenter point
		private var _agentDataLabelX:Number; // X position of the data labels
		private var _agentDataLabelY:Number; // Starting Y postion of the data labels, also used for dataY
		private var _agentDataX:Number; // X position of the data
		private var _agentDetailsHolderX:Number; // X position of the details object container
		private var _agentDetailsHolderY:Number; // Y position of the details object container
		private var _agentNameTextFieldX:Number; // X position of the agent's name
		private var _agentNameTextFieldY:Number // Y position of the agent's name
		private var _agentTextSpacing:Number; // Distance between the data and details TextFields on the page
		private var _maxPicWidth:Number; // Maximum width of the agent's picture, pic is scaled down if it exceeds max
		private var _maxPicHeight:Number; // Maximum height of the agent's picture, pic is scaled down if it exceeds max
		private var _maxLogoWidth:Number; // Maximum width of the agent's logo, logo is scaled down if it exceeds max
		private var _maxLogoHeight:Number; // Maximum height of the agent's logo, logo is scaled down if it exceeds max
		private var _agentInfoLabel:Array; // Array that holds the labels for the agent's contact info
		private var _agentInfoData:Array; // Array that holds the agent's contact info input from the xml config file
		
		// **** AgentInfo class ****
		private var _agentInfoBgLinesX:Number; // X position of the agent info page lines
		private var _agentInfoBgLinesY:Number; // Y position of the agent info page lines
		
		// **** CalculatorConstruct class ****
		private var _calcLabelX:Number; // X position of the calculator page label
		private var _calcLabelY:Number; // Y position of the calculator page label
		private var _inputWidth:Number; // Width of the input boxes
		private var _inputHeight:Number; // Height of the input boxes
		private var _smInputWidth:Number; // Width of the small input boxes
		private var _smInputHeight:Number; // Height of the small input boxes
		private var _leftColX:Number; // X position of the left column of boxes
		private var _leftColY:Number; // Y position of the left column of boxes
		private var _rightColX:Number; // X position of the right column of boxes
		private var _percentYearsX:Number; // X position of the percent label
		private var _calcTextSpacing:Number; // Vertical space in between each box
		private var _calculateX:Number; // X position of the calculate button
		private var _calculateY:Number; // Y position of the calculate button
		private var _amortizeX:Number; // X position of the amortize button
		private var _amortizeY:Number; // Y position of the amortize button
		private var _clearCalcX:Number; // X position of the clear calculator button
		private var _clearCalcY:Number; // Y position of the clear calculator button
		private var _pmiHelpButtonText:String; // String that holds the text for the pmiHelpButton on the Calculator
		private var _loanHelpButtonText:String; // String that holds the text for the loanHelpButton on the Calculator
		private var _loanAmtHelpButtonText:String; // String that holds the text for the loanAmtHelpButton on the Calculator
		private var _mortgageHelpButtonText:String; // String that holds the text for the mortgageHelpButton on the Calculator
		
		// **** Calculator class ****
		private var _calcBgLinesX:Number; // X position of the background lines on the calculator
		private var _calcBgLinesY:Number; // Y position of the background lines on the calculator
		private var _amortizationX:Number; // X position of the amortization page
		private var _amortizationY:Number; // Y position of the amortization page
		
		// **** AmortizationConstruct class ****
		private var _amorConBackBtnX:Number; // X position of the back button
		private var _amorConBackBtnY:Number; // Y position of the back button
		private var _colHeight:Number; // Height of the label bar in the amortizationMC, based off of graphic in library
		
		// **** Amortization class ****
		private var _amorTrackWidth:Number; // Width of the track in the amortization chart
		private var _amorTrackHeight:Number; // Height of the track in the amortization chart
		private var _amorDownwardOffset:Number; // Distance in pixels from the top of the chart to the top of the scrollbar 
		private var _amorMoveAmt:Number; // Distance to move in pixels when the scrollbar btns are clicked
		private var _amorMaskX:Number; // X position of the amortization mask
		private var _amorMaskY:Number; // Y position of the amortization mask
		
// **** Vars for the slideMenu package ****

		// **** SlideMenu class ****
		private var _autoPlay:Boolean; // The auto play option for the slide show, also used in ButtonManager
		
		// **** ButtonManager class ****
		private var _nextButtonX:Number; // x position for the next button
		private var _nextButtonY:Number; // y position for the next button
		private var _prevButtonX:Number; // x position for the prev button
		private var _prevButtonY:Number; // y position for the prev button
		private var _playPauseX:Number; // x position for the play and pause buttons
		private var _playPauseY:Number; // y position for the play and pause buttons
		
		// **** Scrollbar class ****
		private var _scrollbarWidth:Number; // The scrollbar track width
		private var _scrollbarHeight:Number; // The scrollbar track height
		private var _scrollbarXPosition:Number; // The x position of the scrollbar
		private var _scrollbarYPosition:Number; // The y position of the scrollbar
		
		// **** Thumb class ****
		private var _imageWidth:Number; // Also used in ThumbManager
		private var _imageHeight:Number; // Also used in ThumbManager
		private var _borderSize:Number; // The size of the image border in pixels
		
		// **** ThumbManager class ****
		private var _slideMenuWidth:Number; // SlideMenu width
		private var _slideMenuHeight:Number; // SlideMenu height
		private var _spaceBetweenImages:Number; // The space applied between images
		private var _imagesZPosition:Number; // Used to set the images z position, except the selected one
		private var _centerGap:Number; // The space between the selected image and the top and bottom set of images
		private var _turnAngle:Number; // The rotation applied to the top and bottom sets of images in degrees
		private var _offsetImagesXPosition:Number; // Used to offset the x position of all images on x axis
		private var _transitionLength:Number; // This is the length in seconds of the transition between iamges
		private var _useZSpacing:Boolean; // Used as a flag to set the z spacing 3d option
		private var _thumbTopHalf:Array; // Array that takes the top half of the incoming images
		private var _thumbBottomHalf:Array; // Array that takes the bottom half of the incoming images
		
		public function Param(xmlPath:String):void
		{
			_xmlLoader = new URLLoader();
			_xmlLoader.load(new URLRequest(xmlPath));
			_xmlLoader.addEventListener(Event.COMPLETE, setData);
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		}
		
		private function setData(e:Event):void
		{
			try
			{
				_xmlData =  new XML(e.target.data);
			}
			
			catch(e:Error) // Occurs when there is a formatting problem in the xml, mis-matched tags most likely
			{
				var errorString:String = "There is an formatting error in the XML file, Please contact the agent or owner of the tour about the issue.  Sorry for any inconvenience.";
				dispatchEvent(new ParamEvent(ParamEvent.ERROR, errorString));
				return;
			}
			
			setParams();
			dispatchEvent(new ParamEvent(ParamEvent.XML_LOAD_COMPLETE, "", true));
		}
		
		// If the xml file is not found a ParamEvent event is dispatched with the error text. Bad path to xml file most likely
		private function onLoadError(ioErrorEvent:IOErrorEvent):void
		{
			var errorString:String = "Configuration XML file not found.  Please try refreshing your browser, if the problem persists, contact the agent or owner of the tour about the issue.  Sorry for any inconvenience.";
			dispatchEvent(new ParamEvent(ParamEvent.ERROR, errorString));
		}
		
		// Set variable values
		private function setParams()
		{
// **** Vars settings for the classes package ****

		// **** Main class ****			
			if(_xmlData.isPlaying == "yes") { _isPlaying = true; }
			else if(_xmlData.isPlaying == "no") { _isPlaying = false; }
			
			_neighborhoodPageURL = _xmlData.neighborhoodPage.url;
			_schoolsPageURL = _xmlData.schoolsPage.url;
			_agentWebsiteURL = _xmlData.agentWebsiteURL;
			_bgWidth = _xmlData.bgWidth;
			_bgHeight = _xmlData.bgHeight;
			_navBarWidth = _xmlData.navBarWidth;
			_navBarHeight = _xmlData.navBarHeight;
			_navBarX = _xmlData.navBarX;
			_navBarY = _xmlData.navBarY;
			_imgDisplayX = _xmlData.imgDisplayX;
			_imgDisplayY = _xmlData.imgDisplayY;
			_slideMenuX = _xmlData.slideMenuX;
			_slideMenuY = _xmlData.slideMenuY;
			_tabMenuX = _xmlData.tabMenuX;
			_tabMenuY = _xmlData.tabMenuY;
			
		// **** Theme class ****
			_theme = _xmlData.theme;
			
		// **** Preloader class ****
			_orbitSpeed = _xmlData.orbitSpeed;
			_leftOverlayWidth = _xmlData.leftOverlayWidth;
			_leftOverlayHeight = _xmlData.leftOverlayHeight;
			_rightOverlayWidth = _xmlData.rightOverlayWidth;
			_rightOverlayHeight = _xmlData.rightOverlayHeight;
			
		// **** ImgPreload class ****
			_numOfImages = int(XMLList(_xmlData.images.image).length());
			_minNumOfImages = _xmlData.minNumOfImages;
						 
			// Loads image array that is used in ImgPreload, creates an array of Image objects and sets their vars
			_imgArray = new Array;
			
			for(var i:int = 0; i < _numOfImages; i++)
			{
				var imgPath = _xmlData.images.image.imgPath[i].toString();
				var imgName = _xmlData.images.image.imgName[i].toString();
				var interactivity = _xmlData.images.image.interactivity[i].toString();
				
				var img:Image = new Image(imgPath, imgName, interactivity);
				_imgArray[i] = img;
				
				// If an Image is to be interactive, set up a multidimensional array to store interactive object info
				if(img._interactivity)
				{
					var numOfObjects:int = (XMLList(_xmlData.images.image[i].interactive.iaObj).length());
					var interArray:Array = new Array;
					
					for(var j:int = 0; j < numOfObjects; j++)
					{
						var iaObjArray:Array = new Array;
						
						iaObjArray.push(_xmlData.images.image[i].interactive.iaObj.type[j].toString());
						iaObjArray.push(_xmlData.images.image[i].interactive.iaObj.Xpos[j]);
						iaObjArray.push(_xmlData.images.image[i].interactive.iaObj.Ypos[j]);
						iaObjArray.push(_xmlData.images.image[i].interactive.iaObj.data[j].toString());
						
						interArray.push(iaObjArray);
					}
					
					img.setArray = interArray; // Set the interactivity array in the object
				}
			}
			
		// **** ImgDisplay class ****
			_maskWidth = _xmlData.maskWidth;
			_maskHeight = _xmlData.maskHeight;
			
		// **** TextBoxes class ****
			_agentInfoX = _xmlData.agentInfoX;
			_agentInfoY = _xmlData.agentInfoY;
			_agentInfoBgX = _xmlData.agentInfoBgX;
			_agentInfoBgY = _xmlData.agentInfoBgY;
			_agentPicX = _xmlData.agentPicX;
			_agentPicY = _xmlData.agentPicY;
			_agentPicWidth = _xmlData.agentPicWidth;
			_agentPicHeight = _xmlData.agentPicHeight;
			_logoX = _xmlData.logoX;
			_logoY = _xmlData.logoY;
			_propInfoX = _xmlData.propInfoX;
			_propInfoY = _xmlData.propInfoY;
			_propInfoBgX = _xmlData.propInfoBgX;
			_propInfoBgY = _xmlData.propInfoBgY;
			_roomLabelX = _xmlData.roomLabelX;
			_roomLabelY = _xmlData.roomLabelY;
			
		// **** Transistions class ****
			_pixelsPerSec = _xmlData.pixelsPerSec;
			_fadeDelay = _xmlData.fadeDelay;
			_horiRatioLimit = _xmlData.horiRatioLimit;
			_vertRatioLimit = _xmlData.vertRatioLimit;
			_maxTransTime = _xmlData.maxTransTime;
			_minTransTime = _xmlData.minTransTime;
			
		// **** Image class ****
			_maxImgWidth = _xmlData.maxImgWidth;
			
		// **** HelpButton class ****
			_scale = _xmlData.scale;
			_helpPanelWidth = _xmlData.helpPanelWidth;
			
		// **** Music class ****
			if(_xmlData.musicAutoPlay == "yes") { _musicAutoPlay = true; }
			else if(_xmlData.musicAutoPlay == "no") { _musicAutoPlay = false; }
			_song = _xmlData.song;
			_musicBtnsX = _xmlData.musicBtnsX;
			_musicBtnsY = _xmlData.musicBtnsY;
			
// **** Var settings for the tabMenu package ****

		// **** TabMenuConstruct class ****
			_menuPgBgWidth = _xmlData.menuPgBgWidth;
			_menuPgBgHeight = _xmlData.menuPgBgHeight;
			_menuPgBgX = _xmlData.menuPgBgX;
			_menuPgBgY = _xmlData.menuPgBgY;

		// **** PropertyInfoConstruct class ****
			_stAddress = _xmlData.stAddress;
			_city = _xmlData.city;
			_state = _xmlData.state;
			_zipCode = _xmlData.zipCode;
			_mlsNumber = _xmlData.mlsNumber;
			
			_propNumOfDetails = int(XMLList(_xmlData.propertyDetails.details.detail).length());
			_featuresText = _xmlData.features;
			_propTextSpacing = _xmlData.propTextSpacing;
			_propDataLabelsX = _xmlData.propDataLabelsX;
			_propDataLabelsY = _xmlData.propDataLabelsY;
			_propDataX = _xmlData.propDataX;
			_propDataY = _xmlData.propDataY;
			_neighborhoodLinkX = _xmlData.neighborhoodLinkX;
			_neighborhoodLinkY = _xmlData.neighborhoodLinkY;
			_schoolLinkX = _xmlData.schoolLinkX;
			_schoolLinkY = _xmlData.schoolLinkY;
			_detailsLabelX = _xmlData.detailsLabelX;
			_detailsLabelY = _xmlData.detailsLabelY;
			_featuresLabelX = _xmlData.featuresLabelX;
			_featuresLabelY = _xmlData.featuresLabelY;
			_featuresTextX = _xmlData.featuresTextX;
			_featuresTextY = _xmlData.featuresTextY;
			_featuresTextWidth = _xmlData.featuresTextWidth;
			_featuresTextHeight = _xmlData.featuresTextHeight;
			_featuresTrackWidth = _xmlData.featuresTrackWidth;
			
			// Data and label arrays
			_propertyInfoDetails = new Array;
			_propertyInfoData = new Array;
			
			// Build the data and label arrays
			for(var k:int=0; k < _propNumOfDetails; k++)
			{
				var propDetailLabel:String = new String;
				var propDetailData:String = new String;
				
				propDetailLabel = _xmlData.propertyDetails.details.detail[k].label;
				_propertyInfoDetails[k] = propDetailLabel;
				
				propDetailData = _xmlData.propertyDetails.details.detail[k].data;
				_propertyInfoData[k] = propDetailData;
			}
			
		// **** PropertyInfo class ****
			_propInfoBgLinesX = _xmlData.propInfoBgLinesX;
			_propInfoBgLinesY = _xmlData.propInfoBgLinesY;
			
		// **** PropertyMapConstruct class ****
			_mapKey = _xmlData.mapKey;
			_mapZoomLevel = _xmlData.mapZoomLevel;
			_mapWidth = _xmlData.mapWidth;
			_mapHeight = _xmlData.mapHeight;
			
		// **** PropertyMap class ****
			_mapX = _xmlData.mapX;
			_mapY = _xmlData.mapY;
			
		// **** AgentInfoConstruct class ****
			_agentName = _xmlData.agentName;
			_agentPhone = _xmlData.agentPhone;
			_agencyName = _xmlData.agencyName;
			
			_numOfDetails= int(XMLList(_xmlData.agentDetails.details.detail).length());
			_agentPicUrl = _xmlData.agentPicUrl;
			_agentLogoUrl = _xmlData.agentLogoUrl;
			_agentInfoPicX = _xmlData.agentInfoPicX;
			_agentInfoPicY = _xmlData.agentInfoPicY;
			_agentLogoX = _xmlData.agentLogoX;
			_agentLogoY = _xmlData.agentLogoY;
			_agentDataLabelX = _xmlData.dataLabelX;
			_agentDataLabelY = _xmlData.dataLabelY;
			_agentDataX = _xmlData.dataX;
			_agentDetailsHolderX = _xmlData.agentDetailsHolderX;
			_agentDetailsHolderY = _xmlData.agentDetailsHolderY;
			_agentNameTextFieldX = _xmlData.agentNameTextFieldX;
			_agentNameTextFieldY = _xmlData.agentNameTextFieldY;
			_agentTextSpacing = _xmlData.agentTextSpacing;
			_maxPicWidth = _xmlData.maxPicWidth;
			_maxPicHeight = _xmlData.maxPicHeight;
			_maxLogoWidth = _xmlData.maxLogoWidth;
			_maxLogoHeight = _xmlData.maxLogoHeight;
			
			_agentInfoLabel = new Array;
			_agentInfoData = new Array;
			
			for(var l:int=0; l < _numOfDetails; l++)
			{
				var agentDetailLabel:String = new String;
				var agentDetailData:String = new String;
				
				agentDetailLabel = _xmlData.agentDetails.details.detail[l].label;
				_agentInfoLabel[l] = agentDetailLabel;
				
				agentDetailData = _xmlData.agentDetails.details.detail[l].data;
				_agentInfoData[l] = agentDetailData;
			}
			
		// **** AgentInfo class ****
			_agentInfoBgLinesX = _xmlData.agentInfoBgLinesX;
			_agentInfoBgLinesY = _xmlData.agentInfoBgLinesY;
			
		// **** CalculatorConstruct class ****
			_calcLabelX = _xmlData.calcLabelX;
			_calcLabelY = _xmlData.calcLabelY;
			_inputWidth = _xmlData.inputWidth;
			_inputHeight = _xmlData.inputHeight;
			_smInputWidth = _xmlData.smInputWidth;
			_smInputHeight = _xmlData.smInputHeight;
			_leftColX = _xmlData.leftColX;
			_leftColY = _xmlData.leftColY;
			_rightColX = _xmlData.rightColX;
			_percentYearsX = _xmlData.percentYearsX;
			_calcTextSpacing = _xmlData.calcTextSpacing;
			_calculateX = _xmlData.calculateX;
			_calculateY = _xmlData.calculateY;
			_amortizeX = _xmlData.amortizeX;
			_amortizeY = _xmlData.amortizeY;
			_clearCalcX = _xmlData.clearCalcX;
			_clearCalcY = _xmlData.clearCalcY;
			
			// Help button texts
			_pmiHelpButtonText = _xmlData.pmiHelpButtonText;
			_loanHelpButtonText = _xmlData.loanHelpButtonText;
			_loanAmtHelpButtonText = _xmlData.loanAmtHelpButtonText;
			_mortgageHelpButtonText = _xmlData.mortgageHelpButtonText;
			
		// **** Calculator class ****
			_calcBgLinesX = _xmlData.calcBgLinesX;
			_calcBgLinesY = _xmlData.calcBgLinesY;
			_amortizationX = _xmlData.amortizationX;
			_amortizationY = _xmlData.amortizationY;
			
		// **** AmortizationConstruct class ****
			_amorConBackBtnX = _xmlData.amorConBackBtnX;
			_amorConBackBtnY = _xmlData.amorConBackBtnY;
			_colHeight = _xmlData.colHeight;
			
		// **** Amortization class ****
			_amorTrackWidth = _xmlData.amorTrackWidth;
			_amorTrackHeight = _xmlData.amorTrackHeight;
			_amorDownwardOffset = _xmlData.amorDownwardOffset;
			_amorMoveAmt = _xmlData.amorMoveAmt;
			_amorMaskX = _xmlData.amorMaskX;
			_amorMaskY = _xmlData.amorMaskY;
		
// **** Vars settings for the slideMenu package ****

		// **** ButtonManager class ****
			_nextButtonX = Math.round(Number(_xmlData.nextButtonXPosition));
			_nextButtonY = Math.round(Number(_xmlData.nextButtonYPosition));
			_prevButtonX = Math.round(Number(_xmlData.prevButtonXPosition));
			_prevButtonY = Math.round(Number(_xmlData.prevButtonYPosition));
			_playPauseX = Math.round(Number(_xmlData.playPauseX));
			_playPauseY = Math.round(Number(_xmlData.playPauseY));
			
		// **** Scrollbar class ****
			_scrollbarWidth = Math.round(Number(_xmlData.scrollbarWidth));
			_scrollbarHeight = Math.round(Number(_xmlData.scrollbarHeight));
			_scrollbarXPosition = Math.round(Number(_xmlData.scrollbarXPosition));
			_scrollbarYPosition = Math.round(Number(_xmlData.scrollbarYPosition));
			
			if(_scrollbarHeight < 100) {_scrollbarHeight = 100;}
			else if(_scrollbarHeight > (_slideMenuHeight - 50)) {_scrollbarHeight = (_slideMenuHeight - 50);}
		
		// **** Thumb class ****
			_imageWidth = Number(_xmlData.imageWidth);
			_imageHeight = Number(_xmlData.imageHeight);
			_borderSize = Number(_xmlData.borderSize);
		
		// **** ThumbManager class ****
			_slideMenuWidth = Number(_xmlData.slideMenuWidth);
			_slideMenuHeight = Number(_xmlData.slideMenuHeight);
			_spaceBetweenImages = Number(_xmlData.spaceBetweenImages);
			_imagesZPosition = Number(_xmlData.imageZPosition);
			_centerGap = Number(_xmlData.centerGap);
			_turnAngle = Number(_xmlData.turnAngle);
			_offsetImagesXPosition = Number(_xmlData.offsetImagesXPosition);
			_transitionLength = Number(_xmlData.transitionLength);
			
			if(_xmlData.useZSpacing == "yes") {_useZSpacing = true;}
			else if(_xmlData.useZSpacing == "no") {_useZSpacing = false;}
			else {_useZSpacing = true;}
		}
		
	
// **** Get methods for the classes package ****

	// **** Main class ****
		public function set setIsPlaying(isPlaying:Boolean):void { _isPlaying = isPlaying; } // Is set by SlideMenu, sets isPlaying for use in multiple classes
	
		public function get isPlaying():Boolean { return _isPlaying; }
	
		public function get neighborhoodPageURL():String { return _neighborhoodPageURL; }
		
		public function get schoolsPageURL():String { return _schoolsPageURL; }
		
		public function get agentWebsiteURL():String { return _agentWebsiteURL; }
		
		public function get bgWidth():Number { return _bgWidth; }
		
		public function get bgHeight():Number { return _bgHeight; }
		
		public function get navBarWidth():Number { return _navBarWidth; }
		
		public function get navBarHeight():Number { return _navBarHeight; }
		
		public function get navBarX():Number { return _navBarX; }
		
		public function get navBarY():Number { return _navBarY; }
		
		public function get imgDisplayX():Number { return _imgDisplayX; }
		
		public function get imgDisplayY():Number { return _imgDisplayY; }
		
		public function get slideMenuX():Number { return _slideMenuX; }
		
		public function get slideMenuY():Number { return _slideMenuY; }
		
		public function get tabMenuX():Number { return _tabMenuX; }
		
		public function get tabMenuY():Number { return _tabMenuY; }
		
	// **** Theme class ****
		public function get theme():String { return _theme; }
		
	// **** Preloader class ****
		public function get orbitSpeed():Number { return _orbitSpeed; }
		
		public function get leftOverlayWidth():Number { return _leftOverlayWidth; }
		
		public function get leftOverlayHeight():Number { return _leftOverlayHeight; }
		
		public function get rightOverlayWidth():Number { return _rightOverlayWidth; }
		
		public function get rightOverlayHeight():Number { return _rightOverlayHeight; }
		
	// **** ImgPreload class ****
		public function get numOfImages():int { return _numOfImages; }
		
		public function get minNumOfImages():int { return _minNumOfImages; }
		
		public function get imgArray():Array { return _imgArray; }
		
	// **** ImgDisplay class ****
		public function get maskWidth():Number { return _maskWidth; }
		
		public function get maskHeight():Number { return _maskHeight; }
		
	// **** TextBoxes class ****
		public function get agentInfoX():Number { return _agentInfoX; }
		
		public function get agentInfoY():Number { return _agentInfoY; }
		
		public function get agentInfoBgX():Number { return _agentInfoBgX; }
		
		public function get agentInfoBgY():Number { return _agentInfoBgY; }
		
		public function get agentPicX():Number { return _agentPicX; }
		
		public function get agentPicY():Number { return _agentPicY; }
		
		public function get agentPicWidth():Number { return _agentPicWidth; }
		
		public function get agentPicHeight():Number { return _agentPicHeight; }
		
		public function get logoX():Number { return _logoX; }
		
		public function get logoY():Number { return _logoY; }
		
		public function get propInfoX():Number { return _propInfoX; }
		
		public function get propInfoY():Number { return _propInfoY; }
		
		public function get propInfoBgX():Number { return _propInfoBgX; }
		
		public function get propInfoBgY():Number { return _propInfoBgY; }
		
		public function get roomLabelX():Number { return _roomLabelX; }
		
		public function get roomLabelY():Number { return _roomLabelY; }
		
	// **** Transistions class ****
		public function get pixelsPerSec():Number { return _pixelsPerSec; }
				
		public function get fadeDelay():Number { return _fadeDelay; }
		
		public function get horiRatioLimit():Number { return _horiRatioLimit; }
		
		public function get vertRatioLimit():Number { return _vertRatioLimit; }
		
		public function get maxTransTime():Number { return _maxTransTime; }
		
		public function get minTransTime():Number { return _minTransTime; }
		
	// **** Image class ****
		public function get maxImgWidth():Number { return _maxImgWidth; }
		
	// **** HelpButton class ****
		public function get scale():Number { return _scale; }		
		
		public function get helpPanelWidth():Number { return _helpPanelWidth; }
		
	// **** Music class ****
		public function get musicAutoPlay():Boolean{ return _musicAutoPlay; }
	
		public function get song():String { return _song; }
		
		public function get musicBtnsX():Number { return _musicBtnsX; }
		
		public function get musicBtnsY():Number { return _musicBtnsY; }
		
// **** Get methods for the tabMenu package ****

	// **** TabMenuConstruct class ****
		public function get menuPgBgWidth():Number { return _menuPgBgWidth; }
		
		public function get menuPgBgHeight():Number { return _menuPgBgHeight; }
		
		public function get menuPgBgX():Number { return _menuPgBgX; }
		
		public function get menuPgBgY():Number { return _menuPgBgY; }
		
	// **** PropertyInfoConstruct class ****
		public function get stAddress():String { return _stAddress; }
		
		public function get city():String { return _city; }
		
		public function get state():String { return _state; }
		
		public function get zipCode():String { return _zipCode; }
		
		public function get mlsNumber():String { return _mlsNumber; }
		
		public function get propNumOfDetails():Number { return _propNumOfDetails; }
	
		public function get featuresText():String { return _featuresText; }
		
		public function get propTextSpacing():Number { return _propTextSpacing; }
		
		public function get propDataLabelsX():Number { return _propDataLabelsX; }
		
		public function get propDataLabelsY():Number { return _propDataLabelsY; }
		
		public function get propDataX():Number { return _propDataX; }
		
		public function get propDataY():Number { return _propDataY; }
		
		public function get neighborhoodLinkX():Number { return _neighborhoodLinkX; }
		
		public function get neighborhoodLinkY():Number { return _neighborhoodLinkY; }
		
		public function get schoolLinkX():Number { return _schoolLinkX; }
		
		public function get schoolLinkY():Number { return _schoolLinkY; }
		
		public function get detailsLabelX():Number { return _detailsLabelX; }
		
		public function get detailsLabelY():Number { return _detailsLabelY; }
		
		public function get featuresLabelX():Number { return _featuresLabelX; }
		
		public function get featuresLabelY():Number { return _featuresLabelY; }
		
		public function get featuresTextX():Number { return _featuresTextX; }
		
		public function get featuresTextY():Number { return _featuresTextY; }
		
		public function get featuresTextWidth():Number { return _featuresTextWidth; }
		
		public function get featuresTextHeight():Number { return _featuresTextHeight; }
		
		public function get featuresTrackWidth():Number { return _featuresTrackWidth; }
		
		public function get propertyInfoDetails():Array { return _propertyInfoDetails; }
		
		public function get propertyInfoData():Array { return _propertyInfoData; }
		
	// **** PropertyInfo class ****		
		public function get propInfoBgLinesX():Number { return _propInfoBgLinesX; }
		
		public function get propInfoBgLinesY():Number { return _propInfoBgLinesY; }
		
	// **** PropertyMapConstruct class ****
		public function get mapKey():String { return _mapKey; }
			
		public function get mapZoomLevel():int { return _mapZoomLevel; }
		
		public function get mapWidth():Number { return _mapWidth; }
		
		public function get mapHeight():Number { return _mapHeight; }
		
	// **** PropertyMap class ****
		public function get mapX():Number { return _mapX; }
		
		public function get mapY():Number { return _mapY; }
		
	// **** AgentInfoConstruct class ****
		public function get agentName():String { return _agentName; }
		
		public function get agentPhone():String { return _agentPhone; }
		
		public function get agencyName():String { return _agencyName; }
				
		public function get agentNumOfDetails():Number { return _numOfDetails; }
			
		public function get agentPicUrl():String { return _agentPicUrl; }
		
		public function get agentLogoUrl():String { return _agentLogoUrl; }
		
		public function get agentInfoPicX():Number { return _agentInfoPicX; }
		
		public function get agentInfoPicY():Number { return _agentInfoPicY; }
		
		public function get agentLogoX():Number { return _agentLogoX; }
		
		public function get agentLogoY():Number { return _agentLogoY; }
				
		public function get agentDataLabelX():Number { return _agentDataLabelX; }
		
		public function get agentDataLabelY():Number { return _agentDataLabelY; }
		
		public function get agentDataX():Number { return _agentDataX; }
		
		public function get agentDetailsHolderX():Number { return _agentDetailsHolderX; }
		
		public function get agentDetailsHolderY():Number { return _agentDetailsHolderY; }
		
		public function get agentNameTextFieldX():Number { return _agentNameTextFieldX; }
		
		public function get agentNameTextFieldY():Number { return _agentNameTextFieldY; }
		
		public function get agentTextSpacing():Number { return _agentTextSpacing; }
		
		public function get maxPicWidth():Number { return _maxPicWidth; }
		
		public function get maxPicHeight():Number { return _maxPicHeight; }
		
		public function get maxLogoWidth():Number { return _maxLogoWidth; }
		
		public function get maxLogoHeight():Number { return _maxLogoHeight; }
		
		public function get agentInfoLabel():Array { return _agentInfoLabel; }
		
		public function get agentInfoData():Array { return _agentInfoData; }
		
	// **** AgentInfo class ****
		public function get agentInfoBgLinesX():Number { return _agentInfoBgLinesX; }
		
		public function get agentInfoBgLinesY():Number { return _agentInfoBgLinesY; }
		
	// **** CalculatorConstruct class ****
		public function get calcLabelX():Number { return _calcLabelX }
		
		public function get calcLabelY():Number { return _calcLabelY }
		
		public function get inputWidth():Number { return _inputWidth; }
		
		public function get inputHeight():Number { return _inputHeight; }
		
		public function get smInputWidth():Number { return _smInputWidth; }
		
		public function get smInputHeight():Number { return _smInputHeight; }
		
		public function get leftColX():Number { return _leftColX; }
		
		public function get leftColY():Number { return _leftColY; }
		
		public function get rightColX():Number { return _rightColX; }
		
		public function get percentYearsX():Number { return _percentYearsX; }
		
		public function get calcTextSpacing():Number { return _calcTextSpacing; }
		
		public function get calculateX():Number { return _calculateX; }
		
		public function get calculateY():Number { return _calculateY; }
		
		public function get amortizeX():Number { return _amortizeX; }
		
		public function get amortizeY():Number { return _amortizeY; }
		
		public function get clearCalcX():Number { return _clearCalcX; }
		
		public function get clearCalcY():Number { return _clearCalcY; }
				
		public function get pmiHelpButtonText():String { return _pmiHelpButtonText; }
		
		public function get loanHelpButtonText():String { return _loanHelpButtonText; }
		
		public function get loanAmtHelpButtonText():String { return _loanAmtHelpButtonText; }
		
		public function get mortgageHelpButtonText():String { return _mortgageHelpButtonText; }
		
	// **** Calculator class ****
		public function get calcBgLinesX():Number { return _calcBgLinesX; }
	
		public function get calcBgLinesY():Number { return _calcBgLinesY; }
		
		public function get amortizationX():Number { return _amortizationX; }
		
		public function get amortizationY():Number { return _amortizationY; }
		
	// **** AmortizationConstruct class ****
		public function get amorConBackBtnX():Number { return _amorConBackBtnX; }
		
		public function get amorConBackBtnY():Number { return _amorConBackBtnY; }
		
		public function get colHeight():Number { return _colHeight; }
		
	// **** AmortizationConstruct class ****
		public function get amorTrackWidth():Number { return _amorTrackWidth; }
		
		public function get amorTrackHeight():Number { return _amorTrackHeight; }
		
		public function get amorDownwardOffset():Number { return _amorDownwardOffset; }
		
		public function get amorMoveAmt():Number { return _amorMoveAmt; }
		
		public function get amorMaskX():Number { return _amorMaskX; }
		
		public function get amorMaskY():Number { return _amorMaskY; }
				
// **** Get methods for the slideMenu package ****
		
	// **** ButtonManager class ****
		public function get nextButtonX():Number { return _nextButtonX; }
		
		public function get nextButtonY():Number { return _nextButtonY; }
		
		public function get prevButtonX():Number { return _prevButtonX; }
		
		public function get prevButtonY():Number { return _prevButtonY; }
		
		public function get playPauseX():Number { return _playPauseX; }
		
		public function get playPauseY():Number { return _playPauseY; }
		
	// **** Scrollbar class ****
		public function get scrollbarWidth():Number { return _scrollbarWidth; }
		
		public function get scrollbarHeight():Number { return _scrollbarHeight; }
		
		public function get scrollbarXPosition():Number { return _scrollbarXPosition; }
		
		public function get scrollbarYPosition():Number { return _scrollbarYPosition; }
										
	// **** Thumb class ****
		public function get imageWidth():Number { return _imageWidth ;}
		
		public function get imageHeight():Number { return _imageHeight; }
				
		public function get borderSize():Number { return _borderSize; }
		
	// **** ThumbManager class ****
		public function get slideMenuWidth():Number { return _slideMenuWidth; }
		
		public function get slideMenuHeight():Number { return _slideMenuHeight; }
		
		public function get spaceBetweenImages():Number { return _spaceBetweenImages; }
		
		public function get imagesZPosition():Number { return _imagesZPosition; }
		
		public function get centerGap():Number { return _centerGap; }
		
		public function get turnAngle():Number { return _turnAngle;  }
		
		public function get offsetImagesXPosition():Number { return _offsetImagesXPosition;}
		
		public function get transitionLength():Number { return _transitionLength; }
										
		public function get useZSpacing():Boolean { return _useZSpacing; }
	}
}