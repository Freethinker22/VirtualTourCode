package classes.tabMenu // This is the API class for the Google maps feature
{
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import classes.Param;
	import classes.Theme;
	import classes.events.TabMenuEvent;
	
	public class PropertyMap extends PropertyMapConstruct
	{
		// Constants
		public const PAGE_NAME:String = "Property_Map" // Used as a reference in the TabMenu for selection or removal
		
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		
		// Settable vars
		private var _mapX:Number; // X position of the map
		private var _mapY:Number; // Y position of the map
		
		public function PropertyMap(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			super(_xmlData, _theme);
			
			// Settable vars
			_mapX = _xmlData.mapX;
			_mapY = _xmlData.mapY;
		}
		
		// Called from TabMenu to run code that needs to happen when PropertyMap is added to the stage
		public function addToStage():void
		{
			_map.alpha = 0;
			_map.x = _mapX;
			_map.y = _mapY;
			addChild(_map);
			TweenMax.to(_map, .75, {delay:.25, alpha:1});
		}

		public function returnToTour():void 
		{			
			TweenMax.to(_map, .25, {alpha:0, onComplete:removePage});
		}
		
		private function removePage():void
		{
			dispatchEvent(new TabMenuEvent(TabMenuEvent.DESTROY_PAGE, this.PAGE_NAME, true)); // Dispatches to TabMenu to remove page
		}
	}
}