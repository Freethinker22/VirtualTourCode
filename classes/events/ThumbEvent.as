package classes.events // Events specifically for Thumb class
{
	import flash.events.Event;

	public class ThumbEvent extends Event
	{
		public static const IMAGE_PRESSED:String = "image_pressed"; // Dispatched when the image is pressed
		
		private var _id:int; // The thumb id
		
		// Id number to identify the clicked thumb
		public function ThumbEvent(type:String, id:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_id = id;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get id():int
		{
			return _id;
		}
	}
}