package  classes.tabMenu // This class takes information from the Calculator class and returns an amortization chart
{
	import flash.display.Sprite; 
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import classes.Param;
	import classes.Theme;
	import classes.util.NumFormat;
	import classes.events.TabMenuEvent;
	
	public class Amortization extends AmortizationConstruct
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _scrollbar:AmortizeScrollbar; // Reference to the AmortizeScrollbar class
		private var _loanAmount:Number; // Reference to the incoming loan amount
		private var _numOfMonths:Number; // Reference to the incoming number of months of the loan
		private var _loanPayment:Number; // Reference to the incoming loan payment amount
		private var _inputIntRate:Number; // Reference to the incoming loan interest rate
		private var _amortizeData:Sprite; // Sprite that holds all of the numbers after the calculations
		private var _amortizeChart:Sprite; // Sprite to hold amortizeData and apply a drop shadow to it
		private var _tfAmortize:TextFormat; // Format for the numbers in the amortization chart
		private var _evenBar:Sprite; // Sprite that data in the even rows sit on
		private var _oddBar:Sprite; // Sprite that data in the odd rows sit on
		
		// Settable vars
		private var _amorTrackWidth:Number; // Width of the track in the amortization chart
		private var _amorTrackHeight:Number; // Height of the track in the amortization chart
		private var _amorDownwardOffset:Number; // Distance in pixels from the top of the chart to the top of the scrollbar 
		private var _amorMoveAmt:Number; // Distance to move in pixels when the scrollbar btns are clicked
		private var _amorMaskX:Number; // X position of the amortization mask
		private var _amorMaskY:Number; // Y position of the amortization mask
		private var _chartTextColor:uint; // Color of the text in the amortization chart
		private var _oddColor:uint; // Color for the odd rows in the amortization chart
		private var _evenColor:uint; // Color for the even rows in the amortization chart

		public function Amortization(xmlData:Param, theme:Theme, loanAmount:Number,numOfMonths:Number,loanPayment:Number,inputInterestRate:Number)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			_loanAmount = loanAmount;
			_numOfMonths = numOfMonths;
			_loanPayment = loanPayment;
			_inputIntRate = inputInterestRate;
			
			super(_xmlData, _theme);
			
			// Settable vars
			_amorTrackWidth = _xmlData.amorTrackWidth;
			_amorTrackHeight = _xmlData.amorTrackHeight;
			_amorDownwardOffset = _xmlData.amorDownwardOffset;
			_amorMoveAmt = _xmlData.amorMoveAmt;
			_amorMaskX = _xmlData.amorMaskX;
			_amorMaskY = _xmlData.amorMaskY;
			_chartTextColor = _theme.chartTextColor;
			_oddColor = _theme.oddColor;
			_evenColor = _theme.evenColor;
			
			// Create and set objects
			_amortizeData = new Sprite;
			_amortizeChart = new Sprite;
			_amortizeChart.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			
			_closeBtn.addEventListener(MouseEvent.CLICK, returnToCalc);
			
			init();
		}
		
		private function init():void
		{
			// These are the Textfields that hold the amortization data
			var pmtNumTxt:TextField;
			var loanPmtTxt:TextField;
			var intPdTxt:TextField;
			var prinPdTxt:TextField;
			var totIntPdTxt:TextField;
			var loanBalTxt:TextField;
			
			// These vars are used in the amortization calculations
			var intPd:Number; // Interest paid
			var prinPd:Number; // Principal paid
			var totIntPd:Number = 0; // Total interest paid
			var prin:Number = _loanAmount; // Loan remaining
			
			// Text format of the amortization text
			_tfAmortize = new TextFormat;
			_tfAmortize.font = "Verdana, Arial, Times";
			_tfAmortize.size = 13;
			_tfAmortize.color = _chartTextColor;
			_tfAmortize.align = "center";			
			
			for(var i:int = 1; i < (_numOfMonths + 1); i++)
			{
				// Create the backgrounds for the data to be displayed on
				if(i % 2 == 0)
				{
					drawEvenBar(i);
					_amortizeData.addChild(_evenBar);
				}
				
				else
				{
					drawOddBar(i);
					_amortizeData.addChild(_oddBar);
				}
				
				// Amortization calculations
				intPd = prin * (_inputIntRate / 12);
				prinPd = _loanPayment - intPd;
				totIntPd = intPd + totIntPd;
				prin = prin - prinPd;
		
				// Create and set the data text fields
				pmtNumTxt = new TextField;
				pmtNumTxt.text = "Month: " + i;
				pmtNumTxt.antiAliasType = AntiAliasType.ADVANCED;
				pmtNumTxt.setTextFormat(_tfAmortize);
				pmtNumTxt.width = _pmtNumCol.width;
				pmtNumTxt.height = _colHeight;
				pmtNumTxt.x = _pmtNumCol.x;
				pmtNumTxt.y = (_colHeight * i) + 5; // The 5 centers the text in the row, would change if colHeight changes
				_amortizeData.addChild(pmtNumTxt);
				
				loanPmtTxt = new TextField;
				loanPmtTxt.text = NumFormat.format(_loanPayment, 2);
				loanPmtTxt.antiAliasType = AntiAliasType.ADVANCED;
				loanPmtTxt.setTextFormat(_tfAmortize);
				loanPmtTxt.width = _loanPmtCol.width;
				loanPmtTxt.height = _colHeight;
				loanPmtTxt.x = _loanPmtCol.x;
				loanPmtTxt.y = (_colHeight * i) + 5;
				_amortizeData.addChild(loanPmtTxt);
				
				intPdTxt = new TextField;
				intPdTxt.text = NumFormat.format(intPd, 2);
				intPdTxt.antiAliasType = AntiAliasType.ADVANCED;
				intPdTxt.setTextFormat(_tfAmortize);
				intPdTxt.width = _intPdCol.width;
				intPdTxt.height = _colHeight;
				intPdTxt.x = _intPdCol.x;
				intPdTxt.y = (_colHeight * i) + 5;
				_amortizeData.addChild(intPdTxt);
				
				prinPdTxt = new TextField;
				prinPdTxt.text = NumFormat.format(prinPd, 2);
				prinPdTxt.antiAliasType = AntiAliasType.ADVANCED;
				prinPdTxt.setTextFormat(_tfAmortize);
				prinPdTxt.width = _prinPdCol.width;
				prinPdTxt.height = _colHeight;
				prinPdTxt.x = _prinPdCol.x;
				prinPdTxt.y = (_colHeight * i) + 5;
				_amortizeData.addChild(prinPdTxt);
				
				totIntPdTxt = new TextField;
				totIntPdTxt.text = NumFormat.format(totIntPd, 2);
				totIntPdTxt.antiAliasType = AntiAliasType.ADVANCED;
				totIntPdTxt.setTextFormat(_tfAmortize);
				totIntPdTxt.width = _totIntPdCol.width;
				totIntPdTxt.height = _colHeight;
				totIntPdTxt.x = _totIntPdCol.x;
				totIntPdTxt.y = (_colHeight * i) + 5;
				_amortizeData.addChild(totIntPdTxt);
				
				loanBalTxt = new TextField;
				loanBalTxt.text = NumFormat.format(prin, 2);
				loanBalTxt.antiAliasType = AntiAliasType.ADVANCED;
				loanBalTxt.setTextFormat(_tfAmortize);
				loanBalTxt.width = _loanBalCol.width;
				loanBalTxt.height = _colHeight;
				loanBalTxt.x = _loanBalCol.x;
				loanBalTxt.y = (_colHeight * i) + 5;
				_amortizeData.addChild(loanBalTxt);
			}
			
			_scrollbar = new AmortizeScrollbar(_theme, _amortizeData, _amorTrackWidth, _amorTrackHeight, _amorDownwardOffset, _amorMoveAmt, _amorMaskX, _amorMaskY);
		}
		
		// Draws and returns the data background bar if var i is an even number
		private function drawEvenBar(i:int):Sprite
		{
			_evenBar = new Sprite;
			_evenBar.graphics.beginFill(_evenColor);
			_evenBar.graphics.drawRect(0, (_colHeight * i), (_pmtNumCol.width + _loanPmtCol.width + _intPdCol.width + _prinPdCol.width + _totIntPdCol.width + _loanBalCol.width), _colHeight);
			_evenBar.graphics.endFill();
			
			return(_evenBar);
		}
		
		// Draws and returns the data background bar if var i is an odd number
		private function drawOddBar(i:int):Sprite
		{
			_oddBar = new Sprite;
			_oddBar.graphics.beginFill(_oddColor);
			_oddBar.graphics.drawRect(0, (_colHeight * i), (_pmtNumCol.width + _loanPmtCol.width + _intPdCol.width + _prinPdCol.width + _totIntPdCol.width + _loanBalCol.width), _colHeight);
			_oddBar.graphics.endFill();
			
			return(_oddBar);
		}
		
		// Displays amortizeData when called from the Calculator
		public function displayChart():void 
		{
			_amortizeChart.addChild(_amortizeData);
			addChild(_amortizeChart);
			addChild(_scrollbar);
		}
		
		private function returnToCalc(e:MouseEvent):void 
		{
			dispatchEvent(new TabMenuEvent(TabMenuEvent.DESTROY_AMORTIZATION)); // Dispatches to Calculator
		}
	}
}