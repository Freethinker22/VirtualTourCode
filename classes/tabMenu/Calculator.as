package  classes.tabMenu // This is the API class for the Calculator object
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import classes.Param;
	import classes.Theme;
	import classes.util.NumFormat;
	import classes.util.DelayFunction;
	import classes.events.TabMenuEvent;
	
	public class Calculator extends CalculatorConstruct
	{
		// Constants
		public const PAGE_NAME:String = "Calculator" // Used as a reference in the TabMenu for selection or removal
		
		private var _xmlData:Param; // Object to store loaded XML info
		private var _theme:Theme; // Reference to the Theme class
		private var _amortization:Amortization; // Reference to the Amortization class
		
		// Settable vars
		private var _calcBgLinesX:Number; // X position of the calculator page
		private var _calcBgLinesY:Number; // Y position of the calculator page
		private var _amortizationX:Number; // X position of the amortization page
		private var _amortizationY:Number; // Y position of the amortization page
		private var _amorChartInUse:Boolean; // Flag used to determine if the amortization chart is on the screen
		
		// Caluculation vars
		private var _loanAmount:Number; // Loan amount
		private var _paymentFrequency:Number = 12; // Payment frequency equals 12 months
		private var _numOfMonths:Number; // Number of months
		private var _effInterest:Number; // Effective interest rate
		private var _annuityFactor:Number; // Annuity factor
		private var _loanPayment:Number; // Loan payment
		private var _totalMortgagePayment:Number; // Total mortgage payment
		
		// Input vars from Calculator object
		private var _inputPrice:String; // String to hold the input price amount
		private var _inputDownPayment:String; // String to hold the input down payment amount
		private var _inputInterestRate:String; // String to hold the input interest rate amount
		private var _inputLoanTerm:String; // String to hold the input loan term amount
		private var _inputTaxes:String; // String to hold the input taxes amount
		private var _inputInsurance:String; // String to hold the input Insurance amount
		private var _inputPMI:String; // String to hold the input PMI amount
		
		// Number vars to be used after inputs are cleaned out
		private var _price:Number; // Number output to price TextField after claculations
		private var _downPayment:Number; // Number output to down payment TextField after claculations
		private var _interestRate:Number; // Number output to interest rate TextField after claculations
		private var _loanTerm:Number; // Number output to loan term TextField after claculations
		private var _taxes:Number; // Number output to taxes TextField after claculations
		private var _insurance:Number; // Number output to insurance TextField after claculations
		private var _pmi:Number; // Number output to PMI TextField after claculations
		
		public function Calculator(xmlData:Param, theme:Theme) 
		{
			// Set argument vars
			_xmlData = xmlData;
			_theme = theme;
			super(_xmlData, _theme);
			
			// Settable vars
			_calcBgLinesX = _xmlData.calcBgLinesX;
			_calcBgLinesY = _xmlData.calcBgLinesY;
			_amortizationX = _xmlData.amortizationX;
			_amortizationY = _xmlData.amortizationY;
			_amorChartInUse = false;
		}
		
		// Called from TabMenu to run code that needs to happen when Claculator is added to the stage
		public function addToStage():void
		{
			_calcBgLines.alpha = 0;
			_calcBgLines.x = _calcBgLinesX;
			_calcBgLines.y = _calcBgLinesY;
			addChild(_calcBgLines);
			TweenMax.to(_calcBgLines, .50, {alpha:1});
			
			_tweenContainer.alpha = 0;
			addChild(_tweenContainer);
			TweenMax.to(_tweenContainer, .75, {delay:.25, alpha:1});
			
			// Event listeners
			_calculate.addEventListener(MouseEvent.CLICK, calc);
			_clearCalc.addEventListener(MouseEvent.CLICK, clearCalculator);
			this.addEventListener(Event.ADDED_TO_STAGE, setFocus);
			
			super.addEventListeners();
		}
		
		private function setFocus(e:Event):void
		{
			stage.focus = _priceText;
			this.removeEventListener(Event.ADDED_TO_STAGE, setFocus);
		}
		
		private function calc(e:MouseEvent):void 
		{
			// Input variables
			var cleanOutPattern:RegExp = / , | \$ | % | \+ | - | \* | \/ | [a-z] | [A-Z] /gx;
			
			// Commas and dollar signs removed before calculator equations
			_inputPrice = _priceText.text;
			_inputPrice = _inputPrice.replace(cleanOutPattern, "");
			_price = Number(_inputPrice);
			
			_inputDownPayment = _downPaymentText.text;
			_inputDownPayment = _inputDownPayment.replace(cleanOutPattern, "");
			_downPayment = Number(_inputDownPayment);
			
			_inputInterestRate = _interestRateText.text;
			_inputInterestRate = _inputInterestRate.replace(cleanOutPattern, "");
			_interestRate = Number(_inputInterestRate);
			_interestRate = _interestRate / 100;
			
			_inputLoanTerm = _loanTermText.text;
			_inputLoanTerm = _inputLoanTerm.replace(cleanOutPattern, "");
			_loanTerm = Number(_inputLoanTerm);
			
			_inputTaxes = _taxesText.text;
			_inputTaxes = _inputTaxes.replace(cleanOutPattern, "");
			_taxes = Number(_inputTaxes);
				
			_inputInsurance = _insuranceText.text;
			_inputInsurance = _inputInsurance.replace(cleanOutPattern, "");
			_insurance = Number(_inputInsurance);
			
			_inputPMI = _pmiText.text;
			_inputPMI = _inputPMI.replace(cleanOutPattern, "");
			_pmi = Number(_inputPMI);
	
			// Calculator algorithm
			_loanAmount = _price - _downPayment;
			_numOfMonths = _paymentFrequency * _loanTerm;
			_effInterest = Math.pow((1 + _interestRate / _paymentFrequency),(12 / _paymentFrequency)) - 1;
			_annuityFactor = (1 - (Math.pow((1 / (1 + _effInterest)), _numOfMonths))) / _effInterest;
			_loanPayment = (_loanAmount / _annuityFactor);
			_totalMortgagePayment = (_loanPayment + ((_taxes + _insurance + _pmi) / 12));
	
			outputCalc();
		}
	
		// Output calculations to screen if conditions for that box are true
		private function outputCalc():void 
		{
			// Format input vars
			if(_priceText.text != "")
			{
				_priceText.text = NumFormat.format(_price, 2);
			}
			
			if(_priceText.text != "")
			{
				_downPaymentText.text = NumFormat.format(_downPayment, 2);
			}
			
			if(_interestRateText.text != "")
			{
				_interestRateText.text = _inputInterestRate;
			}
			
			if(_loanTermText.text != "")
			{
				_loanTermText.text = _loanTerm.toString();
			}
			
			if(_taxesText.text != "")
			{
				_taxesText.text = NumFormat.format(_taxes, 2);
			}
			
			if(_insuranceText.text != "")
			{
				_insuranceText.text = NumFormat.format(_insurance, 2);
			}
			
			if(_pmiText.text != "")
			{
				_pmiText.text = NumFormat.format(_pmi, 2);
			}
			
			// Format output vars
			if(_priceText.text != "")
			{
				_loanAmountText.text = NumFormat.format(_loanAmount, 2);
			}
		
			if(_interestRateText.text && _loanTermText.text != "")
			{
				_loanPaymentText.text = NumFormat.format(_loanPayment, 2);
				_mortgagePaymentText.text = NumFormat.format(_totalMortgagePayment, 2);
				_amortize.addEventListener(MouseEvent.CLICK, displayAmortization); // Add amortize button listener
			}
			
			// Use the DelayFunction class to allow the calculator to output its numbers w/o the processing delay caused by instantiating Amortization
			new DelayFunction(setupAmortization, 100);
		}
		
		// Creates the amortization chart so that is ready w/o processing delay
		private function setupAmortization():void
		{
			// Clears amortization out if Amortization has already been run once, keeps them from piling up
			if(_amortization != null)
			{
				_amortization = null;
				_amortization = new Amortization(_xmlData, _theme, _loanAmount, _numOfMonths, _loanPayment, _interestRate);
			}
			
			else
			{
				_amortization = new Amortization(_xmlData, _theme, _loanAmount, _numOfMonths, _loanPayment, _interestRate);
			}
		}
		
		// Resets all fields to their default values
		private function clearCalculator(e:MouseEvent):void
		{
			_amortize.removeEventListener(MouseEvent.CLICK, displayAmortization);
			
			_priceText.text = "";
			_downPaymentText.text = "";
			_interestRateText.text = "";
			_loanTermText.text = "";
			_taxesText.text = "";
			_insuranceText.text = "";
			_pmiText.text = "";
			
			_loanAmountText.text = "$0.00";
			_loanPaymentText.text = "$0.00";
			_mortgagePaymentText.text = "$0.00";
			
			stage.focus = _priceText;
		}
		
		// Tweens in the amortization chart while tweening out the calculator's visible content
		private function displayAmortization(e:MouseEvent):void 
		{ 
			_amortization.displayChart();
			_amortization.alpha = 0;
			_amortization.x = _amortizationX;
			_amortization.y = _amortizationY;
			_amortization.addEventListener(TabMenuEvent.DESTROY_AMORTIZATION, unloadAmortizationEvent);
			addChild(_amortization);
			_amorChartInUse = true;
			
			TweenMax.to(_tweenContainer, .75, {alpha:0});
			TweenMax.to(_calcBgLines, .75, {alpha:0});
			TweenMax.to(_amortization, 1, {delay:.25, alpha:1});	
			
			closeHelpBoxes(); // Closes the help boxes if they are still open when amortization chart is used
		}
		
		// Event parameter workaround for unloadAmortization function
		private function unloadAmortizationEvent(tabMenuEvent:TabMenuEvent):void
		{
			unloadAmortization();
		}
		
		// Tweens in the calculator's visible content while tweening out the amortization chart
		private function unloadAmortization():void
		{
			TweenMax.to(_amortization, .5, {alpha:0, onComplete:destroyAmortization});
			TweenMax.to(_calcBgLines, 1, {delay:.25, alpha:1});
			TweenMax.to(_tweenContainer, 1, {delay:.25, alpha:1});
		}
		
		// Removes amortization chart after it tweens out
		private function destroyAmortization():void 
		{ 
			_amortization.removeEventListener(TabMenuEvent.DESTROY_AMORTIZATION, unloadAmortizationEvent);
			_amorChartInUse = false;
			removeChild(_amortization);
		}
		
		// Called when Claculator is removed from the stage
		public function returnToTour():void 
		{
			TweenMax.to(_calcBgLines, .25, {alpha:0});
			TweenMax.to(_tweenContainer, .25, {alpha:0});
			TweenMax.to(_tweenContainer, .25, {alpha:0, onComplete:removePage});
		
			_calculate.removeEventListener(MouseEvent.CLICK, calc);
			_clearCalc.removeEventListener(MouseEvent.CLICK, clearCalculator);
			
			super.destroyPage();
			
			if(_amorChartInUse)
			{
				unloadAmortization();
				_amorChartInUse = false;
			}
		}
		
		private function removePage():void
		{
			dispatchEvent(new TabMenuEvent(TabMenuEvent.DESTROY_PAGE, this.PAGE_NAME, true)); // Dispatches to TabMenu to remove page
		}
	}
}