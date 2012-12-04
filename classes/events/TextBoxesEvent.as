package classes.events // This class handles events for the Textboxes class
{
	import flash.events.Event;
	
	public class TextBoxesEvent extends Event
	{
		public static const MOVE_RM_LABEL:String = "move_rm_label"; // Sent from Transitions to Main and back down to Textboxes to reposition the room label when a vert pano is thinner than the mask width
		
		private var _xPos:Number; // New X position to move the room label text box to
		
		public function TextBoxesEvent(type:String, xPos:Number, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_xPos = xPos;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get rmLabelPos():int
		{
			return _xPos;
		}
	}
}