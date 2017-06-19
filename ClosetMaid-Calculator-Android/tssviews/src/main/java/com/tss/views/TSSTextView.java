package com.tss.views;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.RelativeLayout.LayoutParams;
import android.widget.TextView;

import com.tss.tssviews.R;
import com.tss.utils.ScaleMode;

public class TSSTextView extends TextView implements OnGlobalLayoutListener{

    public TSSTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        TypedArray att = context.getTheme().obtainStyledAttributes(
                attrs,
                R.styleable.tss_attributes,
                0, 0);
        try {
            x=att.getFloat(R.styleable.tss_attributes_tss_x, -1f);
            y=att.getFloat(R.styleable.tss_attributes_tss_y, -1f);
            originX=att.getFloat(R.styleable.tss_attributes_tss_originX, 0f);
            originY=att.getFloat(R.styleable.tss_attributes_tss_originY, 0f);
            width=att.getFloat(R.styleable.tss_attributes_tss_width, -1f);
            height=att.getFloat(R.styleable.tss_attributes_tss_height, -1f);
            scaleMode=ScaleMode.getScaleMode(att.getInt(R.styleable.tss_attributes_tss_scaleMode, 0));
        }
        catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        } finally {
            att.recycle();
        }

        getViewTreeObserver().addOnGlobalLayoutListener(this);
    }


    private ScaleMode scaleMode=ScaleMode.none;
    private float x=-1;
    private float y=-1;
    private float width=-1;
    private float height=-1;
    private float originX=0;
    private float originY=0;

    //left,top,right,bottom;
    int l,t,r,b;
    int w=-1,h=-1;

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int measuredWidth=MeasureSpec.getSize(widthMeasureSpec);
        int measuredHeight=MeasureSpec.getSize(heightMeasureSpec);
        if(w!=measuredWidth||h!=measuredHeight){
            w=measuredWidth;
            h=measuredHeight;
            calculateDimmensions();
            if(w!=0&&h!=0){
                calculateMargins();
                LayoutParams params=(LayoutParams)getLayoutParams();
                int offsetX=(int) (w*originX);
                int offsetY=(int) (h*originY);
                params.height=h;
                params.width=w;
                int left=params.leftMargin;
                int right=params.rightMargin;
                int top=params.topMargin;
                int bottom=params.bottomMargin;
                if(x!=-1){
                    left=l-offsetX;
                }
                if(y!=-1){
                    top=t-offsetY;
                }
                params.setMargins(left,top,right,bottom);
                widthMeasureSpec=MeasureSpec.makeMeasureSpec(w, MeasureSpec.EXACTLY);
                heightMeasureSpec=MeasureSpec.makeMeasureSpec(h, MeasureSpec.EXACTLY);
            }
        }
        setMeasuredDimension(w, h);
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    private void calculateDimmensions(){
        setWidth();
        setHeight();

        switch (scaleMode) {

            case none:
                break;

            case byHeight:
                calculateComplementaryDimension(false, false);
                break;

            case byWidth:
                calculateComplementaryDimension(false, true);
                break;

            case byParentHeight:
                calculateComplementaryDimension(true, false);
                break;

            case byParentWidth:
                calculateComplementaryDimension(true, true);
                break;
            default:
                break;
        }
    }

    private void calculateMargins(){
        setLeft();
        setTop();
    }

    private void setLeft(){
        if(x!=-1){
            l=(int)(x*((View)getParent()).getMeasuredWidth());
        }
    }

    private void setTop(){
        if(y!=-1){
            t=(int)(y*((View)getParent()).getMeasuredHeight());
        }
    }


    private void setWidth(){
        if(width!=-1){
            w=(int)(width*((View)getParent()).getMeasuredWidth());
        }else{
            w=getLayoutParams().width;
        }
    }

    private void setHeight(){
        if(height!=-1){
            h=(int)(height*((View)getParent()).getMeasuredHeight());
        }else{
            h=getLayoutParams().height;
        }
    }



    private void calculateComplementaryDimension(boolean byParent,boolean byWidth){
        View v;
        int dimension;
        if(byParent){
            v=(View)getParent();
            if(getBackground()!=null){
                float scale=getScale(v, byWidth);
                Drawable drawable=getBackground().getCurrent();
                setScaledHeight(scale, drawable);
                setScaledWidth(scale, drawable);
            }
        }else{
            v=this;
            if(byWidth){
                dimension=w;
            }else{
                dimension=h;
            }
            h=getComplementary(v, dimension, byWidth);
        }
    }

    private void setScaledWidth(float scale,Drawable drawable){
        if(drawable!=null){
            w=(int) (drawable.getIntrinsicWidth()*scale);
        }
    }

    private void setScaledHeight(float scale,Drawable drawable){
        if(drawable!=null){
            h=(int) (drawable.getIntrinsicHeight()*scale);
        }
    }

    private float getScale(View v,boolean byWidth){
        float scale=1;
        if(v.getBackground()!=null){
            Drawable current=v.getBackground().getCurrent();
            if(byWidth){
                int wid=v.getMeasuredWidth();
                scale=(float)wid/current.getIntrinsicWidth();
            } else{
                int he=v.getMeasuredWidth();
                scale=(float)he/current.getIntrinsicHeight();
            }
        }
        return scale;
    }

    private int getComplementary(View v,int dimension, boolean byWidth){
        float scale=1;
        int complementary=dimension;
        if(v.getBackground()!=null){
            Drawable current=v.getBackground().getCurrent();
            if(byWidth){
                scale=(float)dimension/current.getIntrinsicWidth();
                complementary=(int) (current.getIntrinsicHeight()*scale);
            } else{
                scale=(float)dimension/current.getIntrinsicHeight();
                complementary=(int) (current.getIntrinsicWidth()*scale);
            }
        }
        return complementary;
    }

    @Override
    public void onGlobalLayout() {
        getViewTreeObserver().removeGlobalOnLayoutListener(this);
        Log.i("TSSView", "global layout");
        if(w==0&&h==0){
            requestLayout();
        }
    }
}
