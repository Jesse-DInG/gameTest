package Utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.WhiteSpaceCollapse;
	
	import starling.display.DisplayObject;
	import starling.display.MovieClip;

	public class ObjectUtils
	{
		public function ObjectUtils()
		{
		}
		public static function getDicCount(dic:Dictionary):int
		{
			var n:int = 0;
			for (var key:* in dic) {
				n++;
			}
			return n;
		}
		
		public static function disposeObj(obj:*):void
		{
			if(obj is DisplayObject)
			{
				var dO:DisplayObject = obj as DisplayObject;
				dO.dispose();
				if(dO.parent)dO.parent.removeChild(dO);
			}
			else if(obj is Dictionary)
			{
				disposeDic(obj as Dictionary);
			}
			else if(obj is Vector)
			{
				var vO:Vector.<*> = obj as Vector.<*>;
				while(vO.length>0)
				{
					disposeObj(vO.shift());
				}
			}
			else if(obj is BitmapData)
			{
				(obj as BitmapData).dispose();
			}
			else if(obj is Bitmap)
			{
				var Bo:Bitmap = obj as Bitmap;
				Bo.bitmapData.dispose();
				if(Bo.parent)Bo.parent.removeChild(Bo);
			}
		}
		
		public static function disposeDic(dic:Dictionary):void
		{
			for(var key:* in dic)
			{
				disposeObj(dic[key]);
				delete dic[key];
			}
			
		}
	}
}