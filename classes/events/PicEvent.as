package classes.events // This class passes the detail picture Sprite from the InteractivePic to the Main
{
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class PicEvent extends Event
	{
		public static const SEND_PIC:String = "send_pic"; // Sent from InteractivePic to Main to display on the Main
		public static const REMOVE_PIC:String = "remove_pic"; // Sent from InteractivePic to Main to remove the detail pic

		private var _detailPic:Sprite; // The object that holds the Sprite built in the InteractivePic
		
		public function PicEvent(type:String, detailPic:Sprite, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_detailPic = detailPic;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get detailPic():Sprite
		{
			return _detailPic;
		}
	}
}