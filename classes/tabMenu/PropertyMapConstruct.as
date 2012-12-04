package classes.tabMenu // This class will build the Sprite for the Google maps feature
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.filters.DropShadowFilter;
	import classes.Param;
	import classes.Theme;
	import com.google.maps.services.ClientGeocoder;
	import com.google.maps.services.GeocodingEvent;
	import com.google.maps.LatLng;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapType;
	import com.google.maps.overlays.Marker;
	import com.google.maps.controls.MapTypeControl;
	import com.google.maps.controls.ZoomControl;
	import com.google.maps.controls.PositionControl;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.InfoWindowOptions;
	
	public class PropertyMapConstruct extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _placeMarks:Array; // Array for the place marks
		private var _geocoder:ClientGeocoder; // Reference to the Geocoder object
		private var _marker:Marker; // Reference to the Marker object
		
		// Settabel vars
		private var _mapKey:String; // String that holds the incoming Google maps key
		private var _mapAddress:String; // The string that is input in to the Google maps API
		private var _mapZoomLevel:int; // Starting position of the map zoom
		private var _mapWidth:Number; // Width of the map displayed
		private var _mapHeight:Number; // Height of the map displayed
		
		// API Object Vars
		protected var _map:Map; // Reference to the map object
		
		public function PropertyMapConstruct(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_mapKey = _xmlData.mapKey;
			_mapAddress = _xmlData.stAddress + " " + _xmlData.city + " " + _xmlData.state;
			_mapZoomLevel = _xmlData.mapZoomLevel;
			_mapWidth = _xmlData.mapWidth;
			_mapHeight = _xmlData.mapHeight;
			 
			 buildMap();
		}
			
		private function buildMap():void
		{
			_map = new Map();
			_map.key = _mapKey;
			_map.sensor = "false";
			_map.setSize(new Point(_mapWidth, _mapHeight));
			_map.filters = [new DropShadowFilter(5, 45, 0x000000)]; // Adds drop shadow to object
			_map.addEventListener(MapEvent.MAP_READY, onMapReady);
		}

		private function onMapReady(e:Event):void 
		{
			_geocoder = new ClientGeocoder();
  		  	_geocoder.addEventListener(GeocodingEvent.GEOCODING_SUCCESS, geocode);
			_geocoder.geocode(_mapAddress);
		}
		
		private function geocode(e:GeocodingEvent):void 
		{
         	_placeMarks = e.response.placemarks; 
          		
			if(_placeMarks.length > 0)
			{
				_marker = new Marker(_placeMarks[0].point);
				_marker.addEventListener(MapMouseEvent.CLICK, addMapControl);
						
           		_map.setCenter(_placeMarks[0].point, _mapZoomLevel, MapType.NORMAL_MAP_TYPE);
				
				_map.addOverlay(_marker);
				_map.addControl(new ZoomControl());
   				_map.addControl(new PositionControl());
    			_map.addControl(new MapTypeControl());
				_map.enableScrollWheelZoom();
    			_map.enableContinuousZoom();
   	 			_map.addControl(new ZoomControl());
			}
		}
												
		private function addMapControl(e:MapMouseEvent):void 
		{
            _marker.openInfoWindow(new InfoWindowOptions({content: _placeMarks[0].address}));
		}
	}
}