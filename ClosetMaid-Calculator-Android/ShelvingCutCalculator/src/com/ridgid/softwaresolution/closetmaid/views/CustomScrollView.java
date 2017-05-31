
package com.ridgid.softwaresolution.closetmaid.views;

import android.content.Context;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ListView;
import android.widget.ScrollView;

/**
 * Created with IntelliJ IDEA. User: danbozdog Date: 1/11/13 Time: 11:20 AM To
 * change this template use File | Settings | File Templates.
 */
public class CustomScrollView extends ScrollView {

    onHeightListener listener = null;

    public void setOnHeightListener(onHeightListener listener) {
        this.listener = listener;
    }

    public CustomScrollView(Context context) {
        super(context);
    }

    public CustomScrollView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CustomScrollView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
        super.onScrollChanged(l, t, oldl, oldt);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int h = MeasureSpec.getSize(heightMeasureSpec);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    };

    float lastY;

    int initScroll = 0;

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        if (scrollable) {
            Rect rec = new Rect();
            innerScrollList.getGlobalVisibleRect(rec);
            final int action = ev.getAction();
            switch (action) {
                case MotionEvent.ACTION_DOWN:
                    onTouchEvent(ev);
                    if (rec.contains((int)ev.getX(), (int)ev.getY())) {
                        lastY = ev.getY();
                    }
                    break;

                case MotionEvent.ACTION_MOVE:
                    int currentY = (int)ev.getY();
                    boolean dragDownMoveUp = true;
                    if (currentY - lastY < 0) {
                        dragDownMoveUp = false;
                    }
                    lastY = currentY;
                    if (dragDownMoveUp) {
                        if (innerScrollList.getFirstVisiblePosition() == 0) {
                            View first = innerScrollList.getChildAt(0);
                            int marginTop = first.getTop();
                            if (marginTop == 0) {
                                return super.onInterceptTouchEvent(ev);
                            }
                        }
                    } else {
                        if (innerScrollList.getLastVisiblePosition() == innerScrollList.getCount() - 1) {
                            View last = innerScrollList.getChildAt(innerScrollList.getChildCount() - 1);
                            int marginBottom = last.getBottom();
                            int listHeight = innerScrollList.getHeight();
                            int deltaLast = marginBottom - listHeight;
                            if (deltaLast <= 0) {
                                return super.onInterceptTouchEvent(ev);
                            }
                        }
                    }
                    return false;
                case MotionEvent.ACTION_CANCEL:
                    return super.onInterceptTouchEvent(ev);

                case MotionEvent.ACTION_UP:
                    return super.onInterceptTouchEvent(ev);

                default:
                    break;
            }
            return false;
        } else {
            return false;
        }
    }

    ListView innerScrollList;

    boolean scrollable = true;

    public void isScrollable(boolean isScrollable) {
        this.scrollable = isScrollable;
    }

    public ListView getScrollableChild() {
        return innerScrollList;
    }

    public void setScrollableChild(ListView innerScroll) {
        this.innerScrollList = innerScroll;
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        if (listener != null) {
            listener.onHeightChanged(h, oldh);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        try {
            return super.onTouchEvent(ev);
        } catch (Exception e) {
            return false;
        }
    }

    public interface onHeightListener {
        public void onHeightChanged(int newHeight, int oldHeight);
    }

}
