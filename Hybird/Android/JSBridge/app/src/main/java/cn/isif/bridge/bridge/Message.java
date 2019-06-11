package cn.isif.bridge.bridge;

import android.text.TextUtils;

public class Message {
    public String handler;//定义native层对外的方法调用类
    public String action;//相应的native方法
    public String params;//参数传递
    public String callbackId;//用于标识JS回调函数的id
    public String callbackFunction;//用于分发处理js回调函数

    public boolean isCallbackMessage() {
        return !TextUtils.isEmpty(callbackId) && !TextUtils.isEmpty(callbackFunction);
    }
}
