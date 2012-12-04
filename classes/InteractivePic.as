package classes // This class creates an interactive button on its parent image to open a detail picture
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenMax;
	import classes.events.PicEvent;
	
	public class InteractivePic extends Sprite
	{
		private var _theme:Theme; // Reference to the Theme class
		private var _Xpos:Number; // Incoming x position of the interactive button
		private var _Ypos:Number; // Incoming y position of the interactive button
		private var _data:String; // Reference to the data used to create the interactivity, in this case the pic's URL
		private var _button:SimpleButton; // Object that becomes the interactive button
		private var _btnUp:Sprite; // Library reference to the up state of the interactive button
		private var _btnOver:Sprite; // Library reference to the over state of the interactive button
		private var _closeBtn:SimpleButton; // Object that becomes the close button
		private var _closeBtnUp:Sprite; // Library reference to the up state of the close button
		private var _closeBtnOver:Sprite; // Library reference to the over state of the close button
		private var _detailPic:Sprite; // Container used to hold the loaded picture and its background
		private var _picLoader:Loader; // Loader used to load the detail picture
		
		// Settable vars
		private var _maxWidth:Number; // Maximum width of the detail picture
		private var _maxHeight:Number; // Maximum height of the detail picture
		private var _picOpen:Boolean; // Flag used to determine if a picture is open

		public function InteractivePic(theme:Theme, Xpos:Number, Ypos:Number, data:String)
		{
			// Set argument vars
			_theme = theme;
			_Xpos = Xpos;
			_Ypos = Ypos;
			_data = data;
			
			// Settable vars
			_maxWidth = 750; // Width of the ImgDisplay mask minus 50
			_maxHeight = 500; // Height of the ImgDisplay mask minus 50
			_picOpen = false;
			
			// Create and set objects
			_detailPic = new Sprite;
			_btnUp = _theme.detailPicBtnUp;
			_btnOver = _theme.detailPicBtnOver;
			_closeBtnUp = _theme.closeBtnUp;
			_closeBtnOver = _theme.closeBtnOver;
			
			init();
			buildDetailPic();
		}
		
		private function init():void
		{
			_button = new SimpleButton;
			_button.upState = _btnUp;
			_button.overState = _btnOver;
			_button.downState = _btnOver;
			_button.hitTestState = _btnUp;
			addChild(_button);
			
			// Assign the close button its states
			_closeBtn = new SimpleButton;
			_closeBtn.upState = _closeBtnUp;
			_closeBtn.overState = _closeBtnOver;
			_closeBtn.downState = _closeBtnOver;
			_closeBtn.hitTestState = _closeBtnUp;
			_closeBtn.filters = [new DropShadowFilter(3, 45, 0x000000)]; // Adds drop shadow to object
			
			_button.addEventListener(MouseEvent.CLICK, onClick);
					
			this.x = _Xpos;
			this.y = _Ypos;
			this.visible = false;
		}
		
		// Load the detail picture
		private function buildDetailPic():void
		{
			_picLoader = new Loader;
			_picLoader.load(new URLRequest(_data));
			_picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		// Once the picture is loaded call picSetup to resize and return the detail pic that gets displayed
		private function loadComplete(e:Event):void
		{
			_detailPic.addChild(picSetup());
			_detailPic.alpha = 0;
			
			this.visible = true;
			_picLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
		}
		
		// Handles the mouse click on the pic button
		private function onClick(e:MouseEvent):void
		{
			if(_picOpen)
			{
				closePicWindow();
			}
			
			else
			{
				TweenMax.to(_detailPic, .5, {alpha: 1, onComplete:openDetailPic});
				dispatchEvent(new PicEvent(PicEvent.SEND_PIC, _detailPic, true)); // Dispatch to Main to add in correct position
			}
		}
		
		// Opens the detail pic and adds the close button
		private function openDetailPic():void
		{
			_closeBtn.x = _detailPic.width - (_closeBtn.width + 7); // The 7 adds padding from the right edge of the pic background
			_closeBtn.y = 7;
			_closeBtn.addEventListener(MouseEvent.CLICK, closePicWindowEvent);
			_detailPic.addChild(_closeBtn);
				
			_picOpen = true;
				
			_detailPic.addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}
		
		// Event parameter workaround for closePicWindow function
		private function closePicWindowEvent(e:MouseEvent):void
		{
			closePicWindow();
		}
		
		// Tweens the detail pic closed
		private function closePicWindow():void
		{
			TweenMax.to(_detailPic, .5, {alpha: 0, onComplete:removeDetailPic});
			
			_picOpen = false;
		}
		
		// Dispatches event to tell Main to remove the detail pic once its transitioned out
		private function removeDetailPic():void
		{
			dispatchEvent(new PicEvent(PicEvent.REMOVE_PIC, _detailPic, true)); // Dispatch to Main to remove the detail picture
		}
		
		// Resets the detail pic if its still open when the img transitions, plus removes event listeners
		private function removed(e:Event):void
		{
			if(_picOpen) // This is basically the closePicWindow func but called only when that func is bypassed because of img trans
			{
				_detailPic.alpha = 0;
				_picOpen = false; // Resets flag when removed from stage via the img transitioning
			}
			
			_detailPic.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			_closeBtn.removeEventListener(MouseEvent.CLICK, closePicWindow);
		}
		
		// Resizes the loaded picture if need be and sets it up on a background to be returned
		private function picSetup():Sprite
		{
			var picCon:Sprite = new Sprite; // Container used to hold the loaded picture
			var picConBg:Sprite = new Sprite; // Object used to create the background the picture sits on
			var displayPic:Sprite = new Sprite // Container to hold the loaded picture and its background
			
			picCon.addChild(_picLoader.content);
			
			if(picCon.width > _maxWidth || picCon.height > _maxHeight) // Check if picture needs to be scaled
			{
				if(picCon.height > picCon.width) // Check if picture is in portrait layout
				{
					var picHeightRatio:Number =  _maxHeight / picCon.height; // Ratio of max height to pic size, used to pic width
					
					picCon.height = _maxHeight;
					picCon.width *= picHeightRatio;
				}
				
				else
				{
					var picWidthRatio:Number =  _maxWidth / picCon.width;
					
					picCon.width = _maxWidth;
					picCon.height *= picWidthRatio;
				}
			}
			
			// Setup background with extra space on sides for padding and close button
			var bgColorBmd:BitmapData = new BitmapData(picCon.width + 50, picCon.height + 50, true, _theme.bgColor);
			var bgColorBm:Bitmap = new Bitmap(bgColorBmd);
			
			var bgTextureBmd:BitmapData = new BitmapData(picCon.width + 50, picCon.height + 50, true, 0xFF000000);
			bgTextureBmd.noise(10, 1, 12, 7); // Adds film grain texture to the background
			var bgTextureBm:Bitmap = new Bitmap(bgTextureBmd);
			bgTextureBm.blendMode = BlendMode.ADD; // Blends background color with texture			
				
			picCon.x = 10; // Makes left padding 10px
			picCon.y = 10; // Makes top padding 10px
			picCon.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
				
			displayPic.addChild(bgColorBm);
			displayPic.addChild(bgTextureBm);
			displayPic.addChild(picCon);
			
			return(displayPic);
		}
	}
}