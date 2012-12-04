package classes.events // This class lets the Main class know the xml is done loading or if an error occurred
{
	import flash.events.Event;
	
	public class ParamEvent extends Event
	{
		public static const XML_LOAD_COMPLETE:String = "xml_load_complete"; // Sent from Param to Main once xml is done loading
		public static const ERROR:String = "error"; // Dispatched when an error occurs
		
		private var _errorText:String; // Dispatched when some loading error occurs
		
		public function ParamEvent(type:String, errorText:String ="", bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_errorText = errorText;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get errorText():String
		{
			return _errorText;
		}
	}
}