package classes // This class creates the TextFields and their backgrounds that display on the front of the tour
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.filters.DropShadowFilter;
	
	public class TextBoxes extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _imgArray; // Reference to the image array in ImgPreload, used to get room names
		private var _agentPic:Sprite; // Reference to the AgentPic class
		private var _picLoader:Loader; // Loader for the agent's picture
		private var _startId:int; // The start id number which is a reference to the first image's slideNum
		private var _slideNum:int; // Reference to which img gets loaded first
		private var _tfAgentInfo:TextFormat; // Format of the agent info text
		private var _tfPwrdBy:TextFormat; // Format of the powered by label
		private var _tfPropInfo:TextFormat; // Format of the property info text
		private var _tfRoomLabel:TextFormat; // Format of the room label text
		private var _agentInfo:TextField; // TextField to hold the agent info text
		private var _pwrdLabel:TextField; // TextField to hold powered by: text for logo
		private var _propInfo:TextField; // TextField to hold the property info text
		private var _rmLabel:TextField; // TextField to hold the room label text
		private var _rmLabelBgBm:Bitmap; // The background the room label text sits on
		private var _rmLabelBgLines:Sprite; // The room label's background lines
		
		// Settable vars
		private var _agentPicUrl:String; // URL of the agent's pic
		private var _agentWebsiteURL:String // String used for the url of the agent's website
		private var _agentInfoX:Number; // X position of the agent info text
		private var _agentInfoY:Number; // Y position of the agent info text
		private var _agentInfoBgX:Number; // X position of the agent info background
		private var _agentInfoBgY:Number; // Y position of the agent info background
		private var _agentPicX:Number; // X position of the agent's picture
		private var _agentPicY:Number; // Y position of the agent's picture
		private var _agentPicWidth:Number; // Width of the agent's picture
		private var _agentPicHeight:Number; // Height of the agent's picture
		private var _logoX:Number; // X position of the logo
		private var _logoY:Number; // Y position of the logo
		private var _propInfoX:Number; // X position of the property info text 
		private var _propInfoY:Number; // Y position of the property info text
		private var _propInfoBgX:Number; // X position of the property info background
		private var _propInfoBgY:Number; // Y position of the property info background
		private var _rmLabelX:Number; // X position of the room label text
		private var _rmLabelY:Number; // Y position of the room label text
		private var _lineWidth:Number; // Thickness of the border lines on the room label box
		
		public function TextBoxes(xmlData:Param, theme:Theme, imgArray:Array, startId:int)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			_imgArray = imgArray;
			_startId = startId;
			
			// Settable vars
			_agentPicUrl = _xmlData.agentPicUrl;
			_agentWebsiteURL = _xmlData.agentWebsiteURL;
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
			_rmLabelX = _xmlData.roomLabelX;
			_rmLabelY = _xmlData.roomLabelY;
			_lineWidth = 1;
			
			// Create and set objects
			_picLoader = new Loader;
			
			// Loader for agentPic
			_picLoader.load(new URLRequest(_agentPicUrl));
			
			// Event listener for picLoader
			_picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, buildAgentPic);
			
			init();
			buildAgentInfo();
			buildPropInfo();
			buildLogo();
			buildRoomLabel();
		}
		
		private function init():void
		{
			_tfAgentInfo = new TextFormat;
			_tfAgentInfo.font = "Verdana, Arial, Times";
			_tfAgentInfo.size = 14;
			_tfAgentInfo.color = 0xFFFFFF;
			_tfAgentInfo.align = "right";
			
			_tfPwrdBy = new TextFormat;
			_tfPwrdBy.font = "Verdana, Arial, Times";
			_tfPwrdBy.size = 12;
			_tfPwrdBy.color = 0xFFFFFF;
			_tfPwrdBy.align = "left";
			
			_tfPropInfo = new TextFormat;
			_tfPropInfo.font = "Verdana, Arial, Times";
			_tfPropInfo.size = 18;
			_tfPropInfo.color = 0xFFFFFF;
			_tfPropInfo.align = "left";
			
			_tfRoomLabel = new TextFormat;
			_tfRoomLabel.font = "Verdana, Arial, Times";
			_tfRoomLabel.size = 16;
			_tfRoomLabel.color = 0xFFFFFF;
			_tfRoomLabel.align = "center";
		}
		
		// Creates the agent's picture and its background
		private function buildAgentPic(e:Event):void
		{
			var picWidth:Number = _picLoader.content.width;
			var picHeight:Number = _picLoader.content.height;
			
			if(picWidth > _agentPicWidth || picHeight > _agentPicHeight) // Check to see if the agent pic needs to be scaled
			{
				if(picWidth > _agentPicWidth) // Check to see if the agent pic width needs to be scaled
				{
					var picWidthRatio:Number = _agentPicWidth / picWidth; // Ratio of max width to image size, used to scale image proportionally
					
					_picLoader.content.width = _agentPicWidth; // Set the agent pic's width to max width
					_picLoader.content.height *=  picWidthRatio; // Multiply the height by the scale ratio to scale the height proportionally
					
					picHeight = _picLoader.content.height; // Reset picWidth for checking in next if statement
				}
				
				if(picHeight > _agentPicHeight) // If the width scaling didn't reduce the height enough, scale the agent pic's height
				{
					var picHeightRatio:Number = _agentPicHeight / picHeight; // Ratio of max width to image size, used to scale image proportionally
					
					_picLoader.content.height = _agentPicHeight;
					_picLoader.content.width *=  picHeightRatio;
				}
			}
			
			_agentPic = new Sprite;
			_agentPic.addChild(_picLoader.content);
			_agentPic.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			_agentPic.x = _agentPicX;
			_agentPic.y = _agentPicY;
			_agentPic.buttonMode = true;
			_agentPic.addEventListener(MouseEvent.CLICK, toAgentWebsite); // Listen for a click on the agent's picture
			addChild(_agentPic);
			
			// Remove picLoader event listeners
			_picLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, buildAgentPic);
		}
		
		// Builds the agent info text field by putting the individual strings and line breaks together along with background
		private function buildAgentInfo():void
		{
			var agentInfoBg:Sprite = new Sprite;
			var agentInfoBgLines:Sprite = new Sprite;
			var lineWidth:Number = 1;
			
			agentInfoBg = _theme.agentInfoBg;
			agentInfoBg.x = _agentInfoBgX;
			agentInfoBg.y = _agentInfoBgY;
			agentInfoBg.alpha = .33;
			agentInfoBg.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			
			agentInfoBgLines.graphics.lineStyle(lineWidth, 0xFFFFFF);
			agentInfoBgLines.graphics.moveTo(_agentInfoBgX, _agentInfoBgY + agentInfoBg.height);
			agentInfoBgLines.graphics.lineTo(_agentInfoBgX, _agentInfoBgY);
			agentInfoBgLines.graphics.lineTo(_agentInfoBgX + agentInfoBg.width, _agentInfoBgY);
			
			_agentInfo = new TextField;
			_agentInfo.text = _xmlData.agentName + "\n" + _xmlData.agentPhone + "\n" + _xmlData.agencyName;
			_agentInfo.antiAliasType = AntiAliasType.ADVANCED;
		 	_agentInfo.autoSize = TextFieldAutoSize.LEFT;
		  	_agentInfo.setTextFormat(_tfAgentInfo);
			_agentInfo.x = _agentInfoX - _agentInfo.width;
			_agentInfo.y = _agentInfoY;
			
			addChild(agentInfoBg);
			addChild(agentInfoBgLines);
			addChild(_agentInfo);
		}
		
		// Builds the property info text field by putting the individual strings and line breaks together along with background
		private function buildPropInfo():void
		{
			var propInfoBg:Sprite = new Sprite;
			var propInfoBgLines:Sprite = new Sprite;
			var lineWidth:Number = 1;
			
			propInfoBg = _theme.propInfoBg;
			propInfoBg.x = _propInfoBgX;
			propInfoBg.y = _propInfoBgY;
			propInfoBg.alpha = .33;
			propInfoBg.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			
			propInfoBgLines.graphics.lineStyle(lineWidth, 0xFFFFFF);
			propInfoBgLines.graphics.moveTo(_propInfoBgX, _propInfoBgY + propInfoBg.height);
			propInfoBgLines.graphics.lineTo(_propInfoBgX, _propInfoBgY);
			propInfoBgLines.graphics.lineTo(_propInfoBgX + propInfoBg.width, _propInfoBgY);
			
			_propInfo = new TextField;
			_propInfo.text = _xmlData.stAddress + "\n" + _xmlData.city + ", " + _xmlData.state + " " + _xmlData.zipCode + "\n" + "MLS#:" + _xmlData.mlsNumber;
			_propInfo.antiAliasType = AntiAliasType.ADVANCED;
		 	_propInfo.autoSize = TextFieldAutoSize.LEFT;
		  	_propInfo.setTextFormat(_tfPropInfo);
			_propInfo.x = _propInfoX;
			_propInfo.y = _propInfoY;
			
			addChild(propInfoBg);
			addChild(propInfoBgLines);
			addChild(_propInfo);
		}
		
		// Puts together the logo along with the powered by text in a logo container that links to home site
		private function buildLogo():void
		{
			var logo:Sprite = new Sprite; // Sprite to hold the logo
			var logoContainer:Sprite = new Sprite; // Sprite to hold the logo and powered by text
			var logoHitArea:Sprite = new Sprite; // Hit area for the logo container
			
			_pwrdLabel = new TextField;
			_pwrdLabel.text = "Powered By:";
			_pwrdLabel.antiAliasType = AntiAliasType.ADVANCED;
		 	_pwrdLabel.autoSize = TextFieldAutoSize.LEFT;
		  	_pwrdLabel.setTextFormat(_tfPwrdBy);
			_pwrdLabel.alpha = .5;
			logoContainer.addChild(_pwrdLabel);
			
			logo = _theme.logo;
			logo.y = _pwrdLabel.height - 2;
			logo.alpha = .66;
			logoContainer.addChild(logo);
			
			logoHitArea.graphics.beginFill(0x000000, 0);
			logoHitArea.graphics.drawRect(0, 0, logoContainer.width, logoContainer.height);
			logoHitArea.graphics.endFill();
			logoContainer.addChild(logoHitArea);
			
			logoContainer.buttonMode = true;
			logoContainer.x = _logoX;
			logoContainer.y = _logoY;
			addChild(logoContainer);
			
			logoContainer.addEventListener(MouseEvent.CLICK, toHomeWebsite);
		}
		
		// Sets the initial room label text and creates its background and background texture
		private function buildRoomLabel():void
		{			
			_rmLabel = new TextField;
			_rmLabel.text = _imgArray[_startId]._imgName;
			_rmLabel.antiAliasType = AntiAliasType.ADVANCED;
			_rmLabel.autoSize = TextFieldAutoSize.CENTER;
		  	_rmLabel.setTextFormat(_tfRoomLabel);
			_rmLabel.mouseEnabled = false;
			_rmLabel.x = (_rmLabelX - _rmLabel.width + 4);
			_rmLabel.y = _rmLabelY + 3;
			
			var rmLabelBgBmd:BitmapData = new BitmapData(_rmLabel.width + 14, _rmLabel.height + 6, true, _theme.rmLabelBgColor);
			_rmLabelBgBm = new Bitmap(rmLabelBgBmd);
			_rmLabelBgBm.alpha = .60;
			_rmLabelBgBm.x = _rmLabelX - _rmLabel.width;
			_rmLabelBgBm.y = _rmLabelY;
						
			_rmLabelBgLines = new Sprite;
			_rmLabelBgLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
			_rmLabelBgLines.graphics.moveTo(_rmLabelBgBm.x, _rmLabelBgBm.y + _rmLabelBgBm.height);
			_rmLabelBgLines.graphics.lineTo(_rmLabelBgBm.x, _rmLabelBgBm.y);
			_rmLabelBgLines.graphics.lineTo(_rmLabelBgBm.x + _rmLabelBgBm.width, _rmLabelBgBm.y);
			
			addChild(_rmLabelBgBm);
			addChild(_rmLabelBgLines);
			addChild(_rmLabel);
		}
		
		// Function for navigating to spiffyhometours.com
		private function toHomeWebsite(e:MouseEvent):void
		{
			var url:URLRequest = new URLRequest("http://www.spiffyhometours.com");
			navigateToURL(url, "_blank");
		}
		
		// Open the agent's website if the agent's picture is clicked on
		private function toAgentWebsite(e:MouseEvent):void
		{
			var url:URLRequest = new URLRequest(_agentWebsiteURL);
			navigateToURL(url, "_blank");
		}
		
		// Takes call from Main to change the room label text and update the size of the label's background and lines
		public function changeRoomLabel(slideNum:int):void
		{
			_slideNum = slideNum;
			
			_rmLabel.text = _imgArray[_slideNum]._imgName;
			_rmLabel.autoSize = TextFieldAutoSize.RIGHT;
		  	_rmLabel.setTextFormat(_tfRoomLabel);
			_rmLabel.x = (_rmLabelX - _rmLabel.width + 4);
			
			_rmLabelBgBm.width = _rmLabel.width + 14;
			_rmLabelBgBm.x = _rmLabelX - _rmLabel.width;
			
			_rmLabelBgLines.graphics.clear();
			_rmLabelBgLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
			_rmLabelBgLines.graphics.moveTo(_rmLabelBgBm.x, _rmLabelBgBm.y + _rmLabelBgBm.height);
			_rmLabelBgLines.graphics.lineTo(_rmLabelBgBm.x, _rmLabelBgBm.y);
			_rmLabelBgLines.graphics.lineTo(_rmLabelBgBm.x + _rmLabelBgBm.width, _rmLabelBgBm.y);
		}
		
		// Takes call from main to move the room label if vert pano is thinner than mask width
		public function moveRoomLabel(xPos:Number):void
		{
			_rmLabel.x = xPos - (_rmLabel.width / 2) + 4; // The 4 adds left padding to the text
			_rmLabelBgBm.x = xPos - (_rmLabel.width / 2);
			
			_rmLabelBgLines.graphics.clear();
			_rmLabelBgLines.graphics.lineStyle(_lineWidth, 0xFFFFFF);
			_rmLabelBgLines.graphics.moveTo(_rmLabelBgBm.x, _rmLabelBgBm.y + _rmLabelBgBm.height);
			_rmLabelBgLines.graphics.lineTo(_rmLabelBgBm.x, _rmLabelBgBm.y);
			_rmLabelBgLines.graphics.lineTo(_rmLabelBgBm.x + _rmLabelBgBm.width - _lineWidth, _rmLabelBgBm.y);
		}
	}
}