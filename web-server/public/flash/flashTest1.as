package  {
	import flash.system.IME;//检测输入法
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	//import flash.events.KeyboardEvent;
	import flash.events.*;
	import flash.text.*;
	//import flash.filters.DropShadowFilter;
	import flash.utils.getTimer;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import ClassLoader;
	import flash.display.DisplayObject;
	
	//pomelo
	import org.idream.pomelo.Pomelo;
	import org.idream.pomelo.PomeloEvent;
	//跨域相关
	import flash.system.Security;
	
	public class flashTest1 extends MovieClip {
		
		private var hero1:Object = new Object();//注册角色Object
		private var dialogueMain:Object = new Object();//注册对话框
		
		static const heroStartX:uint = 615;//这个是用于设置人物随机出现的位置区间，因为chrome浏览器在页面没有完全加载的时候左下角会显示一行615px长的状态栏，挡住了视线。
		static const heroStartY:Number = 0.03;//这个是一个比例，英雄离地面的高度=场景的高度*heroStartY
		static const heroHeightScale= 80;//这是场景的高度-角色的高度的值，80就是对话框的高度。
		
		static const speedScale:uint=1500;//横向移动速度比率，数值越小，速度越快。计算公式角色的移动速度=场景的高度÷speedScale。
		static const aGoSpeed:Number=1.5;//动画的速度，越大越慢
		//static const aRun1:uint=3;//跑步的第一帧
		//static const aRun2:uint=10;//跑步的最后一帧
		
		private var scene:Object=new Object();//注册场景
		static const heightScale:Number=0.06;//背景/场景的值，最好小于0.1，用于设定场景的高度
		
		private var lastTime:uint = 0;//上一次记录的时间
		
		private var speakInputOpen:Boolean = false;//是否已打开对话输入框
		
		//在屏幕中显示文本用的
		private var testText:TextField=new TextField();
		private var textFormat:TextFormat=new TextFormat();//文本格式
		
		//英雄说话用到的
		var heroTalk:TextField = new TextField();
		
		public function flashTest1() {
			// constructor code一开始就运行
			
			//设置swf在html中的缩放方式
			stage.scaleMode = StageScaleMode.NO_SCALE;//设置swf的缩放模式为不缩放
			stage.align = StageAlign.TOP_LEFT;//设置swf向左上对齐
			
			creatScene();
			creatHero();
			creatDialogue();
			startStageResize();//一开始就排好版
			
			stage.addEventListener(Event.RESIZE,stageResize);//如果窗口发生改变，版式也改变
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
			
			addEventListener(Event.ACTIVATE,stageActivate);
			addEventListener(Event.DEACTIVATE,stageLostActivate);
			
			stage.addEventListener(Event.ENTER_FRAME,mainLoop);//主循环
			
			login_mouseDownHandler();//登录
		}
		//注册角色
		function creatHero(){
			/*var hero:char1 = new char1();//在排版前先注册角色
			hero1.mc=hero;
			hero1.heroScale=hero1.mc.height/hero1.mc.width;//先载入好角色的宽高比例
			
			//角色的状态
			hero1.moveLeft=false;
			hero1.moveRight=false;
			
			hero1.goTime=0;//动画每帧计算+1，播放到最后一帧时归零的垫脚石
			
			//角色的数值
			hero1.moveSpeed=scene.mc.height/speedScale;
			
			hero1.aGoSpeed=aGoSpeed;//动画的速度，越大越慢
			hero1.aRun1=aRun1;
			hero1.aRun2=aRun2;
			
			addChild(hero1.mc);*/
			
			//加载外部角色
			var myHero:ClassLoader = new ClassLoader("char1.swf");   //加载char1.swf文件
			myHero.addEventListener(Event.COMPLETE, addHero);
			
		}
		
		function addHero(event:Event){
			var heroClass:Class = event.target.getClass("char1") as Class;
			var hero:DisplayObject = new heroClass();
			hero1.mc = hero;
			
			hero1.heroScale=hero1.mc.height/hero1.mc.width;//先载入好角色的宽高比例
			
			hero1.mc.height = stage.stageHeight-heroHeightScale;
			hero1.mc.width = hero1.mc.height/hero1.heroScale;
			hero1.mc.y = stage.stageHeight * (1 - heroStartY);
			if(stage.stageWidth>heroStartX){hero1.mc.x = Math.ceil(Math.random()*(scene.mc.width-heroStartX))+heroStartX-hero1.mc.width;}//在场景中随机选择一个出现点
			else{hero1.mc.x = Math.ceil(Math.random()*(scene.mc.width-hero1.mc.width*2)+hero1.mc.width)}
			
			//角色的状态
			hero1.moveLeft=false;
			hero1.moveRight=false;
			
			hero1.goTime=0;//动画每帧计算+1，播放到最后一帧时归零的垫脚石
			
			//角色的数值
			hero1.moveSpeed=stage.stageHeight/speedScale;
			
			hero1.aGoSpeed=aGoSpeed;//动画的速度，越大越慢
			
			addChild(hero1.mc);
			
			//加载swf中主场景中的变量。
			var myHeroVar:Loader = new Loader();
			myHeroVar.load(new URLRequest("char1.swf"));
			myHeroVar.contentLoaderInfo.addEventListener(Event.COMPLETE,loadVar);
			
		}
		
		function loadVar(evt:Event):void
		{
			var targetContent = evt.target.content;
			hero1.aRun1=targetContent.aRun1;
			hero1.aRun2=targetContent.aRun2;
			//trace(hero1.aRun1);
		}
			
		//注册场景
		function creatScene(){
			var scene2:background1 = new background1();//在排版前先注册场景
			scene.mc=scene2;
			
			scene.heightScale = heightScale;
			
			scene.mc.height=stage.stageHeight*scene.heightScale;
			scene.mc.width=stage.stageWidth;
			scene.mc.x=0;
			scene.mc.y=stage.stageHeight-scene.mc.height;
			
			addChild(scene.mc);
			}
		
		//注册对话气泡
		function creatDialogue(){
			var myDialogue:ClassLoader = new ClassLoader("dialogue1.swf");   //加载swf文件
			myDialogue.addEventListener(Event.COMPLETE,addDialogue);
		}
		function addDialogue(event:Event){
			var dialogue1:Class = event.target.getClass("dialogue_1") as Class;
			var dialogue0:DisplayObject = new dialogue1();
			dialogueMain.mc1 = dialogue0;
			
			dialogue1 = event.target.getClass("dialogue_2") as Class;
			dialogue0 = new dialogue1();
			dialogueMain.mc2 = dialogue0;
			
			dialogue1 = event.target.getClass("dialogue_3") as Class;
			dialogue0 = new dialogue1();
			dialogueMain.mc3 = dialogue0;
			
			dialogue1 = event.target.getClass("dialogue_2") as Class;
			dialogue0 = new dialogue1();
			dialogueMain.mc4 = dialogue0;
			
			dialogue1 = event.target.getClass("dialogue_1") as Class;
			dialogue0 = new dialogue1();
			dialogueMain.mc5 = dialogue0;
			
			dialogueMain.mc1.x = 0;
			dialogueMain.mc1.y = dialogueMain.mc2.y = dialogueMain.mc3.y = dialogueMain.mc4.y = dialogueMain.mc5.y = 0;
			
			dialogueMain.mc2.x = dialogueMain.mc1.x + dialogueMain.mc1.width;
			//dialogueMain.mc2.y = dialogueMain.mc1.y;
			dialogueMain.mc2.width = dialogueMain.mc4.width = 50;
			
			dialogueMain.mc3.x = dialogueMain.mc2.x + dialogueMain.mc2.width;
			//dialogueMain.mc3.y = dialogueMain.mc1.y;
			
			dialogueMain.mc4.x = dialogueMain.mc3.x + dialogueMain.mc3.width;
			//dialogueMain.mc4.y = dialogueMain.mc1.y;
			//dialogueMain.mc4.width = dialogueMain.mc2.width;
			
			dialogueMain.mc5.x = dialogueMain.mc4.x + dialogueMain.mc4.width + dialogueMain.mc5.width;
			//dialogueMain.mc5.y = dialogueMain.mc1.y;
			dialogueMain.mc5.scaleX = -dialogueMain.mc1.scaleX;
			
			var empty:empty_mc = new empty_mc();//注册一个主mc来放入对话气泡的切片
			dialogueMain.mc = empty;
			dialogueMain.mc.x = -100;
			dialogueMain.mc.y = -100;
			
			addChild(dialogueMain.mc);
			dialogueMain.mc.addChild(dialogueMain.mc1);
			dialogueMain.mc.addChild(dialogueMain.mc2);
			dialogueMain.mc.addChild(dialogueMain.mc3);
			dialogueMain.mc.addChild(dialogueMain.mc4);
			dialogueMain.mc.addChild(dialogueMain.mc5);
			}
			
		function stageResize(event:Event){
			startStageResize();
			}
		//每次场景大小变动，都会运行。
		function startStageResize(){
			//场景
			scene.mc.height=stage.stageHeight*scene.heightScale;
			scene.mc.width=stage.stageWidth;
			scene.mc.x=0;
			scene.mc.y=stage.stageHeight-scene.mc.height;
			//角色
			if(hero1.mc!=null){
				var heroVector:Number = hero1.mc.scaleX;//让角色向后看的时候变尺寸还能向后看
			
				hero1.mc.height = stage.stageHeight-heroHeightScale;
				hero1.mc.width = hero1.mc.height/hero1.heroScale;
				hero1.mc.y = stage.stageHeight * (1 - heroStartY);
			
				if(heroVector<0){hero1.mc.scaleX=-Math.abs(hero1.mc.scaleX);}
				else{hero1.mc.scaleX=Math.abs(hero1.mc.scaleX);}
			
				hero1.moveSpeed=stage.stageHeight/speedScale;
				}
			}
		
		function mainLoop(event:Event){
			//得出上一帧到这帧所花的时间，如果上一帧到这一帧什么都没变
			if (lastTime == 0) {lastTime = getTimer();}
			var timeDiff:uint = getTimer()-lastTime;
			lastTime += timeDiff;
			if(timeDiff != 0){
				goOnLoop(timeDiff);
				}
			}
		
		function keyDownFunction(event:KeyboardEvent){
			//检测输入法,并关掉(中文输入状态下的event.keyCode都等于229的)
			testText.text= "按下的代码是： "+event.keyCode;
			if(!speakInputOpen){
				IME.enabled=false;
				if (event.keyCode == 65||event.keyCode==37) {hero1.moveLeft = true;}  //按下A
				if (event.keyCode == 68||event.keyCode==39) {hero1.moveRight = true;} //按下D
			}
			//按下ctrl+回车、shift+回车、alt+回车
			if(dialogueMain.mc!=null||dialogueMain.mc!=undefined){
				if(event.keyCode == 13){
					if(speakInputOpen){//这里要让对话框对外输出文字，然后经过一定时间把对话框去掉
						dialogueMain.mc.visible = false;//隐藏输入框的样式
						//dialogueMain.mc.removeChild(heroTalk);//移除输入框的文本框
						
						
						speakInputOpen = false;
						
						stage.focus = stage;
					}
					else{//这里要显示对话框
						speakInputOpen = true;
					
						dialogueMain.mc.x = hero1.mc.x - dialogueMain.mc.width/2;
						dialogueMain.mc.y = 0;
						
						dialogueMain.mc.visible = true;//显示输入框的样式
						
						if(speakInputOpen){IME.enabled=true;}
						
						//下面是对话框里的输入框
						var textFormat:TextFormat = new TextFormat;
						textFormat.size = 16;
						heroTalk.defaultTextFormat = textFormat;
						heroTalk.text = "";
						heroTalk.type = TextFieldType.INPUT;
						heroTalk.border = true;
						//heroTalk.borderColor = 0x000000;
						heroTalk.height = 22;
						heroTalk.width = 180;
						heroTalk.x = 13;
						heroTalk.y = 20;
  
						//heroTalk.autoSize = TextFieldAutoSize.CENTER;
						heroTalk.wordWrap = false;
               
						dialogueMain.mc.addChild(heroTalk);
						
						stage.focus = heroTalk;//让输入框成为焦点
					}
				}
			}
			
		}
		function keyUpFunction(event:KeyboardEvent){
			if (event.keyCode == 65||event.keyCode==37) {hero1.moveLeft = false;}
			if (event.keyCode == 68||event.keyCode==39) {hero1.moveRight = false;}
			}
		
		function goOnLoop(timeDiff:uint){
			
			//在页面中显示信息
			testText.defaultTextFormat=textFormat;
			
			testText.x=10;
			testText.y=0;
			//testText.border=true;
			//testText.width=1000;
			testText.height=20;
			testText.autoSize = TextFieldAutoSize.CENTER;   
            testText.wordWrap = true;
			testText.text=String(heroTalk.scrollV);
			addChild(testText);
			
			
			//角色运动
			if(hero1.mc!=null||hero1.mc!=undefined){
				if((!hero1.moveLeft&&!hero1.moveRight)||(hero1.moveLeft&&hero1.moveRight)){
					hero1.o=1;
					}
				else if(hero1.moveLeft&&hero1.mc.x>0)//向左
				{
					//物理移动
					hero1.mc.scaleX=-Math.abs(hero1.mc.scaleX);
					hero1.mc.x-=timeDiff*hero1.moveSpeed;
					//播放动画
					hero1.goTime++;
					hero1.o=uint(hero1.goTime/hero1.aGoSpeed+hero1.aRun1);
					if(hero1.o>hero1.aRun2){hero1.goTime=0;hero1.o=hero1.aRun1;}
				}
				else if(hero1.moveRight==true&&hero1.mc.x<stage.stageWidth)
				{
					//物理移动
					hero1.mc.scaleX=Math.abs(hero1.mc.scaleX);
					hero1.mc.x+=timeDiff*hero1.moveSpeed;
					//播放动画
					hero1.goTime++;
					hero1.o=uint(hero1.goTime/hero1.aGoSpeed+hero1.aRun1);
					if(hero1.o>hero1.aRun2){hero1.goTime=0;hero1.o=hero1.aRun1;}
				}
				hero1.mc.gotoAndStop(hero1.o);
			}
		}
		
		//场景获得/失去焦点
		function stageActivate(event:Event){
			testText.text = "得到焦点";
			}
		function stageLostActivate(event:Event){
			testText.text = "失去焦点";
			hero1.moveLeft = false;
			hero1.moveRight = false;
			}
		
		//***************************** 登录
		var serverIP:String = "172.23.8.119";//"127.0.0.1"
		
		var pomelo:Pomelo = Pomelo.getIns();
		private var connected:Boolean = false;
		var username:String = "haua" + Math.random();
		var room:String = "myRoom";
		var roomID:String;
		private var users:Array;
		
		
		
		function login_mouseDownHandler():void{
			if (!connected)
				connect();
			else
				doLogin();
		}
		
		function connect():void{
			/**
			 * 初始化客户端，并尝试连接服务器
			 * @param host
			 * @param port 端口
			 * @param user 客户端与服务器之间的自定义数据
			 * @param callback 当连接成功会调用此方法
			 public function init(host:String, port:int, user:Object = null, callback:Function = null):void {}
			*/
			pomelo.init(serverIP, 3014, null, function(response:Object):void{
				if (response.code == 200){
					connected=true;
					if (username && room){
						doLogin();
						}
				}
				else addText("连接服务器失败:response.code=", response.code);
			});
			
		}
		
		function doLogin():void{
			/**
 			 * 向服务器请求数据
 			 * @param route
 			 * @param msg
 			 * @param callback 服务器返回数据时会回调
			 public function request(route:String, msg:Object, callback:Function = null):void {}
 			*/
			pomelo.request("gate.gateHandler.queryEntry", {uid: 'test'}, function(response:Object):void{
				trace("反应主机：", response.host, " 端口：", response.port);
				if (response.code == '500'){
					trace("登录时500错误："+response.message);
					return;
				}
				pomelo.init(response.host, response.port, null, function(response:Object):void{
					trace("登录后的response:"+response);
					var route:String="connector.entryHandler.enter";
					roomID=room;
					pomelo.request(route, {username: username, rid: room}, function(data:Object):void{
						addText(data.users);
						/*pomelo.addEventListener('onAdd', addUserHandler);
						pomelo.addEventListener('onLeave', removeUserHandler);
						pomelo.addEventListener('onChat', chatHandler);
						users=new ArrayCollection(data.users);
						currentState='chat';*/
					});
				});
			});
		}
		//***************************** 登录end
		
		//在屏幕中显示能修改，能操作的文字，
		//text0：填充的文本，tx和ty：文本的位置，variableName：文本的变量名（表示把文本存储到这个变量.text里），colo颜色,ts:字体大小，tWidth:文本框宽度,tHeight:文本框高度
		function addText(text0:String="",tx:uint=10,ty:uint=10,addTo:Sprite=null,variableName:TextField=null,colo:Number=0x282828,ts:uint=12,tWidth:Number=0,tHeight:Number=0,tAlign:String="left",canSelect:Boolean=false)
		{
			//removeEventListener(Event.ADDED_TO_STAGE, addText2);
			
			//判断是否addChild
			if(variableName==null){
				variableName=new TextField();
			}
			var textFormat1:TextFormat=new TextFormat();
			textFormat1.size=ts;
			textFormat1.color=colo;
			textFormat1.font = "SimSun";
			
			
			
			if(tAlign=="right"){textFormat1.align = TextFormatAlign.RIGHT;}
			else if(tAlign=="center"){textFormat1.align = TextFormatAlign.CENTER;}
			else{textFormat1.align = TextFormatAlign.LEFT;}
			
			variableName.defaultTextFormat=textFormat1;//这句话必须在textFormat1定义全部完之后写，但是又必须在variableName开始定义之前写...
			
			//
			if(tWidth!=0){
				variableName.width=tWidth;
				if(tHeight!=0){
					variableName.height=tHeight;
				}
			}
			else{
				variableName.autoSize = TextFieldAutoSize.LEFT;
				}
			
			
			if(text0==""||text0==null){variableName.text = "无文字"}
			else{variableName.text=text0;}
			if(!canSelect)variableName.selectable=false;//文字是否能被框选（默认true）
			//variableName.border=true;//显示文本边界线（默认false）
			
			variableName.x=tx;
			variableName.y=ty;
			
			if(!addTo){stage.addChild(variableName);}
			else{
				addTo.addChild(variableName);
			}
		}
		
		
	}//类end
}
