package com.example.proiect;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.widget.Button;
import android.widget.TextView;

import android.app.ActivityManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String TAG = "MainActivity";
    private static final String CHANNEL = "com.example.flutter_service";
    private MobileService2 org = new MobileService2();
    private long firstDragValue = 0, minTime = 90000, timeOfStarting, minTimeOfSmoking = 300000;//5 min
    private float THRESHOLD = 0.5f;
    private int cigarettes=0;
    private int dragValue;
    private int dragCount = 0;
    private boolean isSmokingNow = false;
    private TextView vectorBiti;
    private TextView sensorText;
    private TextView cigarettesText;
    private Button toggleServiceButton;
    private Intent serviceIntent;
    private BroadcastReceiver predictionReceiver;
    private BroadcastReceiver dragValueReceiver;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "getCigarettes":
                                    // Return the cigarettes value to Flutter
                                    result.success(cigarettes);
                                    break;
                                case "getOtherData":
                                    // Implement logic to get other data and return to Flutter
                                    // For example:
                                    // result.success(getOtherData());
                                    break;
                                case "toggleService":
                                    toggleService();
                                    result.success(null);
                                    break;
                                default:
                                    result.notImplemented();
                                    break;
                            }
                        }
                );
    }
    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.layout);

//        toggleServiceButton = findViewById(R.id.toggle_service_button);
//        vectorBiti = findViewById(R.id.vector_biti_text_view);
//        sensorText = findViewById(R.id.sensorText);
//        cigarettesText = findViewById(R.id.cigarettesText);
//        vectorBiti.setText("prediction"); // Initial text

//        toggleServiceButton.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                toggleService();
//            }
//        });

        serviceIntent = MobileService2.getInstance().getServiceIntent(this);

        // Register broadcast receiver to receive prediction updates
        predictionReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                float prediction = intent.getFloatExtra("prediction", 0f);
                updatePredictionData(prediction);
            }
        };
        registerReceiver(predictionReceiver, new IntentFilter("com.example.fututi_mortii_matii.PREDICTION_UPDATE"));
        dragValueReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                int dragValue = intent.getIntExtra("dragValue", 0);
                updateDragValueData(dragValue);
            }
        };
        registerReceiver(dragValueReceiver, new IntentFilter("com.example.fututi_mortii_matii.DRAGVALUE_UPDATE"));


    }

    public void toggleService() {
        if (isServiceRunning(MobileService2.class)) {
            Log.d(TAG, "Service is already running, stopping it...");
            stopService(serviceIntent);
//            toggleServiceButton.setText("Start Service");
        } else {
            Log.d(TAG, "Service is not running, starting it...");
            startService(serviceIntent);
//            toggleServiceButton.setText("Stop Service");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(predictionReceiver);
        unregisterReceiver(dragValueReceiver);
    }

    private void updatePredictionData(float prediction) {
        //vectorBiti.setText("Prediction: " + prediction); // Update the TextView
        if (!isSmokingNow) {
            if (prediction >= THRESHOLD && dragValue == 1) {
                cigarettes++;
                new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                        .invokeMethod("updateCigarettes", cigarettes);
//                cigarettesText.setText("Cigarettes: " + cigarettes);
                isSmokingNow = true;
                timeOfStarting = System.currentTimeMillis();
            }
        } else {
            reset();
        }
    }

    private void updateDragValueData(int dragV) {
        Log.d("am updatat", "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
        if (!isSmokingNow) {
            if (firstDragValue == 0) firstDragValue = System.currentTimeMillis();
            dragValue = dragV;
            dragCount += dragV;
//            sensorText.setText("Number of drags: " + dragCount);
            if (dragCount == 10) {
                long currentTime = System.currentTimeMillis();
                if (currentTime - firstDragValue < minTime) {
                    cigarettes++;
//                    cigarettesText.setText("Cigarettes: " + cigarettes);
                    isSmokingNow = true;
                    timeOfStarting = currentTime;
                }
            }
        } else {
            reset();
        }

    }

    private void reset() {
        if (System.currentTimeMillis() - timeOfStarting >= minTimeOfSmoking) {
            isSmokingNow = false;
        } else {
            dragCount = 0;
            dragValue = 0;
            firstDragValue = 0;
        }
    }

    // Check if a service is running
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