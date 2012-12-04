package classes.events // Handles the sending of thumbs from the ImgPreload to the ThumbManager to update the slide menu
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	public class ThumbDispatchEvent extends Event
	{
		public static const SEND_CENTER_THUMB:String = "send_center_thumb"; // Called when the center image is finished loading in the ImgPreload
		public static const SEND_TOP_THUMB:String = "send_top_thumb"; // Called when a top image is finished loading in the ImgPreload
		public static const SEND_BOTTOM_THUMB:String = "send_bottom_thumb"; // Called when a bottom image is finished loading in the ImgPreload
		
		private var _thumb:DisplayObject; // Incoming image to be sent to ThumbManager
		private var _counter:int; // Incoming number to be sent to ThumbManager

		public function ThumbDispatchEvent(type:String, thumb:DisplayObject, counter:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_thumb = thumb;
			_counter = counter;
			super(type, bubbles, cancelable);
		}
		
		// Get methods
		public function get sentThumb():DisplayObject
		{
			return _thumb;
		}
		
		public function get sentCounter():int
		{
			return _counter;
		}
	}
}