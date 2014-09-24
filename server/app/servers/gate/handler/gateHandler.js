//此js的作用是给客户点分配服务器

var dispatcher = require('../../../util/dispatcher');

module.exports = function(app) {
	return new Handler(app);
};

var Handler = function(app) {
	this.app = app;
};

var handler = Handler.prototype;

/**
 * Gate handler that dispatch user to connectors.
 *
 * @param {Object} msg message from client
 * @param {Object} session
 * @param {Function} next next stemp callback
 *
 */
handler.queryEntry = function(msg, session, next) {
	var uid = msg.uid;//登录时客户端中{uid:'test'}，这个值是随意的，但是最好是用户的用户名
	if(!uid){
		next(null, {
			code: 500,
            message: '请先登录再连接'
		});
		return;
	}
	// 这里获取的就是connector服务器，具体服务器的配置是位于game-server\config\servers.json
	var connectors = this.app.getServersByType('connector');
	if(!connectors || connectors.length === 0) {//判断connectors是否合法，否则返回500（服务器错误）
		next(null, {
			code: 500
		});
		return;
	}
	// select connector
	var res = dispatcher.dispatch(uid, connectors);//根据用户名uid和connectors数组，获取其中一个connector服务器，dispatcher.dispatch()方法在此页第一行引入
	next(null, {
		code: 200,
		host: res.host,//分配的服务器的url
		port: res.clientPort//分配的服务器的端口
	});
};
