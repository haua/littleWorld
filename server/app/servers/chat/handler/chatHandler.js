var chatRemote = require('../remote/chatRemote');

module.exports = function(app) {
	return new Handler(app);
};

var Handler = function(app) {
	this.app = app;
};

var handler = Handler.prototype;

/**
 * 用户发送信息
 *
 * @param {Object} msg message from client
 * @param {Object} session
 * @param  {Function} next next stemp callback
 *
 */
handler.send = function(msg, session, next) {
	var rid = session.get('rid');
	var username = session.uid.split('*')[0];//调用此接口的用户名
	var channelService = this.app.get('channelService');
	var param = {
		route: 'onChat',
		msg: msg.content,
		from: username,
		target: msg.target
	};
	channel = channelService.getChannel(rid, false);//通过用户的房间信息获取其所在频道

	//the target is all users
	if(msg.target == '*'){
		channel.pushMessage(param);//广播事件
	}
	//the target is specific user
	else {
		var tuid = msg.target + '*' + rid;//目标用户加房间号
		var tsid = channel.getMember(tuid)['sid'];
		channelService.pushMessageByUids(param, [{
			uid: tuid,
			sid: tsid
		}]);
	}
	next(null, {
		route: msg.route
	});
}
//用户开始移动的控制器
handler.startMove = function(msg, session, next){
	var moveTowards = msg.moveTowards;//移动的方向
	var target = msg.target;//信息传送的对象
	var username = session.uid.split('*')[0];
	var param = {
		route: 'onStartMove',
		moveTowards: moveTowards,
		from: username,
		target: target
	};
	
	var rid = session.get('rid');
	var channelService = this.app.get('channelService');
	channel = channelService.getChannel(rid, false);
	channel.pushMessage(param);//广播事件
	
	next(null, {
		result:true
	});
}
//用户结束移动的控制器
handler.endMove = function(msg, session, next){
	var nowX = msg.nowX;//用户最终的位置
	var nowTowards = msg.towards;//用户最终的脸朝向
	var target = msg.target;
	var username = session.uid.split('*')[0];
	var param = {
		route: 'onEndMove',
		nowX: nowX,
		nowTowards: nowTowards,
		from: username,
		target: target
	};
	
	var rid = session.get('rid');
	var channelService = this.app.get('channelService');
	channel = channelService.getChannel(rid, false);
	channel.pushMessage(param);//广播事件
	
	next(null, {//如果客户端收不到信息，表示断线了
		result:true
	});
}



