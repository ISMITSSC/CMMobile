
package com.ridgid.softwaresolution.closetmaid.data;

import android.os.Parcel;
import android.os.Parcelable;

public class Measures implements Parcelable {
    private float[] cuttingMeasures;

    private float sectionSize;

    private boolean metric;

    private float waste;

    private int count = 0;

    public Measures(float[] data, float sectionSize, boolean metric, float waste) {
        this.cuttingMeasures = data;
        this.sectionSize = sectionSize;
        this.metric = metric;
        this.waste = waste;
    }

    public float getWaste() {
        return waste;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getCount() {
        return count;
    }

    public float[] getMeasures() {
        return cuttingMeasures;
    }

    public float getSectionSize() {
        return sectionSize;
    }

    public String getUnit() {
        if (metric) {
            return "cm";
        } else {
            return "\"";
        }
    }

    @Override
    public int describeContents() {
        // TODO Auto-generated method stub
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        // TODO Auto-generated method stub

    }

}
