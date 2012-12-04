package  classes.tabMenu // This class will build the Sprite for the Calculator class
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import classes.Param;
	import classes.Theme;
	import classes.HelpButton;
	
	public class CalculatorConstruct extends Sprite
	{
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _calcLabelFormat:TextFormat; // Textformat of the calculator label
		private var _calcTextFormatWhite:TextFormat; // Textformat of the white text
		private var _calcTextFormatBlack:TextFormat; // Textformat of the black text
		
		// Input and output and calculator label vars
		private var _calcLabel:TextField; // Main label for the calculator
		private var _priceLabel:TextField; // Label for the price input
		private var _downPaymentLabel:TextField; // Label for the down payment input 
		private var _interestRateLabel:TextField; // Label for the interest rate input
		private var _loanTermLabel:TextField; // Label for the loan term input
		private var _taxesLabel:TextField; // Label for the taxes input
		private var _insuranceLabel:TextField; // Label for the insurance input
		private var _pmiLabel:TextField; // Label for the PMI input
		private var _loanAmountLabel:TextField; // Label for the loan amount output
		private var _loanPaymentLabel:TextField; // Label for the loan payment output
		private var _mortgagePaymentLabel:TextField; // Label for the mortgage output
		private var _percentLabel:TextField; // Label for the percent symbol after the interest rate box
		private var _yearsLabel:TextField; // Label for the word years after the loan term box
		
		// Help button vars
		private var _pmiHelpButton:HelpButton; // Object that holds the pmi help button
		private var _loanAmtHelpButton:HelpButton; // Object that holds the loan amount help button
		private var _loanHelpButton:HelpButton; // Object that holds the loan help button
		private var _mortgageHelpButton:HelpButton; // Object that holds the mortgage help button
		
		// Settable vars
		private var _pmiHelpText:String; // String that holds the pmi help text
		private var _loanAmtHelpText:String; // String that holds the loan amount help text
		private var _loanHelpText:String; // String that holds the loan help text
		private var _mortgageHelpText:String; // String that holds the mortgage help text
		private var _calcLabelX:Number; // X position of the calculator page label
		private var _calcLabelY:Number; // Y position of the calculator page label
		private var _inputWidth:Number; // Width of the input boxes
		private var _inputHeight:Number; // Height of the input boxes
		private var _smInputWidth:Number; // Width of the small input boxes
		private var _smInputHeight:Number; // Height of the small input boxes
		private var _leftColX:Number; // X position of the left column of boxes
		private var _leftColY:Number; // Y position of the left column of boxes
		private var _rightColX:Number; // X position of the right column of boxes
		private var _percentYearsX:Number; // X position of the percent label
		private var _calcTextSpacing:Number; // Vertical space in between each box
		private var _calculateX:Number; // X position of the calculate button
		private var _calculateY:Number; // Y position of the calculate button
		private var _amortizeX:Number; // X position of the amortize button
		private var _amortizeY:Number; // Y position of the amortize button
		private var _clearCalcX:Number; // X position of the clear calculator button
		private var _clearCalcY:Number; // Y position of the clear calculator button
		
		// Input and output API vars
		protected var _priceText:TextField; // The input price TextField
		protected var _downPaymentText:TextField; // The input down payment TextField
		protected var _interestRateText:TextField; // The input interest rate TextField
		protected var _loanTermText:TextField; // The input loan term TextField
		protected var _taxesText:TextField; // The input taxes TextField
		protected var _insuranceText:TextField; // The input insurance TextField
		protected var _pmiText:TextField; // The input PMI TextField
		protected var _loanAmountText:TextField; // TextField that displays the loan amount output
		protected var _loanPaymentText:TextField; // TextField that displays the loan payment output
		protected var _mortgagePaymentText:TextField; // TextField that displays the mortgage payment output
		
		// API object vars
		//protected var _calcBg:Sprite; // Library reference to the TabMenu page background
		protected var _calcBgLines:Sprite; // Library reference to the calculator page lines
		protected var _tweenContainer:Sprite; // Sprite to hold the objects that get tweened in when added to stage
		protected var _calculate:CalcBtn; // Object that holds the calculate button
		protected var _amortize:CalcBtn; // Object that holds the amortize button
		protected var _clearCalc:CalcBtn; // Object that holds the clear claculator button

		public function CalculatorConstruct(xmlData:Param, theme:Theme) 
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			
			// Settable vars
			_pmiHelpText = _xmlData.pmiHelpButtonText;
			_loanAmtHelpText = _xmlData.loanAmtHelpButtonText;
			_loanHelpText = _xmlData.loanHelpButtonText;
			_mortgageHelpText = _xmlData.mortgageHelpButtonText;
			_calcLabelX = _xmlData.calcLabelX;
			_calcLabelY = _xmlData.calcLabelY;
			_inputWidth = _xmlData.inputWidth;
			_inputHeight = _xmlData.inputHeight;
			_smInputWidth = _xmlData.smInputWidth;
			_smInputHeight = _xmlData.smInputHeight;
			_leftColX = _xmlData.leftColX;
			_leftColY = _xmlData.leftColY;
			_rightColX = _xmlData.rightColX;
			_percentYearsX = _xmlData.percentYearsX;
			_calcTextSpacing = _xmlData.calcTextSpacing;
			_calculateX = _xmlData.calculateX;
			_calculateY = _xmlData.calculateY;
			_amortizeX = _xmlData.amortizeX;
			_amortizeY = _xmlData.amortizeY;
			_clearCalcX = _xmlData.clearCalcX;
			_clearCalcY = _xmlData.clearCalcY;
			
			// Create and set objects
			_calcBgLines = _theme.calcBgLines;			
			_tweenContainer = new Sprite;
			_calculate = new CalcBtn(_theme, "Calculate");
			_amortize = new CalcBtn(_theme, "Amortize");
			_clearCalc = new CalcBtn(_theme, "Clear");
						
			buildCalc();
			posBtns();
		}
		
		private function buildCalc():void
		{
			_calcLabelFormat = new TextFormat;
			_calcLabelFormat.font = "Verdana, Arial, Times";
			_calcLabelFormat.size = 24;
			_calcLabelFormat.color = 0xffffff;
			_calcLabelFormat.align = "center";
			
			_calcTextFormatWhite = new TextFormat;
			_calcTextFormatWhite.font = "Verdana, Arial, Times";
			_calcTextFormatWhite.size = 17;
			_calcTextFormatWhite.color = 0xffffff;
			_calcTextFormatWhite.align = "left";
			
			_calcTextFormatBlack = new TextFormat;
			_calcTextFormatBlack.font = "Verdana, Arial, Times";
			_calcTextFormatBlack.size = 17;
			_calcTextFormatBlack.color = 0x000000;
			_calcTextFormatBlack.align = "left";
			
			// **** These create the input TextFields on the Calculator ****
			_priceText = new TextField;
			_priceText.type = TextFieldType.INPUT;
			_priceText.antiAliasType = AntiAliasType.ADVANCED;
			_priceText.defaultTextFormat = _calcTextFormatBlack;
			_priceText.maxChars = 13;
			_priceText.width = _inputWidth;
			_priceText.height = _inputHeight;
			_priceText.x = _rightColX;
			_priceText.y = _leftColY;
			_priceText.border = true;
			_priceText.background = true; 
			_priceText.backgroundColor = 0xffffff;
			_tweenContainer.addChild(_priceText);
			
			_downPaymentText = new TextField;
			_downPaymentText.type = TextFieldType.INPUT;
			_downPaymentText.antiAliasType = AntiAliasType.ADVANCED;
			_downPaymentText.defaultTextFormat = _calcTextFormatBlack;
			_downPaymentText.maxChars = 13;
			_downPaymentText.width = _inputWidth;
			_downPaymentText.height = _inputHeight;
			_downPaymentText.x = _rightColX;
			_downPaymentText.y = _leftColY + _calcTextSpacing;
			_downPaymentText.border = true;
			_downPaymentText.background = true; 
			_downPaymentText.backgroundColor = 0xffffff;
			_tweenContainer.addChild(_downPaymentText);
			
			_interestRateText = new TextField;
			_interestRateText.type = TextFieldType.INPUT;
			_interestRateText.antiAliasType = AntiAliasType.ADVANCED;
			_interestRateText.defaultTextFormat = _calcTextFormatBlack;
			_interestRateText.maxChars = 5;
			_interestRateText.width = _smInputWidth;
			_interestRateText.height = _smInputHeight;
			_interestRateText.x = _rightColX;
			_interestRateText.y = _leftColY + (_calcTextSpacing * 2);
			_interestRateText.border = true;
			_interestRateText.background = true; 
			_interestRateText.backgroundColor = 0xffffff;
			_tweenContainer.addChild(_interestRateText);
			
			_loanTermText = new TextField;
			_loanTermText.type = TextFieldType.INPUT;
			_loanTermText.antiAliasType = AntiAliasType.ADVANCED;
			_loanTermText.defaultTextFormat = _calcTextFormatBlack;
			_loanTermText.maxChars = 5;
			_loanTermText.width = _smInputWidth;
			_loanTermText.height = _smInputHeight;
			_loanTermText.x = _rightColX;
			_loanTermText.y = _leftColY + (_calcTextSpacing * 3);
			_loanTermText.border = true;
			_loanTermText.background = true; 
			_loanTermText.backgroundColor = 0xffffff;
			_tweenContainer.addChild(_loanTermText);
			
			_taxesText = new TextField;
			_taxesText.type = TextFieldType.INPUT;
			_taxesText.antiAliasType = AntiAliasType.ADVANCED;
			_taxesText.defaultTextFormat = _calcTextFormatBlack;
			_taxesText.maxChars = 13;
			_taxesText.width = _inputWidth;
			_taxesText.height = _inputHeight;
			_taxesText.x = _rightColX;
			_taxesText.y = _leftColY + (_calcTextSpacing * 4);
			_taxesText.border = true;
			_taxesText.background = true; 
			_taxesText.backgroundColor = 0xffffff;
			_tweenContainer.addChild(_taxesText);
			
			_insuranceText = new TextField;
			_insuranceText.type = TextFieldType.INPUT;
			_insuranceText.antiAliasType = AntiAliasType.ADVANCED;
			_insuranceText.defaultTextFormat = _calcTextFormatBlack;
			_insuranceText.maxChars = 13;
			_insuranceText.width = _inputWidth;
			_insuranceText.height = _inputHeight;
			_insuranceText.x = _rightColX;
			_insuranceText.y = _leftColY + (_calcTextSpacing * 5);
			_insuranceText.border = true;
			_insuranceText.background = true; 
			_insuranceText.backgroundColor = 0xffffff;
			_tweenContainer.addChild(_insuranceText);
			
			_pmiText = new TextField;
			_pmiText.type = TextFieldType.INPUT;
			_pmiText.antiAliasType = AntiAliasType.ADVANCED;
			_pmiText.defaultTextFormat = _calcTextFormatBlack;
			_pmiText.maxChars = 13;
			_pmiText.width = _inputWidth;
			_pmiText.height = _inputHeight;
			_pmiText.x = _rightColX;
			_pmiText.y = _leftColY + (_calcTextSpacing * 6);
			_pmiText.border = true;
			_pmiText.background = true; 
			_pmiText.backgroundColor = 0xffffff;
			_tweenContainer.addChild(_pmiText);
			
			// **** These create the output TextFields on the Calculator ****
			_loanAmountText = new TextField;
			_loanAmountText.defaultTextFormat = _calcTextFormatWhite;
			_loanAmountText.text = "$0.00";
			_loanAmountText.antiAliasType = AntiAliasType.ADVANCED;
			_loanAmountText.width = _inputWidth;
			_loanAmountText.height = _inputHeight;
			_loanAmountText.x = _rightColX;
			_loanAmountText.y = _leftColY + (_calcTextSpacing * 7);
			_tweenContainer.addChild(_loanAmountText);
			
			_loanPaymentText = new TextField;
			_loanPaymentText.defaultTextFormat = _calcTextFormatWhite;
			_loanPaymentText.text = "$0.00";
			_loanPaymentText.antiAliasType = AntiAliasType.ADVANCED;
			_loanPaymentText.width = _inputWidth;
			_loanPaymentText.height = _inputHeight;
			_loanPaymentText.x = _rightColX;
			_loanPaymentText.y = _leftColY + (_calcTextSpacing * 8);
			_tweenContainer.addChild(_loanPaymentText);
			
			_mortgagePaymentText = new TextField;
			_mortgagePaymentText.defaultTextFormat = _calcTextFormatWhite;
			_mortgagePaymentText.text = "$0.00";
			_mortgagePaymentText.antiAliasType = AntiAliasType.ADVANCED;
			_mortgagePaymentText.width = _inputWidth;
			_mortgagePaymentText.height = _inputHeight;
			_mortgagePaymentText.x = _rightColX;
			_mortgagePaymentText.y = _leftColY + (_calcTextSpacing * 9);
			_tweenContainer.addChild(_mortgagePaymentText);
			
			// **** These create the labels on the Calculator ****
			_calcLabel = new TextField;
			_calcLabel.text = "Mortgage Calculator";
			_calcLabel.antiAliasType = AntiAliasType.ADVANCED;
			_calcLabel.autoSize = TextFieldAutoSize.CENTER;
			_calcLabel.setTextFormat(_calcLabelFormat);
			_calcLabel.x = _calcLabelX;
			_calcLabel.y = _calcLabelY;
			_tweenContainer.addChild(_calcLabel);
			
			_priceLabel = new TextField;
			_priceLabel.text = "Purchase Price";
			_priceLabel.antiAliasType = AntiAliasType.ADVANCED;
			_priceLabel.autoSize = TextFieldAutoSize.LEFT;
			_priceLabel.setTextFormat(_calcTextFormatWhite);
			_priceLabel.x = _leftColX;
			_priceLabel.y = _leftColY;
			_tweenContainer.addChild(_priceLabel);
			
			_downPaymentLabel = new TextField;
			_downPaymentLabel.text = "Down Payment";
			_downPaymentLabel.antiAliasType = AntiAliasType.ADVANCED;
			_downPaymentLabel.autoSize = TextFieldAutoSize.LEFT;
			_downPaymentLabel.setTextFormat(_calcTextFormatWhite);
			_downPaymentLabel.x = _leftColX;
			_downPaymentLabel.y = _leftColY + _calcTextSpacing;
			_tweenContainer.addChild(_downPaymentLabel);
			
			_interestRateLabel = new TextField;
			_interestRateLabel.text = "Interest Rate";
			_interestRateLabel.antiAliasType = AntiAliasType.ADVANCED;
			_interestRateLabel.autoSize = TextFieldAutoSize.LEFT;
			_interestRateLabel.setTextFormat(_calcTextFormatWhite);
			_interestRateLabel.x = _leftColX;
			_interestRateLabel.y = _leftColY + (_calcTextSpacing * 2);
			_tweenContainer.addChild(_interestRateLabel);
			
			_loanTermLabel = new TextField;
			_loanTermLabel.text = "Loan Term";
			_loanTermLabel.antiAliasType = AntiAliasType.ADVANCED;
			_loanTermLabel.autoSize = TextFieldAutoSize.LEFT;
			_loanTermLabel.setTextFormat(_calcTextFormatWhite);
			_loanTermLabel.x = _leftColX;
			_loanTermLabel.y = _leftColY + (_calcTextSpacing * 3);
			_tweenContainer.addChild(_loanTermLabel);
			
			_taxesLabel = new TextField;
			_taxesLabel.text = "Property Taxes (1Yr)";
			_taxesLabel.antiAliasType = AntiAliasType.ADVANCED;
			_taxesLabel.autoSize = TextFieldAutoSize.LEFT;
			_taxesLabel.setTextFormat(_calcTextFormatWhite);
			_taxesLabel.x = _leftColX;
			_taxesLabel.y = _leftColY + (_calcTextSpacing * 4);
			_tweenContainer.addChild(_taxesLabel);
			
			_insuranceLabel = new TextField;
			_insuranceLabel.text = "Property Insurance (1Yr)";
			_insuranceLabel.antiAliasType = AntiAliasType.ADVANCED;
			_insuranceLabel.autoSize = TextFieldAutoSize.LEFT;
			_insuranceLabel.setTextFormat(_calcTextFormatWhite);
			_insuranceLabel.x = _leftColX;
			_insuranceLabel.y = _leftColY + (_calcTextSpacing * 5);
			_tweenContainer.addChild(_insuranceLabel);
			
			_pmiLabel = new TextField;
			_pmiLabel.text = "PMI (1Yr)";
			_pmiLabel.antiAliasType = AntiAliasType.ADVANCED;
			_pmiLabel.autoSize = TextFieldAutoSize.LEFT;
			_pmiLabel.setTextFormat(_calcTextFormatWhite);
			_pmiLabel.x = _leftColX;
			_pmiLabel.y = _leftColY + (_calcTextSpacing * 6);
			_tweenContainer.addChild(_pmiLabel);
			
			// **** Help Button for PMI ****
			_pmiHelpButton = new HelpButton(_xmlData, _theme, _pmiHelpText);
			_pmiHelpButton.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			_pmiHelpButton.x = _pmiLabel.x + _pmiLabel.width + 15; // 15 is spacing between end of TextField and btn
			_pmiHelpButton.y = _leftColY + (_calcTextSpacing * 6);
			_tweenContainer.addChild(_pmiHelpButton);
			
			_loanAmountLabel = new TextField;
			_loanAmountLabel.text = "Loan Amount";
			_loanAmountLabel.antiAliasType = AntiAliasType.ADVANCED;
			_loanAmountLabel.autoSize = TextFieldAutoSize.LEFT;
			_loanAmountLabel.setTextFormat(_calcTextFormatWhite);
			_loanAmountLabel.x = _leftColX;
			_loanAmountLabel.y = _leftColY + (_calcTextSpacing * 7);
			_tweenContainer.addChild(_loanAmountLabel);
			
			// **** Help Button for Loan Amount ****
			_loanAmtHelpButton = new HelpButton(_xmlData, _theme, _loanAmtHelpText);
			_loanAmtHelpButton.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			_loanAmtHelpButton.x = _loanAmountLabel.x + _loanAmountLabel.width + 15; // 15 is spacing between end of TextField and btn
			_loanAmtHelpButton.y = _leftColY + (_calcTextSpacing * 7);
			_tweenContainer.addChild(_loanAmtHelpButton);
			
			_loanPaymentLabel = new TextField;
			_loanPaymentLabel.text = "Loan Payment";
			_loanPaymentLabel.antiAliasType = AntiAliasType.ADVANCED;
			_loanPaymentLabel.autoSize = TextFieldAutoSize.LEFT;
			_loanPaymentLabel.setTextFormat(_calcTextFormatWhite);
			_loanPaymentLabel.x = _leftColX;
			_loanPaymentLabel.y = _leftColY + (_calcTextSpacing * 8);
			_tweenContainer.addChild(_loanPaymentLabel);
			
			// **** Help Button for Loan Payment ****
			_loanHelpButton = new HelpButton(_xmlData, _theme, _loanHelpText);
			_loanHelpButton.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			_loanHelpButton.x = _loanPaymentLabel.x + _loanPaymentLabel.width + 15; // 15 is spacing between end of TextField and btn
			_loanHelpButton.y = _leftColY + (_calcTextSpacing * 8);
			_tweenContainer.addChild(_loanHelpButton);

			_mortgagePaymentLabel = new TextField;
			_mortgagePaymentLabel.text = "Mortgage Payment";
			_mortgagePaymentLabel.antiAliasType = AntiAliasType.ADVANCED;
			_mortgagePaymentLabel.autoSize = TextFieldAutoSize.LEFT;
			_mortgagePaymentLabel.setTextFormat(_calcTextFormatWhite);
			_mortgagePaymentLabel.x = _leftColX;
			_mortgagePaymentLabel.y = _leftColY + (_calcTextSpacing * 9);
			_tweenContainer.addChild(_mortgagePaymentLabel);
			
			// **** Help Button for Mortgage Payment ****
			_mortgageHelpButton = new HelpButton(_xmlData, _theme, _mortgageHelpText);
			_mortgageHelpButton.filters = [new DropShadowFilter(4, 45, 0x000000)]; // Adds drop shadow to object
			_mortgageHelpButton.x = _mortgagePaymentLabel.x + _mortgagePaymentLabel.width + 15; // 15 is spacing between end of TextField and btn
			_mortgageHelpButton.y = _leftColY + (_calcTextSpacing * 9);
			_tweenContainer.addChild(_mortgageHelpButton);
			
			_percentLabel = new TextField;
			_percentLabel.text = "%";
			_percentLabel.antiAliasType = AntiAliasType.ADVANCED;
			_percentLabel.autoSize = TextFieldAutoSize.LEFT;
			_percentLabel.setTextFormat(_calcTextFormatWhite);
			_percentLabel.x = _percentYearsX;
			_percentLabel.y = _leftColY + (_calcTextSpacing * 2);
			_tweenContainer.addChild(_percentLabel);
			
			_yearsLabel = new TextField;
			_yearsLabel.text = "Years";
			_yearsLabel.antiAliasType = AntiAliasType.ADVANCED;
			_yearsLabel.autoSize = TextFieldAutoSize.LEFT;
			_yearsLabel.setTextFormat(_calcTextFormatWhite);
			_yearsLabel.x = _percentYearsX;
			_yearsLabel.y = _leftColY + (_calcTextSpacing * 3);
			_tweenContainer.addChild(_yearsLabel);
		}
		
		// Button positioning
		private function posBtns():void
		{
			_calculate.x = _calculateX;
			_calculate.y = _calculateY;
			_amortize.x = _amortizeX;
			_amortize.y = _amortizeY;
			_clearCalc.x = _clearCalcX;
			_clearCalc.y = _clearCalcY;
			
			_tweenContainer.addChild(_calculate);
			_tweenContainer.addChild(_amortize);
			_tweenContainer.addChild(_clearCalc);
		}
		
		private function setHelpButtonIndex(e:MouseEvent):void
		{
			_tweenContainer.setChildIndex(Sprite(e.currentTarget), _tweenContainer.numChildren - 1);
		}
		
		// Called from Calculator when its added to the stage 
		public function addEventListeners():void
		{
			_pmiHelpButton.addEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
			_loanAmtHelpButton.addEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
			_loanHelpButton.addEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
			_mortgageHelpButton.addEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
		}
		
		// Closes the help boxes if they are still open when Calculator is removed from the stage or the amortization chart is used
		protected function closeHelpBoxes():void
		{
			_pmiHelpButton.closeHelpBox();
			_loanAmtHelpButton.closeHelpBox();
			_loanHelpButton.closeHelpBox();
			_mortgageHelpButton.closeHelpBox();
		}
		
		// Removes event listeners when the calculator is removed from the stage
		protected function destroyPage():void
		{
			_pmiHelpButton.removeEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
			_loanAmtHelpButton.removeEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
			_loanHelpButton.removeEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
			_mortgageHelpButton.removeEventListener(MouseEvent.MOUSE_OVER, setHelpButtonIndex);
			
			closeHelpBoxes();
		}
	}
}