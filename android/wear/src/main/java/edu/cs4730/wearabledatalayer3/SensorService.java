package edu.cs4730.wearabledatalayer3;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.wearable.DataItem;
import com.google.android.gms.wearable.PutDataMapRequest;
import com.google.android.gms.wearable.PutDataRequest;
import com.google.android.gms.wearable.Wearable;
public class SensorService extends Service implements SensorEventListener{

    private final static String TAG = "Wear SensorService";
    private SensorManager sensorManager;
    PutDataMapRequest dataMap;
    private Sensor accelerometer;
    private boolean dragValueBool = false; // aici verific daca am mai fost in drag value interval
    private Sensor magnetometer;
    private String datapath = "/data_pathNEW";
    private static final int NOTIFICATION_ID = 123;
    private static final String CHANNEL_ID = "SensorServiceChannel";

    // Variable to store the last time data was sent
    private long lastDataSentTime = 0;

    // Minimum interval between data transmissions (in milliseconds)
    private long minDataSendInterval = 500;
    private int dragValue;

    Algoritm org = new Algoritm();

    @Override
    public void onCreate() {
        super.onCreate();
        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        magnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        while(magnetometer == null){
            magnetometer = sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
        }
        registerListener();
        //sendData("Service Started");

        // Start the service in the foreground
        startForeground(NOTIFICATION_ID, createNotification());

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterListener();
        //sendData("Service Stopped");

        if(dataMap != null && !dataMap.getDataMap().isEmpty()) {
            dataMap.getDataMap().clear();
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    float[] mGravity;
    float[] mGeomagnetic;
    @Override
    public void onSensorChanged(SensorEvent event) {

        if (event != null) {
            long currentTime = System.currentTimeMillis();
            // Check if enough time has passed since the last data transmission
            if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER)
                mGravity = event.values;
            if (event.sensor.getType() == Sensor.TYPE_MAGNETIC_FIELD)
                mGeomagnetic = event.values;
            if(mGravity != null && mGeomagnetic != null) {

                int ans = org.sensorsFunction(mGravity, mGeomagnetic);
                if(ans == 1 && !dragValueBool){
                    dragValueBool = true;
                    dragValue += 1;
                    Log.d("Drag Value", Integer.toString(dragValue));
                    sendData("1");
                }
                else if(ans == 0 && dragValueBool){
                    dragValueBool = false;
                    sendData("0");
                }
                //lastDataSentTime = currentTime;
            }
            //else
            // sendData("0");

        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Handle accuracy changes if needed
    }

    private void registerListener() {
        if (accelerometer != null) {
            sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
        }
        if (magnetometer != null) {
            sensorManager.registerListener(this, magnetometer, SensorManager.SENSOR_DELAY_NORMAL);
        }
    }


    private void unregisterListener() {
        sensorManager.unregisterListener(this);
    }

    private void sendData(String message) {
        dataMap = PutDataMapRequest.create(datapath);
        dataMap.getDataMap().putString("message", message);
        PutDataRequest request = dataMap.asPutDataRequest();
        request.setUrgent();

        Task<DataItem> dataItemTask = Wearable.getDataClient(this).putDataItem(request);
        dataItemTask
                .addOnSuccessListener(new OnSuccessListener<DataItem>() {
                    @Override
                    public void onSuccess(DataItem dataItem) {
                        long acum = System.currentTimeMillis();
                        Log.d(TAG, "Sending message was successful: " + dataItem + " " + acum);
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Log.e(TAG, "Sending message failed: " + e);
                    }
                });
    }

    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.notification_icon_foreground)
                .setContentTitle("Sensor Service")
                .setContentText("Service is running in the background")
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Sensor Service Channel";
            String description = "Channel for Sensor Service";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }

        return builder.build();
    }
}