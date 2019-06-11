package cn.isif.bridge.bridge;

/**
 * This interface used abstract JavaScriptInterface Func
 */
public interface BridgeInterface {
    String handleNormalMessage(Message msg);

    String handleCallbackMessage(Message msg);
}
