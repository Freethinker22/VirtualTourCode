package classes.tabMenu // This is the API class for the AgentInfo object
{
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import classes.Param;
	import classes.Theme;
	import classes.events.TabMenuEvent;
	
	public class AgentInfo extends AgentInfoConstruct
	{
		// Constants
		public const PAGE_NAME:String = "Agent_Information" // Used as a reference in the TabMenu for selection or removal
		
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		
		// Settable vars
		private var _agentInfoBgLinesX:Number; // X position of the agent info page lines
		private var _agentInfoBgLinesY:Number; // Y position of the agent info page lines
		
		public function AgentInfo(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			super(_xmlData, _theme);
			
			// Settable vars
			_agentInfoBgLinesX = _xmlData.agentInfoBgLinesX;
			_agentInfoBgLinesY = _xmlData.agentInfoBgLinesY;
		}
		
		// Called from TabMenu to run code that needs to happen when AgentInfo is added to the stage
		public function addToStage():void
		{
			_agentInfoBgLines.alpha = 0;
			_agentInfoBgLines.x = _agentInfoBgLinesX;
			_agentInfoBgLines.y = _agentInfoBgLinesY;
			addChild(_agentInfoBgLines);
			TweenMax.to(_agentInfoBgLines, .50, {alpha:1});
			
			_tweenContainer.alpha = 0;
			addChild(_tweenContainer);
			TweenMax.to(_tweenContainer, .75, {delay:.25, alpha:1});
		}
		
		// Called when the close button is clicked, tweens the page out and then dispatches destroy page event to the TabMenu
		public function returnToTour():void 
		{
			TweenMax.to(_agentInfoBgLines, .25, {alpha:0});
			TweenMax.to(_tweenContainer, .25, {alpha:0});
			TweenMax.to(_tweenContainer, .25, {alpha:0, onComplete:removePage});
						
			super.destroyPage();
		}
		
		private function removePage():void
		{
			dispatchEvent(new TabMenuEvent(TabMenuEvent.DESTROY_PAGE, this.PAGE_NAME, true)); // Dispatches to TabMenu to remove page
		}
	}
}