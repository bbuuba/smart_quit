//package com.example.fututi_mortii_matii;
//
//import android.content.Context;
//import android.content.Intent;
//import android.util.Log;
//
//import androidx.annotation.NonNull;
//
//import io.flutter.embedding.engine.plugins.FlutterPlugin;
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;
//import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
//import io.flutter.plugin.common.MethodChannel.Result;
//
//public class MyServicePlugin implements FlutterPlugin {
//    private static final String TAG = "MyServicePlugin";
//
//    private Context context;
//    private Intent serviceIntent;
//
//    @Override
//    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//        context = flutterPluginBinding.getApplicationContext();
//        serviceIntent = new Intent(context, MobileService2.class);
//
//        MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "my_service_plugin");
//        channel.setMethodCallHandler(new MethodCallHandler() {
//            @Override
//            public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//                switch (call.method) {
//                    case "startService":
//                        startService();
//                        result.success(null);
//                        break;
//                    case "stopService":
//                        stopService();
//                        result.success(null);
//                        break;
//                    default:
//                        result.notImplemented();
//                        break;
//                }
//            }
//        });
//    }
//
//    @Override
//    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
//    }
//
//    private void startService() {
//        Log.d(TAG, "Starting service...");
//        context.startService(serviceIntent);
//    }
//
//    private void stopService() {
//        Log.d(TAG, "Stopping service...");
//        context.stopService(serviceIntent);
//    }
//}
