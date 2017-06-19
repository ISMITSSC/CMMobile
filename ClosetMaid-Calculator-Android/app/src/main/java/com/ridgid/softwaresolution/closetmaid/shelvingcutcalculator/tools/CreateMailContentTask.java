
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools;

import com.ridgid.softwaresolution.closetmaid.data.Measures;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.text.Html;
import android.text.Spanned;
import android.util.Log;
import android.view.Window;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;

public class CreateMailContentTask extends AsyncTask<Void, Void, Void> {

    Context context;

    Intent emailIntent;

    Measures[] data;

    Measures[] groupedData;

    int cutWidth;

    int cutHeight;

    int type;

    String whatYouNeedValue;

    String excessValue;

    float excess;

    protected ProgressDialog mSpinner;

    public CreateMailContentTask(Context context, Intent emailIntent, Measures[] data, Measures[] groupedData,
            int cutWidth, int cutHeight, int type, String whatYouNeedValue, String excessValue, float excess) {
        this.context = context;
        this.emailIntent = emailIntent;
        this.data = data;
        this.cutWidth = cutWidth;
        this.cutHeight = cutHeight;
        this.type = type;
        this.whatYouNeedValue = whatYouNeedValue;
        this.excessValue = excessValue;
        this.excess = excess;
        this.groupedData = groupedData;
        mSpinner = new ProgressDialog(context);
        mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
        mSpinner.setMessage(context
                .getString(com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R.string.preparing_email));
    }

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
        mSpinner.show();
    }

    @Override
    protected Void doInBackground(Void... params) {
        DrawingCutsToFile drawCuts = new DrawingCutsToFile(context);
        try {

            emailIntent.putExtra(Intent.EXTRA_TEXT, createEmailMessage());

            ArrayList<File> cutsFiles = drawCuts.createAtachements(
                    groupedData,
                    cutWidth,
                    cutHeight,
                    context.getResources().getDimension(
                            com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R.dimen.magnifier));
            ArrayList<Uri> uris = new ArrayList<Uri>();
            for (int i = 0; i < cutsFiles.size(); i++) {
                Uri myUri = Uri.fromFile(cutsFiles.get(i));
                uris.add(myUri);
            }
            emailIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris);
            // emailIntent.putExtra(Intent.EXTRA_STREAM, uris.get(0));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void onPostExecute(Void result) {
        super.onPostExecute(result);
        mSpinner.hide();
        ((Activity)context).startActivity(Intent.createChooser(emailIntent, "Send your email in:"));
    }

    @Override
    protected void onCancelled(Void result) {
        Log.i("CreatePHotoTask", "task cancelled");
    };

    private Spanned createEmailMessage() {

        DecimalFormat f = new DecimalFormat("#.##");
        f.setDecimalSeparatorAlwaysShown(false);

        String shelvingCutCalculator = context.getResources().getString(R.string.email_shelving_cut_calculator);

        String typeShelving = context.getResources().getString(R.string.type_of_shelving);

        String typeValue = context.getResources().getStringArray(R.array.shelving_type_array)[type];
        String whatYouNeed = context.getResources().getString(R.string.what_you_need);
        String totalExcess = context.getResources().getString(R.string.email_total_excess_shelving);
        String howToCut = context.getResources().getString(R.string.how_to_cut);
        String waste = context.getResources().getString(R.string.waste);

        String shelf = context.getResources().getString(R.string.shelf);
        String downrod = context.getResources().getString(R.string.email_downrod);

        String body;

        int counter = 0;

        body = "<!DOCTYPE html><html><body>" + shelvingCutCalculator + "<br><br>" + typeShelving + " "
                + "<font color=\"red\">" + typeValue + "</font>" + "<br>" + "<font color=black>" + whatYouNeed + " "
                + "</font>" + "<font color=\"red\">" + whatYouNeedValue + "</font>" + "<br>" + "<font color=\"black\">"
                + totalExcess + " " + "</font>" + "<font color=\"red\">" + f.format(excess) + data[0].getUnit()
                + "</font>" + "<br><br>" + "<font color=\"black\">" + howToCut + " " + "</font>" + "<br><br>";

        String line = "";
        String previousLine = "";
        for (int i = 0; i < data.length; i++) {
            line = "";
            for (int j = 0; j < data[i].getMeasures().length; j++) {
                String value;
                if (data[i].getMeasures()[j] == -1) {
                    value = downrod;
                    line += "<font color=\"red\">" + "[" + value + "]" + "</font>";
                } else {
                    line += "<font color=\"black\">";
                    value = String.valueOf((int)data[i].getMeasures()[j]);
                    line += "[" + value + data[i].getUnit() + "]";
                    line += "</font>";
                }
            }

            if (i == 0) {
                previousLine = line;
            }

            if (line.equals(previousLine)) {
                counter++;
            } else {
                body += "<font color=\"black\">";
                body += String.valueOf(counter) + " x ";
                body += "</font>";
                body += previousLine;
                body += "<font color=\"grey\">" + "[" + String.valueOf(f.format(data[i].getWaste()))
                        + data[i].getUnit() + " " + waste + "]" + "</font>";
                body += "<br>";
                counter = 1;

            }

            if (i == data.length - 1) {
                body += "<font color=\"black\">";
                body += String.valueOf(counter) + " x ";
                body += "</font>";
                body += line;
                body += "<font color=\"grey\">" + "[" + String.valueOf(f.format(data[i].getWaste()))
                        + data[i].getUnit() + " " + waste + "]" + "</font>";
                body += "<br>";
                counter = 1;
            }

            previousLine = line;
        }

        body += "</body></html>";
        return Html.fromHtml(body);
    }

}
