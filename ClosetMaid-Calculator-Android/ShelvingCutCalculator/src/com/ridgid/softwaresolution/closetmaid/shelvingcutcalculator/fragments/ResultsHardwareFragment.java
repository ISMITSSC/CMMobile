
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.fragments;

import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.text.DecimalFormat;

public class ResultsHardwareFragment extends BaseFragment implements OnClickListener {

    long[] values;

    int[] indices;

    String[] hardwareNames;

    TableLayout table;

    float[] lengths;

    int[] quantities;

    int[] locations;

    String unit;

    String shelvingType;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        values = getArguments().getLongArray("results");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.result_hardware, container, false);
        applyFonts(v, Typeface.createFromAsset(getActivity().getAssets(), "font/helveticaneue-condensed.ttf"));

        hardwareNames = getResources().getStringArray(R.array.hardware_needed_names);

        indices = new int[hardwareNames.length];
        int moved = 0;

        for (int i = 0; i < values.length; i++) {
            if (values[i] == 0) {
                moved++;
                indices[values.length - moved] = i;
            } else {
                indices[i - moved] = i;
            }
        }

        table = (TableLayout)v.findViewById(R.id.tbl_results);
        int index = 0;
        for (int i = 0; i < table.getChildCount(); i++) {
            View crtRow = table.getChildAt(i);
            if (crtRow instanceof TableRow) {
                ((TextView)((TableRow)crtRow).getChildAt(0)).setText(hardwareNames[indices[index]]);
                ((TextView)((TableRow)crtRow).getChildAt(1)).setText(String.valueOf(values[indices[index]]));
                index++;
            }

        }

        Button btnEmail = (Button)v.findViewById(R.id.btn_email);
        btnEmail.setOnClickListener(this);
        btnEmail.setTypeface(getHelveticaBold());

        return v;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.btn_email) {
            makeAndSendEmail();
        }
    }

    private void makeAndSendEmail() {
        Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
        String subject = getResources().getString(R.string.email_closet_job_number);
        emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);
        emailIntent.putExtra(Intent.EXTRA_TEXT, createEmailMessage());
        emailIntent.setType("text/html");

        getActivity().startActivity(Intent.createChooser(emailIntent, "Send your email in:"));
    }

    private void getInputValues() {
        quantities = getArguments().getIntArray("quantities");
        lengths = getArguments().getFloatArray("lengths");
        locations = getArguments().getIntArray("locations");
        shelvingType = getArguments().getString("type");
        unit = getArguments().getString("unit");

    }

    private Spanned createEmailMessage() {

        DecimalFormat f = new DecimalFormat("#.##");
        f.setDecimalSeparatorAlwaysShown(false);

        getInputValues();

        String hardwareCalculator = getResources().getString(R.string.email_hardware);

        String typeOfShelvingYouHave = getResources().getString(R.string.type_of_shelving);

        String whatYouNeed = getResources().getString(R.string.what_you_need);

        String shelvingLengthsNeeded = getResources().getString(R.string.add_shelving);

        String[] locationTypes = getResources().getStringArray(R.array.hardware_shelf_location);

        String body;

        body = "<!DOCTYPE html><html><body>" + hardwareCalculator + "<br><br>" + typeOfShelvingYouHave + " "
                + "<font color=\"red\">" + shelvingType + "</font>" + "<br>" + shelvingLengthsNeeded + "<br>";
        for (int i = 0; i < quantities.length; i++) {
            body += String.valueOf(quantities[i]) + " x " + locationTypes[locations[i]] + " of " + f.format(lengths[i])
                    + unit + "<br>";
        }

        body += "<br>";
        body += "<font color=black>" + whatYouNeed + "</font>" + "<br>";
        for (int i = 0; i < indices.length; i++) {
            body += hardwareNames[indices[i]] + ": " + "<font color=\"red\">" + values[indices[i]] + "</font>" + "<br>";
        }

        body += "</body></html>";
        return Html.fromHtml(body);
    }
}
