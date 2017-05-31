package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments;

import com.ridgid.softwaresolution.closetmaid.adapters.SpinnerAdapter;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.MainActivity;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
import com.tss.views.TSSButton;

import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.Spinner;
import android.widget.TextView;

public class MainFragment extends BaseFragment implements OnClickListener{

	
		boolean metric;
		Spinner spinnerUnits;
		String[] units;
	
		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			if(getArguments()!=null){
				metric=getArguments().getBoolean("metric", false);
			}
			
			View v=inflater.inflate(R.layout.main, container,false);
			
			TSSButton btnShelvingCalculator=(TSSButton)v.findViewById(R.id.btn_shelving_calculator);
			btnShelvingCalculator.setOnClickListener(this);
			TSSButton btnHardwareCalculator=(TSSButton)v.findViewById(R.id.btn_hardware_calculator);
			btnHardwareCalculator.setOnClickListener(this);
			Button btnSettings=(Button)v.findViewById(R.id.btn_settings);
			btnSettings.setOnClickListener(this);
			units=getResources().getStringArray(R.array.measurement_unit);
			spinnerUnits=(Spinner)v.findViewById(R.id.spn_unit);
			createAndSetAdapter(spinnerUnits, units);
			int position=0;
			if(metric){
				position=1;
			}
			spinnerUnits.setSelection(position);
			return v;
		}
		
		private void launchShelvingCalculator(){
			InputShelvingFragments fragment=new InputShelvingFragments();
			fragment.setArguments(createArguments());
			launchFragment(fragment);
			
		}
		
		private void launcHardwareCalculator(){
			InputHardwareFragment fragment=new InputHardwareFragment();
			fragment.setArguments(createArguments());
			launchFragment(fragment);
		}
		
		private void launchFragment(Fragment fragment){
			android.support.v4.app.FragmentTransaction transaction=getActivity().getSupportFragmentManager().beginTransaction();
			transaction.setCustomAnimations(R.anim.push_left_in,R.anim.push_left_out,R.anim.push_right_in, R.anim.push_right_out);
			transaction.replace(R.id.fragment_container,fragment,MainActivity.ResultFrag);
			transaction.addToBackStack(null);
			transaction.commit();
		}
		
		private Bundle createArguments(){
			Bundle b=new Bundle();
			int index=spinnerUnits.getSelectedItemPosition();
			if(index==0){
				metric=false;
			}else{
				metric=true;
			}
			b.putBoolean("metric", metric);
			return b;
		}

		@Override
		public void onClick(View v) {
			if(v.getId()==R.id.btn_shelving_calculator){
				launchShelvingCalculator();
			}else if(v.getId()==R.id.btn_hardware_calculator){
				launcHardwareCalculator();
			}else if(v.getId()==R.id.btn_settings){
				spinnerUnits.performClick();
			}
		}
		
		
	
}
