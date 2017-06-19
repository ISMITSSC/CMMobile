package com.ridgid.softwaresolution.closetmaid.views;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.text.style.LineHeightSpan.WithDensity;
import android.util.AttributeSet;
import android.util.Log;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class ResizableImageView extends ImageView {

	public ResizableImageView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
	}

	public ResizableImageView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}

	public ResizableImageView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}
	
	
	
	@Override
	protected void onDraw(Canvas canvas) {
		// TODO Auto-generated method stub
		super.onDraw(canvas);
		//scaleImage();
	}
	
	@Override
	protected void onFinishInflate() {
		// TODO Auto-generated method stub
		super.onFinishInflate();
	}
	
	
	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		// TODO Auto-generated method stub
		int crtWidth=MeasureSpec.getSize(widthMeasureSpec);
		if(crtWidth>0)
		{
			Drawable drawable=getDrawable();
			Bitmap bitmap=((BitmapDrawable)drawable).getBitmap();
			int width=bitmap.getWidth();
			int height=bitmap.getHeight();
			float scale=((float)crtWidth)/width;
			Matrix matrix = new Matrix();
			matrix.postScale(scale, scale);
			Bitmap scaledBitmap=Bitmap.createBitmap(bitmap,0,0,width,height,matrix,true);
			width=scaledBitmap.getWidth();
			height=scaledBitmap.getHeight();
			BitmapDrawable result=new BitmapDrawable(getResources(), scaledBitmap);
			setImageDrawable(result);
			
		}
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
	}
	private void scaleImage()
	{
	   
//	    // Now change ImageView's dimensions to match the scaled image
//	    LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) view.getLayoutParams(); 
//	    params.width = width;
//	    params.height = height;
//	    view.setLayoutParams(params);
//
//	    Log.i("Test", "done");
	}

	private int dpToPx(int dp)
	{
	    float density = getContext().getResources().getDisplayMetrics().density;
	    return Math.round((float)dp * density);
	}
	

}
