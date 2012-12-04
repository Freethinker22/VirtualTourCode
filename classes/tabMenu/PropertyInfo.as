package  classes.tabMenu // This is the API class for the PropertyInfo object
{
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import classes.Param;
	import classes.Theme;
	import classes.events.TabMenuEvent;
	
	public class PropertyInfo extends PropertyInfoConstruct
	{
		// Constants
		public const PAGE_NAME:String = "Property_Information" // Used as a reference in the TabMenu for selection or removal
		
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		
		// Settable vars
		private var _propInfoBgLinesX:Number; // X position of the property info page lines
		private var _propInfoBgLinesY:Number; // Y position of the property info page lines

		public function PropertyInfo(xmlData:Param, theme:Theme) 
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			super(_xmlData, _theme);
			
			// Settable vars
			_propInfoBgLinesX = _xmlData.propInfoBgLinesX;
			_propInfoBgLinesY = _xmlData.propInfoBgLinesY;
		}
		
		// Called from TabMenu to run code that needs to happen when PropertyInfo is added to the stage
		public function addToStage():void
		{	
			_propInfoBgLines.alpha = 0;
			_propInfoBgLines.x = _propInfoBgLinesX;
			_propInfoBgLines.y = _propInfoBgLinesY;
			addChild(_propInfoBgLines);
			TweenMax.to(_propInfoBgLines, .50, {alpha:1});
			
			_tweenContainer.alpha = 0;
			addChild(_tweenContainer);
			TweenMax.to(_tweenContainer, .75, {delay:.25, alpha:1});
		}

		public function returnToTour():void 
		{
			TweenMax.to(_propInfoBgLines, .25, {alpha:0});
			TweenMax.to(_tweenContainer, .25, {alpha:0});
			TweenMax.to(_tweenContainer, .25, {alpha:0, onComplete:removePage});
		}
		
		private function removePage():void
		{
			dispatchEvent(new TabMenuEvent(TabMenuEvent.DESTROY_PAGE, this.PAGE_NAME, true)); // Dispatches to TabMenu to remove page
		}
	}
}