package classes.tabMenu // This class builds the TabMenu that sits on top of the ImageDisplay and is the navigation to the menu pages
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.DropShadowFilter;
	import classes.Param;
	import classes.Theme;
	
	public class TabMenuConstruct extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		
		// Settable vars
		private var _menuPgBgWidth:Number; // Width of the background for the menu pages
		private var _menuPgBgHeight:Number; // Height of the background for the menu pages
		private var _menuPgBgX:Number; // X position of the menu page background
		private var _menuPgBgY:Number; // Y position of the menu page background
		
		// API vars
		protected var _menuPgBg:Sprite; // Background of the TabMenu pages
		protected var _photoGal:TabButton; // Objects that become the tabs in the TabMenu
		protected var _propInfo:TabButton;
		protected var _propMap:TabButton;
		protected var _agentInfo:TabButton;
		protected var _calc:TabButton;

		public function TabMenuConstruct(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_menuPgBgWidth = _xmlData.menuPgBgWidth;
			_menuPgBgHeight = _xmlData.menuPgBgHeight;
			_menuPgBgX = _xmlData.menuPgBgX;
			_menuPgBgY = _xmlData.menuPgBgY;
			
			// Create and set objects
			_menuPgBg = new Sprite;
			
			init();
			buildBackground();
		}
		
		// Creates each new TabButton and passes it a label
		private function init():void
		{
			_photoGal = new TabButton(_theme, "Photo Gallery");
			_photoGal.x = 0;
			addChild(_photoGal);
			
			_propInfo = new TabButton(_theme, "Property Information");
			_propInfo.x = _photoGal.x + _photoGal.width + 8; // 8 is spacing between tabs
			addChild(_propInfo);
			
			_propMap = new TabButton(_theme, "Property Map");
			_propMap.x = _propInfo.x + _propInfo.width + 8;
			addChild(_propMap);
			
			_agentInfo = new TabButton(_theme, "Agent Information");
			_agentInfo.x = _propMap.x + _propMap.width + 8;
			addChild(_agentInfo);
			
			_calc = new TabButton(_theme, "Mortgage Calculator");
			_calc.x = _agentInfo.x + _agentInfo.width + 8;
			addChild(_calc);
		}
		
		// Builds the background for the menu pages
		private function buildBackground():void
		{
			var bgColorBmd:BitmapData = new BitmapData(_menuPgBgWidth, _menuPgBgHeight, true, _theme.bgColor);
			var bgColorBm:Bitmap = new Bitmap(bgColorBmd);
			
			var bgTextureBmd:BitmapData = new BitmapData(_menuPgBgWidth, _menuPgBgHeight, true, 0xFF000000);
			bgTextureBmd.noise(10, 1, 12, 7); // Adds film grain texture to the background
			var bgTextureBm:Bitmap = new Bitmap(bgTextureBmd);
			
			bgTextureBm.blendMode = BlendMode.ADD; // Blends background color with texture
			
			_menuPgBg.x = _menuPgBgX;
			_menuPgBg.y = _menuPgBgY;
			_menuPgBg.filters = [new DropShadowFilter(5, 45, 0x000000)]; // Adds drop shadow to object
			_menuPgBg.addChild(bgColorBm);
			_menuPgBg.addChild(bgTextureBm);
		}
	}
}