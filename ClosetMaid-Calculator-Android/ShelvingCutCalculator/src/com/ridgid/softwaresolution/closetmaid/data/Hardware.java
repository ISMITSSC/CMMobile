
package com.ridgid.softwaresolution.closetmaid.data;

public class Hardware {

    long smallEndCaps = 0;

    long supportBrackets = 0;

    long wallBrackest = 0;

    long wallClips = 0;

    long largeEndCaps;

    public long[] getHardwareCount() {
        long[] h = new long[5];
        h[1] = smallEndCaps;
        h[2] = supportBrackets;
        h[3] = wallBrackest;
        h[4] = wallClips;
        h[0] = largeEndCaps;
        return h;
    }

    public void addSmallEndCaps(int count) {
        smallEndCaps += count;
    }

    public void addSupportBrackets(int count) {
        supportBrackets += count;
    }

    public void addWallBrackets(int count) {
        wallBrackest += count;
    }

    public void addWallClips(int count) {
        wallClips += count;
    }

    public void addLargeEndCaps(int count) {
        largeEndCaps += count;
    }

}
