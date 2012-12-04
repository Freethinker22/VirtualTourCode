package classes.events // This class handles the events for the ImgPreload class
{
	import flash.events.Event;
	
	public class ImgPreloadEvent extends Event
	{
		public static const IMG_PRELOAD_PROGRESS:String = "img_preload_progress"; // Sent from ImgPreload to ImgDisplay
		public static const IMG_PRELOAD_COMPLETE:String = "img_preload_complete"; // Sent from ImgPreload to ImgDisplay
		
		public function ImgPreloadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
