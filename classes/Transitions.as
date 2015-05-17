package classes // This classes will handle the transitions for the ImgDisplay pictures
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.greensock.TweenMax;
	import com.greensock.easing.FastEase;
	import com.greensock.easing.Linear;
	import classes.events.TransitionsEvent;
	import classes.events.TextBoxesEvent;
	import classes.util.PauseTween;
	
	public class Transitions extends Sprite
	{
		private var _xmlData:Param; // Object to hold xml data
		private var _imgPan:ImgPan; // Object that is sent the incoming image and handles its panning
		private var _outgoingImg:Image; // Image to transition out
		private var _incomingImg:Image; // Image to transition in
		private var _initialTrans:Boolean // Flag that indicates if the transition is the initial transition or not
		private var _checkTimer:Timer; // Timer used to set the checking interval if incomingImg is selected but not loaded 
		
		// Settable vars
		private var _pixelsPerSec:Number; // Transition speed
		private var _fadeDelay:Number; // The number of seconds the image takes to fade out
		private var _horiRatioLimit:Number; // The ratio limit used to determine if the img is a horizontal panorama
		private var _vertRatioLimit:Number; // The ratio limit used to determine if the img is a vertical panorama
		private var _maskWidth:Number; // The width of the mask used in ImgDisplay
		private var _maskHeight:Number; // The height of the mask used in ImgDisplay
		private var _maxTransTime:Number; // Limit on the amount of seconds each transition is allowed
		private var _minTransTime:Number; // Minimum amount of seconds each transition is given
		
		// API vars
		public var _isTransitioning:Boolean; // Flag that lets ImgDisplay know if transImgOut is done or not

		public function Transitions(xmlData:Param)
		{
			// Set argument vars
			_xmlData = xmlData;
			
			// Settable vars
			_pixelsPerSec = _xmlData.pixelsPerSec;
			_fadeDelay = _xmlData.fadeDelay;
			_horiRatioLimit = _xmlData.horiRatioLimit;
			_vertRatioLimit = _xmlData.vertRatioLimit;
			_maskWidth = _xmlData.maskWidth;
			_maskHeight = _xmlData.maskHeight;
			_maxTransTime = _xmlData.maxTransTime;
			_minTransTime = _xmlData.minTransTime;
			
			// Create and set objects
			_imgPan = new ImgPan(_xmlData);
			_initialTrans = true;
			_checkTimer = new Timer(40); // 24 checks per second
			
			FastEase.activate([Linear]); // Activates more efficient tweening
		}
		
		// Fades out the target Sprite
		public function imgOut(targetImgOut:Image)
		{
			_isTransitioning = true;
			_outgoingImg = targetImgOut;
			
			TweenMax.to(_outgoingImg, _fadeDelay, {alpha:0, onComplete:transOutComplete});
		}
		
		// Resets flag and tells ImgDisplay to load new image
		private function transOutComplete():void
		{
			_isTransitioning = false;
			dispatchEvent(new TransitionsEvent(TransitionsEvent.TRANS_OUT_COMPLETE, true)); // Dispatched to ImgDisplay
		}
		
		// Called from ImgDisplay, take incoming image, and checks to see if its loaded
		public function imgIn(targetImgIn:Image):void
		{
			_incomingImg = targetImgIn;
			_incomingImg.cacheAsBitmap = false;
			_incomingImg.alpha = 0;
			
			if(_incomingImg.isLoaded) // Checks the isLoaded flag in the Image class
			{
				transImgIn();
				setupPanning();
			}
			
			else // This is only called when the user selects an image in the slide menu that hasn't finished loading yet
			{
				imgInCheck();
			}
		}
		
		// Recursive function: check isLoaded again if false, starts timer to check isLoaded at set interval
		private function imgInCheck():void
		{
			if(_incomingImg.isLoaded) // Checks the isLoaded flag in the Image class
			{
				transImgIn();
				setupPanning();
			}
			
			else // Start recursive function
			{
				_checkTimer.start();
				_checkTimer.addEventListener(TimerEvent.TIMER, notLoaded);
			}
		}
				
		// Called when incomingImg hasn't fully loaded yet, keeps checking by recursively calling imgInCheck 
		private function notLoaded(e:TimerEvent):void
		{
			_checkTimer.stop();
			_checkTimer.removeEventListener(TimerEvent.TIMER, notLoaded);
			imgInCheck(); // Recursive function call if incomingImg isn't loaded
		}
		
		// Pass the ImgPan class the image ref to setup the panning feature
		private function setupPanning():void
		{
			_imgPan.setImage(_incomingImg);
			addChild(_imgPan); // Have to addChild imgPan so event propagation in ImgPan works
		}
		
		// Takes the loaded incoming image and assigns it a random transition based on its height and width ratios
		private function transImgIn():void
		{
			var widthDif:Number = _incomingImg.width - _maskWidth; // Dif in img size and mask size
			var heightDif:Number = _incomingImg.height - _maskHeight;
			var imgRatio:Number = _incomingImg.height / _incomingImg.width; // Ratio of the img height to width
			
			// If the img is a horizontal panorama, this tween is used
			if(imgRatio <= _horiRatioLimit)
			{
				var horiPanoTime:Number = (_incomingImg.width - _maskWidth) / _pixelsPerSec; // Sets time for horizontal panos
				var leftOrRight:Number = Math.ceil(Math.random() * 2); // Generates random number to set transition
				
				// Limit the transition time
				if(horiPanoTime > _maxTransTime)
				{
					horiPanoTime = _maxTransTime;
				}
				
				// Set a minimum transition time
				if(horiPanoTime < _minTransTime)
				{
					horiPanoTime = _minTransTime;
				}
								
				// If leftOrRight equals 1, start the img moving to the left
				if(leftOrRight == 1)
				{
					_incomingImg.x = 0;
					_incomingImg.y = (_maskHeight / 2) - (_incomingImg.height / 2);
					TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});				
					TweenMax.to(_incomingImg, (horiPanoTime / 2), {delay:.25, x:-widthDif, ease:Linear.easeNone}); // .25 delays movement during alpha tween
					TweenMax.to(_incomingImg, (horiPanoTime / 2), {delay:((horiPanoTime / 2) + .25), x:0, ease:Linear.easeNone, onComplete:imgTrans});
				}
				
				// If leftOrRight equals 2, start the img moving to the right
				else
				{
					_incomingImg.x = -widthDif;
					_incomingImg.y = (_maskHeight / 2) - (_incomingImg.height / 2);
					TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});				
					TweenMax.to(_incomingImg, (horiPanoTime / 2), {delay:.25, x:0, ease:Linear.easeNone}); // .25 delays movement during alpha tween
					TweenMax.to(_incomingImg, (horiPanoTime / 2), {delay:((horiPanoTime / 2) + .25), x:-widthDif, ease:Linear.easeNone, onComplete:imgTrans});
				}
			}
			
			// If the img is a vertical panorama, this tween is used
			else if(imgRatio > _vertRatioLimit)
			{
				var vertPanoTime:Number = (_incomingImg.height - _maskHeight) / _pixelsPerSec; // Sets time for vertical panos
				var upOrDown:Number = Math.ceil(Math.random() * 2); // Generates random number to set transition
				
				// If the vert pano is thinner than the mask width, dispatch event to reset the x position of the room label in TextBoxes
				if(_incomingImg.width < _maskWidth)
				{
					var xPos:Number = (_maskWidth / 2) + (_incomingImg.width / 2); // New x position of the room label in TextBoxes
					dispatchEvent(new TextBoxesEvent(TextBoxesEvent.MOVE_RM_LABEL, xPos, true));
				}
				
				// Limit the transition time
				if(vertPanoTime > _maxTransTime)
				{
					vertPanoTime = _maxTransTime;
				}
				
				// Set a minimum transition time
				if(vertPanoTime < _minTransTime)
				{
					vertPanoTime = _minTransTime;
				}
				
				// If upOrDown equals 1, start the img moving up
				if(upOrDown == 1)
				{
					_incomingImg.x = (_maskWidth / 2) - (_incomingImg.width / 2);
					_incomingImg.y = 0;
					TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});
					TweenMax.to(_incomingImg, vertPanoTime, {delay:.25, y:-heightDif, ease:Linear.easeNone});
					TweenMax.to(_incomingImg, vertPanoTime, {delay:(vertPanoTime + .25), y:0, ease:Linear.easeNone, onComplete:imgTrans});
				}
				
				// If upOrDown equals 2, start the img moving down
				else
				{
					_incomingImg.x = (_maskWidth / 2) - (_incomingImg.width / 2);
					_incomingImg.y = -heightDif;
					TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});
					TweenMax.to(_incomingImg, vertPanoTime, {delay:.25, y:0, ease:Linear.easeNone});
					TweenMax.to(_incomingImg, vertPanoTime, {delay:(vertPanoTime + .25), y:-heightDif, ease:Linear.easeNone, onComplete:imgTrans});
				}
			}
			
			// If the image is not a panorama, check and adjust its size, then assign it a random tween
			else
			{
				var transTime:Number = (_incomingImg.width - _maskWidth) / _pixelsPerSec; // Sets time for picture transitions
				var transNum:Number = Math.ceil(Math.random() * 4); // Generates random number to set transition
				
				// Limit the transition time
				if(transTime > _maxTransTime)
				{
					transTime = _maxTransTime;
				}
				
				// Set a minimum transition time
				if(transTime < _minTransTime)
				{
					transTime = _minTransTime;
				}
				
				// Makes it so the first transition moves the image into upper left corner and back
				if(_initialTrans)
				{
					transNum = 1;
					_initialTrans = false;
				}
				
				switch(transNum)
				{
					// Moves image into upper left corner and back
					case 1:
						_incomingImg.x = 0;
						_incomingImg.y = 0;
						TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});
						TweenMax.to(_incomingImg, transTime, {transformMatrix:{x:-widthDif, y:-heightDif}, ease:Linear.easeNone});
						TweenMax.to(_incomingImg, transTime, {delay:transTime, transformMatrix:{x:0, y:0}, ease:Linear.easeNone, onComplete:imgTrans});
					break;
					// Moves image into upper right corner and back
					case 2:
						_incomingImg.x = _maskWidth - _incomingImg.width;
						_incomingImg.y = 0;
						TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});
						TweenMax.to(_incomingImg, transTime, {transformMatrix:{x:0, y:-heightDif}, ease:Linear.easeNone});
						TweenMax.to(_incomingImg, transTime, {delay: transTime, transformMatrix:{x:(_maskWidth - _incomingImg.width), y:0}, ease:Linear.easeNone, onComplete:imgTrans});
					break;
					// Moves image into lower right corner and back
					case 3:
						_incomingImg.x = _maskWidth - _incomingImg.width;
						_incomingImg.y = _maskHeight - _incomingImg.height;
						TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});
						TweenMax.to(_incomingImg, transTime, {transformMatrix:{x:0, y:0}, ease:Linear.easeNone});
						TweenMax.to(_incomingImg, transTime, {delay: transTime, transformMatrix:{x:(_maskWidth - _incomingImg.width), y:(_maskHeight - _incomingImg.height)}, ease:Linear.easeNone, onComplete:imgTrans});
					break;
					// Moves image into lower left corner and back
					case 4:
						_incomingImg.x = 0;
						_incomingImg.y = _maskHeight - _incomingImg.height;
						TweenMax.to(_incomingImg, _fadeDelay, {alpha:1});
						TweenMax.to(_incomingImg, transTime, {transformMatrix:{x:-widthDif, y:0}, ease:Linear.easeNone});
						TweenMax.to(_incomingImg, transTime, {delay: transTime, transformMatrix:{x:0, y:(_maskHeight - _incomingImg.height)}, ease:Linear.easeNone, onComplete:imgTrans});
					break;					
				}
			}
		}
		
		// Tells Main to advance SlideMenu one image if slide show is playing, if its not playing call is ignored in SlideMenu
		private function imgTrans():void
		{
			_incomingImg.dispatchEvent(new TransitionsEvent(TransitionsEvent.TRANS_SLIDE_MENU, true)); // Dispatched to Main
		}
		
		// Stops all tweens if they didn't finish transitioning
		public function stopImgTweens():void
		{
			TweenMax.killTweensOf(_incomingImg);
			TweenMax.killTweensOf(_outgoingImg);
		}
		
		// Stops the transition of the incoming image when the pause button is pressed
		public function stopImgTween():void
		{
			_incomingImg.alpha = 1;
			TweenMax.killTweensOf(_incomingImg);
		}
		
		// Pauses the transition of the image when a TabMenu page is called
		public function pauseOnTabMenu():void
		{
			_incomingImg.alpha = 1;
			
			PauseTween.stopTween(_incomingImg);
		}
		
		// Restarts slide show when the TabMenu navigates back to the photo gallery
		public function resumeOnTabMenu():void
		{
			PauseTween.startTween(_incomingImg);
		}
	}
}