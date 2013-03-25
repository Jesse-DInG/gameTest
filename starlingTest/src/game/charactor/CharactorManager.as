package game.charactor
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
	
	public class CharactorManager extends EventDispatcher
	{
		private static var _instance:CharactorManager;
		
		private var _dic:Dictionary = new Dictionary();
		
		private var _callBack:Function;
		
		public static function get instance():CharactorManager
		{
			if(!_instance)
			{
				_instance = new CharactorManager();
			}
			return _instance;
		}
		public function CharactorManager()
		{
		}
		
		public function loadCharactor(name:String):void
		{
			var loader:gameLoader;
			loader = new gameLoader(name,0);
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,__loadBodyComplete);
			loader.load(new URLRequest(PathManager.getCharactorPath(name,name+"L")));
			
			loader = new gameLoader(name,1);
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE,__loadBodyComplete);
			loader.load(new URLRequest(PathManager.getCharactorPath(name,name+"R")));
		}
		
		protected function __loadBodyComplete(event:flash.events.Event):void
		{
			var loaderinfo:LoaderInfo = event.target as LoaderInfo;
			var loader:gameLoader = loaderinfo.loader as gameLoader;
			loaderinfo.removeEventListener(flash.events.Event.COMPLETE,__loadBodyComplete);
			if(!_dic[loader.cname])
			{
				_dic[loader.cname] = [null,null,null,null];
			}
			_dic[loader.cname][loader.direction] = (loaderinfo.content as Bitmap).bitmapData;
			if(checkHasLoad(loader.cname))
			{
				_callBack(getCharactor(loader.cname));
				_callBack = null;
			}
		}
		
		private function checkHasLoad(name:String):Boolean
		{
//			if(_dic[name][0] && _dic[name][1])
//			{
//				dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
//			}
			return _dic[name] && _dic[name][0] && _dic[name][1];
		}
		
		private function getCharactorAsset(name:String,direction:int):Vector.<Texture>
		{
			var bmVec:Vector.<Texture> = new Vector.<Texture>();
			var bm:BitmapData = _dic[name][direction];
			for(var j:int = 0;j<7;j++)
			{
				for(var i:int = 0;i< 10;i++)
				{
					var rect:Rectangle = new Rectangle((4.5+(i-4.5)*(0.5-direction)*2)*GameConstants.CHARATOR_WIDTH,j*GameConstants.CHARATOR_HEIGHT,GameConstants.CHARATOR_WIDTH,GameConstants.CHARATOR_HEIGHT);
					var temp:BitmapData = new BitmapData(GameConstants.CHARATOR_WIDTH,GameConstants.CHARATOR_HEIGHT,true,0);
					temp.copyPixels(bm,rect,new Point(0,0));
					bmVec.push(Texture.fromBitmapData(temp));
				}
			}
			return bmVec;
		}
		
		public function initCharactorAsset(name:String,callBack:Function):void
		{
			if(checkHasLoad(name))
			{
				callBack(getCharactor(name));
			}
			else
			{
				_callBack = callBack;
				loadCharactor(name);
			}
		}
		
		public function getCharactor(name:String):Dictionary
		{
			var bmVec:Vector.<Texture>;
			
			var actionDic:Dictionary = new Dictionary();
			var actionList:Vector.<int>;
			if(!actionDic)actionDic = new Dictionary();
			var direction:String;
			var list:Vector.<Texture>;
			
			actionDic[GameConstants.CHARATOR_MOVIE] = getCharactorAsset(name,0).concat(getCharactorAsset(name,1));
//			actionDic[GameConstants.CHARATOR_MOVIE] = getCharactorAsset(name,1);
			
			//左边
			direction = GameConstants.LEFT;
			//行走
			actionList =new <int>[5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2];
			actionDic[GameConstants.CHARATOR_WALK_FLAG + direction] = actionList;
			
			//站立
			actionList = new <int>[9,9,9,9,9,8,8,8,8,8,7,7,7,7,7,6,6,6,6,6];
			actionDic[GameConstants.CHARATOR_STAND_FLAG + direction] = actionList;
			
			//攻击
			actionList = new <int>[19,19,19,19,19,19,19,19,19,19,
				18,18,18,18,18,18,18,18,18,18,
				17,17,17,17,17,17,17,17,17,17,
				16,16,16,16,16,16,16,16,16,16,
				15,15,15,15,15,15,15,15,15,15,
				14,14,14,14,14,14,14,14,14,14];
			actionDic[GameConstants.CHARATOR_ATTACK_FLAG + direction] = actionList;
//			
			//右边
			direction = GameConstants.RIGHT;
			//行走
			actionList =new <int>[5,5,5,5,5,4,4,4,4,4,3,3,3,3,3,2,2,2,2,2];
			actionDic[GameConstants.CHARATOR_WALK_FLAG + direction] = actionList;
			
			//站立
			actionList = new <int>[9,9,9,9,9,8,8,8,8,8,7,7,7,7,7,6,6,6,6,6];
			actionDic[GameConstants.CHARATOR_STAND_FLAG + direction] = actionList;
			
			//攻击
			actionList = new <int>[19,19,19,19,19,19,19,19,19,19,
				18,18,18,18,18,18,18,18,18,18,
				17,17,17,17,17,17,17,17,17,17,
				16,16,16,16,16,16,16,16,16,16,
				15,15,15,15,15,15,15,15,15,15,
				14,14,14,14,14,14,14,14,14,14];
			actionDic[GameConstants.CHARATOR_ATTACK_FLAG + direction] = actionList;
			
			return actionDic;
		}
	}
}