package classes.util // This is a utility class used to pause and resume specific tweens of the objects sent to it 
{
	import flash.display.DisplayObject;
	import com.greensock.TweenMax;
	
	public class PauseTween
	{
		public static function stopTween(obj:DisplayObject):void
		{
			var tweenArray:Array = TweenMax.getTweensOf(obj);
			
			for (var i:int = 0; i < tweenArray.length; i++)
			{
				var tweenRef:TweenMax  = tweenArray[i] as TweenMax;
				tweenRef.pause();
			}
		}
		
		public static function startTween(obj:DisplayObject):void
		{
			var tweenArray:Array = TweenMax.getTweensOf(obj);
			
			for (var i:int = 0; i < tweenArray.length; i++)
			{
				var tweenRef:TweenMax  = tweenArray[i] as TweenMax;
				tweenRef.play();
			}
		}
	}
}