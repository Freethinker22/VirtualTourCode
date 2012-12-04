package classes.events // Events specifically for the SlideMenu Scrollbar class
{
	import flash.events.Event;

	public class ScrollbarEvent extends Event
	{
		public static const CHANGE:String = "image_pressed"; // Dispatched when the scrollbar is scrolled
		
		private var _id:int; // The thumb id
		
		// Id number to identify the current scrollbar position based on the total items to scroll
		public function ScrollbarEvent(type:String, id:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_id = id;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get id():uint
		{
			return _id;
		}
	}
}