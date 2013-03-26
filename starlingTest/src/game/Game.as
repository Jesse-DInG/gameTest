package game
{
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import Utils.DirectionType;
	
	import game.Obj.Arrow;
	import game.charactor.BaseCharactor;
	import game.charactor.CharactorManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.extensions.PDParticleSystem;
	import starling.extensions.ParticleSystem;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Game extends Sprite
	{
		public static var $stage:Stage;
		private var _charactor:BaseCharactor;
		private var _keyDowns:Dictionary = new Dictionary();
		
		private var _particleSystem:PDParticleSystem;
		
		private var _isKeyPress:Boolean;
		public function Game()
		{
			super();
			if(stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}

			addEventListener(starling.events.Event.ENTER_FRAME,__enterFrame);
			
		}
		
		private function init(event:Event = null):void
		{
			// TODO Auto Generated method stub
			$stage = stage;
			_charactor = new BaseCharactor("henry");
			_charactor.x = stage.stageWidth/2;
			_charactor.y = stage.stageHeight/2;
			_charactor.addEventListener("attack",__attack);
			addChild(_charactor);
			
//			var arra:Arrow = new Arrow("henry");
//			arra.x = 100;
//			arra.y= 100;
//			addChild(arra);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,__keyUp);
			initParticle();
		}
		
		private function initParticle():void
		{
				var fireConfig:XML = XML(new GameConstants.FireConfig());
				var fireTexture:Texture = Texture.fromBitmap(new GameConstants.FireParticle());
				if(!_particleSystem)
				_particleSystem = new PDParticleSystem(fireConfig, fireTexture);
//				_particleSystem
				//				mParticleSystem.emitterX = Math.ceil(_mc.width/2);
				//				mParticleSystem.emitterY = Math.ceil(_mc.height/2);
//				_particleSystem.start();
				
				addChild(_particleSystem);
				Starling.juggler.add(_particleSystem);
		}
		
		private function __attack(evt:Event):void
		{
			// TODO Auto Generated method stub
			var ch:BaseCharactor = evt.target as BaseCharactor;
			var arra:Arrow = new Arrow("henry");
			arra.side = ch.side;
			arra.x = ch.x+ch.side*20;
			arra.y = ch.y;
//			_particleSystem.stop();
//			_particleSystem.removeFromParent();
//			arra.addChild(_particleSystem);
//			_particleSystem.start();
			addChild(arra);
		}
		
		private function __complete(evt:Event):void
		{

			//			test();
		}
		
		private var _text:TextField;
		private var _movie:MovieClip;
		private var _list:Vector.<Texture>;
		private function test():void
		{
			_text = new TextField(100,100,"hello");
			addChild(_text);
			_list =  CharactorManager.instance.getCharactor("henry")[GameConstants.CHARATOR_MOVIE];
			_movie = new MovieClip(_list);
			_movie.x = 40;
			_movie.y = 40;
			addChild(_movie);
		}
		
		private var count:int = 0
		private function __enterFrame(evt:starling.events.Event):void
		{
			// TODO Auto Generated method stub
			if(!_charactor)return;
			count ++;
			
			var v:int;
			var h:int;
			
			if(_movie)
			{
				_text.text = int(count/60)+"";
				_movie.currentFrame = count/60;
			}
			if(_keyDowns[Keyboard.SPACE])
			{
				_charactor.attack();
			}
			else 
			{
				_charactor.direction = DirectionType.getDirection(_keyDowns);
				_charactor.walk();
			}
		}
		
		private function fixPosition(display:DisplayObject):void
		{
			var nx:Number;
			var ny:Number;
			if(display.x<0) display.x = 0;
			if(display.x> 800)display.x = 800;
			if(display.y<0)display.y = 0;
			if(display.y>600)display.y = 600;
		}
		
		private function __keyDown(evt:KeyboardEvent):void
		{
			// TODO Auto Generated method stub
			if(!_charactor)return;
			_keyDowns[evt.keyCode] = true;
			
			_charactor.direction = DirectionType.getDirection(_keyDowns);
			if(_keyDowns[Keyboard.SPACE])
			{
				_charactor.attack();
			}
			else 
			{
				
				_charactor.walk(true);
			}
		}
		
		private function __keyUp(evt:KeyboardEvent):void
		{
			// TODO Auto Generated method stub
			if(!_charactor)return;
			delete _keyDowns[evt.keyCode];
			_charactor.direction = DirectionType.getDirection(_keyDowns);
			_charactor.walk();
		}
		
	}
}