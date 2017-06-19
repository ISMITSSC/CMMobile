
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments;

import com.ridgid.softwaresolution.closetmaid.adapters.InputAdapter;
import com.ridgid.softwaresolution.closetmaid.adapters.InputAdapter.onRowsChangedListener;
import com.ridgid.softwaresolution.closetmaid.data.Measures;
import com.ridgid.softwaresolution.closetmaid.data.Shelf;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.MainActivity;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
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
import android.widget.AdapterView;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;

public class InputShelvingFragments extends BaseFragment implements onHeightListener, onRowsChangedListener,
        OnClickListener {

    final int defaultLength = 144;

    View masterLayout;

    Shelf board = new Shelf(1, defaultLength);

    ArrayList<Shelf> shelves = new ArrayList<Shelf>();

    ArrayList<Measures> cuts = new ArrayList<Measures>();

    TextView txtJobNumber;

    ScrollView scrollInput;

    Spinner spinnerShelfType;

    Spinner spinnerShelfDimm;

    Spinner spinnerUnits;

    InputAdapter adapterInputs;

    InnerScrollListView listInput;

    CustomScrollView outerScroll;

    public static EditText edtAFriendInNeed;

    private boolean metric = false;

    String[] dimms;

    View parentView;

    public InputShelvingFragments() {
        shelves.add(new Shelf(-1, -1));
        shelves.add(new Shelf(-1, -1));
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    };

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void onPause() {
        super.onPause();
    };

    @Override
    public void onStop() {
        super.onStop();
    };

    public int getShelvesCount() {
        return shelves.size();
    }

    public String getCompUnit() {
        if (!metric) {
            return "cm";
        } else {
            return "\"";
        }
    }

    public String getUnit() {
        if (metric) {
            return "cm";
        } else {
            return "\"";
        }
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle saveInstanceState) {
        metric = getArguments().getBoolean("metric");

        if (parentView == null) {
            parentView = inflater.inflate(R.layout.input_layout2, container, false);
            edtAFriendInNeed = (EditText)parentView.findViewById(R.id.edt_afriendinneed);
            applyFonts(parentView,
                    Typeface.createFromAsset(getActivity().getAssets(), "font/helveticaneue-condensed.ttf"));
            String[] items = getResources().getStringArray(R.array.shelving_type_array);
            spinnerShelfType = (Spinner)parentView.findViewById(R.id.spnr_shelving);
            createAndSetAdapter(spinnerShelfType, items);

            masterLayout = parentView.findViewById(R.id.lay_master);

            dimms = getDimmension(metric);
            spinnerShelfDimm = (Spinner)parentView.findViewById(R.id.spnr_sizes);
            createAndSetAdapter(spinnerShelfDimm, dimms);
            spinnerShelfDimm.setOnItemSelectedListener(new OnItemSelectedListener() {

                @Override
                public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
                    String val = dimms[arg2];
                    val = val.replace("\"", "");
                    val = val.replace("cm", "");
                    float value = Float.parseFloat(val);
                    changeBoardLength(value);
                }

                @Override
                public void onNothingSelected(AdapterView<?> arg0) {
                }
            });

            listInput = (InnerScrollListView)parentView.findViewById(R.id.list_inputs);
            adapterInputs = new InputAdapter(getActivity(), 0, shelves, metric, board, edtAFriendInNeed, this);
            if (shelves.size() > 1) {
                multiRowsRemaining();
            }
            listInput.setAdapter(adapterInputs);

            outerScroll = (CustomScrollView)parentView.findViewById(R.id.scroll);
            outerScroll.setScrollableChild(listInput);
            outerScroll.setOnHeightListener(this);

            Button btnCalculate = (Button)parentView.findViewById(R.id.btn_calculate);
            btnCalculate.setTypeface(getHelveticaBold());
            btnCalculate.setOnClickListener(this);
            TextView txtQuantity = (TextView)parentView.findViewById(R.id.txtquantityhead);
            txtQuantity.setTypeface(getHelveticaBold());
            TextView txtLenght = (TextView)parentView.findViewById(R.id.txtlenghthead);
            txtLenght.setTypeface(getHelveticaBold());

            Button btnClearInput = (Button)parentView.findViewById(R.id.btn_clear);
            btnClearInput.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    new AlertDialog.Builder(v.getContext()).setMessage(R.string.clear_data_message)
                            .setPositiveButton(R.string.yes, new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    hideKeyboardIfPossible();
                                    adapterInputs.resetList();
                                }
                            }).setNegativeButton(R.string.no, null).show();
                }
            });
        } else {
            ((ViewGroup)parentView.getParent()).removeView(parentView);
        }
        return parentView;
    }

    private void changeBoardLength(float value) {
        board.setLength(value);
        adapterInputs.notifyBoardLenghtChanged();
    }

    private String[] getDimmension(boolean metric) {
        if (metric) {
            return getResources().getStringArray(R.array.shelving_dimm_cm);
        } else {
            return getResources().getStringArray(R.array.shelving_dimm_inch);
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

        int total = 0;
        ArrayList<Shelf> validShelves = new ArrayList<Shelf>();
        for (int i = 0; i < shelves.size(); i++) {
            Shelf crt = shelves.get(i);
            if (crt.getLength() > 0 && crt.getQuantity() > 0) {
                validShelves.add(crt);
                total += crt.getQuantity();
            }
        }
        if (total <= 1000 && total > 0) {
            String selected = (String)InputShelvingFragments.this.spinnerShelfType.getSelectedItem();
            boolean typeI = false;
            String nameTypeI = getResources().getStringArray(R.array.shelving_type_array)[0];
            if (selected.equals(nameTypeI)) {
                typeI = true;
            }
            ResultsFragment result = new ResultsFragment();
            Bundle arguments = new Bundle();
            arguments.putBoolean("type", typeI);
            arguments.putParcelable("board", board);
            arguments.putBoolean("metric", metric);
            arguments.putParcelableArrayList("shelves", validShelves);
            result.setArguments(arguments);
            android.support.v4.app.FragmentTransaction transaction = getActivity().getSupportFragmentManager()
                    .beginTransaction();
            transaction.setCustomAnimations(R.anim.push_left_in, R.anim.push_left_out, R.anim.push_right_in,
                    R.anim.push_right_out);
            transaction.replace(R.id.fragment_container, result, MainActivity.ResultFrag);
            transaction.addToBackStack(null);
            transaction.commit();
        } else {
            if (total > 1000) {
                Toast t = Toast.makeText(getActivity(), R.string.overflow_warning_message, 2000);
                t.setGravity(Gravity.TOP, 0, 0);
                t.show();
            } else {
                Toast t = Toast.makeText(getActivity(), R.string.enter_data_message, 2000);
                t.setGravity(Gravity.TOP, 0, 0);
                t.show();
            }
        }
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
                if (waitToKeyboardToHide) {
                    showResults();
                }
                outerScroll.isScrollable(false);
            } else {
                outerScroll.isScrollable(true);
            }
        }
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo) {
        Log.i("input shelving", "create context menu");
        super.onCreateContextMenu(menu, v, menuInfo);
        menu.add(0, v.getId(), 0, R.string.delete);
    }

    @Override
    public boolean onContextItemSelected(MenuItem item) {
        AdapterContextMenuInfo info = ((AdapterContextMenuInfo)item.getMenuInfo());
        InputAdapter listAdapter = (InputAdapter)listInput.getAdapter();
        listAdapter.deleteRow(info.position);
        Log.i("bullshit", String.valueOf(info.position));
        return super.onContextItemSelected(item);
    }

    @Override
    public void multiRowsRemaining() {
        registerForContextMenu(listInput);
    }

    @Override
    public void oneRowRemaining() {
        unregisterForContextMenu(listInput);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btn_calculate) {
            prepareShowResults();
        }
    }

}
