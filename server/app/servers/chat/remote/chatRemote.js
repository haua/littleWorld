/**
 * 远程事件，用于向客户端发出事件(广播事件)
 *
 */

module.exports = function(app) {
	return new ChatRemote(app);
};

var ChatRemote = function(app) {
	this.app = app;
	this.channelService = app.get('channelService');
};

/**
 * Add user into chat channel.
 *
 * @param {String} uid (userid)就是username*rid
 * @param {String} sid server id 服务器id
 * @param {String} name channel的名字，一般就是rid(roomID)
 * @param {boolean} flag flag用于控制是获取channel还是创建channel
 *
 */
ChatRemote.prototype.add = function(uid, sid, name, flag, cb) {
	var channel = this.channelService.getChannel(name, flag);//当flag为true且名为name的channel不存在，则会创建channel，否则返回名为name的channel
	var username = uid.split('*')[0];
	var param = {
		route: 'onAdd',//这里route就是客户端要监听的事件，我们可以自定义的route，然后在客户端使用pomelo.on(“onXXX”,cb)就能监听自定义的route
		user: username
	};
	channel.pushMessage(param);//将param发送到同一channel的所有用户，只要用户监听onAdd，就能收到登录用户的用户名username

	if( !! channel) {
		channel.add(uid, sid);//将userid和serverid放入channel中
	}

	cb(this.get(name, flag));//调用get()方法，向回调函数传入get()的返回结果（同一channel中的所有用户）
};

/**
 * Get user from chat channel.
 *
 * @param {Object} opts parameters for request
 * @param {String} name channel name
 * @param {boolean} flag channel parameter
 * @return {Array} users uids in channel
 *
 */
ChatRemote.prototype.get = function(name, flag) {
	var users = [];
	var channel = this.channelService.getChannel(name, flag);//获取名为name的channel
	if( !! channel) {
		users = channel.getMembers();//该channel下的所有uid和sid，这些id是由上面的这句 channel.add(uid, sid)添加进去的
	}
	for(var i = 0; i < users.length; i++) {
		users[i] = users[i].split('*')[0];
	}
	return users;
};

/**
 * Kick user out chat channel.
 *
 * @param {String} uid unique id for user
 * @param {String} sid server id
 * @param {String} name channel name
 *
 */
ChatRemote.prototype.kick = function(uid, sid, name) {
	var channel = this.channelService.getChannel(name, false);
	// leave channel
	if( !! channel) {
		channel.leave(uid, sid);
	}
	var username = uid.split('*')[0];
	var param = {
		route: 'onLeave',
		user: username
	};
	channel.pushMessage(param);
};
