package com.ridgid.softwaresolution.closetmaid.views;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Style;
import android.util.AttributeSet;
import android.widget.TextView;

public class CutRodTextView extends TextView{
	
	
	public CutRodTextView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}
	public CutRodTextView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}

	public CutRodTextView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
		
	}
	
	Paint mPaint=new Paint();
	@Override
	protected void onDraw(Canvas canvas) {
		// TODO Auto-generated method stub
		super.onDraw(canvas);
		mPaint.setColor(Color.RED);
		mPaint.setStyle(Style.FILL_AND_STROKE);
		mPaint.setStrokeWidth(4);
		int h=this.getHeight();
		int w=this.getWidth();
//		this.getdrawing
//		int h=canvas.getHeight();
//		int w=canvas.getWidth();
		int line=w/2;
		canvas.drawLine(0, h,getPaddingLeft(), h, mPaint);
		//canvas.drawLine((w-line)/2, 1, (w-line)/2+line, 1, mPaint);	
	}

}
