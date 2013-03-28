package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
	public class BigIntDemo extends Sprite
	{
		private static const ADD:uint 	= 0;
		private static const MINUS:uint = 1;
		private static const PROD:uint 	= 2;
		private static const DIV:uint 	= 3;
		private static const POWER:uint = 4;
		
		private var preNum1:String = "";
		private var preNum2:String = "";
		
		private var oriResTfY:Number = 0;
		private var oriResTfHeight:Number = 0;
		
		private var _demo:bigIntDemo;
		
		public function BigIntDemo()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_demo = new bigIntDemo;
			addChild( _demo );
			
			preNum1 = _demo.num1_tf.text.replace( /\r*/g, "" );
			preNum2 = _demo.num2_tf.text.replace( /\r*/g, "" );
			
			setupOprtChoser();
			setupTextFeild();
		}
		
		private function setupOprtChoser():void
		{
			_demo.oprt_choser.dropdownWidth = 60;
			_demo.oprt_choser.width = 60;
			
			_demo.oprt_choser.addItem( { label:"+" } );
			_demo.oprt_choser.addItem( { label:"-" } );
			_demo.oprt_choser.addItem( { label:"*" } );
			_demo.oprt_choser.addItem( { label:"/" } );
			_demo.oprt_choser.addItem( { label:"^" } );
			
			_demo.oprt_choser.addEventListener( Event.CHANGE, onSelectOprt );
			_demo.oprt_choser.addEventListener( Event.CLOSE, onSelectOprt );
		}
		
		private function setupTextFeild():void
		{
			_demo.num1_tf.restrict = _demo.num2_tf.restrict = "0-9";
			_demo.result_tf.selectable = true;
			oriResTfY = _demo.result_tf.y;
			oriResTfHeight = _demo.result_tf.height;
			_demo.result_tf.autoSize = TextFieldAutoSize.LEFT;
			_demo.result_tf.y = oriResTfY + ( oriResTfHeight - _demo.result_tf.height)*0.5;
			
			_demo.num1_tf.addEventListener( KeyboardEvent.KEY_UP, inputHandle );
			_demo.num2_tf.addEventListener( KeyboardEvent.KEY_UP, inputHandle );
			
		}
		
		private function inputHandle( e:KeyboardEvent ):void
		{
			if( e.keyCode == Keyboard.ENTER )
			{
				_demo.num1_tf.text = _demo.num1_tf.text.replace( /\r*/g, "" );
				_demo.num2_tf.text = _demo.num2_tf.text.replace( /\r*/g, "" );
				onSelectOprt();
			}
		}
		
		private function onSelectOprt( e:Event = null ):void
		{
			var num1:String = _demo.num1_tf.text.replace( /\r*/g, "" );
			var num2:String = _demo.num2_tf.text.replace( /\r*/g, "" );
			
			var isTextChanged:Boolean = (num1 != preNum1 || num2 != preNum2);
			var isOprtChanged:Boolean = e && e.type == Event.CHANGE;
			
			if( !isTextChanged && !isOprtChanged )
			{
				trace( "noChange!" );
				return; 
			}
			
			preNum1 = num1;
			preNum2 = num2;
			
			var result:String = "";
			
			switch( _demo.oprt_choser.selectedIndex )
			{
				case ADD:
					result = BigInt.add( num1, num2 );
					break;
				case MINUS:
					result = BigInt.minus( num1, num2 );
					break;
				case PROD:
					result = BigInt.prod( num1, num2 );
					break;
				case DIV:
					var divRes:Array = BigInt.divide( num1, num2 );
					result = "商："+divRes[0]+"\n余："+divRes[1];
					break;
				case POWER:
					if( BigInt.comp( num1, String(int.MAX_VALUE) ) > 0 )
					{
						result = "暂不支持num1超过int最大值的乘方运算！";
					}
					else if( num2.length >= 4 )
					{
						result = "为了不使运算时间过长，暂不支持4位幂的乘方运算！";
					}
					else
					{
						result = BigInt.pow( int(num1), int(num2) );
					}
					break;
				default:
					break;
			}
		
			_demo.result_tf.text = result;
			_demo.result_tf.y = oriResTfY + ( oriResTfHeight - _demo.result_tf.height)*0.5;
			
		}
		
	}
}