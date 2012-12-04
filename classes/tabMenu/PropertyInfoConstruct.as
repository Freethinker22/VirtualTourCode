package  classes.tabMenu // This class will build the Sprite for the PropertyInfo class
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import classes.Param;
	import classes.Theme;
	import classes.TextScrollbar;
	
	public class PropertyInfoConstruct extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _featTextScrollbar:TextScrollbar; // Reference to the TextScrollbar class
		private var _featTextArea:Sprite; // Sprite for holding the features text so is can be passed to the scrollbar
		private var _featText:TextField; // TextField to hold the features text
		private var _detailsLabel:TextField; // TextField to hold the details column label
		private var _featuresLabel:TextField; // TextField to hold the features column label
		private var _neighborLink:TextField; // TextField to hold the link to neighborhood info
		private var _schoolLink:TextField; // TextField to hold the link to school info
		private var _tfPropInfo:TextFormat; // Format for the property info text
		private var _tfColLabels:TextFormat; // Format for the data labels text
		private var _tfHoodLink:TextFormat; // Format for the neighborhood info link
		private var _tfSchoolLink:TextFormat; // Format for the schools info link
		
		// Settable vars
		private var _bgColor:uint; // Color of the background the page sits on
		private var _propNumOfDetails:int; // Number of allowed data spots on the PropertyInfo page
		private var _featuresText:String; // Text for the features text area of the page
		private var _neighborhoodURL:String; // String to hold the url of the neighborhood info page
		private var _schoolURL:String; // String to hold the url of the school info page
		private var _propTextSpacing:Number; // Vertical distance between the data and labels TextFields on the page
		private var _propDataLabelsX:Number; // X position of the data labels
		private var _propDataLabelsY:Number; // Y position of the data labels
		private var _propDataX:Number; // X position of the data
		private var _propDataY:Number; // Y position of the data
		private var _neighborLinkX:Number; // X position of the neighborhood link
		private var _neighborLinkY:Number; // Y position of the neighborhood link
		private var _schoolLinkX:Number; // X position of the school link
		private var _schoolLinkY:Number; // Y position of the school link
		private var _detailsLabelX:Number; // X position of the details column label
		private var _detailsLabelY:Number; // Y position of the details column label
		private var _featuresLabelX:Number; // X position of the features column label
		private var _featuresLabelY:Number; // Y position of the features column label
		private var _featuresTextX:Number; // X position of the features text box
		private var _featuresTextY:Number; // Y position of the features text box
		private var _featuresTextWidth:Number; // Available text area width
		private var _featuresTextHeight:Number; // Available text area height, also used for track height in scrollbar
		private var _featuresTrackWidth:Number; // Width of the scrollbar track
		
		// API object vars
		protected var _propInfoBgLines:Sprite; // Library reference to the property info page
		protected var _tweenContainer:Sprite; // Sprite to hold the objects that get tweened in when added to stage

		public function PropertyInfoConstruct(xmlData:Param, theme:Theme) 
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_bgColor = _theme.bgColor;
			_propNumOfDetails = _xmlData.propNumOfDetails;
			_featuresText = _xmlData.featuresText;
			_neighborhoodURL =_xmlData.neighborhoodPageURL;
			_schoolURL = _xmlData.schoolsPageURL;
			_propTextSpacing = _xmlData.propTextSpacing;
			_propDataLabelsX = _xmlData.propDataLabelsX;
			_propDataLabelsY = _xmlData.propDataLabelsY;
			_propDataX = _xmlData.propDataX;
			_propDataY = _xmlData.propDataY;
			_neighborLinkX = _xmlData.neighborhoodLinkX;
			_neighborLinkY = _xmlData.neighborhoodLinkY;
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
			
			// Create and set objects
			_propInfoBgLines = _theme.propInfoBgLines;
			_featTextArea = new Sprite;
			_tweenContainer = new Sprite;
			
			buildPropInfoText();
			buildFeatTextBox();
			buildInfoLinks();
		}
		
		// Builds the text fields that hold data in the PropertyInfo class
		private function buildPropInfoText():void
		{
			_tfPropInfo = new TextFormat;
			_tfPropInfo.font = "Verdana, Arial, Times";
			_tfPropInfo.size = 16;
			_tfPropInfo.color = 0xFFFFFF;
			_tfPropInfo.align = "left";
			
			_tfColLabels = new TextFormat;
			_tfColLabels.font = "Verdana, Arial, Times";
			_tfColLabels.size = 25;
			_tfColLabels.color = 0xFFFFFF;
			_tfColLabels.align = "left";
			
			// Builds the page labels
			_detailsLabel = new TextField;
			_detailsLabel.text = "Details";
			_detailsLabel.antiAliasType = AntiAliasType.ADVANCED;
			_detailsLabel.autoSize = TextFieldAutoSize.LEFT;
			_detailsLabel.setTextFormat(_tfColLabels);
			_detailsLabel.x = _detailsLabelX;
			_detailsLabel.y = _detailsLabelY;
			_tweenContainer.addChild(_detailsLabel);
			
			_featuresLabel = new TextField;
			_featuresLabel.text = "Features";
			_featuresLabel.antiAliasType = AntiAliasType.ADVANCED;
			_featuresLabel.autoSize = TextFieldAutoSize.LEFT;
			_featuresLabel.setTextFormat(_tfColLabels);
			_featuresLabel.x = _featuresLabelX;
			_featuresLabel.y = _featuresLabelY;
			_tweenContainer.addChild(_featuresLabel);
			
			// Builds the two columns of data and their labels
			for(var i:int = 0; i < _propNumOfDetails; i++)
			{
				var detailLabel:TextField = new TextField;
				var detailData:TextField = new TextField;
				
				detailLabel.text = _xmlData.propertyInfoDetails[i];
				detailLabel.antiAliasType = AntiAliasType.ADVANCED;
				detailLabel.autoSize = TextFieldAutoSize.LEFT;
				detailLabel.setTextFormat(_tfPropInfo);
				detailLabel.x = _propDataLabelsX;
				detailLabel.y = _propDataLabelsY + (i * _propTextSpacing);
				_tweenContainer.addChild(detailLabel);
			
				detailData.text = _xmlData.propertyInfoData[i];
				detailData.antiAliasType = AntiAliasType.ADVANCED;
				detailData.autoSize = TextFieldAutoSize.LEFT;
				detailData.setTextFormat(_tfPropInfo);
				detailData.x = _propDataX;
				detailData.y = _propDataY + (i * _propTextSpacing);
				_tweenContainer.addChild(detailData);
			}
		}
		
		// Sets up  the features text box and checks to see if the text needs a scrollbar
		private function buildFeatTextBox():void
		{
			_featText = new TextField;
			_featText.text = _featuresText;
			_featText.antiAliasType = AntiAliasType.ADVANCED;
			_featText.autoSize = TextFieldAutoSize.LEFT
			_featText.wordWrap = true;
			_featText.setTextFormat(_tfPropInfo);
			_featText.width = _featuresTextWidth;
			_featTextArea.x = _featuresTextX;
			_featTextArea.y = _featuresTextY;
			_featTextArea.addChild(_featText);
			
			if(_featTextArea.height >= _featuresTextHeight)
			{
				// Adds featuresText to a Sprite so it can be passed to TextScrollbar 
				_featTextScrollbar = new TextScrollbar(_theme, _featTextArea, _featuresTrackWidth, _featuresTextHeight);
				
				_tweenContainer.addChild(_featTextArea);
				_tweenContainer.addChild(_featTextScrollbar);
			}
			
			else
			{
				_tweenContainer.addChild(_featTextArea);
			}
		}
		
		// Builds the links for neighborhood and school info
		private function buildInfoLinks():void
		{
			_tfHoodLink = new TextFormat;
			_tfHoodLink.font = "Verdana, Arial, Times";
			_tfHoodLink.size = 16;
			_tfHoodLink.color = 0xFFFFFF;
			_tfHoodLink.align = "left";
			_tfHoodLink.url = _neighborhoodURL;
			_tfHoodLink.target = "_blank";
			
			_tfSchoolLink = new TextFormat;
			_tfSchoolLink.font = "Verdana, Arial, Times";
			_tfSchoolLink.size = 16;
			_tfSchoolLink.color = 0xFFFFFF;
			_tfSchoolLink.align = "left";
			_tfSchoolLink.url = _schoolURL;
			_tfSchoolLink.target = "_blank";
			
			_neighborLink = new TextField;
			_neighborLink.text = "Neighborhood Information >";
			_neighborLink.antiAliasType = AntiAliasType.ADVANCED;
			_neighborLink.autoSize = TextFieldAutoSize.LEFT;
			_neighborLink.setTextFormat(_tfHoodLink);
			_neighborLink.x = _neighborLinkX;
			_neighborLink.y = _neighborLinkY;
			_neighborLink.addEventListener(MouseEvent.MOUSE_OVER, neighborhoodOver);
			_neighborLink.addEventListener(MouseEvent.MOUSE_OUT, neighborhoodOut);
			_tweenContainer.addChild(_neighborLink);
			
			_schoolLink = new TextField;
			_schoolLink.text = "School Information >";
			_schoolLink.antiAliasType = AntiAliasType.ADVANCED;
			_schoolLink.autoSize = TextFieldAutoSize.LEFT;
			_schoolLink.setTextFormat(_tfSchoolLink);
			_schoolLink.x = _schoolLinkX;
			_schoolLink.y = _schoolLinkY;
			_schoolLink.addEventListener(MouseEvent.MOUSE_OVER, schoolOver);
			_schoolLink.addEventListener(MouseEvent.MOUSE_OUT, schoolOut);
			_tweenContainer.addChild(_schoolLink);
		}
		
		// Mouse over functions for the info links
		private function neighborhoodOver(e:MouseEvent):void
		{
			_tfHoodLink.underline = true;
			_neighborLink.setTextFormat(_tfHoodLink);
		}
		
		private function neighborhoodOut(e:MouseEvent):void
		{
			_tfHoodLink.underline = false;
			_neighborLink.setTextFormat(_tfHoodLink);
		}
		
		private function schoolOver(e:MouseEvent):void
		{
			_tfSchoolLink.underline = true;
			_schoolLink.setTextFormat(_tfSchoolLink);
		}
		
		private function schoolOut(e:MouseEvent):void
		{
			_tfSchoolLink.underline = false;
			_schoolLink.setTextFormat(_tfSchoolLink);
		}
	}
}