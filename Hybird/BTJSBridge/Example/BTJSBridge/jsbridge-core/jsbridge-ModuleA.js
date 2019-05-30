/** 
jsbridge-ModuleA.js

假如有一些业务独有的需求，比如加入购物车，比如购买兑换积分等等，可以统一归类到 ModuleA 模块，所有跟 haha 模块相关的代码，都放在这里
*/



//具体的某个h5页面
//页面有复制进入剪切板的需求
window.bridge.Common.copyContent('哈哈哈哈，我复制进剪切板啦')
//页面有读取客户端信息的需求
window.bridge.Common.getCommonParams(function (params) {
    console.log(params);
});
//页面有监听锁屏的需求
window.bridge.Core.onListenEvent(window.bridge.Common.applicationEnterBackgroundEvent, function () {
    console.log('home press')
});