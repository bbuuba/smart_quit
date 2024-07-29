package com.example.fututi_mortii_matii;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.chaquo.python.Python;
import com.google.android.gms.wearable.DataClient;
import com.google.android.gms.wearable.DataEvent;
import com.google.android.gms.wearable.DataEventBuffer;
import com.google.android.gms.wearable.DataMapItem;
import com.google.android.gms.wearable.Wearable;
import com.chaquo.python.android.AndroidPlatform;


class IntWrapper {
    int value;

    IntWrapper(int value) {
        this.value = value;
    }
}

public class MobileService2 extends Service implements DataClient.OnDataChangedListener{

    private String TAG = "MobileService";
    private String datapath = "/data_pathNEW";
    private String datapath2 = "/peter";

    private int dragValue = 0;
    public float prediction=0f;
    public float xa = 0f, ya = 0f, za = 0f, xm = 0f, ym = 0f, zm = 0f;

    private Float THRESHOLD = 0.6f;
    public int bul;
    public byte[] vectorBiti;
    private long timeForClear = 0;

    public String sensorData; // aici ai si accelerometrul si magentometrul intrun string
    //byte[] byteArray; // aici ai bitii in chunkuri de o secunda(sper)


    private static MobileService2 sInstance;
    private static Intent sServiceIntent;
    private static boolean sIsServiceRunning = false;
    public static MobileService2 getInstance() {
        if (sInstance == null) {
            sInstance = new MobileService2();
        }
        return sInstance;
    }

    public static Intent getServiceIntent(Context context) {
        if (sServiceIntent == null) {
            sServiceIntent = new Intent(context, MobileService2.class);
        }
        return sServiceIntent;
    }
    public static void stopMobileService(Context context) {
        if (sIsServiceRunning) {
            context.stopService(sServiceIntent);
            sIsServiceRunning = false;
            Log.d("1", "MobileService stopped.");
        } else {
            Log.d("1", "MobileService is not running.");
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        sServiceIntent = getServiceIntent(this);
        Wearable.getDataClient(this).addListener(this);
        sIsServiceRunning = true;
        Log.d(TAG, "MobileService created.");
        if (!Python.isStarted()) {
            Python.start(new AndroidPlatform(this));
        }
        sensorData=null;
        prediction = 0f;
        xa = 0f;
        ya = 0f;
        za = 0f;
        xm = 0f;
        ym = 0f;
        zm = 0f;
        bul = 0;
        vectorBiti=null;


    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        Wearable.getDataClient(this).removeListener(this);

        super.onDestroy();
        sIsServiceRunning = false;
    }


    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDataChanged(@NonNull DataEventBuffer dataEventBuffer) {
        Log.d(TAG, "onDataChanged: " + dataEventBuffer);
        for (DataEvent event : dataEventBuffer) {
            if (event.getType() == DataEvent.TYPE_CHANGED) {
                String path = event.getDataItem().getUri().getPath();
                if (datapath.equals(path)) {
                    Log.d("100000000000", "10000000000000000");
                    DataMapItem dataMapItem = DataMapItem.fromDataItem(event.getDataItem());
                    String message = dataMapItem.getDataMap().getString("message");
                    sensorData = message;
                    Log.d("ceva ceva ceva", message);
                    Intent intent = new Intent("com.example.fututi_mortii_matii.DRAGVALUE_UPDATE");
                    if(sensorData != null){
                        dragValue = Integer.parseInt(sensorData);
                        Log.d("dragvaluenew", Integer.toString(dragValue));
                        intent.putExtra("dragValue", dragValue);
                        sendBroadcast(intent);
                        Log.d("Drag Value", Integer.toString(dragValue));
                    }
                    Log.d(TAG, "Wear activity received message: " + message);
                }
                if (datapath2.equals(path)) {
                    DataMapItem dataMapItem = DataMapItem.fromDataItem(event.getDataItem());
                    vectorBiti = dataMapItem.getDataMap().getByteArray("audio_chunk");

                    if (vectorBiti != null) {
                        Python python = Python.getInstance();
                        prediction = python.getModule("test").callAttr("callback", vectorBiti).toFloat();

                        Intent intent = new Intent("com.example.fututi_mortii_matii.PREDICTION_UPDATE");
                        intent.putExtra("prediction", prediction);
                        sendBroadcast(intent);
                        Log.d("Prediction", Float.toString(prediction));
                        bul = 0;
                        if (prediction > THRESHOLD) {
                            bul = 1;
                        }
                        //Log.d(TAG, "NIGGER " + bul);
                    }
                    long now = System.currentTimeMillis();
                    if(now - timeForClear >= 5000){
                        dataMapItem.getDataMap().clear();
                    }

                    // Display message in UI or log
                }
            }
            else if (event.getType() == DataEvent.TYPE_DELETED) {
                Log.v(TAG, "Data deleted : " + event.getDataItem().toString());
            } else {
                Log.e(TAG, "Unknown data event Type = " + event.getType());
            }
        }
    }

//    private void whilenu(String message, IntWrapper ind, int size){
//        while(ind.value < size  && !Character.isDigit(message.charAt(ind.value))){
//            ind.value++;
//        }
//    }
//    private float whileda(String message, IntWrapper ind, int size){
//        float nr = 0f;
//        while(ind.value < size && Character.isDigit(message.charAt(ind.value))){
//            nr = nr * 10 + message.charAt(ind.value) - '0';
//            ind.value++;
//        }
//        int p = -1;
//        whilenu(message, ind, size);
//        while (ind.value < size && Character.isDigit(message.charAt(ind.value))) {
//            nr += (message.charAt(ind.value) - '0') * (float)Math.pow(10f, p);
//            p--;
//            ind.value++;
//        }
//        return nr;
//    }
//
//    private void impartire(String message){
//        int size = message.length();
//
//        if (message.charAt(0) == 'M') {
//            IntWrapper ind = new IntWrapper(0);
//            whilenu(message, ind, size);
//            xm = whileda(message, ind, size);
//            whilenu(message, ind, size);
//            ym = whileda(message, ind, size);
//            whilenu(message, ind, size);
//            zm = whileda(message, ind, size);
//        }
//
//        if (message.charAt(0) == 'A') {
//            IntWrapper ind = new IntWrapper(0);
//            whilenu(message, ind, size);
//            //Log.d("indice: ", Integer.toString(ind.value));
//            xa = whileda(message, ind, size);
//            whilenu(message, ind, size);
//            ya = whileda(message, ind, size);
//            whilenu(message, ind, size);
//            za = whileda(message, ind, size);
//            //Log.d("sensor data floats", Float.toString(xm));
//
//        }


//        Intent intent = new Intent("com.example.fututi_mortii_matii.SENSOR_UPDATE");
//        intent.putExtra("sensors",  "Accelerometer:\nX: " + xa + "\nY: " + ya + "\nZ: " + za + "\n" + "Magnetometer:\nX: " + xm + "\nY: " + ym + "\nZ: " + zm);
//        sendBroadcast(intent);
//    }

}