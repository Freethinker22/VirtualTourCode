package classes.events // This class passes the info text Sprite from the InteractiveText to the Main
{
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class InfoEvent extends Event
	{
		public static const SEND_INFO_BOX:String = "send_info_box"; // Sent from InteractiveText to Main to display on the Main
		public static const REMOVE_INFO_BOX:String = "remove_info_box"; // Sent from InteractiveText to Main to remove the info box

		private var _infoBox:Sprite; // The object that holds the info box built in the InteractiveText
		
		public function InfoEvent(type:String, infoBox:Sprite, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_infoBox = infoBox;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get infoBox():Sprite
		{
			return _infoBox;
		}
	}
}