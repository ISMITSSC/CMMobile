package com.ridgid.softwaresolution.closetmaid.adapters;

import java.util.ArrayList;

import com.ridgid.softwaresolution.closetmaid.data.Measures;
import com.ridgid.softwaresolution.closetmaid.views.CuttingView;
import com.ridgid.softwaresolution.closetmaid.views.CuttingView.SizeListener;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

//public class ResultAdapter extends BaseAdapter{
//
//	 @Override
//	    public int getCount() {
//	        return 20;
//	    }
//	 
//	    @Override
//	    public Object getItem(int position) {
//	        return 0;
//	    }
//	 
//	    @Override
//	    public long getItemId(int position) {
//	        return 0;
//	    }
//	 
//	    @Override
//	    public View getView(int position, View convertView, ViewGroup parent) {
//	        CuttingView view=new CuttingView(parent.getContext());
//	        return view;
//	    }
//}

public class ResultAdapter extends ArrayAdapter<Measures> implements SizeListener
{
	Context context;
	Measures[] data=null;
	View txtCutRod;
	ArrayList<View> cuts=new ArrayList<View>();
	
	int cutViewHeight;
	int cutViewWidth;
	
	public ResultAdapter(Context context,Measures[] data,View txtCutRod,View parent)
	{
		super(context,0,data);
		this.context=context;
		this.data=data;
		if(txtCutRod!=null){
		this.txtCutRod=txtCutRod;
		if(txtCutRod.getVisibility()==View.VISIBLE)
		{
			txtCutRod.setVisibility(View.VISIBLE);
		}
		}
	}

	
	@Override
	public View getView(int position,View convertView,ViewGroup parent)
	{
		View v=convertView;
		ResultHolder holder=null;
		if(v==null)
		{
			v=new CuttingView(parent.getContext(),parent,data[position],txtCutRod,this);
			holder=new ResultHolder();
			holder.view=(CuttingView)v;
			v.setTag(holder);
		}
		else
		{
			holder=(ResultHolder)v.getTag();
		}
		holder.view.setCuttingMeasures(data[position]);
		return v;
	}
	
	public int getCutViewWidth(){
		return cutViewWidth;
	}
	
	public int getCutViewHeight(){
		return cutViewHeight;
	}
	
	
	static class ResultHolder
	{
		CuttingView view;
	}


	@Override
	public void onCutViewSizeChange(int width, int height) {
		cutViewWidth=width;
		cutViewHeight=height;
	}
}
