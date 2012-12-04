package classes // Creates object containers for the images, sizes them in needed, and adds their interactivity if active
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	
	public class Image extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _image:DisplayObject; // The loaded image, either a sprite or a bitmap
		private var _imgHolder:Sprite; // Object to hold the temp background and then the incoming image
		private var _interArray:Array; // Array used to store the interactive button data if image is interactive
		
		// Settable vars
		private var _isLoaded:Boolean; // Flag to tell if the image has been loaded into the imgHolder or not
		private var _horiRatioLimit:Number; // The ratio limit used to determine if the img is a horizontal panorama
		private var _vertRatioLimit:Number; // The ratio limit used to determine if the img is a vertical panorama
		private var _maskWidth:Number; // The width of the mask used in ImgDisplay
		private var _maskHeight:Number; // The height of the mask used in ImgDisplay
		private var _maxImgWidth:Number; // Maximum width size for non-pano images
		
		// API vars
		public var _imgPath:String; // URL of the image
		public var _imgName:String; // Name of the image
		public var _interactivity:Boolean; // Flag used to tell if the image has interactive buttons or not

		public function Image(imgPath:String, imgName:String, interactivity:String) 
		{
			// Set argument vars
			_imgPath = imgPath;
			_imgName = imgName;
			
			if(interactivity == "yes") { _interactivity = true; }
			else if(interactivity == "no") { _interactivity = false; }
			
			// Settable vars
			_isLoaded = false;
			
			// Create and set objects
			_imgHolder = new Sprite;
			addChild(_imgHolder);
		}
		
		// Once the image is done loading in the ImgPreload, it will be set to the imgHolder
		public function setContent(img:DisplayObject):void
		{
			if(_imgHolder == null)
			{
				return;
			}
			
			if(img == null)
			{
				return;
			}
						
			if(img is Sprite)
			{
				_image = Sprite(img);
			}
			
			else if(img is Bitmap)
			{
				_image = Bitmap(img);
			}
			
			_imgHolder.addChild(_image);
			_isLoaded = true;
			
			checkSize();
		}
		
		// Checks the type of image and resizes the image to fit in the tour display
		private function checkSize():void
		{
			var imgRatio:Number = _imgHolder.height / _imgHolder.width; // Ratio of the img height to width	
			
			if(imgRatio <= _horiRatioLimit)// If the img is a horizontal panorama
			{
				// If the horizontal panorama's height is taller than the mask height set it to the mask height
				if(_imgHolder.height > _maskHeight)
				{
					var horiScaleRatio:Number = _maskHeight / _imgHolder.height; // Ratio of mask size to img size, used to scale img proportionally
					_imgHolder.height = _maskHeight;
					_imgHolder.width *=  horiScaleRatio;
				}
			}
			
			else if(imgRatio > _vertRatioLimit) // If the img is a vertical panorama
			{
				// If the vertical panorama's width is wider than the mask width set it to the mask width
				if(_imgHolder.width > _maskWidth)
				{
					var vertScaleRatio:Number = _maskWidth / _imgHolder.width;
					_imgHolder.width = _maskWidth;
					_imgHolder.height *=  vertScaleRatio;
				}
			}
			
			else // Sizes incoming non-pano images to the set size so that the majority of the image gets seen in the display
			{
				if(_imgHolder.width > _maxImgWidth)
				{
					var imgScaleRatio:Number = _maxImgWidth / _imgHolder.width;
					_imgHolder.width = _maxImgWidth;
					_imgHolder.height *=  imgScaleRatio;
				}
			}
			
			buildInteractivity();
		}
		
		// Called once the image is done loading to setup the interactive buttons on the image if there are any
		private function buildInteractivity():void
		{
			if(_interactivity)
			{
				for(var i:int = 0; i < _interArray.length; i++)
				{
					switch(_interArray[i][0])
					{
						case "text":
							var iaText:InteractiveText;
							iaText = new InteractiveText(_theme, _interArray[i][1], _interArray[i][2], _interArray[i][3]);
							addChild(iaText);
						break;
						case "pic":
							var iaPic:InteractivePic;
							iaPic = new InteractivePic(_theme, _interArray[i][1], _interArray[i][2], _interArray[i][3]);
							addChild(iaPic);
						break;
						case "nav":
							var iaNav:InteractiveNav;
							iaNav = new InteractiveNav(_theme, _interArray[i][1], _interArray[i][2], _interArray[i][3]);
							addChild(iaNav);
						break;
					}
				}
			}
		}
		
		// **** Get method ****
		
		// Returns isLoaded to check if the incoming img has been loaded into imgHolder
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		// **** Set methods ****
		
		// Sets up the interactivity array created out of the xml data
		public function set setArray(interArray:Array):void
		{
			_interArray = interArray;
		}
		
		// Sets the theme variable from ImgPreload so it can be passed to the interactive objects
		public function set setTheme(theme:Theme):void
		{
			_theme = theme;
		}
		
		// Sets the xmlData variable from ImgPreload so it can be used inside this class
		public function set setXml(xmlData:Param):void
		{
			_xmlData = xmlData;
			_horiRatioLimit = _xmlData.horiRatioLimit;
			_vertRatioLimit = _xmlData.vertRatioLimit;
			_maskWidth = _xmlData.maskWidth;
			_maskHeight = _xmlData.maskHeight;
			_maxImgWidth = _xmlData.maxImgWidth;
		}
	}
}