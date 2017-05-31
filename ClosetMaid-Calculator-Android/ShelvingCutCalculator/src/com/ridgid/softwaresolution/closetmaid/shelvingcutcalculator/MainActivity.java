package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator;


import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments.InputShelvingFragments;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments.MainFragment;

import android.view.inputmethod.InputMethodManager;
import android.os.Bundle;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.view.Menu;
import android.view.View;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;

public class MainActivity extends FragmentActivity {
	
	
	public static final String mainFragmentName="main";
	public static final String ResultFrag="result";
	

	InputMethodManager inputManager;


	public InputMethodManager getInputManager() {
		return inputManager;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.shelving_cut_calculator);
		if(findViewById(R.id.fragment_container)!=null)
		{
		   if(savedInstanceState!=null)
		   {
			   return;   
		   }
		   MainFragment mainFragment=new MainFragment();
		   getSupportFragmentManager().beginTransaction().replace(R.id.fragment_container, mainFragment,mainFragmentName).commit();
		}
		inputManager=(InputMethodManager)getSystemService(INPUT_METHOD_SERVICE);	
	}
	
	
	@Override
	public void onBackPressed() {
		Fragment frag=getSupportFragmentManager().findFragmentByTag(mainFragmentName);
		if(frag.isVisible())
		{
			new AlertDialog.Builder(this)
			.setMessage(R.string.quit_app_message)
			.setPositiveButton(R.string.yes, new OnClickListener() {
				@Override
				public void onClick(DialogInterface dialog, int which) {
					finish();
				}
			})
			.setNegativeButton(R.string.no,null)
			.show();
		}
		else
		{
			super.onBackPressed();
		}
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		return true;
	}
	
}
