//package com.example.fututi_mortii_matii;
//
//import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.FlutterEngine;
//import io.flutter.plugin.common.MethodChannel;
//
//
//
//public class Start extends FlutterActivity {
//    private static final String CHANNEL = "method_channel";
//    //MobileService obj = new MobileService();
//    //int bul = obj.bul;
//    @Override
//    public void configureFlutterEngine(FlutterEngine flutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//                .setMethodCallHandler(
//                        (call, result) -> {
//                            if (call.method.equals("getBool")) {
//                                // Your Java logic here
//                                //int myBool = bul; // You can change this to whatever logic you want
//                                //result.success(myBool);
//                            } else {
//                                result.notImplemented();
//                            }
//                        }
//                );
//    }
//}
