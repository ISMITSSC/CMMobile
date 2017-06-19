
package com.ridgid.softwaresolution.closetmaid.views;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.RelativeLayout;

public class SpecialRelativeLayout extends RelativeLayout {

    public SpecialRelativeLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public SpecialRelativeLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SpecialRelativeLayout(Context context) {
        super(context);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int proposedHeight = getLayoutParams().height;
        if (proposedHeight > -1) {
            heightMeasureSpec = MeasureSpec.makeMeasureSpec(proposedHeight, MeasureSpec.EXACTLY);
        }
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

}
