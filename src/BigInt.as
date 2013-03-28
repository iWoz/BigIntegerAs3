package
{
	/**
	 * A Class Which can do plus, minus, product, divide and power of Big Integers.<br />
	 * @author Tim<br />
	 * <a href="http://wuzhiwei.net" target="_blank">My Blog</a>
	 * 
	 */	
	public class BigInt
	{
		public static const MAX_DIGITS:int = int.MAX_VALUE;
		public static const NAN:String = "NAN";
		
		public function BigInt()
		{
		}
		
		/**
		 * Compare num1 and num2.<br /> 
		 * If num1 greater than num2, then return 1. 
		 * If num1 euqual num2 , return 0. 
		 * Else return -1
		 * @param num1
		 * @param num2
		 * @return 
		 * 
		 */		
		public static function comp( num1:String, num2:String ):int
		{
			if( num1 == num2 )
			{
				return 0;
			}
			if( num1.length != num2.length )
			{
				return num1.length > num2.length ? 1 : -1;
			}
			return num1 > num2 ? 1 : -1;
		}
		
		/**
		 * clear the pre zero of a BigInt String <br />
		 * e.p: fixPreZero("000220013100") return "220013100"
		 * @param num
		 * @return 
		 * 
		 */		
		public static function fixPreZero( num:String ):String
		{
			var fixZeroPt:RegExp = /^0*/;
			return num.replace( fixZeroPt, "" );
		}
		
		/**
		 * Get the product of BigInt num1 and BigInt num2 in [limit] digits
		 * @param num1
		 * @param num2
		 * @param limit
		 * @return 
		 * 
		 */	
		public static function prod( num1:String, num2:String, limit:int = MAX_DIGITS ):String
		{
			var thisNumStr:String = fixPreZero(num1);
			var prodNumStr:String = fixPreZero(num2);
			
			if( num2 == "0" || num1 == "0" )
			{
				return "0";
			}
			
			var tmpProd:String;
			var lastProd:String = "0";
			
			var prodDigit:int;
			var addDigit:int = 0;
			var digitProd:int;
			
			var prod:String = "";
			
			var k:int = 0;
			
			for(var i:int = prodNumStr.length - 1 ; i >= 0; i--)
			{
				if( k > limit )
				{
					return strReverse(prod);
				}
				
				prodDigit = int(prodNumStr.charAt(i));
				tmpProd = "";
				addDigit = 0;
				
				for(var j:int = thisNumStr.length - 1; j >= 0; j--)
				{
					digitProd = (int(thisNumStr.charAt(j))*prodDigit + addDigit);
					tmpProd += digitProd % 10;
					addDigit = digitProd / 10;
				}
				tmpProd += addDigit == 0 ? "" : addDigit;
				tmpProd = add( strReverse( tmpProd ), lastProd );
				prod += tmpProd.charAt( tmpProd.length - 1 );
				lastProd = tmpProd.substring(0,tmpProd.length-1);
				
				k ++;
			}
			return lastProd + strReverse(prod) ;
		}
		
		/**
		 * Get the diffrence of BigInt num1 and BigInt num2 
		 * @param num1
		 * @param num2
		 * @return 
		 * 
		 */		
		public static function minus( num1:String, num2:String ):String
		{
			var comp:int = comp( num1, num2 );
			if( comp == 0 )
			{
				return "0";
			}
			var tmp:String;
			if( comp == -1 )
			{
				tmp = num1;
				num1 = num2;
				num2 = tmp;
			}
			var i:int;
			var num2Len:int = num2.length;
			for( i = 0; i < num1.length - num2Len; i++ )
			{
				num2 = "0"+num2;
			}
			var diff:String = "";
			var sdiff:int = 0;
			var offset:int = 0;
			
			for ( i = num2.length - 1; i >= 0; i-- )
			{
				sdiff = int( num1.charAt( i ) ) + offset - int( num2.charAt( i ) );
				if( sdiff < 0 )
				{
					offset = -1;
					sdiff = 10+sdiff;
				}
				else
				{
					offset = 0;
				}
				diff += String(sdiff);
			}
			diff = fixPreZero( strReverse( diff ) );
			return comp == 1 ? diff : "-"+diff;
		}
		
		/**
		 * Get the quotient and remainder of num1 divide num2 return in an Array 
		 * @param num1
		 * @param num2
		 * @return [ quotient, remainder ]
		 * 
		 */		
		public static function divide( num1:String, num2:String ):Array
		{
			if( num2 == "0" )
			{
				return [NAN,NAN];
			}
			var comp:int = comp( num1, num2 );
			if( comp == 0 )
			{
				return ["1","0"];
			}
			else if( comp == -1 )
			{
				return [ num1, "0" ];
			}
			
			var n:String = num1.slice( 0, num2.length );
			var q:String = "";
			var r:String = "";
			var tp:String = "";
			
			for( var i:int = num2.length; i <= num1.length; i++ )
			{
				for( var j:int = 1; j <= 10; j++ )
				{
					tp = prod( num2, ""+j );
					comp = BigInt.comp( tp, n );
					if( comp == 0 )
					{
						q += j;
						i == num1.length ? 
							r = "0" : n = num1.charAt(i);
						break;
					}
					else if( comp > 0 )
					{
						q += (j-1);
						i == num1.length ?
							r = fixPreZero( minus( n, prod( num2, ""+(j-1) ) ) ) :
							n = fixPreZero( minus( n, prod( num2, ""+(j-1) ) ) + num1.charAt(i) );
						break;
					}
				}
			}
			return [ fixPreZero(q), r ];
		}
		
		/**
		 * Get the pow BigInt of [baseNum]^[powNum] in [limit] digits
		 * @param baseNum
		 * @param powNum
		 * @param limit
		 * @return 
		 * 
		 */		
		public static function pow( baseNum:int, powNum:int, limit:int = MAX_DIGITS ):String
		{
			if( powNum == 0 )
			{
				return baseNum == 0 ? NAN : "1";
			}
			if( baseNum == 1 || baseNum == 0 )
			{
				return String(baseNum);
			}
			var base:String;
			
			var totalLoop:int = powNum;
			var loopCt:int = 0;
			var totalPow:String = "1";
			
			while( loopCt != powNum )
			{
				base = String(baseNum);
				for( var i:int = 1;Math.pow(2,i) <= totalLoop;i++)
				{
					base = prod( base, base,limit);
				}
				loopCt += Math.pow(2,i-1);
				totalLoop = totalLoop - Math.pow(2,i-1);
				totalPow = prod( totalPow, base, limit );
			}
			return totalPow;
		}
		
		/**
		 * Get the sum of two number string.
		 * @param strA
		 * @param strB
		 * @return 
		 * 
		 */		
		public static function add( strA:String, strB:String ):String
		{
			var topDigits:String;
			var addDigits:String;
			var addedDigits:String;
			var tmpStr:String;
			
			if( strA.length < strB.length )
			{
				tmpStr = strA;
				strA = strB;
				strB = tmpStr;
			}
			if( strA.length > strB.length )
			{
				
				topDigits = strA.substr( 0, strA.length - strB.length );
				addDigits = strA.substring( strA.length - strB.length );
				addedDigits = sameDigitStrAdd( addDigits, strB );
				if( addedDigits.length > addDigits.length )
				{
					return addByOne(topDigits) + addedDigits.substr(1);
				}
				else
				{
					return topDigits + addedDigits;
				}
			}
			else
			{
				return sameDigitStrAdd(strA, strB);
			}
		}
		
		private static function addByOne( numStr:String ):String
		{
			var i:int = numStr.length - 1;
			var addDigit:int = 1;
			var tmp:int;
			var sum:String = "";
			while( i >= 0 )
			{
				tmp = int(numStr.charAt(i)) + addDigit;
				if( tmp > 9 )
				{
					addDigit = 1;
					sum += "0";
				}
				else
				{
					sum += tmp;
					return numStr.substring( 0, i ) + strReverse(sum);
				}
				i --;
			}
			return strReverse(sum+"1");
		}
		
		private static function sameDigitStrAdd( strA:String , strB:String ):String
		{
			if( strA.length == strB.length )
			{
				var sum:String = "";
				var addBit:int = 0;
				
				var i:int = strA.length-1;
				var digitSum:int = 0;
				while( i >= 0 )
				{
					digitSum = int(strA.charAt(i)) + int(strB.charAt(i)) + addBit;
					if( digitSum > 9 )
					{
						addBit = 1;
						sum += digitSum-10;
					}
					else
					{
						addBit = 0;
						sum += digitSum;
					}
					i--;
				}
				if( digitSum > 9 )
				{
					sum += 1;
				}
				return strReverse( sum );
			}
			return "0";
		}
		
		/**
		 *Get the reversed copy of str, str will not be changed.  
		 * @param str
		 * @return 
		 * 
		 */		
		private static function strReverse( str:String ):String
		{
			var i:int = str.length-1;
			var res:String = "";
			
			while( i >= 0 )
			{
				res += str.charAt(i);
				i --;
			}
			
			return res;
		}
	}
}