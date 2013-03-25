package Utils
{
	public class PathManager
	{
		public function PathManager()
		{
		}
		
		public static function getCharactorPath(name:String,fileName:String):String
		{
			return "../media/charactor/" + name + "/" + fileName + ".png";
		}
	}
}