package game.Obj
{
	import flash.utils.Dictionary;
	
	import Utils.ObjectUtils;
	
	import game.GameConstants;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.textures.Texture;
	
	public class Arrow extends Sprite
	{
		private var mParticleSystems:Vector.<ParticleSystem>;
		private var mParticleSystem:ParticleSystem;
		
		private var _direction:int;
		private var _side:int;//左右
		private var _speedX:Number = 10;
		private var _speedY:Number = -5;
		private var _va:Number = 40/147;
		private var _currentState:int;
		private var _currentFrameList:Vector.<int>;
		private var _tickCount:int;
		
		private var _type:int;
		
		private var _frames:Dictionary;
		
		private var _styleName:String;
		private var _mc:MovieClip;
		public function Arrow(name:String)
		{
			_styleName = name;
			ObjManager.instance.initObjAsset(_styleName,init);
		}
		private function init(frames:Dictionary):void
		{
			_frames = frames;
			_mc = new MovieClip(_frames[GameConstants.ARROW_FLAG]);
			_mc.stop();
			_mc.x = Math.ceil(-_mc.width/2);
			_mc.y = Math.ceil(-_mc.height/2);
			starling.core.Starling.juggler.add(_mc);
			addChild(_mc);
			
			_currentFrameList = _frames[getActionType()];
			initEvent();
			
			if(!mParticleSystem)
			{
				var fireConfig:XML = XML(new GameConstants.FireConfig());
				var fireTexture:Texture = Texture.fromBitmap(new GameConstants.FireParticle());
				mParticleSystem = new PDParticleSystem(fireConfig, fireTexture);
				
//				mParticleSystem.emitterX = Math.ceil(_mc.width/2);
//				mParticleSystem.emitterY = Math.ceil(_mc.height/2);
				mParticleSystem.start();
				
				addChild(mParticleSystem);
				Starling.juggler.add(mParticleSystem);
			}


		}
		
		protected function initEvent():void
		{
			addEventListener(Event.ENTER_FRAME,__enterFrame);
		}
		
		private function __enterFrame():void
		{
			_mc.currentFrame = _currentFrameList[_tickCount%_currentFrameList.length] + (_side>0?30:0);
			_mc.x += _side*_speedX;
 			_speedY+=_va;
			_mc.y += _speedY;
			
//			mParticleSystem.emitterX = _mc.x;
//			mParticleSystem.emitterY = _mc.y;
			if(_tickCount%_currentFrameList.length == _currentFrameList.length-1)
			{
				dispose();
			}
			_tickCount++;
		}
		
		private function getActionType():String
		{
			var flag:String;
			var sideFlag:String = _side>0?GameConstants.RIGHT:GameConstants.LEFT;
			//			_body.scaleX = _side;
			switch(_type)
			{
				case 0:
					flag = GameConstants.ARROW_NORMAL + sideFlag;
					break;
				
//				case GameConstants.CHARATOR_WALK_TYPE:
//					flag = GameConstants.CHARATOR_WALK_FLAG + sideFlag;
//					break;
//				
//				case GameConstants.CHARATOR_ATTACK_TYPE:
//					flag = GameConstants.CHARATOR_ATTACK_FLAG + sideFlag;
//					break;
			}
			return flag;
		}
		public override function dispose():void
		{
			Starling.juggler.remove(mParticleSystem);
			mParticleSystem.stop();
			mParticleSystem.removeFromParent();
			mParticleSystem = null;
			super.dispose();
			removeEventListener(Event.ENTER_FRAME,__enterFrame);
			
			ObjectUtils.disposeDic(_frames);
			_frames = null;
			if(parent)parent.removeChild(this);
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