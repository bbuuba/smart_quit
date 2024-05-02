package com.example.fututi_mortii_matii;

import android.os.Bundle;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class Start extends FlutterActivity {
    private static final String CHANNEL = "com.example.app/data";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getData")) {
                                // Simulated boolean data
                                boolean data = true;
                                result.success(data);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}
