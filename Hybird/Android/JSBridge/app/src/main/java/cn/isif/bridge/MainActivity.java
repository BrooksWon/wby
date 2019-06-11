package cn.isif.bridge;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;

import cn.isif.bridge.bridge.JavaScriptInterface;

/**
 * JS主动调用原生             [ok]
 * JS主动调用原生后回调       [ok]
 * 原生主动调用JS              [ok]
 * 原生主动调用JS后回调        [ok]
 * 同步通信                    [ok]
 * 通信编码                    [ok]
 *
 */

public class MainActivity extends AppCompatActivity {
    WebView webView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        webView = findViewById(R.id.web);
        initView();
    }

    public void initView(){
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        webView.addJavascriptInterface(new JavaScriptInterface(this,webView),"android");
        webView.setWebChromeClient(new WebChromeClient());
        webView.loadUrl("file:///android_asset/test.html");
    }
}
