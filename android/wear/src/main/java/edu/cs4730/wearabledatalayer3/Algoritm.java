package edu.cs4730.wearabledatalayer3;

import android.hardware.SensorManager;

public class Algoritm {

    float azimut, pitch, roll;
    public int dragvalue = 0;

    public int sensorsFunction(float[] mGravity, float[] mGeomagnetic){
        float R[] = new float[9];
        float I[] = new float[9];
        boolean success = SensorManager.getRotationMatrix(R, I, mGravity, mGeomagnetic);
        if (success) {
            float orientation[] = new float[3];
            SensorManager.getOrientation(R, orientation);
            azimut = orientation[0]; // orientation contains: azimut, pitch and roll
            pitch = orientation[1];
            roll = orientation[2];
            if ((pitch >= 0 && pitch <= 1) && (roll >= 0.7 && roll <= 1.9)) {
                return 1;
            }
            return 0;
        }
        return 0;
    }
}