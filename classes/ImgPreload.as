package classes // This class preloads a set number of images before the tour starts and the rest after the tour starts
{	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import classes.events.ImgPreloadEvent;
	import classes.events.ThumbDispatchEvent;
	
	public class ImgPreload extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _startId:int; // Reference to which img gets loaded first
		
		// Settable vars
		private var _numOfImages:int; // Holds the total number of images to be preloaded
		private var _minNumOfImages:int; // Minimun number of images to load before slide show starts
		private var _topCounter:int; // Counter that increments to tell the loader which image to load 
		private var _bottomCounter:int; // Counter that increments to tell the loader which image to load
		private var _delayCounter:int; // Counter used to increment until start trans event is dispatched
		private var _centerLoaded:Boolean; // Flag to make sure the center image is loaded before preload is complete
		private var _eventDispatched:Boolean; // Flag to check if the preload complete event has been dispatched

		// API vars
		public var _imgArray:Array; // Holds all the images that get loaded and returned
		public var _percLoaded:int; // Percent of the loading images
		
		public function ImgPreload(xmlData:Param, theme:Theme, startId:int)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			_startId = startId;
			
			// Settable vars
			_numOfImages = _xmlData.numOfImages;
			_minNumOfImages = _xmlData.minNumOfImages;
			_topCounter = _startId - 1;
			_bottomCounter = _startId + 1;
			_delayCounter = 1; // Set to 1 so percLoaded doesn't equal 0
			_centerLoaded = false;
			_eventDispatched =  false;
			
			// Create and set objects
			_imgArray = new Array;
			
			init();
		}
			
		private function init():void
		{
			buildImageArray();
			loadImages();
		}
		
		// Build object containers for the soon to be loaded images so ImgDisplay has objects to load w/o throwing errors
		private function buildImageArray():void
		{
			var tempArray:Array; // Setup temporary array to be cut up
			var topHalf:Array; // Take off the top half of the xml image array
			var bottomHalf:Array; // Then bottom half of the xml image array
			
			tempArray = _xmlData.imgArray;
			topHalf = tempArray.slice(0, Math.floor(_numOfImages / 2 + 1));
			bottomHalf = tempArray.slice(Math.floor(_numOfImages / 2 + 1), tempArray.length);
			
			_imgArray = bottomHalf.concat(topHalf); // Join the bottom to the top so the top img in the xml array is now the middle one
			
			for(var i:int = 0; i < _numOfImages; i++) // Loop through image array and set the theme if the object is interactive
			{
				if(_imgArray[i]._interactivity)
				{
					_imgArray[i].setXml = _xmlData;
					_imgArray[i].setTheme = _theme;
				}
			}
		}
		
		// Calls the Array loading functions and passes them the correct Image and image path to use 
		private function loadImages():void
		{
			loadCenterArray(_imgArray[_startId]);
			loadTopArray(_imgArray[_topCounter]);
			loadBottomArray(_imgArray[_bottomCounter]);
		}
		
		// Loads the center and first image of the slide menu
		private function loadCenterArray(image:Image):void
		{
			var loader:Loader =  new Loader();
			loader.load(new URLRequest(image._imgPath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePercent);
			
			function loadComplete(e:Event):void
			{
				var bitmap:Bitmap = e.target.content;
				var bitmapData:BitmapData = new BitmapData(bitmap.width, bitmap.height);
				bitmapData.draw(bitmap);
				var bitmapDataCopy:BitmapData = bitmapData.clone();
				var bitmapCopy = new Bitmap(bitmapDataCopy);
				
				dispatchEvent(new ThumbDispatchEvent(ThumbDispatchEvent.SEND_CENTER_THUMB, bitmapCopy, _startId)); // Copy to SlideMenu
				image.setContent(loader.content); // Send the image to the Image class after its loaded
				_centerLoaded = true;
				preloadComplete();
			}
		}
		
		// Loads the images above the center image in the slide menu
		private function loadTopArray(image:Image):void
		{
			var loader:Loader =  new Loader();
			loader.load(new URLRequest(image._imgPath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePercent);
			
			function loadComplete(e:Event):void
			{
				var bitmap:Bitmap = e.target.content;
				var bitmapData:BitmapData = new BitmapData(bitmap.width, bitmap.height);
				bitmapData.draw(bitmap);
				var bitmapDataCopy:BitmapData = bitmapData.clone();
				var bitmapCopy = new Bitmap(bitmapDataCopy);
				
				dispatchEvent(new ThumbDispatchEvent(ThumbDispatchEvent.SEND_TOP_THUMB, bitmapCopy, _topCounter));
				image.setContent(loader.content);
				_topCounter--;
				preloadComplete();
				
				try // Recursive function call
				{
					loadTopArray(_imgArray[_topCounter]);
				}
				
				catch(e:Error){} // Better way to end recursive function call than this???
			}
		}
			
		// Loads the images below the center image in the slide menu
		private function loadBottomArray(image:Image):void
		{
			var loader:Loader =  new Loader();
			loader.load(new URLRequest(image._imgPath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, updatePercent);
			
			function loadComplete(e:Event):void
			{
				var bitmap:Bitmap = e.target.content;
				var bitmapData:BitmapData = new BitmapData(bitmap.width, bitmap.height);
				bitmapData.draw(bitmap);
				var bitmapDataCopy:BitmapData = bitmapData.clone();
				var bitmapCopy = new Bitmap(bitmapDataCopy);
				
				dispatchEvent(new ThumbDispatchEvent(ThumbDispatchEvent.SEND_BOTTOM_THUMB, bitmapCopy, _bottomCounter));
				image.setContent(loader.content);
				_bottomCounter++;
				preloadComplete();
				
				try // Recursive function call
				{
					loadBottomArray(_imgArray[_bottomCounter]);
				}
				
				catch(e:Error){} // Better way to end recursive function call than this???
			}
		}
		
		// Updates the percLoaded var to set the percent loaded on the Preloader
		private function updatePercent(e:ProgressEvent):void
		{
			var percent:Number = (((e.bytesLoaded / e.bytesTotal) * 125 * _delayCounter) / _minNumOfImages);
			// The 125 is normally 100 but for some reason when its 100, percent only goes to 80?  So 25% increase to patch
			if(percent > 100)
			{
				_percLoaded = 100;
			}
			
			else if(percent > _percLoaded)
			{
				_percLoaded = percent;
			}
						
			dispatchEvent(new ImgPreloadEvent(ImgPreloadEvent.IMG_PRELOAD_PROGRESS)); // Dispatch a progress update to Main
		}
		
		// Calls the Main to start the tour once the preloadNum number of images and the center image has been loaded
		private function preloadComplete():void
		{
			_delayCounter++;
			
			if(_eventDispatched)
			{
				return; // Keeps the preload complete event from dispatching more than once 
			}
			
			else
			{
				if(_delayCounter >= _minNumOfImages && _centerLoaded)
				{
					dispatchEvent(new ImgPreloadEvent(ImgPreloadEvent.IMG_PRELOAD_COMPLETE));
					_eventDispatched = true;
				}
			}
		}
		
		// *** Get methods ***
		
		// Returns the loaded percentage of the preload images being loaded
		public function get percLoaded():Number
		{
			return _percLoaded;
		}
		
		// Returns the loaded images as an array
		public function get imgArray():Array
		{
			return _imgArray;
		}
	}
}