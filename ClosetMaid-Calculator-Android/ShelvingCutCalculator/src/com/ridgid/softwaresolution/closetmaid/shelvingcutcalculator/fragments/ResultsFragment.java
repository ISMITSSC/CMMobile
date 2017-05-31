
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments;

import com.ridgid.softwaresolution.closetmaid.adapters.ResultAdapter;
import com.ridgid.softwaresolution.closetmaid.data.Measures;
import com.ridgid.softwaresolution.closetmaid.data.Shelf;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools.CalculateCuts;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools.CreateMailContentTask;
import com.ridgid.softwaresolution.closetmaid.views.CutRodTextView;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.GridView;
import android.widget.TextView;

import java.text.DecimalFormat;
import java.util.ArrayList;

@SuppressLint("ValidFragment")
public class ResultsFragment extends Fragment implements OnClickListener {

    TextView txtNeeded;

    TextView txtExcess;

    Measures data[];

    Measures groupedData[];

    ArrayList<Shelf> shelves;

    Shelf board;

    boolean typeI;

    boolean metric;

    ResultAdapter adapter;

    StringBuilder message = new StringBuilder();

    GridView gridview;

    CalculateCuts calculate;

    CutRodTextView txtCutRod;

    int type;

    String whatYouNeedValue;

    String excessValue;

    float excess;

    Intent emailIntent = null;

    public ResultsFragment() {

    }

    @Override
    public void onViewStateRestored(Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle arguments = getArguments();
        typeI = arguments.getBoolean("type");
        shelves = arguments.getParcelableArrayList("shelves");
        board = arguments.getParcelable("board");
        metric = arguments.getBoolean("metric");

        calculate = new CalculateCuts();

        if (typeI) {
            type = 0;
            data = calculate.GetResult(shelves, board.getLength(), metric);
        } else {
            type = 1;
            data = calculate.GetResultTwo(shelves, board.getLength(), metric);
        }

        groupedData = groupResults(data);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle saveInstanceState) {
        View view = inflater.inflate(R.layout.result_layout, container, false);
        InputShelvingFragments.applyFonts(view,
                Typeface.createFromAsset(getActivity().getAssets(), "font/helveticaneue-condensed.ttf"));
        gridview = (GridView)view.findViewById(R.id.grid_results);
        txtCutRod = (CutRodTextView)view.findViewById(R.id.txt_cutrod);
        adapter = new ResultAdapter(this.getActivity(), groupedData, txtCutRod, gridview);
        gridview.setAdapter(adapter);
        txtNeeded = (TextView)view.findViewById(R.id.txt_needed);
        txtNeeded.setTypeface(getHelveticaBold());
        message = new StringBuilder();
        DecimalFormat f = new DecimalFormat("#.##");
        f.setDecimalSeparatorAlwaysShown(false);
        message.append(data.length);
        message.append(" - ");
        message.append(f.format(data[0].getSectionSize()));
        message.append(data[0].getUnit());
        message.append(" ");
        message.append(getString(R.string.sections));
        whatYouNeedValue = message.toString();
        txtNeeded.setText(whatYouNeedValue);

        txtExcess = (TextView)view.findViewById(R.id.txt_excess);
        excess = 0;
        for (int i = 0; i < data.length; i++) {
            excess += data[i].getWaste();
        }
        f.setDecimalSeparatorAlwaysShown(false);
        message.delete(0, message.length());
        message.append(getString(R.string.excess));
        message.append(" ");
        message.append(f.format(excess));
        message.append(data[0].getUnit());
        excessValue = message.toString();
        txtExcess.setText(excessValue);

        Button btnSendEmail = (Button)view.findViewById(R.id.btn_email);
        btnSendEmail.setOnClickListener(this);
        btnSendEmail.setTypeface(getHelveticaBold());

        return view;
    }

    private boolean compareMeasure(Measures a, Measures b) {
        boolean equal = false;
        if (a.getMeasures().length == b.getMeasures().length) {
            for (int i = 0; i < a.getMeasures().length; i++) {
                if (a.getMeasures()[i] != b.getMeasures()[i]) {
                    return false;
                }
            }
            equal = true;
        }
        return equal;
    }

    private Measures[] groupResults(Measures[] data) {
        ArrayList<Measures> groupedMeasures = new ArrayList<Measures>();
        int counter = 0;
        Measures previous;
        Measures current = null;

        counter = 1;
        previous = data[0];
        current = data[0];

        for (int i = 1; i < data.length; i++) {
            current = data[i];

            if (compareMeasure(current, previous)) {
                counter++;
            } else {
                previous.setCount(counter);
                groupedMeasures.add(previous);
                counter = 1;
            }

            previous = current;
        }

        current.setCount(counter);
        groupedMeasures.add(current);
        Measures[] grouped = new Measures[groupedMeasures.size()];
        return groupedMeasures.toArray(grouped);
    }

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

    @Override
    public void onClick(View v) {
        if (emailIntent == null) {
            emailIntent = new Intent(android.content.Intent.ACTION_SEND_MULTIPLE);
            String subject = getResources().getString(R.string.email_closet_job_number);
            emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);
            emailIntent.setType("text/html");
            CreateMailContentTask task = new CreateMailContentTask(getActivity(), emailIntent, data, groupedData,
                    adapter.getCutViewWidth(), adapter.getCutViewHeight(), type, whatYouNeedValue, excessValue, excess);
            task.execute();
        } else {
            getActivity().startActivity(Intent.createChooser(emailIntent, "Send your email in:"));
        }

    }

}
