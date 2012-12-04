package classes // Assigns each display object its correct library item based on theme when the get method is called
{
	import flash.display.Sprite;
	
	public class Theme
	{
		private var _xmlData:Param; // Object to store loaded XML info
		
		// Settable vars
		private var _theme:String; // String to hold the color theme of the whole tour
		
		// Constants
		public static const BLACK_THEME:String = "black";
		public static const BLUE_THEME:String = "blue";
		public static const GREEN_THEME:String = "green";
		public static const RED_THEME:String = "red";
		
// Display object vars, vars are divided by their package and by what class they are mainly used in or for
		
// **** Vars for the classes package ****
		// **** Main class ****
		private var _bgColor:uint; // Color of the tour background
		private var _navBarColor:uint; // Color of the nav bar
		
		// **** HelpButton class ****
		private var _helpPanelBgColor:uint; // Color of the help panel background
		private var _helpBtnUp:Sprite; // Library reference to the up state of the help button
		private var _helpBtnOver:Sprite; // Library reference to the over state of the help button
		private var _closeBtnUp:Sprite; // Library reference to the up state of the close button
		private var _closeBtnOver:Sprite; // Library reference to the over state of the close button
		
		// **** InteractiveNav ****
		private var _navBtnUp:Sprite; // Library reference to the up state of the navigation button
		private var _navBtnOver:Sprite; // Library reference to the over state of the navigation button
		
		// **** InteractivePic ****
		private var _detailPicBtnUp:Sprite; // Library reference to the up state of the pic detail button
		private var _detailPicBtnOver:Sprite; // Library reference to the over state of the pic detail button
		
		// **** InteractiveText ****
		private var _infoBtnUp:Sprite; // Library reference to the up state of the information button
		private var _infoBtnOver:Sprite; // Library reference to the over state of the information button
		
		// **** Preloader class ****
		private var _ballPath:Sprite; // Library reference to the tubePath
		private var _ball:Sprite; // Library reference to the ball that rotates around the tubePath
		
		// **** ScrollbarConstruct class ****
		private var _dragHandleUp:Sprite; // Library reference to the scrollbar's drag handle up state
		private var _dragHandleOver:Sprite; // Library reference to the scrollbar's drag handle over state
		private var _upScrollBtnUp:Sprite; // Library reference to the scrollbar's up arrow button over state
		private var _upScrollBtnOver:Sprite; // Library reference to the scrollbar's up arrow button over state
		private var _downScrollBtnUp:Sprite; // Library reference to the scrollbar's down arrow button up state
		private var _downScrollBtnOver:Sprite; // Library reference to the scrollbar's down arrow button over state
		private var _track:Sprite; // Library reference to the scrollbar track
		private var _trackColor:uint; // Color of the scrollbar track
		
		// **** TextBoxes class ****
		private var _rmLabelBgColor:uint; // Color of the room label's background
		private var _logo:Sprite; // Library reference to the logo
		private var _propInfoBg:Sprite; // Library reference to the property info background
		private var _agentInfoBg:Sprite; // Library reference to the agent info background
		
// **** Vars for the tabMenu package ****
		// **** TabButton class ****
		private var _tabBtnUpColor:uint; // Color of the tabs in up mode in the TabMenu
		private var _tabBtnOverColor:uint // Color of the tabs in over mode in the TabMenu
		
		// **** PropertyInfoConstruct class ****
		private var _propInfoBgLines:Sprite; // Library reference to the property info page lines
		
		// **** AgentInfoConstruct class ****
		private var _agentInfoBgLines:Sprite; // Library reference to the agent info page lines
		
		// **** CalculatorConstruct class ****
		private var _calcBgLines:Sprite; // Library reference to the calculator page lines
		
		// **** CalcBtn class ****
		private var _calcBtnColor:uint; // Color of the calc buttons
		
		// **** Amortization class ****
		private var _chartTextColor:uint; // Color of the text in the amortization chart
		private var _oddColor:uint; // Color of the odd rows in the amortization chart
		private var _evenColor:uint; // Color of the even rows in the amortization chart
				
// **** Vars for the slideMenu package ****
		// **** ButtonManager class ****
		private var _nextButtonUp:Sprite; // Library reference to up state of the next button
		private var _nextButtonOver:Sprite; // Library reference to over state of the next button
		private var _prevButtonUp:Sprite; // Library reference to up state of the previous button
		private var _prevButtonOver:Sprite; // Library reference to over state of the previous button	
		
		// **** Thumb class ****
		private var _imageBackgoundColor:uint; // The image background color
		private var _borderColor:uint; // The border color of the images

// Class constructor
		public function Theme(xmlData:Param)
		{
			// Set argument vars
			_xmlData = xmlData;
			
			// Settable vars
			_theme = _xmlData.theme;
		}
		
// **** Get functions used to create instances of objects ****

// **** Functions for the classes package ****

// **** Main class ****

		public function get bgColor():uint // Needs alpha in hex
		{
			switch(_theme)
			{
				case BLACK_THEME: _bgColor = 0xFF202020; break; // Base RGB values, add set amounts for different hues
				case BLUE_THEME: _bgColor = 0xFF2D3B76; break;
				case GREEN_THEME: _bgColor = 0xFF1F400C; break;
				case RED_THEME: _bgColor = 0xFF4A090E; break;
				default: _bgColor = 0xFF202020; 
			}
			return _bgColor;
		}
		
		public function get navBarColor():uint // Needs alpha in hex
		{
			switch(_theme)
			{
				case BLACK_THEME: _navBarColor = 0xFF2F2F2F; break; // Base RGB + 15 on all values
				case BLUE_THEME: _navBarColor = 0xFF3C4A85; break;
				case GREEN_THEME: _navBarColor = 0xFF2E4F1B; break;
				case RED_THEME: _navBarColor = 0xFF591827; break;
				default: _navBarColor = 0xFF2F2F2F; 
			}
			return _navBarColor;
		}

// **** HelpButton class ****

		public function get helpPanelBgColor():uint // Needs alpha in hex
		{
			switch(_theme)
			{
				case BLACK_THEME: _helpPanelBgColor = 0xFF3E3E3E; break; // Base RGB + 30 on all values
				case BLUE_THEME: _helpPanelBgColor = 0xFF4B5994; break;
				case GREEN_THEME: _helpPanelBgColor = 0xFF3D5E2A; break;
				case RED_THEME: _helpPanelBgColor = 0xFF682736; break;
				default: _helpPanelBgColor = 0xFF3E3E3E; 
			}
			return _helpPanelBgColor;
		}
	
		public function get helpBtnUp():Sprite
		{
			switch(_theme)
			{
				case BLACK_THEME: _helpBtnUp = new BlackHelpBtn; break;
				case BLUE_THEME: _helpBtnUp = new BlueHelpBtn; break;
				case GREEN_THEME: _helpBtnUp = new GreenHelpBtn; break;
				case RED_THEME: _helpBtnUp = new RedHelpBtn; break;
				default: _helpBtnUp = new BlackHelpBtn;
			}
			return _helpBtnUp;
		}
		
		public function get helpBtnOver():Sprite
		{
			switch(_theme)
			{
				case BLACK_THEME: _helpBtnOver = new BlackHelpBtnOver; break;
				case BLUE_THEME: _helpBtnOver = new BlueHelpBtnOver; break;
				case GREEN_THEME: _helpBtnOver = new GreenHelpBtnOver; break;
				case RED_THEME: _helpBtnOver = new RedHelpBtnOver; break;
				default: _helpBtnOver = new BlackHelpBtnOver;
			}
			return _helpBtnOver;
		}
		
		public function get closeBtnUp():Sprite
		{
			switch(_theme)
			{
				case BLACK_THEME: _closeBtnUp = new BlackCloseBtn; break;
				case BLUE_THEME: _closeBtnUp = new BlueCloseBtn; break;
				case GREEN_THEME: _closeBtnUp = new GreenCloseBtn; break;
				case RED_THEME: _closeBtnUp = new RedCloseBtn; break;
				default: _closeBtnUp = new BlackCloseBtn;
			}
			return _closeBtnUp;
		}
		
		public function get closeBtnOver():Sprite
		{
			switch(_theme)
			{
				case BLACK_THEME: _closeBtnOver = new BlackCloseBtnOver; break;
				case BLUE_THEME: _closeBtnOver = new BlueCloseBtnOver; break;
				case GREEN_THEME: _closeBtnOver = new GreenCloseBtnOver; break;
				case RED_THEME: _closeBtnOver = new RedCloseBtnOver; break;
				default: _closeBtnOver = new BlackCloseBtnOver;
			}
			return _closeBtnOver;
		}
		
// **** InteractiveNav ****
		public function get navBtnUp():Sprite
		{
			_navBtnUp = new NavUp;
			
			return _navBtnUp;
		}
		
		public function get navBtnOver():Sprite
		{
			_navBtnOver = new NavOver;
			
			return _navBtnOver;
		}
		
// **** InteractivePic ****
		public function get detailPicBtnUp():Sprite
		{
			_detailPicBtnUp = new DetailPicUp;
			
			return _detailPicBtnUp;
		}
		
		public function get detailPicBtnOver():Sprite
		{
			_detailPicBtnOver = new DetailPicOver;
			
			return _detailPicBtnOver;
		}
		
// **** InteractiveText ****
		public function get infoBtnUp():Sprite
		{
			_infoBtnUp = new InfoUp;
			
			return _infoBtnUp;
		}
		
		public function get infoBtnOver():Sprite
		{
			_infoBtnOver = new InfoOver;
			
			return _infoBtnOver;
		}
		
// **** Preloader class ****
		
		public function get ballPath():Sprite
		{
			_ballPath = new BallPath;
			
			return _ballPath;
		}
		
		public function get ball():Sprite
		{
			_ball = new Ball;
			
			return _ball;
		}
		
// **** ScrollbarConstruct class ****
		
		public function get dragHandleUp():Sprite // Also used in the Scrollbar for the slide menu
		{
			_dragHandleUp = new ScrollbarDragHandle;
			
			return _dragHandleUp;
		}
		
		public function get dragHandleOver():Sprite // Also used in the Scrollbar for the slide menu
		{
			_dragHandleOver = new ScrollbarDragHandleOver;
			
			return _dragHandleOver;
		}
		
		public function get upScrollBtnUp():Sprite
		{
			_upScrollBtnUp = new ScrollbarUpArrow;
			
			return _upScrollBtnUp;
		}
		
		public function get upScrollBtnOver():Sprite
		{
			_upScrollBtnOver = new ScrollbarUpArrowOver;
			
			return _upScrollBtnOver;
		}
		
		public function get downScrollBtnUp():Sprite
		{
			_downScrollBtnUp = new ScrollbarDownArrow;
			
			return _downScrollBtnUp;
		}
		
		public function get downScrollBtnOver():Sprite
		{
			_downScrollBtnOver = new ScrollbarDownArrowOver;
			
			return _downScrollBtnOver;
		}
		
		public function get track():Sprite // Also used in the Scrollbar for the slide menu
		{
			_track = new ScrollbarTrack;
			
			return _track;
		}
		
		public function get trackColor():uint // Also used in the Scrollbar for the slide menu
		{
			_trackColor = 0x000000; 
			
			return _trackColor;
		}
		
// **** TextBoxes class ****
		public function get rmLabelBgColor():uint // Needs alpha in hex
		{
			switch(_theme)
			{
				case BLACK_THEME: _rmLabelBgColor = 0xFF2F2F2F; break; // Base RGB + 15 on all values
				case BLUE_THEME: _rmLabelBgColor = 0xFF3C4A85; break;
				case GREEN_THEME: _rmLabelBgColor = 0xFF2E4F1B; break;
				case RED_THEME: _rmLabelBgColor = 0xFF591827; break;
				default: _rmLabelBgColor = 0xFF2F2F2F;
			}
			return _rmLabelBgColor;
		}
		
		public function get logo():Sprite
		{
			_logo = new Logo;
			
			return _logo;
		}
		
		public function get propInfoBg():Sprite
		{
			_propInfoBg = new PropInfoBg;
			
			return _propInfoBg;
		}
		
		public function get agentInfoBg():Sprite
		{
			_agentInfoBg = new AgentInfoBg;
			
			return _agentInfoBg;
		}
		
// **** Functions for the tabMenu package ****

// **** TabButton class ****
		
		public function get tabBtnUpColor():uint
		{
			switch(_theme)
			{
				case BLACK_THEME: _tabBtnUpColor = 0x3E3E3E; break; // Base RGB + 30 on all values
				case BLUE_THEME: _tabBtnUpColor = 0x4B5994; break;
				case GREEN_THEME: _tabBtnUpColor = 0x3D5E2A; break;
				case RED_THEME: _tabBtnUpColor = 0x682736; break;
				default: _tabBtnUpColor = 0x3E3E3E;
			}
			return _tabBtnUpColor;
		}
		
		public function get tabBtnOverColor():uint
		{
			switch(_theme)
			{
				case BLACK_THEME: _tabBtnOverColor = 0x484848; break; // Base RGB + 40 on all values
				case BLUE_THEME: _tabBtnOverColor = 0x55639E; break;
				case GREEN_THEME: _tabBtnOverColor = 0x476834; break;
				case RED_THEME: _tabBtnOverColor = 0x723140; break;
				default: _tabBtnOverColor = 0x484848;
			}
			return _tabBtnOverColor;
		}
		
// **** PropertyInfoConstruct class ****
		public function get propInfoBgLines():Sprite
		{
			_propInfoBgLines = new PropInfoLines;
			
			return _propInfoBgLines;
		}
				
// **** AgentInfoConstruct class ****
		public function get agentInfoBgLines():Sprite
		{
			_agentInfoBgLines = new AgentInfoLines;
			
			return _agentInfoBgLines;
		}

// **** CalculatorConstruct class ****
		
		public function get calcBgLines():Sprite
		{
			_calcBgLines = new CalculatorLines;
			
			return _calcBgLines;
		}
		
// **** CalcBtn class ****
	
		public function get calcBtnColor():uint // Needs alpha in hex
		{
			switch(_theme)
			{
				case BLACK_THEME: _calcBtnColor = 0xFF111111; break; // Base RGB - 15 on all values
				case BLUE_THEME: _calcBtnColor = 0xFF1E2C67; break;
				case GREEN_THEME: _calcBtnColor = 0xFF103100; break;
				case RED_THEME: _calcBtnColor = 0xFF3B0000; break;
				default: _calcBtnColor = 0xFF111111;
			}
			return _calcBtnColor;
		}
		
// **** Amortization class ****
		public function get chartTextColor():uint
		{
			switch(_theme)
			{
				case BLACK_THEME: _chartTextColor = 0xFFFFFF; break;
				case BLUE_THEME: _chartTextColor = 0x000000; break;
				case GREEN_THEME: _chartTextColor = 0x000000; break;
				case RED_THEME: _chartTextColor = 0x000000; break;
				default: _chartTextColor = 0xFFFFFF;
			}
			return _chartTextColor;
		}
	
		public function get oddColor():uint
		{
			switch(_theme)
			{
				case BLACK_THEME: _oddColor = 0x585858; break;
				case BLUE_THEME: _oddColor = 0xE0E0E0; break;
				case GREEN_THEME: _oddColor = 0xE0E0E0; break;
				case RED_THEME: _oddColor = 0xE0E0E0; break;
				default: _oddColor = 0x585858;
			}
			return _oddColor;
		}
	
		public function get evenColor():uint // Needs alpha in hex
		{
			switch(_theme)
			{
				case BLACK_THEME: _evenColor = 0x686868; break;
				case BLUE_THEME: _evenColor = 0xFFFFFF; break;
				case GREEN_THEME: _evenColor = 0xFFFFFF; break;
				case RED_THEME: _evenColor = 0xFFFFFF; break;
				default: _evenColor = 0x686868;
			}
			return _evenColor;
		}
		
// **** Functions for the slideMenu package ****

// **** ButtonManager class ****
		
		public function get nextButtonUp():Sprite
		{
			_nextButtonUp = new NextBtn;
			
			return _nextButtonUp;
		}
		
		public function get nextButtonOver():Sprite
		{
			_nextButtonOver = new NextBtnOver;
			
			return _nextButtonOver;
		}
		
		public function get prevButtonUp():Sprite
		{
			_prevButtonUp = new PrevBtn;
			
			return _prevButtonUp;
		}
		
		public function get prevButtonOver():Sprite
		{
			_prevButtonOver = new PrevBtnOver;
			
			return _prevButtonOver;
		}
		
// **** Thumb class ****
		public function get imageBackgoundColor():uint
		{
			_imageBackgoundColor = 0x111111;
			
			return _imageBackgoundColor;
		}
		
		public function get borderColor():uint
		{
			_borderColor = 0xFFFFFF;
			
			return _borderColor;
		}
	}
}