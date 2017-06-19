
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments;

import com.ridgid.softwaresolution.closetmaid.adapters.InputHardwareAdapter;
import com.ridgid.softwaresolution.closetmaid.adapters.InputHardwareAdapter.onRowsChangedListener;
import com.ridgid.softwaresolution.closetmaid.data.HardwareShelf;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.MainActivity;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools.CalculateHardware;
import com.ridgid.softwaresolution.closetmaid.views.CustomScrollView;
import com.ridgid.softwaresolution.closetmaid.views.CustomScrollView.onHeightListener;
import com.ridgid.softwaresolution.closetmaid.views.InnerScrollListView;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

public class InputHardwareFragment extends BaseFragment implements OnClickListener, onHeightListener,
        onRowsChangedListener {

    int shelfType;

    ArrayList<HardwareShelf> shelves = new ArrayList<HardwareShelf>();

    boolean metric;

    Spinner spnShelfType;

    InputHardwareAdapter inputAdapter;

    InnerScrollListView listInput;

    CustomScrollView outerScroll;

    View masterLayout;

    View parentView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        metric = getArguments().getBoolean("metric");
        shelves.add(new HardwareShelf(-1, 0, -1));
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {

        if (parentView == null) {
            parentView = inflater.inflate(R.layout.input_hardware, container, false);
            EditText edtAFriendInNeed = (EditText)parentView.findViewById(R.id.edt_afriendinneed);
            applyFonts(parentView,
                    Typeface.createFromAsset(getActivity().getAssets(), "font/helveticaneue-condensed.ttf"));

            masterLayout = parentView.findViewById(R.id.lay_master);

            spnShelfType = (Spinner)parentView.findViewById(R.id.spnr_hardware_shelving_types);
            createAndSetAdapter(spnShelfType, createShelfTypes());

            listInput = (InnerScrollListView)parentView.findViewById(R.id.list_hardware_inputs);
            inputAdapter = new InputHardwareAdapter(getActivity(), 0, shelves, metric, edtAFriendInNeed, this);
            if (shelves.size() > 1) {
                multiRowsRemaining();
            }
            listInput.setAdapter(inputAdapter);
            outerScroll = (CustomScrollView)parentView.findViewById(R.id.scroll);
            outerScroll.setScrollableChild(listInput);
            outerScroll.setOnHeightListener(this);

            TextView txtQuantity = (TextView)parentView.findViewById(R.id.txtquantityhead);
            txtQuantity.setTypeface(getHelveticaBold());
            TextView txtLenght = (TextView)parentView.findViewById(R.id.txtlenghthead);
            txtLenght.setTypeface(getHelveticaBold());
            TextView txtLocation = (TextView)parentView.findViewById(R.id.txtshelflocation);
            txtLocation.setTypeface(getHelveticaBold());

            Button btnCalculate = (Button)parentView.findViewById(R.id.btn_hardware_calculate);
            btnCalculate.setOnClickListener(this);
            applyFonts(btnCalculate, getHelveticaBold());

            Button btnClear = (Button)parentView.findViewById(R.id.btn_hardware_clear);
            btnClear.setOnClickListener(this);
        } else {
            ((ViewGroup)parentView.getParent()).removeView(parentView);
        }

        return parentView;
    }

    private String[] createShelfTypes() {
        String[] dimms;
        if (metric) {
            dimms = getResources().getStringArray(R.array.hardware_shelf_dimm_cm);
        } else {
            dimms = getResources().getStringArray(R.array.hardware_shelf_dimm_inch);
        }

        String[] shelfTypes = getResources().getStringArray(R.array.hardware_shelving_type);
        String[] shelfAssociations = getResources().getStringArray(R.array.harware_needed_type_association);
        String[] spinnerValues = new String[shelfAssociations.length];

        for (int i = 0; i < spinnerValues.length; i++) {
            String[] key_value = shelfAssociations[i].split("\\|", 2);
            spinnerValues[i] = dimms[Integer.parseInt(key_value[0])] + " " + shelfTypes[Integer.parseInt(key_value[1])];
        }

        return spinnerValues;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btn_hardware_calculate) {
            prepareShowResults();
        } else if (v.getId() == R.id.btn_hardware_clear) {
            clearList();
        }
    }

    private boolean waitToKeyboardToHide = false;

    private void prepareShowResults() {
        if (hideKeyboardIfPossible()) {
            waitToKeyboardToHide = true;
        } else {
            if (!dataHasErrors) {
                showResults();
            }
        }
    }

    private void showResults() {
        waitToKeyboardToHide = false;
        shelfType = spnShelfType.getSelectedItemPosition();
        ArrayList<HardwareShelf> validShelves = new ArrayList<HardwareShelf>(shelves.size());
        boolean validInputs = false;
        for (HardwareShelf s : shelves) {
            if (s.getLength() > 0 && s.getQuantity() > 0) {
                validShelves.add(s);
                validInputs = true;
            }
        }
        if (validInputs) {
            long[] values = new CalculateHardware().calculate(getActivity(), shelfType, validShelves);

            ResultsHardwareFragment result = new ResultsHardwareFragment();
            result.setArguments(addResultsToBundle(values, validShelves));
            android.support.v4.app.FragmentTransaction transaction = getActivity().getSupportFragmentManager()
                    .beginTransaction();
            transaction.setCustomAnimations(R.anim.push_left_in, R.anim.push_left_out, R.anim.push_right_in,
                    R.anim.push_right_out);
            transaction.replace(R.id.fragment_container, result, MainActivity.ResultFrag);
            transaction.addToBackStack(null);
            transaction.commit();
        } else {
            Toast t = Toast.makeText(getActivity(), R.string.hardware_enter_data_message, 2000);
            t.setGravity(Gravity.TOP, 0, 0);
            t.show();
        }
    }

    private void clearList() {
        new AlertDialog.Builder(getActivity()).setMessage(R.string.clear_data_message)
                .setPositiveButton(R.string.yes, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        hideKeyboardIfPossible();
                        inputAdapter.resetList();
                    }
                }).setNegativeButton(R.string.no, null).show();
    }

    private Bundle addResultsToBundle(long[] values, ArrayList<HardwareShelf> validShelves) {
        Bundle b = new Bundle();
        b.putLongArray("results", values);

        int[] quantities = new int[validShelves.size()];
        float[] lengths = new float[validShelves.size()];
        int[] locations = new int[validShelves.size()];

        for (int i = 0; i < validShelves.size(); i++) {
            HardwareShelf s = validShelves.get(i);
            quantities[i] = s.getQuantity();
            lengths[i] = s.getLength();
            locations[i] = s.getLocationType();
        }

        b.putIntArray("quantities", quantities);
        b.putFloatArray("lengths", lengths);
        b.putIntArray("locations", locations);
        b.putString("type", (String)spnShelfType.getSelectedItem());
        b.putString("unit", getUnit());
        return b;
    }

    @Override
    public void onHeightChanged(int newHeight, int oldHeight) {
        if (oldHeight == 0) {
            listInput.getLayoutParams().height = listInput.getMeasuredHeight();
            masterLayout.getLayoutParams().height = newHeight;
            masterLayout.requestLayout();
        } else {
            outerScroll.smoothScrollBy(0, newHeight - oldHeight);
            if (newHeight > oldHeight) {
                // keyboard hidden
                if (waitToKeyboardToHide) {
                    showResults();
                }
            }
        }
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo) {
        Log.i("input hardaweare", "create context menu");
        super.onCreateContextMenu(menu, v, menuInfo);
        menu.add(0, v.getId(), 0, R.string.delete);
    }

    @Override
    public boolean onContextItemSelected(MenuItem item) {
        AdapterContextMenuInfo info = ((AdapterContextMenuInfo)item.getMenuInfo());
        InputHardwareAdapter listAdapter = (InputHardwareAdapter)listInput.getAdapter();
        listAdapter.deleteRow(info.position);
        return true;
    }

    @Override
    public void multiRowsRemaining() {
        registerForContextMenu(listInput);
    }

    @Override
    public void oneRowRemaining() {
        unregisterForContextMenu(listInput);
    }

    private String getUnit() {
        if (metric) {
            return "cm";
        } else {
            return "\"";
        }
    }

}
