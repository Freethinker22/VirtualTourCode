package classes // This class manages which images are loaded and unloaded in the tour and their transistions
{
	import flash.display.Sprite;
	import classes.events.TransitionsEvent;
	import classes.events.InfoEvent;
		
	public class ImgDisplay extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _transitions:Transitions; // Class that handles image transitions
		private var _imgArray:Array; // Array of imgages from ImgPreload
		private var _imgMask:Sprite;  // Main mask that hides edges of images
		private var _startId:int; // Initial slideNum on start up
		private var _slideNum:int; // Number of slide corresponding to number of image to display
		private var _prevSlide:int; // Number of last slide, used for unloading images after TansImgOut
		private var _transPrevSlide:int; // Number of last slide, used when clicks occur during TransImgOut
		
		// Settable vars
		private var _maskWidth:Number; // Width of the image mask
		private var _maskHeight:Number; // Height of the image mask
		
		// API var
		public var _fromPlayBtn:Boolean; // Flag to indicate if the call to transition came from the play button

		public function ImgDisplay(xmlData:Param, imgArray:Array, startId:int)
		{
			// Set argument vars
			_xmlData = xmlData;
			_imgArray = imgArray;
			_startId = startId;
			
			// Settable vars
			_maskWidth = xmlData.maskWidth;
			_maskHeight = xmlData.maskHeight;
			
			// Create and set objects
			_transitions = new Transitions(_xmlData);
			_imgMask = new Sprite;
			_fromPlayBtn = false;
			_slideNum = 0;
			_prevSlide = _startId;
			
			init();
		}
		
		private function init():void
		{
			addChild(_transitions); // Have to addChild transitions so event propagation in ImgPan works
			addChild(_imgMask);
			
			_transitions.addEventListener(TransitionsEvent.TRANS_OUT_COMPLETE, removeOldImg); // Listen for transOutComplete in Transitions
			
			setMasks();
		}
		
		// Create mask for the images
		private function setMasks():void
		{
			var mainMask:Sprite = new Sprite;
			mainMask.graphics.beginFill(0x000000);
			mainMask.graphics.drawRect(0, 0, _maskWidth, _maskHeight); // 16:11 Aspect ratio
			mainMask.graphics.endFill();
			_imgMask.mask = mainMask;
			addChild(mainMask);
		}
		
		// Called once a certain number of images has finished loading in the ImgPreload
		public function startTour():void
		{
			_imgMask.addChild(_imgArray[_startId]);
			_transitions.imgIn(_imgArray[_startId]); // Passes the set Image to Transitions to start slide show
		}
		
		// Stops the transition of the image when the pause button is pressed
		public function stopImgTween():void
		{
			_transitions.stopImgTween();
		}
		
		// Pauses the transition of the image when a TabMenu page is called
		public function pauseOnTabMenu():void
		{
			_transitions.pauseOnTabMenu();
		}
		
		// Restarts slide show when the TabMenu navigates back to the photo gallery
		public function resumeOnTabMenu():void
		{
			_transitions.resumeOnTabMenu();
		}
		
		// These functions work with Main and Transitions to change the img depending the number fed into the slideNum from ThumbManager
		public function changeImg(slideNum:int, prevSlide:int, fromPlayBtn:Boolean):void
		{
			_transPrevSlide = _prevSlide; // Set transPrevSlide to old prevSlide, one image back of the new prevSlide
			_slideNum = slideNum; // Set slideNum to the new incoming slideNum
			_prevSlide = prevSlide; // Set prevSlide to new incoming prevSlide
			_fromPlayBtn = fromPlayBtn; // Set fromPlayBtn to new incoming fromPlayBtn
			_transitions.stopImgTweens(); // Stop any unfinished tweens
						
			if(_transitions._isTransitioning) // This code is only used when another image is selected w/o the first image being done transitioning out
			{
				if(_fromPlayBtn) // If the call to changeImg comes from the play button, reload the image w/o changing anything
				{
					_imgMask.removeChild(_imgArray[_transPrevSlide]); // Remove image that was transitioning out
					_imgMask.addChild(_imgArray[_slideNum]); // Reset mask container with new selection
					_transitions.imgIn(_imgArray[_slideNum]); // Transition in new selection
					_transitions._isTransitioning = false; // Reset flag in Transitions because imgOut is not called here
					_fromPlayBtn = false; // Set fromPlayBtn to false so the code only gets used when the call comes from the play button
				}
				
				else
				{
					_imgMask.removeChild(_imgArray[_transPrevSlide]); // Remove image that was transitioning out
					_transitions.imgOut(_imgArray[_prevSlide]); // Transition out image that was on the way in
					_imgMask.addChild(_imgArray[_slideNum]); // Reset mask container with new selection
					_transitions.imgIn(_imgArray[_slideNum]); // Transition in new selection
				}
				
				_transPrevSlide = _prevSlide; // Set transPrevSlide to the new incoming prevSlide
			}
			
			else
			{
				if(_fromPlayBtn) // If the call to changeImg comes from the play button, reload the image w/o changing anything
				{
					_transitions.imgIn(_imgArray[_slideNum]); // Resend image to Transitions w/o changing the image
					_fromPlayBtn = false; // Set fromPlayBtn to false so the code only gets used when the call comes from the play button
				}
				
				else
				{
					_transitions.imgOut(_imgArray[_prevSlide]); // Send previous image to imgOut, to transition out
					_imgMask.addChild(_imgArray[_slideNum]); // Add new image to mask container
					_transitions.imgIn(_imgArray[slideNum]); // Transition in new image
				}
			}
		}
		
		// Called once imgOut is done in Transitions
		private function removeOldImg(imgTransEvent:TransitionsEvent):void
		{
			_imgMask.removeChild(_imgArray[_prevSlide]); // Removes image that just got done transitioning out
		}
		
		private function onInfoBox(infoEvent:InfoEvent):void
		{
			trace("info box");
		}
	}
}