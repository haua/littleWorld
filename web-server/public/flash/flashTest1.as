﻿package  {
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
	
	//自定义类
	import haua.Addhero;//自定义类的名字中间不能有大写！！！这个居然花了我一个多小时解决！！！
	
	public class flashTest1 extends MovieClip {
		
		private var heros:Array = new Array;//所有英雄的Object都会在这里，[0]是我的英雄
		
		
		
		private var dialogueMain:Object = new Object();//注册对话框
		
		
		
		//static const heroStartX:uint = 615;//这个是用于设置人物随机出现的位置区间，因为chrome浏览器在页面没有完全加载的时候左下角会显示一行615px长的状态栏，挡住了视线。
		//static const heroStartY:Number = 0.03;//这个是一个比例，英雄离地面的高度=场景的高度*heroStartY
		//static const heroHeightScale= 80;//这是场景的高度-角色的高度的值，80就是对话框的高度。
		
		//static const aRun1:uint=3;//跑步的第一帧
		//static const aRun2:uint=10;//跑步的最后一帧
		
		public static var scene:Object=new Object();//注册场景
		static const heightScale:Number=0.06;//背景/场景的值，最好小于0.1，用于设定场景的高度
		
		private var lastTime:uint = 0;//上一次记录的时间
		
		private var speakInputOpen:Boolean = false;//是否已打开对话输入框
		
		//在屏幕中显示文本用的
		private var testText:TextField=new TextField();
		private var textFormat:TextFormat=new TextFormat();//文本格式
		
		//英雄说话用到的
		var heroTalk:TextField = new TextField();
		
		
		public function flashTest1() {
			// constructor code 一开始就运行
			
			
			//设置swf在html中的缩放方式
			stage.scaleMode = StageScaleMode.NO_SCALE;//设置swf的缩放模式为不缩放
			stage.align = StageAlign.TOP_LEFT;//设置swf向左上对齐
			
			creatScene();
			
			/*//为了优化Addhero.as用的。
			var newHero:Addhero = new Addhero("haua1");
			stage.addChild(newHero);
			newHero.retuObj(function(obj:Object,i:String,ii:String){
				heros.push(obj);
				trace("我叫"+heros[0].name);
				//trace("有"+heros.length+"人，大家的名字： "+names);
			
			var newHero2:Addhero = new Addhero("haua2");
			stage.addChild(newHero2);
			newHero2.retuObj(function(obj:Object,i:String,ii:String){
				heros.push(obj);
				trace("我叫"+heros[0].name);
				//trace("有"+heros.length+"人，大家的名字： "+names);
			});
			
			});*/
			
			
			
			creatDialogue();
			startStageResize();//一开始就排好版
			
			stage.addEventListener(Event.RESIZE,stageResize);//如果窗口发生改变，版式也改变
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
			
			
			//addEventListener(Event.ACTIVATE,stageActivate);
			//addEventListener(Event.DEACTIVATE,stageLostActivate);
			
			stage.addEventListener(Event.ENTER_FRAME,mainLoop);//主循环
			
			login_mouseDownHandler();//登录
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
			for(var i:uint=0;i<heros.length;i++){
				
				var heroVector:Number = heros[i].mc.scaleX;//让角色向后看的时候变尺寸还能向后看
			
				heros[i].mc.height = stage.stageHeight-heros[i].heightScale;
				heros[i].mc.width = heros[i].mc.height/heros[i].heroScale;
				heros[i].mc.y = stage.stageHeight * (1 - heros[i].startY);
		
				if(heroVector<0){heros[i].mc.scaleX=-Math.abs(heros[i].mc.scaleX);}
				else{heros[i].mc.scaleX=Math.abs(heros[i].mc.scaleX);}
			
				
				
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
			addText("按下的代码是： "+event.keyCode,10,0);
			if(!speakInputOpen){
				IME.enabled=false;
				if (event.keyCode == 65||event.keyCode==37) {heros[0].moveLeft = true;}  //按下A
				if (event.keyCode == 68||event.keyCode==39) {heros[0].moveRight = true;} //按下D
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
					
						dialogueMain.mc.x = heros[0].mc.x - dialogueMain.mc.width/2;
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
			if (event.keyCode == 65||event.keyCode==37) {heros[0].moveLeft = false;}
			if (event.keyCode == 68||event.keyCode==39) {heros[0].moveRight = false;}
		}
		
		function goOnLoop(timeDiff:uint){
			
			
			//角色运动
			if(heros.length){
				//我的角色
				if((!heros[0].moveLeft&&!heros[0].moveRight)||(heros[0].moveLeft&&heros[0].moveRight)){
					heros[0].o=1;
				}
				else if(heros[0].moveLeft&&heros[0].mc.x>0)//向左
				{
					//物理移动
					heros[0].mc.scaleX=-Math.abs(heros[0].mc.scaleX);
					heros[0].mc.x-=timeDiff*heros[0].moveSpeed;
					//播放动画
					heros[0].goTime++;
					heros[0].o=uint(heros[0].goTime/heros[0].aGoSpeed+heros[0].aRun1);
					if(heros[0].o>heros[0].aRun2){heros[0].goTime=0;heros[0].o=heros[0].aRun1;}
				}
				else if(heros[0].moveRight==true&&heros[0].mc.x<stage.stageWidth)
				{
					//物理移动
					heros[0].mc.scaleX=Math.abs(heros[0].mc.scaleX);
					heros[0].mc.x+=timeDiff*heros[0].moveSpeed;
					//播放动画
					heros[0].goTime++;
					heros[0].o=uint(heros[0].goTime/heros[0].aGoSpeed+heros[0].aRun1);
					if(heros[0].o>heros[0].aRun2){heros[0].goTime=0;heros[0].o=heros[0].aRun1;}
				}
				heros[0].mc.gotoAndStop(heros[0].o);
				
				//如果我的角色状态变了，就告诉服务器
				judgeMyHeroState();
				
				//别人的角色
				for(var i:uint=1;i<heros.length;i++){
					var statu1:Boolean = heros[i].moveLeft&&heros[i].mc.x>0;//左移
					var statu2:Boolean = heros[i].moveRight;//右移
					if((statu1&&statu2)||(!statu1&&!statu2)){heros[i].o=0}
					else if(statu1||statu2){
						if(statu1){
							heros[i].mc.scaleX=-Math.abs(heros[i].mc.scaleX);
							heros[i].mc.x-=timeDiff*heros[i].moveSpeed;
						}
						else if(statu2){
							//物理移动
							heros[i].mc.scaleX=Math.abs(heros[i].mc.scaleX);
							heros[i].mc.x+=timeDiff*heros[i].moveSpeed;
						}
						//播放动画
						heros[i].goTime++;
						heros[i].o=uint(heros[i].goTime/heros[i].aGoSpeed+heros[i].aRun1);
						if(heros[i].o>heros[i].aRun2){heros[i].goTime=0;heros[i].o=heros[i].aRun1;}
						
					}
					
					heros[i].mc.gotoAndStop(heros[i].o);
					
					heroMoveTo(heros[i]);
				}
			}
			
		}//goonLoop end
		
		
		//场景获得/失去焦点
		function stageActivate(event:Event){
			testText.text = "得到焦点";
			}
		function stageLostActivate(event:Event){
			testText.text = "失去焦点";
			heros[0].moveLeft = false;
			heros[0].moveRight = false;
			}
		
		//***************************** 与服务器交互 *************************************************************************
		var serverIP:String = "172.23.8.119";//"192.168.199.155""127.0.0.1"
		
		var username:String = "haua" + Math.random();
		var pomelo:Pomelo = Pomelo.getIns();
		private var connected:Boolean = false;
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
 			 * @param route (gate.gateHandler.queryEntry 分别代表了服务器类型、服务端相应的文件名及对应的方法名，在服务器中的servers\gate\handler的js文件中有对应的响应)
 			 * @param msg
 			 * @param callback 服务器返回数据时会回调
			 public function request(route:String, msg:Object, callback:Function = null):void {}
 			*/
			pomelo.request("gate.gateHandler.queryEntry", {uid: 'test'}, function(response:Object):void{//向服务端请求连接，连接成功后会给分配服务器哦
				if (response.code == '500'){
					trace("登录时500错误："+response.message);
					return;
				}
				trace("分配的服务器是：", response.host, " 端口：", response.port);
				pomelo.init(response.host, response.port, null, function(response:Object):void{
					//
					roomID=room;
					pomelo.request("connector.entryHandler.enter", {username: username, rid: room, stageWidth:stage.stageWidth}, function(data:Object):void{//告诉服务器：登录人的id和房间号，这一步才是真正的登录
						
						//登录成功创建自己的角色
						var myHero:Addhero = new Addhero(username);
						stage.addChild(myHero);
						myHero.retuObj(function(obj:Object,i:String,ii:String){
							heros.unshift(obj);//把我的英雄添加到数组第一位
							heros[0].mc.x = data.userX;
							
							//创建别人的角色
							for(var h:uint=0;h<data.users.length;h++){
								if(data.users[h]!=heros[0].name)addSomeOne(data.users[h]);
							}
						});
						
						
						pomelo.addEventListener('onAdd', someoneIn);//添加其它用户
						pomelo.addEventListener('onLeave', someoneOut);//其它用户离开
						pomelo.addEventListener('onChat', someoneTalk);
						pomelo.addEventListener('onStartMove', someoneStartMove);
						pomelo.addEventListener('onEndMove', someoneEndMove);
						users=data.users;
						//currentState='chat';
					});
				});
			});
		}
		//添加用户
		function someoneIn(eve:PomeloEvent):void{
			addSomeOne(eve.message.user,eve.message.userX);
		}
		function someoneOut(eve:PomeloEvent):void{
			
			//users.removeItem(event.message.user);
			trace("离开前")
			users.splice(users.indexOf(eve.message.user),1);
			trace("离开了一个人，还有"+heros.length+"人");
		}
		//某人在说话
		function someoneTalk(eve:PomeloEvent):void{
			var obj:Object=eve.message;
			addText('用户' + obj.from + '说: ' + obj.msg);
		}
		
		//如果我的角色状态变了，就告诉服务器
		var myHeroLastState:Object = {moveLeft:false,moveRight:false};
		function judgeMyHeroState(){
			if(myHeroLastState.moveLeft == heros[0].moveLeft && myHeroLastState.moveRight == heros[0].moveRight){return;}
			
			var param:Object = new Object;
			
			if((!heros[0].moveLeft&&!heros[0].moveRight)||(heros[0].moveLeft&&heros[0].moveRight)){
				param.nowX = heros[0].mc.x;
				param.towards = heros[0].mc.scaleX>0?"right":"left";
				pomelo.request('chat.chatHandler.endMove', param , function(data:Object):void{
					trace("结束移动：成功告诉服务器：", JSON.stringify(data));
				});
			}
			else if((heros[0].moveLeft||heros[0].moveRight)&&heros[0].mc.x>0&&heros[0].mc.x<stage.stageWidth){
				//通知移动服务器
				if(heros[0].moveLeft){param.moveTowards = "left";}
				else {param.moveTowards = "right";}
				pomelo.request('chat.chatHandler.startMove', param , function(data:Object):void{
					trace("开始移动：成功告诉服务器：", JSON.stringify(data));
				});
			}
			
			
			myHeroLastState.moveLeft = heros[0].moveLeft;
			myHeroLastState.moveRight = heros[0].moveRight;
			
		}
		
		//某人开始移动
		function someoneStartMove(eve:PomeloEvent):void{
			if(heros.length<2)return
			
			var obj:Object=eve.message;
			if(obj.from==heros[0].name){trace("是自己在移动！！！");return}
			for(var i:uint=1;i<heros.length;i++){
				if(heros[i].name==obj.from){
					if(obj.moveTowards=="left"){heros[i].moveLeft = true ;heros[i].moveRight = false;}
					else if(obj.moveTowards=="right"){ heros[i].moveRight = true ;heros[i].moveLeft = false;}
					else{trace("根本不知道他在向着哪移动",JSON.stringify(obj));}
					break
				}
			}
		}
		//某人结束移动
		function someoneEndMove(eve:PomeloEvent):void{
			//trace("某人结束移动", JSON.stringify(eve.message));
			if(heros.length<2)return
			
			var obj:Object=eve.message;
			if(obj.from==heros[0].name){trace("是自己在移动！！！");return}
			for(var i:uint=1;i<heros.length;i++){
				if(heros[i].name==obj.from){
					gotoTheCoord(heros[i], obj.nowX, obj.nowTowards);
					trace(heros[i].targetX);
					break
				}
			}
		}
		
		function gotoTheCoord(hero:Object,targetX,towards){
			hero.moveLeft = hero.moveRight = false;
			hero.needToMove = true;
			hero.targetX = targetX;
			hero.towards = towards;
		}
		
		//让英雄移动到指定点的方法，每帧遍历所有英雄
		function heroMoveTo(hero:Object){
			if(!hero.needToMove)return
			
			if(hero.mc.x>hero.targetX+5){hero.moveLeft = true;hero.moveRight = false;}
			else if(hero.mc.x<hero.targetX-5){hero.moveRight = true;hero.moveLeft = false;}
			else{
				hero.moveRight = hero.moveLeft = hero.needToMove = false;
				if(hero.towards=="left"){hero.mc.scaleX=-Math.abs(hero.mc.scaleX);}
				else if(hero.towards=="right"){hero.mc.scaleX=Math.abs(hero.mc.scaleX);}
				else{trace("不知道此人最后面的朝向");}
			}
			//hero.targetX = targetX;
			//hero.towards = towards;
			
			
		}
		
		function sendMsg_clickHandler(event:MouseEvent):void{
			var target:String = '*';
			var speakText:String = '哈哈哈哈哈';
			if (target != '*')
				addText( '你对' + target + '说:' + speakText );
			pomelo.request('chat.chatHandler.send', {content: speakText, rid: roomID, target: target}, function(data:Object):void{
				trace(data);
			});
		}
		
		
		function leave_clickHandler(event:MouseEvent):void{
			pomelo.disconnect();
			//currentState='login';
			connected=false;
		}
		
		
		function addSomeOne(hname:String,heroX:uint=-1){
			var newHero:Addhero = new Addhero(hname);
			
			stage.addChild(newHero);
			newHero.retuObj(function(obj:Object,i:String,ii:String){
				if(heroX!=-1){obj.mc.x = heroX;}
				heros.push(obj);
				/*var names:String = new String;
				for(var h:uint=0;h<heros.length;h++){
					names=names.concat(heros[h].name+",");
				}
				trace("有"+heros.length+"人，大家的名字： "+names);*/
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
