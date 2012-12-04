package classes // This class is the preloader for the entire tour and will display while the images are loading
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import com.greensock.TweenMax;
	import classes.events.ImgPreloadEvent;
	
	public class Preloader extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _percentLoaded:Number; // Holds the number that is the percent that is loaded
		private var _leftOverlay:Sprite; // Left side of the 'door' overlay that opens when the loading is done
		private var _rightOverlay:Sprite; // Right side of the 'door' overlay that opens when the loading is done
		private var _progressText:TextField; // Text that displays the percent loaded
		private var _loadingText:TextField; // Text the displays the word 'Loading...'
		private var _progressTextFormat:TextFormat; // Format of the text that displays the percentage
		private var _ballPath:Sprite; // Library reference to the tubePath
		private var _ball:Sprite; // Library reference to the ball that rotates around the tubePath
		
		// Settable vars
		private var _leftOverlayWidth:Number; // Width of the left overlay
		private var _leftOverlayHeight:Number; // Height of the left overlay
		private var _rightOverlayWidth:Number; // Width of the right overlay
		private var _rightOverlayHeight:Number; // Height of the right overlay
		private var _orbitSpeed:Number; // Speed at which the ball orbits on its path
		private var _centerX:Number; // X center point on the stage
		private var _centerY:Number; // Y center point on the stage
		private var _radius:Number; // Used to set the position of the ball on its path
		private var _angle:Number; // Used in the calculation of the balls position

		public function Preloader(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_leftOverlayWidth = _xmlData.leftOverlayWidth;
			_leftOverlayHeight = _xmlData.leftOverlayHeight;
			_rightOverlayWidth = _xmlData.rightOverlayWidth;
			_rightOverlayHeight = _xmlData.rightOverlayHeight;
			_orbitSpeed = _xmlData.orbitSpeed;
			_centerX = (_leftOverlayWidth + _rightOverlayWidth) / 2;
			_centerY = _leftOverlayHeight / 2;
			_radius = 0;
			_angle = 0;
			
			// Create and set variables
			_ballPath = _theme.ballPath;
			_ball = _theme.ball;
			
			init();
		}
		
		private function init():void
		{
			_progressTextFormat = new TextFormat;
			_progressTextFormat.font = "Verdana, Arial, Times";
			_progressTextFormat.size = 16;
			_progressTextFormat.color = 0xFFFFFF;
			_progressTextFormat.align = "center";
			
			_leftOverlay = new Sprite;
			_leftOverlay.graphics.beginFill(0x000000);
			_leftOverlay.graphics.drawRect(0, 0, _leftOverlayWidth, _leftOverlayHeight);
			_leftOverlay.graphics.endFill();
			addChild(_leftOverlay);
			
			_rightOverlay = new Sprite;
			_rightOverlay.graphics.beginFill(0x000000);
			_rightOverlay.graphics.drawRect(_leftOverlayWidth, 0, _rightOverlayWidth, _rightOverlayHeight);
			_rightOverlay.graphics.endFill();
			addChild(_rightOverlay);
			
			_progressText = new TextField;
			_progressText.antiAliasType = AntiAliasType.ADVANCED;
			_progressText.defaultTextFormat = _progressTextFormat;
			_progressText.x = _centerX - (_progressText.width / 2);
			_progressText.y = _centerY - 11; // Offset to center with ballPath
			addChild(_progressText);
			
			_loadingText = new TextField;
			_loadingText.text = "Loading...";
			_loadingText.antiAliasType = AntiAliasType.ADVANCED;
			_loadingText.setTextFormat(_progressTextFormat);
			_loadingText.autoSize = TextFieldAutoSize.CENTER;
			_loadingText.x = _centerX - (_loadingText.width / 2);
			_loadingText.y = _centerY + 75;
			addChild(_loadingText);
			
			_ballPath.x = _centerX;
			_ballPath.y = _centerY;
			_radius = _ballPath.width / 2;
			_ball.addEventListener(Event.ENTER_FRAME, orbit);
			addChild(_ballPath);
			addChild(_ball);
		}
		
		// Removes the pre loader text and animation when called from the Main
		public function remove():void
		{
			removeChild(_progressText);
			removeChild(_loadingText);
			removeChild(_ballPath);
			removeChild(_ball);
				
			openOverlay();
		}
		
		// Sets and updates the text on the Preloader
		public function setPercent(percent:Number):void
		{
			_percentLoaded = percent;
			Math.ceil(_percentLoaded);
			
			_progressText.text = String(_percentLoaded + "%");
			_progressText.autoSize = TextFieldAutoSize.CENTER;
		}		
		
		// Called on ENTER_FRAME to orbit the ball around the ballPath
		private function orbit(e:Event):void
		{
			_ball.x = _centerX + Math.cos(_angle) * _radius;
			_ball.y = _centerY + Math.sin(_angle) * _radius;
			_angle += _orbitSpeed;
		}
		
		// Called whent the ImgPreload class is done loading the tour images
		private function openOverlay():void
		{
			var rightOverlayX:Number = _rightOverlay.width * 2;
						
			TweenMax.to(_leftOverlay, 4, {width:0});
			TweenMax.to(_rightOverlay, 4, {x:rightOverlayX, width:0});
		}
	}
}