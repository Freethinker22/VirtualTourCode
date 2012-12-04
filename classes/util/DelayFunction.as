package classes.util // This is a utility class used to delay a function's execution for the input period of time
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DelayFunction
	{
		private var _timer:Timer;
		private var _delayedFunction:Function;
		
		public function DelayFunction(functionToDelay:Function, delayInMilliseconds:Number)
		{
			this._delayedFunction = functionToDelay;
			_timer = new Timer(delayInMilliseconds, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, callDelayedFunction);
			_timer.start();
		}
		
		private function callDelayedFunction(e:TimerEvent)
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, callDelayedFunction);
			_delayedFunction();
		}
	}
}