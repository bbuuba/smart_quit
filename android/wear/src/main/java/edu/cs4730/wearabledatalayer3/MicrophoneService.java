package edu.cs4730.wearabledatalayer3;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.net.Uri;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.Tasks;
import com.google.android.gms.wearable.DataItem;
import com.google.android.gms.wearable.PutDataMapRequest;
import com.google.android.gms.wearable.PutDataRequest;
import com.google.android.gms.wearable.Wearable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MicrophoneService extends Service {

    private static final int REQUEST_RECORD_AUDIO_PERMISSION = 200;
    private static final String TAG = "MicrophoneStreaming";
    private static final int SAMPLE_RATE = 16000;
    private static final int BYTES_PER_SAMPLE = 4;
    private static final int CHUNK_SIZE = SAMPLE_RATE * BYTES_PER_SAMPLE;
    private String datapath2 = "/peter";
    PutDataMapRequest dataMap;

    private AudioRecord audioRecord;
    private boolean isRecording = false;
    private final IBinder binder = new MicrophoneBinder();
    private ExecutorService executorService;

    @Override
    public IBinder onBind(Intent intent) {
        return binder;
    }

    public class MicrophoneBinder extends Binder {
        public MicrophoneService getService() {
            return MicrophoneService.this;
        }
    }

    @Override
    public void onCreate() {
        super.onCreate();
        executorService = Executors.newSingleThreadExecutor();

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        startForeground(1, createNotification());
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            stopSelf();
            return START_NOT_STICKY;
        }
        startRecording();
        return START_STICKY;
    }

    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);


        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, TAG)
                .setSmallIcon(R.drawable.notification_icon_foreground)


                .setContentTitle("Sensor Service")
                .setContentText("Service is running in the background")
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Sensor Service Channel";
            String description = "Channel for Sensor Service";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(TAG, name, importance);
            channel.setDescription(description);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }

        return builder.build();
    }

    @Override
    public void onDestroy() {

        stopRecording();
        executorService.shutdown();
        super.onDestroy();
        if(dataMap != null && !dataMap.getDataMap().isEmpty()) {
            dataMap.getDataMap().clear();
        }
    }

    public void startRecording() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            // Permission not granted, handle accordingly
            Toast.makeText(this, "Permission denied", Toast.LENGTH_SHORT).show();
            stopSelf(); // Stop the service
            return;
        }

        executorService.execute(() -> {
            int bufferSize = CHUNK_SIZE;

            audioRecord = new AudioRecord(
                    MediaRecorder.AudioSource.MIC,
                    SAMPLE_RATE,
                    AudioFormat.CHANNEL_IN_MONO,
                    AudioFormat.ENCODING_PCM_32BIT,
                    bufferSize
            );

            byte[] buffer = new byte[CHUNK_SIZE];

            audioRecord.startRecording();
            isRecording = true;

            while (isRecording) {
                int bytesRead = audioRecord.read(buffer, 0, CHUNK_SIZE);
                if (bytesRead > 0) {
                    int sum = 0;
                    for(int i = 0; i < bytesRead; i++)sum += buffer[i];
                    if(buffer != null)
                        sendDataChunk(buffer, bytesRead);
                }
            }
        });
    }


    public void stopRecording() {
        isRecording = false;
        if (audioRecord != null) {
            audioRecord.stop();
            audioRecord.release();
            audioRecord = null;
        }
    }

    private List<Uri> dataItemUris = new ArrayList<>(); // List to store URIs
    private long lastClearTime = System.currentTimeMillis();

    private void sendDataChunk(byte[] chunk, int length) {
        if (length == 64000) {
            dataMap = PutDataMapRequest.create(datapath2);
            dataMap.getDataMap().putByteArray("audio_chunk", Arrays.copyOf(chunk, length));
            PutDataRequest request = dataMap.asPutDataRequest();
            request.setUrgent();

            Task<DataItem> dataItemTask = Wearable.getDataClient(this).putDataItem(request);
            dataItemTask.addOnSuccessListener(dataItem -> {
                Log.d(TAG, "Sent chunk of length " + length);
                Uri dataItemUri = dataItem.getUri();
                dataItemUris.add(dataItemUri); // Store the URI
                Log.d(TAG, "DataItem URI: " + dataItemUri.toString());
            }).addOnFailureListener(e -> {
                Log.e(TAG, "Failed to send chunk: " + e);
            });

            long now = System.currentTimeMillis();
            if (now - lastClearTime > 5000) {
                // Delete all stored data items
                for (Uri uri : dataItemUris) {
                    Wearable.getDataClient(this).deleteDataItems(uri)
                            .addOnSuccessListener(aVoid -> {
                                Log.d(TAG, "Successfully deleted data item with URI: " + uri);
                            })
                            .addOnFailureListener(e -> {
                                Log.e(TAG, "Failed to delete data item: " + e);
                            });
                }
                dataItemUris.clear(); // Clear the list after deletion
                lastClearTime = now; // Update the last clear time
            }
        }


}

}


