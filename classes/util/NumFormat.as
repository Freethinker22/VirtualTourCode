﻿package classes.util // This is a utility class used to return formatted currency numbers
{
	public class NumFormat 
	{
		public static function format(number:Number, precision:int, decimalDelimiter:String = ".", commaDelimiter:String = ",", prefix:String = "$", suffix:String = ""):String
		{
			var decimalMultiplier:int = Math.pow(10, precision);
			var str:String = Math.round(number * decimalMultiplier).toString();
	
			var leftSide:String = str.substr(0, -precision);
			var rightSide:String = str.substr(-precision);
			var leftSideNew:String = "";
			
      		for(var i:int = 0; i < leftSide.length;i++)
			{
				if(i > 0 && (i % 3 == 0 ))
				{
					leftSideNew = commaDelimiter + leftSideNew;
				}
             
				leftSideNew = leftSide.substr(-i - 1, 1) + leftSideNew;
			} 
            
			if(Number(leftSideNew) == 0)
			{
				return prefix + "0.00" + suffix; // Anything less that $1.00 shows up as $0.00?? Not a big deal for mortgages
			}
			
			else
			{
				return prefix + leftSideNew + decimalDelimiter + rightSide + suffix;
			}
		}
	}
}