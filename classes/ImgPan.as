package classes // This class takes an Image from Transitions and handles the panning of the image based on mouse position
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.greensock.TweenMax;
	import classes.events.ImgPanEvent;
	
	public class ImgPan extends Sprite
	{
		private var _xmlData:Param; // Object to hold xml data
		private var _imgToPan:Sprite; // Current image in the ImgDisplay
		private var _timer:Timer; // Timer used to repeatedly call mouse positioning function
		
		// Settable vars
		private var _maskWidth:Number; // The width of the mask used in ImgDisplay
		private var _maskHeight:Number; // The height of the mask used in ImgDisplay

		public function ImgPan(xmlData:Param)
		{
			// Set argument vars
			_xmlData = xmlData;
			
			// Settable vars
			_maskWidth = _xmlData.maskWidth;
			_maskHeight = _xmlData.maskHeight;
			
			// Create and set new objects
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, updateMouse);
		}
		
		// Set the incoming image to its class var and assign event listeners
		public function setImage(incomingImg:Sprite):void
		{
			_imgToPan = incomingImg;
			_imgToPan.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			_imgToPan.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			_imgToPan.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		// If the user clicks on the image, stop the slide show and allow panning
		private function downHandler(e:MouseEvent):void
		{
			if(_xmlData.isPlaying)
			{
				TweenMax.killTweensOf(_imgToPan); // Stop any transitioning tweens
				_imgToPan.alpha = 1; // Set the alpha to 1 incase mouse moves over before the alpha equals 1 in Transitions
				_imgToPan.buttonMode = false;
				_imgToPan.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
						
				dispatchEvent(new ImgPanEvent(ImgPanEvent.STOP_SLIDE_SHOW, true)); // Dispatch event to stop slide show
			}
			
			else
			{
				return;
			}
		}
		
		// Checks get method in Param class to see if the slide show is running, if not, the image can be panned
		private function overHandler(e:MouseEvent):void
		{
			_imgToPan.buttonMode = true;
			
			if(_xmlData.isPlaying)
			{
				return;
			}
			
			else // If the slide show is not running then allow the mouse to move around the image
			{
				TweenMax.killTweensOf(_imgToPan); // Stop any tweens
				_imgToPan.alpha = 1; // Set the alpha to 1 incase mouse moves over before the alpha equals 1 in Transitions
				_imgToPan.buttonMode = false;
				_imgToPan.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			}			
		}
		
		// Removes the moveHandler listener if the mouse moves off the image
		private function outHandler(e:MouseEvent):void
		{
			_imgToPan.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		// Listens for the mouse to move and starts the update timer
		private function moveHandler(e:MouseEvent):void
		{
			_timer.start();			
		}
		
		// Stop the update timer and sets image X and Y based on mouseX and mouseY
		private function updateMouse(e:TimerEvent):void
		{
			_timer.stop();
			
			// If the image is a vertical panorama, only pan the Y axis
			if(_imgToPan.width < _maskWidth)
			{
				_imgToPan.y = (mouseY / _maskHeight) * (_imgToPan.height - _maskHeight) * - 1;
			
				// Set panning limits for the image so it doesn't move past the edges of the mask
				if(_imgToPan.y >= 0)
				{
					_imgToPan.y = 0;
				}
			
				if(_imgToPan.y <= -_imgToPan.height + _maskHeight)
				{
					_imgToPan.y = -_imgToPan.height + _maskHeight;
				}
			}
			
			// If its a normal panorama or normal picture, pan both X and Y
			else
			{
				_imgToPan.x = (mouseX / _maskWidth) * (_imgToPan.width - _maskWidth) * - 1;
				_imgToPan.y = (mouseY / _maskHeight) * (_imgToPan.height - _maskHeight) * - 1;
			
				// Set panning limits for the image so it doesn't move past the edges of the mask
				if(_imgToPan.x >= 0)
				{
					_imgToPan.x = 0;
				}
			
				if(_imgToPan.x <= -_imgToPan.width + _maskWidth)
				{
					_imgToPan.x = -_imgToPan.width + _maskWidth;
				}
			
				if(_imgToPan.y >= 0)
				{
					_imgToPan.y = 0;
				}
			
				if(_imgToPan.y <= -_imgToPan.height + _maskHeight)
				{
					_imgToPan.y = -_imgToPan.height + _maskHeight;
				}
			}			
		}
	}
}