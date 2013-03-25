package Utils
{
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	public final class DirectionType
	{
		public static function getDirection(keys:Dictionary):int
		{
			var left:Boolean = keys[Keyboard.A] || keys[Keyboard.LEFT];
			var up:Boolean = keys[Keyboard.W] || keys[Keyboard.UP];
			var right:Boolean = keys[Keyboard.D] || keys[Keyboard.RIGHT];
			var down:Boolean = keys[Keyboard.S] || keys[Keyboard.DOWN];
			if(left && up && !right  && !down)
			{
				return TL;
			}
			else if(!left && up && !right  && !down)
			{
				return T;
			}
			else if(!left && up && right  && !down)
			{
				return TR;
			}
			else if(left && !up && !right  && !down)
			{
				return L;
			}
			else if(!left && !up && right  && !down)
			{
				return R;
			}
			else if(left && !up && !right  && down)
			{
				return BL;
			}
			else if(!left && !up && !right  && down)
			{
				return B;
			}
			else if(!left && !up && right  && down)
			{
				return BR;
			}
			else return CENTER;
		}
		
		public static function getHorizontalDirection(value:int):int
		{
			if(value == TL || value == L || value == BL)
			{
				return -1;
			}
			else if(value == TR || value == R || value == BR)
			{
				return 1;
			}
			else return 0;
		}
		
		public static function getVerticalDirection(value:int):int
		{
			if(value == TL || value == T || value == TR)
			{
				return -1;
			}
			else if(value == BL || value == B || value == BR)
			{
				return 1;
			}
			else return 0;
		}
		
		public static const CENTER:int = 0;
		public static const TL:int = 1;
		public static const T:int = 2;
		public static const TR:int = 3;
		public static const L:int = 4;
		public static const R:int = 5;
		public static const BL:int = 6;
		public static const B:int = 7;
		public static const BR:int = 8;
	}
}