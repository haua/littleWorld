module.exports = function(app) {
	return new Handler(app);
};

var Handler = function(app) {
		this.app = app;
};

var handler = Handler.prototype;

/**
 * 新用户登录服务器.
 *
 * @param  {Object}   msg     request message
 * @param  {Object}   session current session object
 * @param  {Function} next    next stemp callback
 * @return {Void}
 */
handler.enter = function(msg, session, next) {
	var self = this;
	var rid = msg.rid;//房间
	var uid = msg.username + '*' + rid;
	var userX = Math.ceil(Math.random()*msg.stageWidth);
	
	//获取sessionService，sessionService主要负责管理客户端连接session,
	//对session完成一些基本操作，包括创建session、session绑定用户id、获取session绑定的用户id等。
	var sessionService = self.app.get('sessionService');
	//如果sessionService根据uid可以获得session，说明当前用户和服务器已经建立连接，不能重复登录
	if( !! sessionService.getByUid(uid)) {
		next(null, {
			code: 500,
			error: true,
			message:'用户已登陆'
		});
		return;
	}

	session.bind(uid);//将session与该用户id建立一个映射关系， key -- value
	session.set('rid', rid);//给session添加一个属性， 提供用户更改session的机会。
	session.push('rid', function(err) {//session同步，在改变session之后需要同步，以后的请求处理中就可以获取最新session
		if(err){
			console.error('set rid for session service failed! error is : %j', err.stack);
		}
	});
	session.on('closed', onUserLeave.bind(null, self.app));//监听close事件，当监听到session为close状态时，调用onUserLeave()方法，该方法会通知同一channel的所有用户(需要客户端监听”onLeave”)，当前用户下线。

	//put user into channel。该方法会向同一channel中的所有用户发送事件："onAdd"，事件参数为当前加入频道的单个用户的user对象，此方法位于chatRemote.js中
	self.app.rpc.chat.chatRemote.add(session, uid, self.app.get('serverId'), rid, true, function(users){
		next(null, {
			users:users,
			userX:userX
		});
	});
};

/**
 * User log out handler
 *
 * @param {Object} app current application
 * @param {Object} session current session object
 *
 */
var onUserLeave = function(app, session) {
	if(!session || !session.uid) {
		return;
	}
	app.rpc.chat.chatRemote.kick(session, session.uid, app.get('serverId'), session.get('rid'), null);
};