package classes.events // Events specifically for ButtonManager class
{
	import flash.events.Event;

	public class ButtonManagerEvent extends Event
	{
		public static const NEXT_BUTTON_DOWN:String = "next_button_down"; // Dispatched when the next button is pressed
		public static const PREV_BUTTON_DOWN:String = "prev_button_down"; // Dispatched when the prev button is pressed
		public static const PLAY_BUTTON_DOWN:String = "play_button_down"; // Dispatched when the play button is pressed
		public static const PAUSE_BUTTON_DOWN:String = "pause_button_down"; // Dispatched when the pause button is pressed
		
		public function ButtonManagerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}