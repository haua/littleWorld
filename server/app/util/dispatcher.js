var crc = require('crc');
//专门用于给客户端分配服务器的。
module.exports.dispatch = function(uid, connectors) {
	var index = Math.abs(crc.crc32(uid)) % connectors.length;//根据传入的uid随机生成的数再与connectors的长度取模(求余数)得到的所要的connector在数组的索引。
	return connectors[index];
};