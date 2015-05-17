package classes.slideMenu // This class holds the created thumbs loads the images and manages the slideMenu functionality
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.PerspectiveProjection;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quint;
	import classes.ImgDisplay;
	import classes.Param;
	import classes.Theme;
	import classes.events.ThumbEvent;
	import classes.events.ThumbManagerEvent;
	import classes.events.ThumbDispatchEvent;
	import classes.events.SlideIdEvent;
	
	public class ThumbManager extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _startId:int; // Reference to which img gets loaded first
		private var _checkFinishedTransition_tm:Timer; // Used to check if the last image is in place and the transition is finished
		private var _thumbArray:Array = new Array; // This will hold a reference to all created thumbs
		private var _imgArrayCopy:Array; // Array holding all the Loaders used to load the images in the center
		private var _perspecitveProjection:PerspectiveProjection; // The perspective projection used to set the vanishing point
		
		// Settable vars
		private var _numOfImages:int; // Total number of pictures
		private var _slideMenuWidth:Number; // The slideMenu width
		private var _slideMenuHeight:Number; // The slideMenu width
		private var _imageWidth:Number; // The image width
		private var _imageHeight:Number; // The image height
		private var _spaceBetweenImages:Number; // The space on x axis applied to all images except the selected one
		private var _imageZ:Number; // The z position applied to all images except the selected one
		private var _centerGap:Number; // Space on x axis applied to all images except the selected one, this will push the top and bottom sets of images away from the selected one
		private var _turnAngle:Number; // The rotation angle applied to all images except the selected one
		private var _offsetImagesXPosition:Number; // This is used to offset the y position of all images on the y axis
		private var _transitionLength:Number; // The transition duration
		private var _useZSpacing:Boolean; // Used as a flag to set the z spacing 3d option
		private var _countTop:uint; // Used as a counter to count how many images has loaded on the top side
		private var _countBottom:uint; // Used as a counter to count how many images has loaded on the bottom side
		private var _id:int; // The current thumb id
		private var _isTransitioning:Boolean; // Used to as flag to check if the images are still tweening or not
		private var _centerX:Number; // The center x position of this based on the total width
		private var _centerY:Number; // The center y position of this based on the total height
		
		public function ThumbManager(xmlData:Param, theme:Theme, startId:int)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			_startId = startId;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// When this is added to stage initialize it
		private function init(pEvent:Event):void
		{
			disable();
			setProperties();
			setPerspective();
			setTimer();
			createThumbs();
			
			stage.addEventListener(Event.RESIZE, setPerspectiveEvent);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		// Setting parameters to this class
		private function setProperties():void
		{
			// Settable vars
			_numOfImages = _xmlData.numOfImages;
			_slideMenuWidth = _xmlData.slideMenuWidth;
			_slideMenuHeight = _xmlData.slideMenuHeight;
			_imageWidth = _xmlData.imageWidth;
			_imageHeight = _xmlData.imageHeight;
			_spaceBetweenImages = _xmlData.spaceBetweenImages;
			_imageZ = _xmlData.imagesZPosition;
			_centerGap =_xmlData.centerGap;
			_turnAngle = _xmlData.turnAngle;
			_offsetImagesXPosition = _xmlData.offsetImagesXPosition;
			_transitionLength = _xmlData.transitionLength;
			_useZSpacing = _xmlData.useZSpacing;
			_countTop = _startId - 1;
			_countBottom = _startId + 1;
			_id = _startId;
			_isTransitioning = false;
			_centerX = _slideMenuWidth / 2;
			_centerY = (_slideMenuHeight / 2) - 1;
			
			// Create and set objects
			_thumbArray =  new Array;
			_perspecitveProjection = new PerspectiveProjection;
		}
		
		// Event parameter workaround for setPerspective function
		private function setPerspectiveEvent(e:Event):void
		{
			setPerspective();
		}
		
		// Setting the vanishing point
		private function setPerspective():void
		{
			_perspecitveProjection.projectionCenter = new Point(_slideMenuWidth / 2, _slideMenuHeight / 2);
			this.transform.perspectiveProjection = _perspecitveProjection;
		}
		
		// Create a timer used to check when the the images transition is finished
		private function setTimer():void
		{
			_checkFinishedTransition_tm =  new Timer(_transitionLength * 1000);
			_checkFinishedTransition_tm.addEventListener(TimerEvent.TIMER, transitionComplete);
		}
		
		// Start the timer
		private function startToCheckTransition():void
		{
			_isTransitioning = true;
			_checkFinishedTransition_tm.reset();
			_checkFinishedTransition_tm.start();
		}
		
		// When the transition is finished dispatch an event
		private function transitionComplete(e:TimerEvent):void
		{
			_isTransitioning = false;
			var currentThumb:Thumb = Thumb(_thumbArray[_startId]);
			currentThumb.selected = true;
			currentThumb.enable();
			_checkFinishedTransition_tm.stop();
		}
		
		// Create the thumbs ***Thumbs array***
		private function createThumbs():void
		{
			for(var i:int = 0; i < _numOfImages; i++)
			{
				var _thumb:Thumb = new Thumb(_xmlData, _theme, i);
				_thumbArray[i] = _thumb;
				_thumb.y = _centerY;
				_thumb.x = _centerX + _offsetImagesXPosition;
			
				if(i == _startId)
				{
					_thumb.rotationX = 0;
					_thumb.selected = true;
				}
				
				else if(i > _startId)
				{
					_thumb.visible = false;
					_thumb.alpha = 0;
					_thumb.rotationX = _turnAngle;
					_thumb.z = _imageZ;
				}
				
				else if(i < _startId)
				{
					_thumb.visible = false;
					_thumb.alpha = 0;
					_thumb.rotationX = -_turnAngle;
					_thumb.z = _imageZ;
				}
		
				_thumb.addEventListener(ThumbEvent.IMAGE_PRESSED, thumbOnMouseDown); // Listens for img pressed in Thumb
				addChild(_thumb);
			}
			
			var selectedThumb:Thumb = Thumb(_thumbArray[_startId]);
			setChildIndex(selectedThumb, numChildren - 1);
			selectedThumb.alpha = 0;
			selectedThumb.z = 2000;
			TweenMax.to(selectedThumb, .8, {alpha:1, z:0, ease:Expo.easeOut, onComplete:introAnimationFinished});
		}
		
		// When the image is pressed except the selected one navigate to that image
		private function thumbOnMouseDown(thumbEvent:ThumbEvent):void
		{
			_id = thumbEvent.id;
			var thumb:Thumb = _thumbArray[_id];
			
			if(_id > _startId)
			{
				for(var i:uint = 0; i < _numOfImages; i++)
				{
					var thumbIn:Thumb = _thumbArray[i];
					
					if(thumbIn.rotationX == -180)
					{
						thumbIn.rotationX = 180;
					}
				}
			}
			
			gotoThumb(_id);
			
			dispatchEvent(new ThumbManagerEvent(ThumbManagerEvent.IMAGE_CLICKED)); // Dispatch to SlideMenu to turn off slideshow
		}
		
		// Navigate to the current thumb based on the id
		public function gotoThumb(id:int, fromPlayBtn:Boolean = false):void
		{
			_id = id;
			var thumb:Thumb = _thumbArray[_id];
			
			if(_id > _startId)
			{
				for(var i:int = 0; i < _numOfImages; i++)
				{
					var thumbIn:Thumb = _thumbArray[i];
					if(thumbIn.rotationX == -180)
					{
						thumbIn.rotationX = 180;
					}
				}
			}
			reOrderSlides(thumb.id);
			_startId = _id;
			startToCheckTransition();

			dispatchEvent(new ThumbManagerEvent(ThumbManagerEvent.TRANSITION_START, _id)); // Dispatch to SlideMenu to set Scrollbar position
			dispatchEvent(new SlideIdEvent(SlideIdEvent.CHANGE_IMG, _id, fromPlayBtn, true)); // Dispatch to Main to change picture
		}
		
		// When the first thumb animation is finised enable all and show all thumbs
		private function introAnimationFinished():void
		{
			enable();
			var delayTop:Number = 0;
			var delayBottom:Number = 0;
			for(var i:int = 0; i < _numOfImages; i++)
			{
				var thumb:Thumb = _thumbArray[i];
				Thumb(_thumbArray[i]).visible = true;	
				if(i < _startId)
				{
					// Top slideMenu	
					TweenMax.to(thumb, .8, {alpha:1, ease:Expo.easeOut});
			    } else if (i > _startId) {
					// Bottom slideMenu
					TweenMax.to(thumb, .8, {alpha:1, ease:Expo.easeOut});
				} 
			}
			reOrderSlides(_startId);
			startToCheckTransition();
			dispatchEvent(new ThumbManagerEvent(ThumbManagerEvent.TRANSITION_COMPLETE)); // Dispatch to SlideMenu to enable mouse events
		}
		
		// Change each slide's position and rotation
		private function reOrderSlides(id:uint):void
		{
			var zTop:Number = 0;
			var zBottom:Number = 0;
	
			for(var i:int = 0; i < _numOfImages; i++) // *** Dev note: all slides set to center then reOrderSlides puts them in the right
			{    									  // position once the menu is set up
				var thumb:Thumb = _thumbArray[i];
				
				if(i < id)
				{
					thumb.selected = false;
					thumb.enable();
					
					// Top slideMenu
					if(_useZSpacing)
					{
						zTop = Math.abs(_imageZ * (i - id));
					}
					
					else
					{
						zTop = _imageZ;
					}
					
					TweenMax.to(thumb, _transitionLength, {y:(_centerY - (id - i) * _spaceBetweenImages - _imageHeight / 2) - _centerGap, z:(_imageZ + zTop), rotationX:_turnAngle, ease:Quint.easeOut});
			    }
				
				else if(i > id)
				{
			    	thumb.selected = false;
			    	thumb.enable();
					
					// Bottom slideMenu
					if(_useZSpacing)
					{
						zBottom += _imageZ;
					}
					
					else
					{
						zBottom = _imageZ;
					}
					
					TweenMax.to(thumb, _transitionLength, {y:(_centerY + (i - id) * _spaceBetweenImages + _imageHeight / 2) + _centerGap, z:(_imageZ + zBottom), rotationX:-_turnAngle, ease:Quint.easeOut});
				}
				
				else
				{
					thumb.disable();
					//Center slideMenu
					TweenMax.to(thumb, _transitionLength, {y:_centerY, z:0, rotationX:0, ease:Quint.easeOut, onUpdate:checkRotation});
				}
			}
				
			for(i = 0; i < id; i++)
			{
				setChildIndex(Thumb(_thumbArray[i]),numChildren - 1);
			}
			
			for(i = _thumbArray.length - 1; i > id; i--)
			{					
				setChildIndex(Thumb(_thumbArray[i]),numChildren - 1);
			}
			
			setChildIndex(Thumb(_thumbArray[i]),numChildren - 1);
		}
		
		// Checking the rotation and based on that the image or text is showed
		private function checkRotation():void
		{
			for (var i:uint = 0; i < _numOfImages; i++)
			{
				var thumb:Thumb = _thumbArray[i];
			}
		}
		
		// Load the center image of the slide menu onto the center object of the thumbArray
		public function setCenter(img:DisplayObject, counter:int):void
		{
			var thumb:Thumb = _thumbArray[counter];
			thumb.setContent(img);
		}
		
		// Load the top of the slide menu onto the bottom of the thumbArray
		public function setTop(img:DisplayObject, counter:int):void
		{
			var thumb:Thumb = _thumbArray[counter];
			thumb.setContent(img);
		}
		
		// Load the bottom of the slide menu onto the bottom of the thumbArray
		public function setBottom(img:DisplayObject, counter:int):void
		{
			var thumb:Thumb = _thumbArray[counter];
			thumb.setContent(img);
		}
		
		// Navigate to the next image
		public function gotoNextThumb(fromPlayBtn:Boolean = false):void
		{
			if(fromPlayBtn) // If the call comes from the play button, gotoThumb w/o _id++ and notify gotoThumb call is coming from play button
			{
				_id = _id;
			}
			
			else if(_id < _numOfImages - 1)
			{
				_id++;
			}
			
			else
			{
				_id = 0;
			}
			
			gotoThumb(_id, fromPlayBtn);
		}
		
		// Navigate to the previous image
		public function gotoPrevThumb():void
		{
			if(_id > 0)
			{
				_id --;
			}
			
			else
			{
				_id = _numOfImages - 1;
			}
			
			gotoThumb(_id);
		}
		
		// Disable all mouse events
		private function disable():void
		{
			this.mouseChildren = false;
		}
		
		// Enable all mouse events
		private function enable():void
		{
			this.mouseChildren = true;
		}
		
		// Get method
		public function get isTransitioning():Boolean
		{
			return _isTransitioning;
		}
	}
}