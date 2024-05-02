package com.example.fututi_mortii_matii;

import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.wearable.DataClient;
import com.google.android.gms.wearable.DataEvent;
import com.google.android.gms.wearable.DataEventBuffer;
import com.google.android.gms.wearable.DataItem;
import com.google.android.gms.wearable.DataMapItem;
import com.google.android.gms.wearable.PutDataMapRequest;
import com.google.android.gms.wearable.PutDataRequest;
import com.google.android.gms.wearable.Wearable;
//import com.chaquo.python.Python;
//import com.chaquo.python.android.AndroidPlatform;




public class MobileService2 extends Service implements DataClient.OnDataChangedListener {

    private String TAG = "MobileService";
    private String datapath = "/data_pathNEW";
    private String datapath2 = "/audio_chunksNEW";

    public String sensorData; // aici ai si accelerometrul si magentometrul intrun string
    byte[] byteArray; // aici ai bitii in chunkuri de o secunda(sper)


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
                if (datapath2.equals(path)) {
                    DataMapItem dataMapItem = DataMapItem.fromDataItem(event.getDataItem());
                    byte[] vectorBiti= dataMapItem.getDataMap().getByteArray("byteArrayKey");
                    byteArray=vectorBiti;

                    Log.d(TAG, "Wear activity received message: "+dataMapItem);
                    // Display message in UI or log
                }

                if (datapath.equals(path)) {
                    DataMapItem dataMapItem = DataMapItem.fromDataItem(event.getDataItem());
                    String message = dataMapItem.getDataMap().getString("message");
                    sensorData=message;
                    Log.d(TAG, "Wear activity received message: " + message);
                    // Display message in UI or log
                } else {
                    Log.e(TAG, "Unrecognized path: " + path);
                }
            } else if (event.getType() == DataEvent.TYPE_DELETED) {
                Log.v(TAG, "Data deleted : " + event.getDataItem().toString());
            } else {
                Log.e(TAG, "Unknown data event Type = " + event.getType());
            }
        }
    }


}
