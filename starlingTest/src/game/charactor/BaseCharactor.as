package game.charactor
{
	import flash.utils.Dictionary;
	
	import Utils.DirectionType;
	
	import game.GameConstants;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class BaseCharactor extends Sprite
	{
		public var stylename:String;
		
		private var _direction:int;
		private var _side:int = 1;//左右
		private var _speedX:Number;
		private var _speedY:Number;
		private var _currentState:int;
		
		private var _frames:Dictionary;
		
		private var _body:MovieClip;
		
		private var _currentFrameList:Vector.<int>;
		private var _tickCount:int;
		
		private var _isAttacking:Boolean;
		private var _callBack:Function;
		private var _delayState:int;
		public function BaseCharactor(stylename:String)
		{
			this.stylename = stylename;
			CharactorManager.instance.initCharactorAsset(stylename,init);

		}
		
		private function init(frames:Dictionary):void
		{
			_frames = frames;
			_body = new MovieClip(_frames[GameConstants.CHARATOR_MOVIE]);
			_body.stop();
			_body.x = Math.ceil(-_body.width/2);
			_body.y = Math.ceil(-_body.height/2);
			starling.core.Starling.juggler.add(_body);
			addChild(_body);
			
			_currentFrameList = _frames[getActionType()];
			initEvent();
		}
		
		public function get currentState():int
		{
			return _currentState;
		}
		
		public function setcurrentState(value:int,rightNow:Boolean = false):void
		{
			if(rightNow)
			{
				setStateImmediately(value);
			}
			else
			{
				_delayState = value;
				_callBack = setStateDelay;
			}
		}
		
		
		private function setStateDelay(value:int):void
		{
			_currentState = value;
			_tickCount = 0;
			_currentFrameList = _frames[getActionType()];
			_callBack = null;
		}
		
		public function setStateImmediately(value:int):void
		{
			if(_currentState == value)return;
			_currentState = value;
			_currentFrameList = _frames[getActionType()];
			_callBack = null;
		}
		
		protected function initEvent():void
		{
			addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		private function __enterFrame():void
		{
			_body.currentFrame = _currentFrameList[_tickCount%_currentFrameList.length] + (_side>0?70:0);
			if(_currentState == GameConstants.CHARATOR_WALK_TYPE)
			{
				x+=DirectionType.getHorizontalDirection(_direction)*5;
				y+=DirectionType.getVerticalDirection(_direction)*3;
			}
			if(_tickCount%_currentFrameList.length == _currentFrameList.length-1)
			{
				if(_callBack!=null)_callBack(_delayState);
			}
			if(_currentState == GameConstants.CHARATOR_ATTACK_TYPE)
			{
				trace(_body.currentFrame);
				if(_tickCount%_currentFrameList.length == 45)
				{
					dispatchEvent(new Event("attack"));
				}
			}
			
			_tickCount++;
		}
		
		private function getActionType():String
		{
			var flag:String;
			var sideFlag:String = _side>0?GameConstants.RIGHT:GameConstants.LEFT;
//			_body.scaleX = _side;
			switch(_currentState)
			{
				case GameConstants.CHARATOR_STAND_TYPE:
					flag = GameConstants.CHARATOR_STAND_FLAG + sideFlag;
					break;
				
				case GameConstants.CHARATOR_WALK_TYPE:
					flag = GameConstants.CHARATOR_WALK_FLAG + sideFlag;
					break;
				
				case GameConstants.CHARATOR_ATTACK_TYPE:
					flag = GameConstants.CHARATOR_ATTACK_FLAG + sideFlag;
					break;
			}
			return flag;
		}
		
		public function attack():void
		{
			setStateImmediately(GameConstants.CHARATOR_ATTACK_TYPE);
		}
		
		public function walk(rightNow:Boolean = false):void
		{
			if(direction > 0)
			{
				setcurrentState(GameConstants.CHARATOR_WALK_TYPE,rightNow);
			}
			else
			{
				setcurrentState(GameConstants.CHARATOR_STAND_TYPE,rightNow);
			}
		}
		
		private function attackEnd():void
		{
			
		}
		
		public function get direction():int
		{
			return _direction;
		}
		
		public function set direction(value:int):void
		{
//			if(value == 0) return;
			_direction = value;
			var hd:int = DirectionType.getHorizontalDirection(_direction);
			if(hd!=0)_side = hd;
		}

		public function get side():int
		{
			return _side;
		}

		public function set side(value:int):void
		{
			_side = value;
		}

		
	}
}