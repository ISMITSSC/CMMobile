
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools;

import com.ridgid.softwaresolution.closetmaid.data.Hardware;
import com.ridgid.softwaresolution.closetmaid.data.HardwareShelf;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;

import android.content.Context;

import java.util.ArrayList;

public class CalculateHardware {

    public long[] calculate(Context context, int shelfType, ArrayList<HardwareShelf> shelves) {
        Hardware result = new Hardware();

        int[] smallEndCaps = context.getResources().getIntArray(R.array.hardware_small_end_caps);
        int[] largeEndCaps = context.getResources().getIntArray(R.array.hardware_large_end_caps);
        int[] supportBrackets = context.getResources().getIntArray(R.array.hardware_support_brackest);
        int[] wallBrackets = context.getResources().getIntArray(R.array.hardware_wall_brackest);

        for (HardwareShelf s : shelves) {
            result.addSmallEndCaps(s.getQuantity() * calculateSmallEndCaps(shelfType, smallEndCaps));
            result.addLargeEndCaps(s.getQuantity() * calculateLargeEndCaps(shelfType, largeEndCaps));
            result.addWallClips(s.getQuantity() * calculateWallClips(s));
            result.addSupportBrackets(s.getQuantity() * calculateSupportBrackets(s, supportBrackets));
            result.addWallBrackets(s.getQuantity() * calculateWallBrackets(s, wallBrackets));
        }

        return result.getHardwareCount();
    }

    private int calculateSmallEndCaps(int shelfTypeIndex, int values[]) {
        return values[shelfTypeIndex];
    }

    private int calculateLargeEndCaps(int shelfTypeIndex, int values[]) {
        return values[shelfTypeIndex];
    }

    private int calculateSupportBrackets(HardwareShelf s, int values[]) {
        int brackets = (int)((s.getLength() - 3) / 36);
        brackets += values[s.getLocationType()];
        return brackets;
    }

    private int calculateWallBrackets(HardwareShelf s, int values[]) {
        return values[s.getLocationType()];
    }

    private int calculateWallClips(HardwareShelf s) {
        int clips = (int)Math.ceil(((s.getLength() - 4.0) / 12.0) + 1);
        clips = (clips < 3 ? 3 : clips);
        return clips;
    }
}
