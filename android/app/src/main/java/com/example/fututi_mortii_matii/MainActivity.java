package com.example.fututi_mortii_matii;



import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;


import android.app.ActivityManager;
import android.content.Context;

import io.flutter.embedding.android.FlutterActivity;
//import com.chaquo.python.Python;
//import com.chaquo.python.android.AndroidPlatform;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "MainActivity";

    Button toggleServiceButton;
    Intent serviceIntent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        toggleServiceButton = findViewById(R.id.toggle_service_button);

        // Start the service using the singleton pattern
        serviceIntent = MobileService2.getInstance().getServiceIntent(this);
//        if (!Python.isStarted()) {
//            Python.start(new AndroidPlatform(this));
//        }
//        Python python = Python.getInstance();
//        String name = "John"; // Replace "John" with any name you want to greet
//        String greeting = python.getModule("test").callAttr("greet", name).toString();
//
//        // Print or use the greeting
//        Log.d("Python Greeting", greeting);

        toggleServiceButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isServiceRunning(MobileService2.class)) {
                    Log.d(TAG, "Service is already running, stopping it...");
                    stopService(serviceIntent); // Stop the service using the intent
                    toggleServiceButton.setText("Start Service");
                } else {
                    Log.d(TAG, "Service is not running, starting it...");
                    startService(serviceIntent); // Start the service using the intent
                    toggleServiceButton.setText("Stop Service");
                }
            }
        });


    }

    private boolean isServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }
}