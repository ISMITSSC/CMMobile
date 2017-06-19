package com.ridgid.softwaresolution.closetmaid.views;


import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.widget.ScrollView;

public class SpecialVerticalScrollView extends ScrollView{

	public SpecialVerticalScrollView(Context context, AttributeSet attrs,
			int defStyle) {
		super(context, attrs, defStyle);
		// TODO Auto-generated constructor stub
	}
	public SpecialVerticalScrollView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}
	public SpecialVerticalScrollView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
	}
	float x;
	float y;
	boolean scrolling;
	@Override
	public boolean onInterceptTouchEvent(MotionEvent event) {
		// TODO Auto-generated method stub
		switch(event.getAction())
 		{
 		case MotionEvent.ACTION_DOWN:
 		{
 			x=event.getX();
 			y=event.getY();
 			scrolling=false;
 			super.onTouchEvent(event);
 			Log.i("InputView","Scroll down");
 		}
 		break;
 		case MotionEvent.ACTION_MOVE:
 		{
 				float vertical=Math.abs(y-event.getY());
 				float horizontal=Math.abs(x-event.getX());
 				Log.i("InputView", "Scroll");
 				if(vertical>5*(horizontal+1)||scrolling)
 				{
 					scrolling=true;
 					Log.i("InputView","Scrolling");
 					return super.onTouchEvent(event);
 				}
 			}
 		break;
 		case MotionEvent.ACTION_UP:
 		{
 			Log.i("InputView", "Scroll Up");
 			if(scrolling)
 			{
 				return true;
 			}
 			else
 			{
 			return false;
 			}
 		}
 		default:
 			super.onTouchEvent(event);
 			break;
 		}
		return false;
	}
	

}
