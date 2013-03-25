package game.Obj
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import BaseLoader.gameLoader;
	
	import Utils.PathManager;
	
	import game.GameConstants;
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;

	public class ObjManager extends EventDispatcher
	{
		private static var _instance:ObjManager;
		
		private var _dic:Dictionary = new Dictionary();
		
		private var _callBack:Function;
		public static function get instance():ObjManager
		{
			if(!_instance)
			{
				_instance = new ObjManager();
			}
			return _instance;
		}
		public function ObjManager()
		{
		}
		
		public function loadObj(name:String):void
		{
			var loader:gameLoader;
			loader = new gameLoader(name,-1);
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,__loadObjComplete);
			loader.load(new URLRequest(PathManager.getCharactorPath(name,name+"_"+GameConstants.ARROW_FLAG+"L")));
			
			loader = new gameLoader(name,1);
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,__loadObjComplete);
			loader.load(new URLRequest(PathManager.getCharactorPath(name,name+"_"+GameConstants.ARROW_FLAG+"R")));
		}
		
		protected function __loadObjComplete(event:flash.events.Event):void
		{
			var loaderinfo:LoaderInfo = event.target as LoaderInfo;
			var loader:gameLoader = loaderinfo.loader as gameLoader;
			loaderinfo.removeEventListener(flash.events.Event.COMPLETE,__loadObjComplete);
			if(!_dic[loader.cname])
			{
				_dic[loader.cname] = [null,null,null,null];
			}
			_dic[loader.cname][loader.direction] = (loaderinfo.content as Bitmap).bitmapData;
			if(checkHasLoad(loader.cname))
			{
				_callBack(getArrow(loader.cname));
				_callBack = null;
			}
		}
		
		private function checkHasLoad(name:String):Boolean
		{
			return _dic[name] && _dic[name][-1] && _dic[name][1];
		}
		
		private function getArrowAsset(name:String,direction:int):Vector.<Texture>
		{
			var bmVec:Vector.<Texture> = new Vector.<Texture>();
			var bm:BitmapData = _dic[name][direction];
			for(var j:int = 0;j<3;j++)
			{
				for(var i:int = 0;i< 10;i++)
				{
					var rect:Rectangle = new Rectangle((4.5-(i-4.5)*direction)*(GameConstants.ARROW_WIDTH+1)+(direction<0?1:0),j*(GameConstants.ARROW_HEIGHT+1),GameConstants.ARROW_WIDTH,GameConstants.ARROW_HEIGHT);
					var temp:BitmapData = new BitmapData(GameConstants.ARROW_WIDTH,GameConstants.ARROW_HEIGHT,true,0);
					temp.copyPixels(bm,rect,new Point(0,0));
					bmVec.push(Texture.fromBitmapData(temp));
				}
			}
			return bmVec;
		}
		
		public function initObjAsset(name:String,callBack:Function):void
		{
			if(checkHasLoad(name))
			{
				callBack(getArrow(name));
			}
			else
			{
				_callBack = callBack;
				loadObj(name);
			}
		}
		
		public function getArrow(name:String):Dictionary
		{
			var bmVec:Vector.<Texture>;
			
			var actionDic:Dictionary = new Dictionary();
			var actionList:Vector.<int>;
			if(!actionDic)actionDic = new Dictionary();
			var direction:String;
			var list:Vector.<Texture>;
			
			actionDic[GameConstants.ARROW_FLAG] = getArrowAsset(name,-1).concat(getArrowAsset(name,1));
			//			actionDic[GameConstants.CHARATOR_MOVIE] = getCharactorAsset(name,1);
			
			//左边
			direction = GameConstants.LEFT;
			//正常攻击
			actionList =new <int>[9,9,9,9,9,9,8,8,8,8,8,8,7,7,7,7,7,7,6,6,6,6,6,6,5,5,5,5,5,5,4,4,4,4,4,4,3,3,3,3,3,3];
			actionDic[GameConstants.ARROW_NORMAL + direction] = actionList;
			
			//右边
			direction = GameConstants.RIGHT;
			//正常攻击
			actionList =new <int>[9,9,9,9,9,9,8,8,8,8,8,8,7,7,7,7,7,7,6,6,6,6,6,6,5,5,5,5,5,5,4,4,4,4,4,4,3,3,3,3,3,3];
			actionDic[GameConstants.ARROW_NORMAL + direction] = actionList;
			
			return actionDic;
		}
	}
}