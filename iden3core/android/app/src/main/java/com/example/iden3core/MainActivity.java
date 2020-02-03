package com.example.iden3core;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import mobile.Iden3;

public class MainActivity extends FlutterActivity {
  
  MethodChannel channel;
  CallbackHandler callback;


  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    // INITALIZE IDEN3 AND CHANNELS (flutter <==> android <==> go)
    // CHANNEL (android ==> go)
    Iden3 iden3 = new Iden3();
    String storagePath = getFilesDir().getAbsolutePath();
    iden3.setPath(storagePath);
    // CHANNEL (flutter ==> android)
    channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "iden3.com/callinggo");
    // CHANNEL (flutter <== android <== go)
    callback = new CallbackHandler(channel);
    iden3.registerCallback(callback);

    GeneratedPluginRegistrant.registerWith(flutterEngine);
    // HANDLE METHODS (flutter ==> android)
    channel.setMethodCallHandler((call, result) -> {
      // NEW ID
      if (call.method.equals("newID")) {
        if (!call.hasArgument("msg")) {
            result.error("newID", "Send argument as Map<\"data\", string>", null);
            return;
        }
        try {
            String genesis = call.argument("msg");
            result.success(iden3.newID(genesis));
            return;
        } catch (Exception e) {
            result.error("newID", e.getMessage(), null);
        }
      }
      // ASYNC TEST
      if (call.method.equals("asyncTest")) {
        if (!call.hasArgument("secs")) {
            result.error("asyncTest", "Send argument as Map<\"data\", string>", null);
            return;
        }
        try {
            int secs = call.argument("secs");
            iden3.fakeAsync(secs);
            result.success(true);
            return;
        } catch (Exception e) {
            result.error("asyncTest", e.getMessage(), null);
        }
        return;
      }
      // UNKNOWN METHOD
      else {
        result.notImplemented();
      }
    });
  }
}


