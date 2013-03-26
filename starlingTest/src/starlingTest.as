package
{
	import flash.display.Sprite;
	
	import game.Game;
	
	import starling.core.Starling;
	
	[SWF(frameRate=60,width=800,height=600,backgroundColor=0x000000)]
	public class starlingTest extends Sprite
	{
		public function starlingTest()
		{
			var star:Starling = new Starling(Game,stage);
			star.start();
		}
	}
}