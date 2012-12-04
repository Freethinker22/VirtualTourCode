package classes.events // This class passes the img id number from the InteractiveNav to the Main
{
	import flash.events.Event;
	
	public class NavEvent extends Event
	{
		public static const SEND_SLIDENUM:String = "send_slidenum"; // Sent from InteractiveNav to Main to change the img displayed

		private var _slideNum:int; // The number that references a certain image in the image array
		
		public function NavEvent(type:String, slideNum:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_slideNum = slideNum;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get slideNum():int
		{
			return _slideNum;
		}
	}
}