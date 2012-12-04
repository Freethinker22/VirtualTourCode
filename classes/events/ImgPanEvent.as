package classes.events // This class is used to tell the Main to stop the slide show when the user clicks the image in transition
{
	import flash.events.Event;
	
	public class ImgPanEvent extends Event
	{
		public static const STOP_SLIDE_SHOW:String = "stop_slide_show"; // Sent from ImgDrag to Main to stop the slide show
		
		public function ImgPanEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}