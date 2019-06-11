package cn.isif.bridge.bridge;


import android.text.TextUtils;

import java.lang.reflect.Method;

public class NativeInvokeHandler {

    public static Object invoke(Message msg) throws Exception {
        Class<?> clazz = Class.forName(getMethodString(msg.handler));
        Object result;
        if (TextUtils.isEmpty(msg.params)) {
            Method method = clazz.getMethod(msg.action, null);
            result = method.invoke(null, null);
        } else {
            Method method = clazz.getMethod(msg.action, String.class);
            result = method.invoke(null, msg.params);
        }
        return result == null ? "" : result;
    }

    private static String getMethodString(String handle) {
        return "cn.isif.bridge.bridge.fun." + handle;
    }

}
