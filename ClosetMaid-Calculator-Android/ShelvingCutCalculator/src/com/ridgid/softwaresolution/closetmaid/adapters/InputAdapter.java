
package com.ridgid.softwaresolution.closetmaid.adapters;

import com.ridgid.softwaresolution.closetmaid.data.Shelf;
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
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

public class InputAdapter extends ArrayAdapter<Shelf> implements OnFocusChangeListener {

    private ArrayList<Shelf> shelves;

    private String editedText = "";

    int focusedPosition = -1;

    boolean quantityFocused = true;

    int removablePosition = -1;

    boolean metric = false;

    boolean showWarning = false;

    Shelf board;

    private EditText edtFriendInNeed;

    private onRowsChangedListener listener;

    private boolean lastVisible = false;

    View lastRow = null;

    boolean hadErrors = false;

    public InputAdapter(Context context, int textViewResourceId, List<Shelf> objects, boolean metric, Shelf board,
            EditText edtFriendInNeed, onRowsChangedListener listener) {
        super(context, textViewResourceId, objects);
        this.shelves = (ArrayList<Shelf>)objects;
        this.metric = metric;
        this.board = board;
        this.edtFriendInNeed = edtFriendInNeed;
        this.listener = listener;
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
            h = new Holder();
            LayoutInflater inflater = ((Activity)getContext()).getLayoutInflater();
            row = inflater.inflate(R.layout.input_row, null);
            h.edtQuantity = (CustomEditText)row.findViewById(R.id.edt_quantity);
            h.edtQuantity.setOnFocusChangeListener(this);
            h.edtQuantity.setAFriendInNeed(edtFriendInNeed);
            EditTextWatcher textWatcher = new EditTextWatcher(h);
            h.edtQuantity.addTextChangedListener(textWatcher);
            h.edtLength = (CustomEditText)row.findViewById(R.id.edt_size);
            h.edtLength.setAFriendInNeed(edtFriendInNeed);
            h.edtLength.setOnFocusChangeListener(this);
            h.edtLength.addTextChangedListener(textWatcher);
            h.textWatcher = textWatcher;
            row.setTag(h);
        } else {
            h = (Holder)row.getTag();
        }

        Shelf crt = shelves.get(position);
        h.shelf = crt;
        h.edtLength.setTag(h);
        h.edtQuantity.setTag(h);
        h.position = position;

        String unit;
        if (metric) {
            unit = "cm";
        } else {
            unit = "\"";
        }
        if (crt.getLength() > 0) {
            if (crt.getLength() > board.getLength()) {
                showWarning = true;
                crt.setLength(board.getLength());
            }
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

        if (position == getCount() - 1) {
            if (showWarning) {
                showLengthWarning();
            }
        }

        row.setVisibility(View.VISIBLE);
        // lastRow = null;
        if (position == shelves.size() - 1 && !lastVisible && position > 0) {
            row.setVisibility(View.INVISIBLE);
            lastRow = row;
        }

        return row;
    }

    private void showLengthWarning() {
        showWarning = false;
        Toast t = Toast.makeText(getContext(), R.string.length_max_warning_message, 2000);
        t.setGravity(Gravity.TOP, 0, 0);
        t.show();
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
                            holder.shelf.setQuantity(q);
                        } else if (v.getId() == R.id.edt_size) {
                            value = value.replace("cm", "").replace("\"", "");
                            int s = Integer.parseInt(value);
                            if (s > board.getLength()) {
                                showLengthWarning();
                                crt.dataHasErrors = true;
                                s = (int)board.getLength();
                            }
                            holder.shelf.setLength(s);
                            crt.removeTextChangedListener(holder.textWatcher);
                            crt.setText(String.valueOf(s) + getUnit(metric));
                            crt.addTextChangedListener(holder.textWatcher);
                        }
                    } catch (Exception ex) {
                        value = "";
                        crt.removeTextChangedListener(holder.textWatcher);
                        crt.setText(value);
                        crt.addTextChangedListener(holder.textWatcher);
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

            Shelf current = holder.shelf;
            if (current.getLength() == -1 && current.getQuantity() == -1) {
                if (lastVisible) {
                    InputAdapter.this.add(new Shelf(-1, -1));
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
                crt.setOnFocusChangeListener(null);
                crt.getText().clear();
                crt.append(value);
                crt.setOnFocusChangeListener(this);
                crt.addTextChangedListener(holder.textWatcher);
            }
            editedText = value;
            focusedPosition = position;
        }
    }

    private String getUnit(boolean metric) {
        if (metric) {
            return "cm";
        } else {
            return "\"";
        }
    }

    public void notifyBoardLenghtChanged() {
        notifyDataSetChanged();
    }

    public void setUnit(boolean metric) {
        this.metric = metric;
        notifyDataSetChanged();
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
            Shelf current = holder.shelf;
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
                            InputAdapter.this.remove(shelves.get(removablePosition));
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
                            InputAdapter.this.remove(shelves.get(removablePosition));
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

    public void resetList() {
        shelves.clear();
        shelves.add(new Shelf(-1, -1));
        shelves.add(new Shelf(-1, -1));
        lastVisible = false;
        focusedPosition = -1;
        notifyDataSetChanged();
        rowDeleted();
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

    private static class Holder {

        int position;

        Shelf shelf;

        CustomEditText edtQuantity;

        CustomEditText edtLength;

        EditTextWatcher textWatcher;
    }

    public interface onRowsChangedListener {

        public void multiRowsRemaining();

        public void oneRowRemaining();
    }
}
