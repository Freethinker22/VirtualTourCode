package classes.tabMenu // This class will build the Sprite for the AgentInfo class
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.filters.DropShadowFilter;
	import classes.Param;
	import classes.Theme;
	
	public class AgentInfoConstruct extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _picLoader:Loader; // Loader for the agent's picture
		private var _logoLoader:Loader; // Loader for the agent's company logo
		private var _detailLabel:TextField; // Created multiple times to hold the data's label
		private var _detailData:TextField; // Created multiple times to hold the agent's data
		private var _tfAgentInfo:TextFormat; // Formats the agent info text
		private var _tfAgentName:TextFormat; // Formats the agent name text
		private var _tfEmail:TextFormat; // Formats the email text and sets the url to 'mailto:'
		private var _tfWebsite:TextFormat; // Format the website url text and sets the url to the incoming url
		private var _detailsHolder:Sprite; // Sprite to hold the detail data and label text, makes both column into one group
		private var _agentPic:Sprite; // Sprite to hold agent's pic loaded in picLoader
		private var _agentLogo:Sprite; // Sprite to hold the agent's logo loaded in logoLoader
		private var _agentNameTextField:TextField; // TextField to hold the agent's name
		
		// Settable vars
		private var _numOfDetails:int; // Number of allowed data spots on the AgentInfo page
		private var _agentPicUrl:String; // URL of the agent's pic
		private var _agentLogoUrl:String; // URL of the agent's logo
		private var _agentInfoPicX:Number; // X position of the picCenter point
		private var _agentInfoPicY:Number; // Y position of the picCenter point
		private var _agentLogoX:Number; // X position of the logoCenter point
		private var _agentLogoY:Number; // Y position of the logoCenter point
		private var _agentDataLabelX:Number; // X position of the left column inside the details holder
		private var _agentDataLabelY:Number; // Starting Y position of data's labels and their data
		private var _agentDataX:Number; // X position of the right column inside the details holder
		private var _agentDetailsHolderX:Number; // X position of the details holder, this positions the text group as a whole
		private var _agentDetailsHolderY:Number; // Y position of the details holder, this positions the text group as a whole
		private var _agentNameTextFieldX:Number; // X position of the agent's name
		private var _agentNameTextFieldY:Number // Y position of the agent's name	
		private var _agentTextSpacing:Number; // Vertical distance between the data and labels TextFields on the page
		private var _maxPicWidth:Number; // Maximum width of the agent's picture, pic is scaled down if it exceeds max
		private var _maxPicHeight:Number; // Maximum height of the agent's picture, pic is scaled down if it exceeds max
		private var _maxLogoWidth:Number; // Maximum width of the agent's logo, logo is scaled down if it exceeds max
		private var _maxLogoHeight:Number; // Maximum height of the agent's logo, logo is scaled down if it exceeds max
		
		// API object vars
		protected var _agentInfoBgLines:Sprite; // Library reference to the agent info page lines
		protected var _tweenContainer:Sprite; // Sprite to hold the objects that get tweened in when added to stage

		public function AgentInfoConstruct(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_numOfDetails = _xmlData.agentNumOfDetails;
			_agentPicUrl = _xmlData.agentPicUrl;
			_agentLogoUrl = _xmlData.agentLogoUrl;
			_agentInfoPicX = _xmlData.agentInfoPicX;
			_agentInfoPicY = _xmlData.agentInfoPicY;
			_agentLogoX = _xmlData.agentLogoX;
			_agentLogoY = _xmlData.agentLogoY;
			_agentDataLabelX = _xmlData.agentDataLabelX;
			_agentDataLabelY = _xmlData.agentDataLabelY;
			_agentDataX = _xmlData.agentDataX;
			_agentDetailsHolderX = _xmlData.agentDetailsHolderX;
			_agentDetailsHolderY = _xmlData.agentDetailsHolderY;
			_agentNameTextFieldX = _xmlData.agentNameTextFieldX;
			_agentNameTextFieldY = _xmlData.agentNameTextFieldY;
			_agentTextSpacing = _xmlData.agentTextSpacing;
			_maxPicWidth = _xmlData.maxPicWidth;
			_maxPicHeight = _xmlData.maxPicHeight;
			_maxLogoWidth = _xmlData.maxLogoWidth;
			_maxLogoHeight = _xmlData.maxLogoHeight;
						
			// Create and set objects
			_agentInfoBgLines = _theme.agentInfoBgLines;
			_detailsHolder = new Sprite;
			_tweenContainer = new Sprite;
			_picLoader = new Loader;
			_logoLoader = new Loader;
			
			// Loaders for agentPic and agentLogo
			_picLoader.load(new URLRequest(_agentPicUrl));
			_logoLoader.load(new URLRequest(_agentLogoUrl));
			
			// Event listeners for loaders
			_picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buildAgentPic);
			_picLoader.addEventListener(IOErrorEvent.IO_ERROR, picLoadingError);
			_logoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buildAgentLogo);
			_logoLoader.addEventListener(IOErrorEvent.IO_ERROR, logoLoadingError);
			
			buildAgentInfoText();
		}
		
		// Creates the agent's picture and resizes it if necessary
		private function buildAgentPic(e:Event):void
		{
			var picCenter:Point = new Point(_agentInfoPicX, _agentInfoPicY); // Point that agent pic centers to on page
			var picWidth:Number = _picLoader.content.width;
			var picHeight:Number = _picLoader.content.height;
			
			if(picWidth > _maxPicWidth || picHeight > _maxPicHeight) // Check to see if the agent pic needs to be scaled
			{
				if(picWidth > _maxPicWidth) // Check to see if the agent pic width needs to be scaled
				{
					var picWidthRatio:Number = _maxPicWidth / picWidth; // Ratio of max width to image size, used to scale image proportionally
					
					_picLoader.content.width = _maxPicWidth; // Set the agent pic's width to max width
					_picLoader.content.height *=  picWidthRatio; // Multiply the height by the scale ratio to scale the height proportionally
					
					picHeight = _picLoader.content.height; // Reset picWidth for checking in next if statement
				}
				
				if(picHeight > _maxPicHeight) // If the width scaling didn't reduce the height enough, scale the agent pic's height
				{
					var picHeightRatio:Number = _maxPicHeight / picHeight; // Ratio of max width to image size, used to scale image proportionally
					
					_picLoader.content.height = _maxPicHeight;
					_picLoader.content.width *=  picHeightRatio;
				}
			}
			
			_agentPic = new Sprite;
			_agentPic.addChild(_picLoader.content);
			_agentPic.filters = [new DropShadowFilter(5, 45, 0x000000)]; // Adds drop shadow to object
			_agentPic.x = picCenter.x - (_agentPic.width / 2);
			_agentPic.y = picCenter.y - (_agentPic.height / 2);
			_tweenContainer.addChild(_agentPic);
			
			// Remove picLoader event listeners
			_picLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, buildAgentPic);
			_picLoader.removeEventListener(IOErrorEvent.IO_ERROR, picLoadingError);
		}
		
		// Creates the agent's logo and resizes it if necessary
		private function buildAgentLogo(e:Event):void
		{			
			var logoWidth:Number = _logoLoader.content.width;
			var logoHeight:Number = _logoLoader.content.height;
			var logoCenter:Point = new Point(_agentLogoX, _agentLogoY); // Point that agent logo centers to on page
			
			if(logoWidth > _maxLogoWidth || logoHeight > _maxLogoHeight) // Check to see if the logo needs to be scaled
			{
				if(logoWidth > _maxLogoWidth) // Check to see if the logo width needs to be scaled
				{
					var logoWidthRatio:Number = _maxLogoWidth / logoWidth; // Ratio of max width to image size, used to scale image proportionally
					
					_logoLoader.content.width = _maxLogoWidth; // Set the logo's width to max width
					_logoLoader.content.height *=  logoWidthRatio; // Multiply the height by the scale ratio to scale the height proportionally
					
					logoHeight = _logoLoader.content.height; // Reset logoWidth for checking in next if statement
				}
				
				if(logoHeight > _maxLogoHeight) // If the width scaling didn't reduce the height enough, scale the logo's height
				{
					var logoHeightRatio:Number = _maxLogoHeight / logoHeight; // Ratio of max width to image size, used to scale image proportionally
					
					_logoLoader.content.height = _maxLogoHeight;
					_logoLoader.content.width *=  logoHeightRatio;
				}
			}
			
			_agentLogo = new Sprite;
			_agentLogo.addChild(_logoLoader.content);
			_agentLogo.filters = [new DropShadowFilter(5, 45, 0x000000)]; // Adds drop shadow to object
			_agentLogo.x = logoCenter.x - (_agentLogo.width / 2);
			_agentLogo.y = logoCenter.y - (_agentLogo.height / 2);
			_tweenContainer.addChild(_agentLogo);
			
			// Remove logoLoader event listeners
			_logoLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, buildAgentLogo);
			_logoLoader.removeEventListener(IOErrorEvent.IO_ERROR, logoLoadingError);
		}		
			
		private function buildAgentInfoText():void
		{
			// Regular Expressions for email and website address
			var atSymbol:RegExp = /@/;
			var webAddress:RegExp = /http:\/\//;
			
			// Create text formating
			_tfAgentInfo = new TextFormat;
			_tfAgentInfo.font = "Verdana, Arial, Times";
			_tfAgentInfo.size = 18;
			_tfAgentInfo.color = 0xFFFFFF;
			_tfAgentInfo.align = "left";
			
			_tfAgentName = new TextFormat;
			_tfAgentName.font = "Verdana, Arial, Times";
			_tfAgentName.size = 24;
			_tfAgentName.color = 0xFFFFFF;
			_tfAgentName.align = "left";
			
			// Creates the TextField that holds the agent's name
			_agentNameTextField = new TextField;
			_agentNameTextField.text = _xmlData.agentName;
			_agentNameTextField.antiAliasType = AntiAliasType.ADVANCED;
			_agentNameTextField.autoSize = TextFieldAutoSize.LEFT;
			_agentNameTextField.setTextFormat(_tfAgentName);
			_agentNameTextField.x = _agentNameTextFieldX;
			_agentNameTextField.y = _agentNameTextFieldY;
			_tweenContainer.addChild(_agentNameTextField);
			
			// Creates and positions the TextFields that hold the agent's details
			for(var i:int = 0; i < _numOfDetails; i++)
			{
				var labelText:String = new String;
				var dataText:String = new String;
				
				labelText = _xmlData.agentInfoLabel[i];
				dataText = _xmlData.agentInfoData[i]
				
				_detailLabel = new TextField;
				_detailLabel.text = labelText;
				_detailLabel.antiAliasType = AntiAliasType.ADVANCED;
				_detailLabel.autoSize = TextFieldAutoSize.LEFT;
				_detailLabel.setTextFormat(_tfAgentInfo);
				_detailLabel.x = _agentDataLabelX;
				_detailLabel.y = _agentDataLabelY + (i * _agentTextSpacing);
				_detailsHolder.addChild(_detailLabel);
			
				_detailData = new TextField;
				_detailData.text = dataText;
				_detailData.antiAliasType = AntiAliasType.ADVANCED;
				_detailData.autoSize = TextFieldAutoSize.LEFT;
								
				if(atSymbol.test(dataText)) // Checks to see if the data is an email address
				{
					_tfEmail = new TextFormat;
					_tfEmail.font = "Verdana, Arial, Times";
					_tfEmail.size = 18;
					_tfEmail.color = 0xFFFFFF;
					_tfEmail.align = "left";
					_tfEmail.url = "mailto:" + dataText;
						
					_detailData.setTextFormat(_tfEmail);
					_detailData.addEventListener(MouseEvent.MOUSE_OVER, emailOver);
					_detailData.addEventListener(MouseEvent.MOUSE_OUT, emailOut);
				}
					
				else if(webAddress.test(dataText)) // Check to see if the data is a website
				{
					_tfWebsite = new TextFormat;
					_tfWebsite.font = "Verdana, Arial, Times";
					_tfWebsite.size = 18;
					_tfWebsite.color = 0xFFFFFF;
					_tfWebsite.align = "left";
					_tfWebsite.url = dataText;
					_tfWebsite.target = "_blank";
						
					_detailData.text = _detailData.text.replace(webAddress, ""); // Uses RegExp to remove http:// from text
         			_detailData.setTextFormat(_tfWebsite);
					_detailData.addEventListener(MouseEvent.MOUSE_OVER, websiteOver);
					_detailData.addEventListener(MouseEvent.MOUSE_OUT, websiteOut);
	 			}
					
				else // If the data is not an email address or website, apply normal formatting 
				{
					_detailData.setTextFormat(_tfAgentInfo);
				}
				
				_detailData.x = _agentDataX;
				_detailData.y = _agentDataLabelY + (i * _agentTextSpacing);
				_detailsHolder.addChild(_detailData);
				_detailsHolder.x = _agentDetailsHolderX;
				_detailsHolder.y = _agentDetailsHolderY;
				_tweenContainer.addChild(_detailsHolder);
			}
		}
		
		// Mouse over functions for e-mail and website
		private function emailOver(e:MouseEvent):void
		{
			_tfEmail.underline = true;
			e.target.setTextFormat(_tfEmail);
		}
		
		private function emailOut(e:MouseEvent):void
		{
			_tfEmail.underline = false;
			e.target.setTextFormat(_tfEmail);
		}
		
		private function websiteOver(e:MouseEvent):void
		{
			_tfWebsite.underline = true;
			e.target.setTextFormat(_tfWebsite);
		}
		
		private function websiteOut(e:MouseEvent):void
		{
			_tfWebsite.underline = false;
			e.target.setTextFormat(_tfWebsite);
		}
		
		// Error handler for the agent's picture
		private function picLoadingError(e:IOErrorEvent):void
		{
			var picAltText:TextField;
			var tfError:TextFormat;
			
			tfError = new TextFormat;
			tfError.font = "Verdana, Arial, Times";
			tfError.size = 18;
			tfError.color = 0xFFFFFF;
			tfError.align = "center";
			
			picAltText = new TextField;
			picAltText.text = _xmlData.agentName;
			picAltText.antiAliasType = AntiAliasType.ADVANCED;
			picAltText.width = _maxPicWidth;
			picAltText.wordWrap = true;
			picAltText.setTextFormat(tfError);
			picAltText.x = _agentInfoPicX - (picAltText.width / 2);
			picAltText.y = _agentInfoPicY - (picAltText.height / 2);
			_tweenContainer.addChild(picAltText);
		}
		
		// Error handler for the agency logo
		private function logoLoadingError(e:IOErrorEvent):void
		{
			var logoAltText:TextField;
			var tfError:TextFormat;
			
			tfError = new TextFormat;
			tfError.font = "Verdana, Arial, Times";
			tfError.size = 18;
			tfError.color = 0xFFFFFF;
			tfError.align = "center";
			
			logoAltText = new TextField;
			logoAltText.text = _xmlData.agencyName;
			logoAltText.antiAliasType = AntiAliasType.ADVANCED;
			logoAltText.width = _maxLogoWidth;
			logoAltText.wordWrap = true;
			logoAltText.setTextFormat(tfError);
			logoAltText.x = _agentLogoX - (logoAltText.width / 2);
			logoAltText.y = _agentLogoY - (logoAltText.height / 2);
			_tweenContainer.addChild(logoAltText);
		}
		
		// Destroy function, called when AgentInfo is removed
		protected function destroyPage():void
		{
			_detailData.removeEventListener(MouseEvent.MOUSE_OVER, emailOver);
			_detailData.removeEventListener(MouseEvent.MOUSE_OUT, emailOut);
			_detailData.removeEventListener(MouseEvent.MOUSE_OVER, websiteOver);
			_detailData.removeEventListener(MouseEvent.MOUSE_OUT, websiteOut);
		}
	}
}