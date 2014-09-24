package haua {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import ClassLoader;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	
	public class addhero extends MovieClip {

		private var thisStage:Object = new Object;
		private var heroObj:Object = new Object;
		
		static const heroStartX:uint = 615;//这个是用于设置人物随机出现的位置区间，因为chrome浏览器在页面没有完全加载的时候左下角会显示一行615px长的状态栏，挡住了视线。
		static const heroStartY:Number = 0.03;//这个是一个比例，英雄离地面的高度=场景的高度*heroStartY
		static const heroHeightScale= 80;//这是场景的高度-角色的高度的值，80就是对话框的高度。
		
		
		public function addhero() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}

		private function init(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			thisStage=this.stage;
			creatHero();
		}
		
		//注册角色
		function creatHero(){
			/*var hero:char1 = new char1();//在排版前先注册角色
			heroObj.mc=hero;
			heroObj.heroScale=heroObj.mc.height/heroObj.mc.width;//先载入好角色的宽高比例
			
			//角色的状态
			heroObj.moveLeft=false;
			heroObj.moveRight=false;
			
			heroObj.goTime=0;//动画每帧计算+1，播放到最后一帧时归零的垫脚石
			
			//角色的数值
			heroObj.moveSpeed=scene.mc.height/speedScale;
			
			heroObj.aGoSpeed=aGoSpeed;//动画的速度，越大越慢
			heroObj.aRun1=aRun1;
			heroObj.aRun2=aRun2;
			
			addChild(heroObj.mc);*/
			
			//加载外部角色
			var myHero:ClassLoader = new ClassLoader("char1.swf");   //加载char1.swf文件
			myHero.addEventListener(Event.COMPLETE, addHero);
			
		}
		
		function addHero(event:Event){
			var heroClass:Class = event.target.getClass("char1") as Class;
			var hero1:DisplayObject = new heroClass();
			heroObj.mc = hero1;
			
			heroObj.heroScale=heroObj.mc.height/heroObj.mc.width;//先载入好角色的宽高比例
			
			heroObj.mc.height = stage.stageHeight-heroHeightScale;
			heroObj.mc.width = heroObj.mc.height/heroObj.heroScale;
			heroObj.mc.y = stage.stageHeight * (1 - heroStartY);
			if(stage.stageWidth>heroStartX){heroObj.mc.x = Math.ceil(Math.random()*(scene.mc.width-heroStartX))+heroStartX-heroObj.mc.width;}//在场景中随机选择一个出现点
			else{heroObj.mc.x = Math.ceil(Math.random()*(scene.mc.width-heroObj.mc.width*2)+heroObj.mc.width)}
			
			//角色的状态
			heroObj.moveLeft=false;
			heroObj.moveRight=false;
			
			heroObj.goTime=0;//动画每帧计算+1，播放到最后一帧时归零的垫脚石
			
			//角色的数值
			heroObj.moveSpeed=stage.stageHeight/speedScale;
			
			heroObj.aGoSpeed=aGoSpeed;//动画的速度，越大越慢
			
			addChild(heroObj.mc);
			
			//加载swf中主场景中的变量。
			var myHeroVar:Loader = new Loader();
			myHeroVar.load(new URLRequest("char1.swf"));
			myHeroVar.contentLoaderInfo.addEventListener(Event.COMPLETE,loadVar);
			
		}
		
		function loadVar(evt:Event):void
		{
			var targetContent = evt.target.content;
			heroObj.aRun1=targetContent.aRun1;
			heroObj.aRun2=targetContent.aRun2;
			//trace(heroObj.aRun1);
		}
		

	}//class end
	
}
