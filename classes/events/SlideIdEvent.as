package classes.events // This class passes the img id number from the ThumbManager to the Main
{
	import flash.events.Event;
	
	public class SlideIdEvent extends Event
	{
		public static const CHANGE_IMG:String = "change_img"; // Sent from ThumbManager to Main to change the img displayed

		private var _slideNum:int; // The number that references a certain image in the image array
		private var _fromPlayBtn:Boolean; // Flag to indicate if the call was from the play button
		
		public function SlideIdEvent(type:String, slideNum:int, fromPlayBtn:Boolean, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_slideNum = slideNum;
			_fromPlayBtn = fromPlayBtn;
			super(type, bubbles, cancelable);
		}
		
		// Get methods
		public function get slideNum():int
		{
			return _slideNum;
		}
		
		public function get fromPlayBtn():Boolean
		{
			return _fromPlayBtn;
		}
	}
}