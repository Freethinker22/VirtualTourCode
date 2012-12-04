package classes.events // This class handles events for the TabMenu
{
	import flash.events.Event;
	
	public class TabMenuEvent extends Event
	{
		public static const MENU_CLICK:String = "menu_click"; // Sent from TabMenu to Main to pause slide show
		public static const REMOVE_COVER:String = "remove_cover"; // Sent from a menu page to Main to remove the grey cover and restart the slideshow
		public static const DESTROY_PAGE:String = "destroy_page"; // Sent from a menu page to TabMenu to remove the page after it transed out
		public static const DESTROY_AMORTIZATION:String = "destroy_amortization"; // Sent from Amortization to Calculator
		
		private var _pageName:String; // Name of the page to remove in the TabMenu
		
		public function TabMenuEvent(type:String, pageName:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			_pageName = pageName;
			super(type, bubbles, cancelable);
		}
		
		// Get method
		public function get pageToRemove():String
		{
			return _pageName;
		}
	}
}