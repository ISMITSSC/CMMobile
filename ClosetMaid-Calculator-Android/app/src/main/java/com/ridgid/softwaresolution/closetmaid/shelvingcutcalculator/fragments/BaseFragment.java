
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments;

import com.ridgid.softwaresolution.closetmaid.adapters.SpinnerAdapter;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.MainActivity;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
import com.ridgid.softwaresolution.closetmaid.views.CustomEditText;

import android.graphics.Typeface;
import android.support.v4.app.Fragment;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.Spinner;
import android.widget.TextView;

public class BaseFragment extends Fragment {

    public Typeface getHelveticaBold() {
        if (bold == null) {
            bold = Typeface.createFromAsset(getActivity().getAssets(), "font/helveticaneue-boldcond.ttf");
        }
        return bold;
    }

    Typeface bold;

    Typeface normal;

    public Typeface getHelvetica() {
        if (normal == null) {
            normal = Typeface.createFromAsset(getActivity().getAssets(), "font/helveticaneue-condensed.ttf");
        }
        return normal;
    }

    public static void applyFonts(final View v, Typeface fontToSet) {
        try {
            if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup)v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    View child = vg.getChildAt(i);
                    applyFonts(child, fontToSet);
                }
            } else if (v instanceof TextView) {
                ((TextView)v).setTypeface(fontToSet);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // ignore
        }
    }

    protected void createAndSetAdapter(Spinner spinner, String[] values) {
        SpinnerAdapter adapter = new SpinnerAdapter(getActivity(), R.layout.spinner_item, android.R.id.text1, values) {
            @Override
            public View getView(int position, View convertView, ViewGroup parent) {
                View v = super.getView(position, convertView, parent);
                TextView txtSpinner = (TextView)v.findViewById(android.R.id.text1);
                txtSpinner.setTypeface(getHelveticaBold());
                return v;
            }
        };
        spinner.setAdapter(adapter);
    }

    boolean keyboardVisible = false;

    protected boolean dataHasErrors = false;

    protected boolean hideKeyboardIfPossible() {
        boolean hideAction = false;
        View currentFocused = getActivity().getCurrentFocus();
        if (currentFocused != null) {
            if (currentFocused instanceof CustomEditText) {
                dataHasErrors = ((CustomEditText)currentFocused).virtualFocusClear();
                hideAction = ((MainActivity)getActivity()).getInputManager().hideSoftInputFromWindow(
                        currentFocused.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
                if (dataHasErrors) {
                    hideAction = false;
                }
            }
        }
        return hideAction;
    }

}
