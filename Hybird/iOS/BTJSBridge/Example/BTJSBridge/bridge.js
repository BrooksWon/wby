var msgCallbackMap = [];
function callbackDispatcher(callbackId,params){
    var handler = this.msgCallbackMap[callbackId];
    if(handler && typeof(handler) === 'function'){
        console.log(params);
        var resultObj = params ? JSON.parse(params) : {};
        handler(resultObj);
    }
    delete this.msgCallbackMap[callbackId];
}


// native to js
var eventCallMap = [];
function eventDispatcher(eventId,params){
    var handler = this.eventCallMap[eventId];
    if(handler && typeof(handler) === 'function'){
        console.log(params);
        var resultObj = params ? JSON.parse(params) : {};
        handler(resultObj);
    }
    delete this.eventCallMap[eventId];
}

//获取系统类型
function getOS(){
    var u = navigator.userAgent;
//    var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1; //android终端
//    var isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
    if(u.indexOf('Android') > -1 || u.indexOf('Adr') > -1){
        return 'Android';
    }else if(!!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)){
        return 'iOS';
    }else {
        return 'iOS';
    }
}

function sendSyncMessage(data){
    if(getOS()=='Android'){
        return window.android.handleSyncMessage(JSON.stringify(data));
    }else{
        //ios
       window.webkit.messageHandlers.BTJSBridge.postMessage(data);
    }

}

function sendAsyncMessage(data){
    if(getOS()=='Android'){
        return window.android.handleAsyncMessage(JSON.stringify(data));
    }else{
        //ios
        return window.webkit.messageHandlers.BTJSBridge.postMessage(data);
    }
}

function getCallbackId(){
    var timestamp = Date.parse(new Date());
    timestamp = timestamp / 1000;
    return timestamp;
}

function testCallback(params){
    window.alert('native回调返回：'+ params);
}
//发送同步无回调消息
function sendSyncNormalMessage(){
    var msgBody = {};
    msgBody.handler = 'Common';
    msgBody.action = 'nativeLog';
    msgBody.params = "massage content";
             
    window.alert(sendSyncMessage(msgBody));
}

//发送同步回调消息
function sendSyncCallbackMessage(){
    var msgBody = {};
    msgBody.handler = 'Core';
    msgBody.action = 'getUserID';
    msgBody.params = "";
    var callbackId = getCallbackId();
    this.msgCallbackMap[callbackId] = testCallback;
    msgBody.callbackId = callbackId;
    msgBody.callbackFunction = 'callbackDispatcher';
    sendSyncMessage(msgBody);
}
//发送异步无回调消息
function sendAsyncNormalMessage(){
    var msgBody = {};
    msgBody.handler = 'Common';
    msgBody.action = 'nativeLog';
    msgBody.params = "massage content";
    sendAsyncMessage(msgBody);
}
//发送异步有回调消息
function sendAsyncCallbackMessage(){
    var msgBody = {};
    msgBody.handler = 'Core';
    msgBody.action = 'getUserID';
    msgBody.params = "";
    var callbackId = getCallbackId();
    this.msgCallbackMap[callbackId] = testCallback;
    msgBody.callbackId = callbackId;
    msgBody.callbackFunction = 'callbackDispatcher';
    sendAsyncMessage(msgBody);
}

 //-------------------------------------------
 //-------------------------------------------
 //-------------------------------------------
 //-------------------------------------------
 //-------------------------------------------

             
 String.prototype.hashCode = function() {
     var hash = 0;
     if (this.length == 0) return hash;
     for (var index = 0; index < this.length; index++) {
     var charactor = this.charCodeAt(index);
     hash = ((hash << 5) - hash) + charactor;
     hash = hash & hash;
     }
     return hash;
 };
             
//ModuleA-testA1 无回调
function sendSyncMessageA1(){
    var msgBody = {};
    msgBody.handler = 'ModuleA';
    msgBody.action = 'testA1';
    msgBody.parameters = "js 同步调用 ModuleA 中的 testA1 方法";

    sendSyncMessage(msgBody);
             
     //注册一下eventID
     this.eventCallMap['nativetojs'] = nativetojs;
}
             
 //ModuleA-testA2 回调
 function sendSyncNormalCallbackMessageA2(){
     var msgBody = {};
     msgBody.handler = 'ModuleA';
     msgBody.action = 'testA2';
     msgBody.parameters = "js 同步调用 ModuleA 中的 testA2 方法, 并且回调js";
             
     var dataString = encodeURIComponent(JSON.stringify(msgBody.parameters));
     var timestamp = Date.parse(new Date());
     var identifier = ("targetName" + "actionName" + dataString + timestamp).hashCode().toString();
             
     //回调
     var callbackId = identifier;
     this.msgCallbackMap[callbackId] = testCallback;
             
     
     msgBody.callbackID = callbackId;
     msgBody.callbackFunction = 'callbackDispatcher';
     
     sendSyncMessage(msgBody);
}
             
  //ModuleA-testA3 同步回调
 function sendSyncCallbackMessageA3(){
     var msgBody = {};
     msgBody.handler = 'ModuleA';
     msgBody.action = 'testA3';
     msgBody.parameters = "js 调用 ModuleA 中的 testA3 方法, 并且同步回调js";
             
             
     var dataString = encodeURIComponent(JSON.stringify(msgBody.parameters));
     var timestamp = Date.parse(new Date());
     var identifier = ('targetName' + 'actionName' + dataString + timestamp).hashCode().toString();

     //回调
     var callbackId = identifier;
     this.msgCallbackMap[callbackId] = testCallback;
             
             
     msgBody.callbackID = callbackId;
     msgBody.callbackFunction = 'callbackDispatcher';
           
     //同步回调
     alert(JSON.stringify(msgBody));
 }
         
             
 function nativetojs(params){
     window.alert(JSON.stringify(params));
 }
