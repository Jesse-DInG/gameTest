package BaseLoader
{
	import flash.display.Loader;

	public class gameLoader extends Loader
	{
		public var cname:String;
		public var direction:int;//0:左,1:右
		public function gameLoader(name:String,direction:int)
		{
			this.cname = name;
			this.direction = direction;
			super();
		}
	}
}