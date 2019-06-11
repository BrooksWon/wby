package cn.isif.bridge.bridge;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.widget.Toast;


import cn.isif.bridge.bridge.utils.GsonUtil;

public class JavaScriptInterface implements BridgeInterface {
    final String TAG = "JavaScriptInterface";
    WebView webView;
    Context context;

    public JavaScriptInterface(Context context, WebView webView) {
        this.webView = webView;
        this.context = context;
    }

    @JavascriptInterface
    public String handleSyncMessage(String params) {
        Log.i(TAG, "handleMessage 是否发生在主线程：" + (Looper.myLooper() == Looper.getMainLooper()));
        return executeMethod(params);
    }

    @JavascriptInterface
    public void handleAsyncMessage(String params) {
        new AsyncTask<String,Integer,String>(){

            @Override
            protected String doInBackground(String[] objects) {
                try {
                    Thread.sleep(3_000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                Log.i(TAG, "handleMessage 是否发生在主线程：" + (Looper.myLooper() == Looper.getMainLooper()));
                return executeMethod(objects[0]);
            }
        }.execute(params);
    }

    private String executeMethod(String params){
        try {
            Log.d("JavaScriptInterface",params);
            Message msg = GsonUtil.fromJsonToModel(params,Message.class);
            if (msg.isCallbackMessage()){
                return handleCallbackMessage(msg);
            }else {
                return  handleNormalMessage(msg);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    @Override
    public String handleNormalMessage(Message msg) {
        try {
            return NativeInvokeHandler.invoke(msg).toString();
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }

    @Override
    public String handleCallbackMessage(Message msg) {
        try {
            if (!TextUtils.isEmpty(msg.callbackId) && !TextUtils.isEmpty(msg.callbackFunction)) {
                String call = "javascript:" + msg.callbackFunction + "(" + msg.callbackId + "," + System.currentTimeMillis() + ")";//JS此方法的返回值会通过onReceiveValue回调到原生
                new Handler(Looper.getMainLooper()).post(() -> webView.evaluateJavascript(call, value -> {
                    Log.i(TAG, "ValueCallback 是否发生在主线程：" + (Looper.myLooper() == Looper.getMainLooper()));//true
                    Toast.makeText(context, "JS方法返回" + value, Toast.LENGTH_SHORT).show();
                }));
            }
            return NativeInvokeHandler.invoke(msg).toString();
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
    }
}
