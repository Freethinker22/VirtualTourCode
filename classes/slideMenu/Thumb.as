package classes.slideMenu // This class will act as a holder for loaded thumbs and it;s linked to the Thumb MC in the lib
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quint;
	import classes.Param;
	import classes.Theme;
	import classes.events.ThumbEvent;

	public class Thumb extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _loadedAsset:DisplayObject; // The loaded asset, a sprite or a bitmap
		private var _loadedAssetHolder:Sprite; // A Sprite containing the loaded asset
		private var _imageBackground:Shape; // Used as a background for the image
		private var _imageBorder:Shape; // Used as a border for the image
		private var _id:uint; // An number used to identify this
		
		// Settable vars
		private var _selected:Boolean; // Used as a flag to check which image is selected
		private var _isImageLoaded:Boolean; // Used as a flag to check if the image has loaded
		private var _imageWidth:Number; // Image width
		private var _imageHeight:Number; // Image height
		private var _backgroundColor:uint; // The background color for this
		private var _borderSize:Number; // The border size
		private var _borderColor:uint; // The border color
		
		public function Thumb(xmlData:Param, theme:Theme, id:int)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			_id = id;
			
			init();
			createImageBackground();
			createBorder();
		}
		
		// Setting parameters to this class
		private function init():void
		{
			// Settable vars
			_selected = false;
			_isImageLoaded = false;
			_imageWidth = _xmlData.imageWidth;
			_imageHeight = _xmlData.imageHeight;
			_backgroundColor = _theme.imageBackgoundColor;
			_borderSize = _xmlData.borderSize;
			_borderColor = _theme.borderColor;
			
			// Create and set objects
			_loadedAssetHolder = new Sprite;
			_loadedAssetHolder.buttonMode = true;
			addChild(_loadedAssetHolder);
		}
		
		// Create the image background
		private function createImageBackground():void
		{
			_imageBackground = new Shape();
			_imageBackground.graphics.beginFill(_backgroundColor);
			_imageBackground.graphics.drawRect(0, 0, _imageWidth, _imageHeight);
			_imageBackground.graphics.endFill();
			_imageBackground.x = -(_imageWidth / 2);
			_imageBackground.y = -(_imageHeight / 2);
			addChildAt(_imageBackground, 0);
		}
		
		// Create the image border
		private function createBorder():void
		{
			_imageBorder = new Shape();
			_imageBorder.graphics.beginFill(_borderColor);
			_imageBorder.graphics.drawRect(0, 0, _imageWidth + _borderSize, _imageHeight + _borderSize);
			_imageBorder.graphics.endFill();
			_imageBorder.x = -((_imageWidth + _borderSize) / 2);
			_imageBorder.y = -((_imageHeight + _borderSize) / 2);
			addChildAt(_imageBorder, 0);
		}

		// Add The object to the window also manage the mouse events
		public function setContent(displayObject:DisplayObject):void
		{
			if(_loadedAssetHolder == null)
			{
				return;
			}
			
			if(displayObject == null)
			{
				return;
			}
			
			this.mouseEnabled = true;
			
			if(displayObject is Sprite)
			{
				_loadedAsset = Sprite(displayObject);
			}
			
			else if(displayObject is Bitmap)
			{
				_loadedAsset = Bitmap(displayObject);
			}
			
			if(_loadedAsset.height > _loadedAsset.width) // Detects of the image is in portrait layout
			{
				var ratio:Number;
				ratio = _loadedAsset.width / _loadedAsset.height
				
				_imageBackground.graphics.clear();
				_imageBackground.graphics.beginFill(_backgroundColor);
				_imageBackground.graphics.drawRect(0, 0, _imageWidth * ratio, _imageHeight);
				_imageBackground.graphics.endFill();
				_imageBackground.x = -((_imageWidth * ratio) / 2);
				_imageBackground.y = -(_imageHeight / 2);
				addChildAt(_imageBackground, 0);
				
				_imageBorder.graphics.clear();
				_imageBorder.graphics.beginFill(_borderColor);
				_imageBorder.graphics.drawRect(0, 0, (_imageWidth * ratio) + _borderSize, _imageHeight + _borderSize);
				_imageBorder.graphics.endFill();
				_imageBorder.x = -(((_imageWidth * ratio) + _borderSize) / 2);
				_imageBorder.y = -((_imageHeight + _borderSize) / 2);
				addChildAt(_imageBorder, 0);
				
				_loadedAsset.width = _imageWidth * ratio;
				_loadedAsset.height = _imageHeight;
				_loadedAsset.x = -((_imageWidth * ratio) / 2);
				_loadedAsset.y = -(_imageHeight / 2);
			}
			
			else
			{
				_loadedAsset.width = _imageWidth;
				_loadedAsset.height = _imageHeight;
				_loadedAsset.x = -(_imageWidth / 2);
				_loadedAsset.y = -(_imageHeight / 2);
			}
			
			_loadedAsset.alpha = 0;
			_loadedAssetHolder.addChild(_loadedAsset);
			TweenMax.to(_loadedAsset, 1, {alpha:1, ease:Quint.easeOut});
			
			//Set mouse events
			_loadedAssetHolder.addEventListener(MouseEvent.MOUSE_DOWN, _imageOnMuseDown);
			_loadedAssetHolder.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			_loadedAssetHolder.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
			
		// When the image is pressed disaptch an event
		private function _imageOnMuseDown(e:MouseEvent):void
		{
			if(!_selected)
			{
				dispatchEvent(new ThumbEvent(ThumbEvent.IMAGE_PRESSED, _id)); // Dispatch to ThumbManager to change img displayed
			}
		}
		
		// Increase the size of the border on mouse over
		private function onMouseOver(e:MouseEvent):void
		{
			TweenMax.to(_loadedAssetHolder, .5, {colorTransform:{tint:0xFFFFFF, tintAmount:.25}, ease:Expo.easeOut});
		}
		
		// Return the border to its original size on mouse out
		private function onMouseOut(e:MouseEvent):void
		{
			TweenMax.to(_loadedAssetHolder, .5, {colorTransform:{tint:0xFFFFFF, tintAmount:0}, ease:Expo.easeOut});
		}
		
		public function disable():void
		{
			_loadedAssetHolder.mouseEnabled = false;
			_loadedAssetHolder.buttonMode = false;
		}
		
		public function enable():void
		{
			if(!_selected)
			{
		   		_loadedAssetHolder.mouseEnabled = true;
				_loadedAssetHolder.buttonMode = true;
			}
		}
		
		// Get and Set methods
		public function get id():int
		{
			return _id;
		}
		
		public function set selected(isSelected:Boolean):void
		{
			_selected = isSelected;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
	}
}