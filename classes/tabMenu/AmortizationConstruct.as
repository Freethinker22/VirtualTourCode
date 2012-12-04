package classes.tabMenu // This class will build the Sprite for the Amortization class
{ 
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.filters.DropShadowFilter;
	import classes.Param;
	import classes.Theme;
	
	public class AmortizationConstruct extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _amortization:Sprite; // Sprite that holds the text labels at the top of the amortization chart
		private var _amortizeColTextFormat:TextFormat; // Formats the text to be displayed in the amortization chart
		private var _chartBorder:Sprite; // Border of the amortization chart
		
		// Settable vars
		private var _amorConBackBtnX:Number; // X position of the back button
		private var _amorConBackBtnY:Number; // Y position of the back button
		
		// API vars
		protected var _colHeight:Number; // Height of the column label bar in the amortization
		protected var _pmtNumCol:TextField; // TextField to hold the payment text
		protected var _loanPmtCol:TextField; // TextField to hold the loan payment text
		protected var _intPdCol:TextField; // TextField to hold the interest text
		protected var _prinPdCol:TextField; // TextField to hold the principal paid text
		protected var _totIntPdCol:TextField; // TextField to hold the total interest paid text
		protected var _loanBalCol:TextField; // TextField to hold the loan balance text
		protected var _closeBtn:SimpleButton; // Object that becomes the close button
		protected var _closeBtnUp:Sprite; // Library reference to the up state of the close button
		protected var _closeBtnOver:Sprite; // Library reference to the over state of the close button
		
		public function AmortizationConstruct(xmlData:Param, theme:Theme)
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_amorConBackBtnX = _xmlData.amorConBackBtnX;
			_amorConBackBtnY = _xmlData.amorConBackBtnY;
			_colHeight = _xmlData.colHeight;
			
			// Create and set objects
			_amortization = new Sprite;
			_closeBtnUp = _theme.closeBtnUp;
			_closeBtnOver = _theme.closeBtnOver;
						
			init();
			drawBorder();
		}
		
		private function init():void
		{
			// Text format of the amortization column text
			_amortizeColTextFormat = new TextFormat;
			_amortizeColTextFormat.font = "Verdana, Arial, Times";
			_amortizeColTextFormat.size = 15;
			_amortizeColTextFormat.color = 0xFFFFFF;
			_amortizeColTextFormat.align = "center";
			
			// Creates the close button for the amortization chart
			_closeBtn = new SimpleButton;
			_closeBtn.filters = [new DropShadowFilter(3, 45, 0x000000)]; // Adds drop shadow to object
			_closeBtn.upState = _closeBtnUp;
			_closeBtn.overState = _closeBtnOver;
			_closeBtn.downState = _closeBtnOver;
			_closeBtn.hitTestState = _closeBtnUp;
			
			// These create the column label text fields in the amortization chart
			_pmtNumCol = new TextField;
			_pmtNumCol.text = "Payment #";
			_pmtNumCol.antiAliasType = AntiAliasType.ADVANCED;
			_pmtNumCol.setTextFormat(_amortizeColTextFormat);
			_pmtNumCol.width = 98;
			_pmtNumCol.height = _colHeight;
			_pmtNumCol.x = 0;
			_amortization.addChild(_pmtNumCol);
			
			_loanPmtCol = new TextField;
			_loanPmtCol.text = "Payment";
			_loanPmtCol.antiAliasType = AntiAliasType.ADVANCED;
			_loanPmtCol.setTextFormat(_amortizeColTextFormat);
			_loanPmtCol.width = 98;
			_loanPmtCol.height = _colHeight;
			_loanPmtCol.x = _pmtNumCol.x + _pmtNumCol.width;
			_amortization.addChild(_loanPmtCol);
			
			_intPdCol = new TextField;
			_intPdCol.text = "To Interest";
			_intPdCol.antiAliasType = AntiAliasType.ADVANCED;
			_intPdCol.setTextFormat(_amortizeColTextFormat);
			_intPdCol.width = 98;
			_intPdCol.height = _colHeight;
			_intPdCol.x = _loanPmtCol.x + _loanPmtCol.width;
			_amortization.addChild(_intPdCol);
			
			_prinPdCol = new TextField;
			_prinPdCol.text = "To Principal";
			_prinPdCol.antiAliasType = AntiAliasType.ADVANCED;
			_prinPdCol.setTextFormat(_amortizeColTextFormat);
			_prinPdCol.width = 118;
			_prinPdCol.height = _colHeight;
			_prinPdCol.x = _intPdCol.x + _intPdCol.width;
			_amortization.addChild(_prinPdCol);
			
			_totIntPdCol = new TextField;
			_totIntPdCol.text = "Total Interest";
			_totIntPdCol.antiAliasType = AntiAliasType.ADVANCED;
			_totIntPdCol.setTextFormat(_amortizeColTextFormat);
			_totIntPdCol.width = 118;
			_totIntPdCol.height = _colHeight;
			_totIntPdCol.x = _prinPdCol.x + _prinPdCol.width;
			_amortization.addChild(_totIntPdCol);
			
			_loanBalCol = new TextField;
			_loanBalCol.text = "Loan Balance";
			_loanBalCol.antiAliasType = AntiAliasType.ADVANCED;
			_loanBalCol.setTextFormat(_amortizeColTextFormat);
			_loanBalCol.width = 118;
			_loanBalCol.height = _colHeight;
			_loanBalCol.x = _totIntPdCol.x + _totIntPdCol.width;
			_amortization.addChild(_loanBalCol);
			
			_closeBtn.x = _amorConBackBtnX;
			_closeBtn.y = _amorConBackBtnY;
						
			addChild(_closeBtn);
			addChild(_amortization);
		}
		
		// Draws a border around the amortization chart
		private function drawBorder():void
		{
			_chartBorder = new Sprite;
			_chartBorder.graphics.lineStyle(1, 0x000000);
			_chartBorder.graphics.moveTo(-9, 490);
			_chartBorder.graphics.lineTo(-9, -5);
			_chartBorder.graphics.lineTo(687, -5);
			_amortization.addChild(_chartBorder);
		}
	}
}