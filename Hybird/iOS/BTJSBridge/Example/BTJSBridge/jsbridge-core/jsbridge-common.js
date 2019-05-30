/** 
jsbridge-common.js

假如有一些通用的bridge消息需求，比如日志/获取设备信息/屏幕锁屏监听/屏幕，各种Common相关的需求代码，都放到这里
*/

var Common = function () {
    this.webviewAppearEvent = 'webviewAppear';
    this.webviewDisappearEvent = 'webviewDisappear';
    this.applicationEnterBackgroundEvent = 'applicationEnterBackground';
    this.applicationEnterForegroundEvent = 'applicationEnterForeground';
};

// dataDic为Object对象
Common.nativeLog = function (dataDic) {
    var params = {};
    params.dataDic = dataDic;
    this.sendCommonMessage('nativeLog', params);
},

// traceData为字符串
Common.crashTrace = function (traceData) {
    var params = {};
    params.data = traceData;
    this.sendCommonMessage('crashTrace', params);
},
// 复制剪切板
Common.copyContent = function (content) {
    var params = {};
    params.str = content;
    this.sendCommonMessage('copyContent', params);
},
//获取设备一些通用信息
Common.getCommonParams = function (callback) {
    this.sendCommonMessage('commonParams', {}, callback);
},
// common模块的基础类，选用同样的 handler name => Common
Common.sendCommonMessage: function (action, params, callback) {
    var msgBody = {};
    msgBody.handler = 'Common';
    msgBody.action = action;
    msgBody.params = params;
    window.bridge.Core.sendMessage(msgBody, callback);
}
window.bridge.Common = Common;

