package haua {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import ClassLoader;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class Addhero extends MovieClip {

		public static var thisStage:Object = new Object;
		public static var _hero:Addhero;
		public static var heroObj:Object = new Object;
		
		static const heroStartX:uint = 615;//这个是用于设置人物随机出现的位置区间，因为chrome浏览器在页面没有完全加载的时候左下角会显示一行615px长的状态栏，挡住了视线。
		static const heroStartY:Number = 0.03;//这个是一个比例，英雄离地面的高度=场景的高度*heroStartY
		static const heroHeightScale= 80;//这是场景的高度-角色的高度的值，80就是对话框的高度。
		
		static const speedScale:uint=1500;//横向移动速度比率，数值越小，速度越快。计算公式角色的移动速度=场景的高度÷speedScale。
		static const aGoSpeed:Number=1.5;//动画的速度，越大越慢
		
		
		public function Addhero() {
			// constructor code
			
			this.addEventListener(Event.ADDED_TO_STAGE, addToStage);
			
			
		}
		
		public static function returnHero(heroName:String):Addhero{
			_hero = new Addhero;
			
			heroObj.name = heroName;
			
			return _hero
		}
		
		public function addToStage(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			thisStage=this.stage;
			creatHero();
		}
		
		
		//注册角色
		public static function creatHero(){
			
			//加载外部角色
			var myHero:ClassLoader = new ClassLoader("char1.swf");   //加载char1.swf文件
			myHero.addEventListener(Event.COMPLETE, addHero);
			
		}
		
		public static function addHero(event:Event){
			var heroClass:Class = event.target.getClass("char1") as Class;
			var hero1:DisplayObject = new heroClass();
			heroObj.mc = hero1;
			
			heroObj.heroScale=heroObj.mc.height/heroObj.mc.width;//先载入好角色的宽高比例
			
			heroObj.mc.height = thisStage.stageHeight-heroHeightScale;
			heroObj.mc.width = heroObj.mc.height/heroObj.heroScale;
			heroObj.mc.y = thisStage.stageHeight * (1 - heroStartY);
			
			if(thisStage.stageWidth>heroStartX){//在场景中随机选择一个出现点
				heroObj.mc.x = Math.ceil(Math.random()*(thisStage.stageWidth-heroStartX))+heroStartX-heroObj.mc.width;
			}
			else{
				heroObj.mc.x = Math.ceil(Math.random()*(thisStage.stageWidth-heroObj.mc.width*2)+heroObj.mc.width);
			}
			
			//角色的状态
			heroObj.moveLeft=false;
			heroObj.moveRight=false;
			
			heroObj.goTime=0;//动画每帧计算+1，播放到最后一帧时归零的垫脚石
			
			
			//角色的数值
			heroObj.moveSpeed=thisStage.stageHeight/speedScale;
			
			heroObj.aGoSpeed=aGoSpeed;//动画的速度，越大越慢
			
			thisStage.addChild(heroObj.mc);
			
			//加载swf中主场景中的变量。
			var myHeroVar:Loader = new Loader();
			myHeroVar.load(new URLRequest("char1.swf"));
			myHeroVar.contentLoaderInfo.addEventListener(Event.COMPLETE,loadVar);
			
		}
		
		public static function loadVar(evt:Event):void{
			var targetContent = evt.target.content;
			heroObj.aRun1=targetContent.aRun1;
			heroObj.aRun2=targetContent.aRun2;
			//trace(heroObj.aRun1);
		}
		
		//*************************************** 外部调用的方法
		
		public function retuName(){
			return heroObj.name
		}
		
		public function retuObj(callback:Function=null){
			if(callback==null){
				return heroObj
			}
			else if(!heroObj.aRun2){
				addEventListener(Event.ENTER_FRAME,function(evt:Event){
					if(!!heroObj.aRun2){
						removeEventListener(evt.type,arguments.callee);
						callback.apply(null,[heroObj,"null","null"]);
					}
				});
			}
			
		}
		
		
		//*************************************** 外部调用的方法end

	}//class end
	
}
