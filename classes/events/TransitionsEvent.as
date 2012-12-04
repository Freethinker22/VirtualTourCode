package classes.events // This class handles events for the Transition class
{
	import flash.events.Event;
	
	public class TransitionsEvent extends Event
	{
		public static const TRANS_OUT_COMPLETE:String = "trans_out_complete"; // Sent from Transitions to ImgDisplay after current img is faded out
		public static const TRANS_SLIDE_MENU:String = "trans_slide_menu"; // Sent from Transitions to SlideMenu to advance the imgs in the SlideMenu
		public static const MOVE_RM_LABEL:String = "move_rm_label"; // Sent from Transitions to Main and back down to Textboxes to reposition the room label when a vert pano is thinner than the mask width
		
		public function TransitionsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}