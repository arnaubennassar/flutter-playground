package com.example.iden3core;
import io.flutter.plugin.common.MethodChannel;
import android.util.Log;

import mobile.Callback;

// CHANNEL (flutter <== android <== go)
public class CallbackHandler implements Callback {
    MethodChannel channel;
    public CallbackHandler(MethodChannel _channel) {
      channel = _channel;
    }
  
    private void callback(String function, String arguments) {
      channel.invokeMethod(function, arguments);
    }
    
    @Override
    public void fakeAsync(String msg) {
      Log.println(Log.ERROR, "fakeAsync", msg);
      callback("asyncTestCallback", msg);
    }
}