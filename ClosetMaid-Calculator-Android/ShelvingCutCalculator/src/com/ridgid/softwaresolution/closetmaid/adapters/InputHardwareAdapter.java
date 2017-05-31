
package com.ridgid.softwaresolution.closetmaid.adapters;

import com.ridgid.softwaresolution.closetmaid.data.HardwareShelf;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
import com.ridgid.softwaresolution.closetmaid.views.CustomEditText;

import android.app.Activity;
import android.content.Context;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnFocusChangeListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

public class InputHardwareAdapter extends ArrayAdapter<HardwareShelf> implements OnFocusChangeListener,
        OnItemSelectedListener {

    ArrayList<HardwareShelf> shelves;

    private String editedText = "";

    int focusedPosition = -1;

    boolean quantityFocused = true;

    int removablePosition = -1;

    boolean metric = false;

    boolean showWarning = false;

    float minLength;

    float maxLength;

    EditText aFriendInNeed;

    private onRowsChangedListener listener;

    private boolean lastVisible = false;

    View lastRow = null;

    public InputHardwareAdapter(Context context, int textViewResourceId, List<HardwareShelf> objects, boolean metric,
            EditText aFriendInNeed, onRowsChangedListener listener) {
        super(context, textViewResourceId, objects);
        this.listener = listener;
        this.shelves = (ArrayList<HardwareShelf>)objects;
        this.metric = metric;
        this.aFriendInNeed = aFriendInNeed;
        if (metric) {
            minLength = Float.valueOf(getContext().getResources().getString(R.string.minMetricLength));
            maxLength = Float.valueOf(getContext().getResources().getString(R.string.maxMetricLength));
        } else {
            minLength = Float.valueOf(getContext().getResources().getString(R.string.minImperialLength));
            maxLength = Float.valueOf(getContext().getResources().getString(R.string.maxImperialLenght));
        }

        for (int i = 0; i < shelves.size(); i++) {
            if (shelves.get(i).getLength() == -1 && shelves.get(i).getQuantity() == -1) {
                if (i < shelves.size() - 1) {
                    break;
                } else {
                    lastVisible = true;
                }
            }
        }

    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        Holder h;
        if (row == null) {
            LayoutInflater inflater = ((Activity)getContext()).getLayoutInflater();
            row = inflater.inflate(R.layout.input_row_hardware, parent, false);
            h = new Holder();
            row.setTag(h);

            h.edtLength = (CustomEditText)row.findViewById(R.id.edt_size);
            h.edtQuantity = (CustomEditText)row.findViewById(R.id.edt_quantity);
            h.spnLocation = (Spinner)row.findViewById(R.id.spnr_location);
            h.spnLocation.setTag(h);
            String[] shelfLocation = getContext().getResources().getStringArray(R.array.hardware_shelf_location);
            createAndSetAdapter(h.spnLocation, shelfLocation);
            h.spnLocation.setOnItemSelectedListener(this);

            EditTextWatcher textWatcher = new EditTextWatcher(h);
            h.textWatcher = textWatcher;
            h.edtLength.addTextChangedListener(textWatcher);
            h.edtQuantity.addTextChangedListener(textWatcher);
            h.edtLength.setOnFocusChangeListener(this);
            h.edtQuantity.setOnFocusChangeListener(this);
            h.edtLength.setAFriendInNeed(aFriendInNeed);
            h.edtQuantity.setAFriendInNeed(aFriendInNeed);

        } else {
            h = (Holder)row.getTag();
        }

        HardwareShelf crt = shelves.get(position);
        h.shelf = crt;
        h.position = position;
        h.edtLength.setTag(h);
        h.edtQuantity.setTag(h);
        h.edtLength.setOnFocusChangeListener(this);

        String unit;
        if (metric) {
            unit = "cm";
        } else {
            unit = "\"";
        }
        if (crt.getLength() > 0) {
            if (focusedPosition != position || (focusedPosition == position && quantityFocused)) {
                h.edtLength.removeTextChangedListener(h.textWatcher);
                h.edtLength.setText(String.valueOf((int)crt.getLength()) + unit);
                h.edtLength.addTextChangedListener(h.textWatcher);
            }
        } else {
            h.edtLength.removeTextChangedListener(h.textWatcher);
            h.edtLength.getText().clear();
            h.edtLength.addTextChangedListener(h.textWatcher);
        }
        if (crt.getQuantity() > 0) {

            if (focusedPosition != position) {
                h.edtQuantity.removeTextChangedListener(h.textWatcher);
                h.edtQuantity.setText(String.valueOf(crt.getQuantity()));
                h.edtQuantity.addTextChangedListener(h.textWatcher);
            }
        } else {
            h.edtQuantity.removeTextChangedListener(h.textWatcher);
            h.edtQuantity.setText("");
            h.edtQuantity.addTextChangedListener(h.textWatcher);
        }
        if (position == focusedPosition) {
            if (!quantityFocused) {
                h.edtLength.setOnFocusChangeListener(null);
                h.edtLength.removeTextChangedListener(h.textWatcher);
                h.edtLength.requestFocus();
                h.edtLength.getText().clear();
                h.edtLength.append(editedText);
                h.edtLength.setOnFocusChangeListener(this);
                h.edtLength.addTextChangedListener(h.textWatcher);
            } else {
                h.edtQuantity.setOnFocusChangeListener(null);
                h.edtQuantity.removeTextChangedListener(h.textWatcher);
                h.edtQuantity.requestFocus();
                h.edtLength.getText().clear();
                h.edtQuantity.append(editedText);
                h.edtQuantity.addTextChangedListener(h.textWatcher);
                h.edtQuantity.setOnFocusChangeListener(this);
            }
        } else {
            if (h.edtQuantity.hasFocus()) {
                h.edtQuantity.clearFocus();
            }
            if (h.edtLength.hasFocus()) {
                h.edtLength.clearFocus();
            }
        }

        h.spnLocation.setSelection(crt.getLocationType());

        row.setVisibility(View.VISIBLE);
        if (position == shelves.size() - 1 && !lastVisible && position > 0) {
            row.setVisibility(View.INVISIBLE);
            lastRow = row;
        }

        return row;
    }

    private static class Holder {

        HardwareShelf shelf;

        int position;

        CustomEditText edtQuantity;

        CustomEditText edtLength;

        Spinner spnLocation;

        EditTextWatcher textWatcher;
    }

    protected void createAndSetAdapter(Spinner spinner, String[] values) {
        SpinnerAdapter adapter = new SpinnerAdapter(getContext(), R.layout.spinner_item, android.R.id.text1, values);
        spinner.setAdapter(adapter);
    }

    private String getUnit(boolean metric) {
        if (metric) {
            return "cm";
        } else {
            return "\"";
        }
    }

    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        CustomEditText crt = (CustomEditText)v;
        Holder holder = (Holder)v.getTag();
        String value = crt.getText().toString();
        crt.dataHasErrors = false;
        int position = holder.position;
        if (!hasFocus) {
            if (focusedPosition != -1) {
                if (!value.equals("")) {
                    try {
                        if (v.getId() == R.id.edt_quantity) {
                            value = value.replace("cm", "").replace("\"", "");
                            int q = Integer.parseInt(value);
                            if (q > 1000000) {
                                throw new Exception();
                            }
                            holder.shelf.setQuantity(q);
                        } else if (v.getId() == R.id.edt_size) {
                            value = value.replace("cm", "").replace("\"", "");
                            int s = Integer.parseInt(value);
                            if (s > maxLength || s < minLength) {
                                showLengthWarning();
                                s = s > maxLength ? (int)maxLength : (int)Math.ceil(minLength);
                                crt.dataHasErrors = true;
                            }
                            holder.shelf.setLength(s);
                            crt.removeTextChangedListener(holder.textWatcher);
                            crt.setText(String.valueOf(s) + getUnit(metric));
                            crt.addTextChangedListener(holder.textWatcher);
                        }
                    } catch (Exception ex) {
                        value = "";
                        crt.removeTextChangedListener(holder.textWatcher);
                        holder.textWatcher.onTextChanged("", 0, 1, 1);
                        crt.setText(value);
                        crt.addTextChangedListener(holder.textWatcher);
                        Toast t = Toast.makeText(getContext(), R.string.hardware_quantity_exceded, 2000);
                        t.setGravity(Gravity.TOP, 0, 0);
                        t.show();
                        crt.dataHasErrors = true;
                    }
                } else {
                    position = position == shelves.size() ? position - 1 : position;
                    if (v.getId() == R.id.edt_quantity) {
                        holder.shelf.setQuantity(-1);
                    } else if (v.getId() == R.id.edt_size) {
                        holder.shelf.setLength(-1);
                    }
                    if (holder.shelf.getLength() == -1 && holder.shelf.getQuantity() == -1) {
                        removablePosition = position;
                    }
                }
            }
        } else {

            HardwareShelf current = holder.shelf;
            if (current.getLength() == -1 && current.getQuantity() == -1) {
                if (lastVisible) {
                    InputHardwareAdapter.this.add(new HardwareShelf(-1, 0, -1));
                    rowAdded();
                    lastVisible = false;
                }
            }

            if (v.getId() == R.id.edt_quantity) {
                quantityFocused = true;
            } else if (v.getId() == R.id.edt_size) {
                quantityFocused = false;
                if (metric) {
                    value = value.replace("cm", "");
                } else {
                    value = value.replace("\"", "");
                }
                crt.removeTextChangedListener(holder.textWatcher);
                crt.getText().clear();
                crt.append(value);
                crt.addTextChangedListener(holder.textWatcher);
            }
            editedText = value;
            focusedPosition = position;
        }
    }

    private void showLengthWarning() {
        showWarning = false;
        DecimalFormat f = new DecimalFormat("#.##");
        f.setDecimalSeparatorAlwaysShown(false);
        String message = getContext().getString(R.string.length_max_warning_message);
        message = message.replace(".", "");
        message += " (" + f.format(minLength) + getUnit(metric) + "-" + f.format(maxLength) + getUnit(metric) + ").";
        Toast t = Toast.makeText(getContext(), R.string.length_max_warning_message, 2000);
        t.setGravity(Gravity.TOP, 0, 0);
        t.show();
    }

    private class EditTextWatcher implements TextWatcher {

        Holder holder;

        public EditTextWatcher(Holder h) {
            this.holder = h;
        }

        @Override
        public void afterTextChanged(Editable s) {

        }

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            editedText = s.toString();
            HardwareShelf current = holder.shelf;
            if (start == 0 && before == 0) {
                if (current.getLength() == -1 && current.getQuantity() == -1) {
                    if (lastRow != null) {
                        lastRow.setVisibility(View.VISIBLE);
                        removablePosition = ((Holder)lastRow.getTag()).position;
                    }
                    lastVisible = true;
                }
            }
            if (start == 0 && before == 1) {
                if (quantityFocused) {
                    current.setQuantity(-1);
                    if (current.getLength() == -1) {
                        if (removablePosition == shelves.size() - 1) {
                            lastVisible = false;
                            if (lastRow != null) {
                                lastRow.setVisibility(View.INVISIBLE);
                            }
                        } else {
                            InputHardwareAdapter.this.remove(shelves.get(removablePosition));
                            lastVisible = false;
                            rowDeleted();
                        }
                    }
                } else {
                    current.setLength(-1);
                    if (current.getQuantity() == -1) {
                        if (removablePosition == shelves.size() - 1) {
                            lastVisible = false;
                            if (lastRow != null) {
                                lastRow.setVisibility(View.INVISIBLE);
                            }
                        } else {
                            InputHardwareAdapter.this.remove(shelves.get(removablePosition));
                            lastVisible = false;
                            rowDeleted();
                        }

                    }
                }
                if (focusedPosition > removablePosition) {
                    focusedPosition--;
                }

            }
        }

    }

    @Override
    public void onItemSelected(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
        Holder h = (Holder)arg0.getTag();
        if (h.shelf != null) {
            h.shelf.setLocationType(arg2);
        }
    }

    @Override
    public void onNothingSelected(AdapterView<?> arg0) {

    }

    public void deleteRow(int position) {
        if (position != removablePosition) {
            shelves.remove(position);
            notifyDataSetChanged();
            focusedPosition = -1;
            editedText = "";
            rowDeleted();
        }
    }

    public void resetList() {
        shelves.clear();
        shelves.add(new HardwareShelf(-1, 0, -1));

        shelves.add(new HardwareShelf(-1, 0, -1));
        lastVisible = false;

        focusedPosition = -1;
        notifyDataSetChanged();
        rowDeleted();
    }

    private void rowAdded() {
        if (getCount() == 3) {
            listener.multiRowsRemaining();
        }
    }

    private void rowDeleted() {
        if (getCount() == 2 && !lastVisible) {
            listener.oneRowRemaining();
        }
    }

    public interface onRowsChangedListener {

        public void multiRowsRemaining();

        public void oneRowRemaining();

    }

}
