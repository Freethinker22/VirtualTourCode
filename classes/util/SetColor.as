package classes.util // This is a utility class used to strip the "#" from the color unit and add "0x"
{
	public class SetColor
	{
		public static function setFinalColor(str:String):Number
		{
			var string:String = str;
			var finalString:String = "0x" + string.substr(1, string.length);
			return int(finalString);
		}
	}
}