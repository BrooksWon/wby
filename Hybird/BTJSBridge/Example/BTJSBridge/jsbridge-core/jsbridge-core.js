/** 
jsbridge-core.js

所有底层通信的相关代码能力，都会放到core这个js代码里，也就是各种核心通信框架代码
*/

var Core = function () {
    this.ua = navigator.userAgent;
    this.isAndroid = (/(Android);?[\s\/]+([\d.]+)?/.test(this.ua));
    this.isIOS = !!this.ua.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/);
    this.msgCallbackMap = {};
    this.eventCallMap = {};
    this.sendMessage = function(xxxx){xxxx};
    this.onListenEvent = function(xxxx){xxxx};
    this.eventDispatcher = function(xxxx){xxxx};
    this.callbackDispatcher = function(xxxx){xxxx};
};
window.bridge.Core = Core;

//////////////////
sendMessage: function (data,callback) {
    if (callback && typeof (callback) === 'function') {
        var callbackid = this.getNextCallbackID();
        this.msgCallbackMap[callbackid] = callback;
        params.callbackId = callbackid;
        params.callbackFunction = 'window.callbackDispatcher';
    }
    
    if (this.isIOS) {
        try {
                                 //data-json string
            window.webkit.messageHandlers.BTJSBridge.postMessage(data);
        }
        catch (error) {
            console.log('error native message');
        }
    }

    if (this.isAndroid) {
        try {
            prompt(JSON.stringify([data]));
        }
        catch (error) {
            console.log('error native message');
        }
    }
},

//////////////////
sendSyncMessage: function (data) {
    if (this.isIOS) {
        try {
            //将消息体直接JSON字符串化，调用Prompt()            
            var resultjson = prompt(JSON.stringify(params));
            //直接用 = 接收 Prompt()的返回数据，JSON反解
            var resultObj = resultjson ? JSON.parse(resultjson) : {};
            return resultObj;
        }
        catch (error) {
            console.log('error native message');
        }
    }
},

//////////////////
eventDispatcher: function (eventId, resultjson) {
    var handlerArr = this.eventCallMap[eventId];
    var me = this;
    for (var key in handlerArr) {
        if (handlerArr.hasOwnProperty(key)) {
            var handler = handlerArr[key];
            if (handler && typeof (handler) === 'function') {
                var resultObj = resultjson ? JSON.parse(resultjson) : {};
                var returnData = handler(resultObj);
                //多写一个return
                return returnData; 
            }
        }
    }
},

