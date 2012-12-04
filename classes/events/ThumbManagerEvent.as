package classes.events // Events specifically for ThumbManager class
{
	import flash.events.Event;

	public class ThumbManagerEvent extends Event
	{
		public static const TRANSITION_COMPLETE:String = "transition_complete"; // Dispatched when the thumbs initialize and the first tween is done
		public static const TRANSITION_START:String = "transition_start"; // Dispatched when the images transition starts
		public static const IMAGE_CLICKED:String = "image_clicked"; // Dispatched when an image is clicked and tells the SlideMenu to stop playing and change the buttons
		
		private var _id:int; // The id of the current selected thumb
		
		// Id number to identify the current pressed thumb
		public function ThumbManagerEvent(type:String, id:int = 0, bubbles:Boolean = false, cancelable:Boolean = false)
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