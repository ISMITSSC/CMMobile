package com.ridgid.softwaresolution.closetmaid.adapters;

import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CheckedTextView;

public class SpinnerAdapter extends ArrayAdapter<String> {

	String[] data;
	Context context;
	
	public SpinnerAdapter(Context context, int resource,
			int textViewResourceId, String[] objects) {
		super(context, resource, textViewResourceId, objects);
		// TODO Auto-generated constructor stub
		this.context=context;
		this.data=objects;
	}
	
	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		return super.getView(position, convertView, parent);
	}
	
	
	@Override
	public View getDropDownView(int position, View convertView, ViewGroup parent) {
		View row = convertView;
		CheckedTextView checkBox;
        if(row == null)
        {
            LayoutInflater inflater = ((Activity) context).getLayoutInflater();
            row = inflater.inflate(R.layout.spinner_dropdown, parent, false);
        }
        checkBox=(CheckedTextView)row;
        checkBox.setText(data[position]);         
        return row;
	}
	

}
