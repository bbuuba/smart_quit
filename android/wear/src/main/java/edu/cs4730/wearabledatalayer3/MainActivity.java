package edu.cs4730.wearabledatalayer3;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

public class MainActivity extends Activity {

    private static final int REQUEST_RECORD_AUDIO_PERMISSION = 200;

    private boolean isServiceRunning = false;
    private Button toggleServiceButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        toggleServiceButton = findViewById(R.id.toggleServiceButton);
        toggleServiceButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                toggleService();
            }
        });

        // Check and request permission if needed
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.RECORD_AUDIO},
                    REQUEST_RECORD_AUDIO_PERMISSION);
        } else {
            // Start services if permission is granted
            startServices();
        }

        // Update button text based on service state
        updateButtonState();
    }

    private void toggleService() {
        if (isServiceRunning) {
            stopServices();
        } else {
            startServices();
        }
        updateButtonState();
    }

    private void startServices() {
        startMicrophoneService();
        startSensorService();
        isServiceRunning = true;
    }

    private void stopServices() {
        stopMicrophoneService();
        stopSensorService();
        isServiceRunning = false;
    }

    private void startMicrophoneService() {
        Intent intent = new Intent(this, MicrophoneService.class);
        startForegroundService(intent);
    }

    private void stopMicrophoneService() {
        Intent intent = new Intent(this, MicrophoneService.class);
        stopService(intent);
    }

    private void startSensorService() {
        Intent serviceIntent = new Intent(this, SensorService.class);
        startForegroundService(serviceIntent);
    }

    private void stopSensorService() {
        Intent serviceIntent = new Intent(this, SensorService.class);
        stopService(serviceIntent);
    }

    private void updateButtonState() {
        if (isServiceRunning) {
            toggleServiceButton.setText("Stop Service");
        } else {
            toggleServiceButton.setText("Start Service");
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_RECORD_AUDIO_PERMISSION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted, start the services
                startServices();
            } else {
                // Permission denied, show a message or handle accordingly
                Toast.makeText(this, "Permission denied", Toast.LENGTH_SHORT).show();
            }
        }
    }
}
