
package com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.tools;

import com.ridgid.softwaresolution.closetmaid.data.Measures;
import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.R;
import com.ridgid.softwaresolution.closetmaid.views.Archiver;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Paint.Align;
import android.graphics.Paint.Cap;
import android.graphics.Paint.Join;
import android.graphics.Paint.Style;
import android.graphics.Rect;
import android.graphics.RectF;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;

public class DrawingCutsToFile {

    RectF textRectangle;

    StringBuilder message;

    Paint mPaint = new Paint();

    int markingLine;

    int initialX;

    int finalX;

    int textWidth;

    int textHeight;

    int wasteTextHeight;

    float lineWidth = 2.0f;

    float roundingRadius;

    int lineCount = 0;

    int width;

    int height;

    int shelfHeigth;

    int shelfWidth;

    Context context;

    int cutsPerFile = 10;

    int maxFilesBeforeZipping = 10;

    int translation;

    int countTextPadding;

    Rect boundingTextRectangle = new Rect();

    public DrawingCutsToFile(Context context) {
        this.context = context;

    }

    public ArrayList<File> createAtachements(Measures[] data, int width, int height, float magnifier)
            throws IOException {
        ArrayList<File> results = new ArrayList<File>();
        Log.i("DrawingCutsToFile", String.valueOf(magnifier));
        int fileCount = data.length % cutsPerFile == 0 ? data.length / cutsPerFile : data.length / cutsPerFile + 1;
        for (int i = 0; i < fileCount; i++) {
            int cutsCount = data.length - i * cutsPerFile >= cutsPerFile ? cutsPerFile : data.length - i * cutsPerFile;
            Measures[] partials = new Measures[cutsCount];
            for (int j = 0; j < partials.length; j++) {
                partials[j] = data[i * cutsPerFile + j];
            }
            int startindex = i * cutsPerFile;
            int endIndex = i * cutsPerFile + cutsCount;
            results.add(createBitmapFile(partials, width, height, magnifier, createFileName(startindex, endIndex)));
        }

        if (results.size() > maxFilesBeforeZipping) {
            File output = new File(context.getExternalFilesDir(null), "closetmaidcuts.zip");
            Archiver.getInstance().createArchive(results, output);
            results.clear();
            results.add(output);
        }

        return results;

    }

    private String createFileName(int startindex, int endIndex) {
        return String.format("closedmaidcuts_%d_%d.png", startindex + 1, endIndex);
    }

    public File createBitmapFile(Measures[] data, int width, int height, float magnifier, String fileName)
            throws IOException {
        int magnifiedWidth = (int)(magnifier * width);
        int magnifiedHeight = (int)(magnifier * height);
        this.translation = (int)(context.getResources().getDimensionPixelSize(R.dimen.dp5_s) * magnifier);
        this.countTextPadding = (int)(context.getResources().getDimensionPixelSize(R.dimen.dp10_s) * magnifier);
        calculateSizes(magnifiedWidth, magnifiedHeight);
        int columns = 2;
        int rows = data.length % 2 == 0 ? data.length / 2 : data.length / 2 + 1;
        int offsetLeft = (int)(0.1f * magnifiedWidth);
        int offsetTop = (int)(0.1f * magnifiedHeight);
        Bitmap bmp = Bitmap.createBitmap(offsetLeft + columns * magnifiedWidth, offsetTop * (rows + 1) + rows
                * magnifiedHeight, Config.RGB_565);
        Canvas c = new Canvas(bmp);
        c.drawColor(Color.WHITE);
        for (int i = 0; i < data.length; i++) {
            Bitmap cut = Bitmap.createBitmap(magnifiedWidth, magnifiedHeight, Config.RGB_565);
            Canvas cutCanvas = new Canvas(cut);
            cutCanvas.drawColor(Color.WHITE);
            CalculateDrawing(data[i]);
            Draw(cutCanvas, data[i].getCount());
            int column = i % columns;
            int row = i / columns;
            c.drawBitmap(cut, offsetLeft + column * magnifiedWidth, offsetTop * (row + 1) + row * magnifiedHeight,
                    mPaint);
            cut.recycle();
        }

        File output = new File(context.getExternalFilesDir(null), fileName);
        if (output.exists()) {
            output.delete();
        } else {
            output.createNewFile();
        }
        FileOutputStream outputStream = new FileOutputStream(output);
        bmp.compress(CompressFormat.PNG, 30, outputStream);
        bmp.recycle();
        return output;
    }

    private void calculateSizes(int w, int h) {
        width = w;
        height = h;
        shelfHeigth = 90 * height / 100;
        shelfWidth = 3 * width / 8;
        textRectangle = new RectF();
        message = new StringBuilder();
        roundingRadius = context.getResources().getDimension(R.dimen.rounding_radius);
        lineWidth = context.getResources().getDimension(R.dimen.canvas_lines);

    }

    private void Draw(Canvas canvas, int count) {
        lineCount = 0;
        canvas.translate(translation, 0);
        for (int i = 0; i < drawingSegment.size(); i++) {
            drawingSegment.get(i).DrawSegment(canvas);
        }
        canvas.translate(-translation, 0);
        drawCount(canvas, count);
    }

    private void drawCount(Canvas canvas, int count) {
        if (count > 1) {
            String value = String.valueOf(count) + "x";

            int countTextHeight = (int)(1.1 * textHeight);

            mPaint.setStyle(Paint.Style.FILL);
            mPaint.setAntiAlias(true);
            mPaint.setTextAlign(Align.CENTER);
            mPaint.setTextSize(countTextHeight);
            mPaint.setColor(Color.argb(200, 129, 133, 139));

            mPaint.getTextBounds(value, 0, value.length(), boundingTextRectangle);

            int textHeight = boundingTextRectangle.height();
            int textWidth = boundingTextRectangle.width();

            textRectangle.top = 2 * translation;
            textRectangle.bottom = textRectangle.top + 1.1f * countTextHeight;
            textRectangle.left = 0;
            textRectangle.right = textRectangle.left + textWidth + countTextPadding;
            canvas.drawRoundRect(textRectangle, roundingRadius, roundingRadius, mPaint);

            int x = (int)(textRectangle.left + (textRectangle.right - textRectangle.left) / 2);
            int y = (int)(textRectangle.bottom - (textRectangle.height() - textHeight) / 2);
            mPaint.setColor(Color.WHITE);
            canvas.drawText(value, x, y, mPaint);

        }
    }

    private void CalculateDrawing(Measures cuttingMeasures) {
        drawingSegment.clear();
        markingLine = shelfWidth / 3;
        initialX = shelfWidth + 7;
        finalX = shelfWidth + markingLine;
        textWidth = 25 * markingLine / 10;
        textHeight = 5 * textWidth / 16;
        wasteTextHeight = 3 * textHeight / 4;

        float unit = shelfHeigth / cuttingMeasures.getSectionSize();
        float waste = cuttingMeasures.getWaste();
        float wasteLine = unit * waste;
        if (waste > 0) {
            if (wasteLine < wasteTextHeight) {
                wasteLine = wasteTextHeight;
            }
            drawingSegment.add(new Segment(0, wasteLine, 1, waste, CutType.Waste, cuttingMeasures));
        }
        float cutLine = shelfHeigth - wasteLine;
        float cutUnit = cutLine / (cuttingMeasures.getSectionSize() - cuttingMeasures.getWaste());
        float cuttingFrom = wasteLine;
        for (int i = 0; i < cuttingMeasures.getMeasures().length; i++) {
            CutType type = CutType.Cut;
            if (cuttingMeasures.getMeasures()[i] < 0) {
                type = CutType.Downrod;
            }
            float segment = Math.abs(cuttingMeasures.getMeasures()[i]);
            float segmentLine = segment * cutUnit;
            int count = 1;
            if (type == CutType.Cut) {
                if (segmentLine < textHeight) {
                    boolean flag = true;
                    while (flag) {
                        if (i < cuttingMeasures.getMeasures().length - 1) {
                            if (cuttingMeasures.getMeasures()[i] == cuttingMeasures.getMeasures()[i + 1]) {
                                i++;
                                count++;
                            } else {
                                flag = false;
                            }
                        } else {
                            flag = false;
                        }
                    }
                }

            }
            drawingSegment.add(new Segment(cuttingFrom, segmentLine, count, segment, type, cuttingMeasures));
            cuttingFrom = cuttingFrom + count * segmentLine;
        }
    }

    private enum CutType {
        Cut, Downrod, Waste
    }

    DecimalFormat f = new DecimalFormat("#.##");

    private ArrayList<Segment> drawingSegment = new ArrayList<Segment>();

    private class Segment {
        float from;

        float to;

        CutType type;

        int count;

        float cutValue;

        Measures cuttingMeasures;

        public Segment(float from, float height, int count, float cutValue, CutType type, Measures cuttingMeasures) {
            this.from = from;
            this.to = from + height * count;
            this.count = count;
            this.type = type;
            this.cutValue = cutValue;
            this.cuttingMeasures = cuttingMeasures;
        }

        public void DrawSegment(Canvas canvas) {
            switch (type) {
                case Cut: {
                    DrawCut(canvas);
                }
                    break;
                case Downrod: {
                    DrawNotCut(canvas);
                }
                    break;
                case Waste: {
                    DrawWaste(canvas);
                }
            }
        }

        private void DrawCut(Canvas canvas) {
            mPaint.setStrokeWidth(5);
            mPaint.setColor(Color.BLACK);
            mPaint.setStrokeCap(Cap.BUTT);
            canvas.drawLine(2, from, 2, to, mPaint);
            canvas.drawLine(shelfWidth - 10, from, shelfWidth - 10, to, mPaint);
            canvas.drawLine(shelfWidth, from, shelfWidth, to, mPaint);
            mPaint.setStrokeWidth(lineWidth);
            while (lineCount * lineWidth < to) {
                lineCount++;
                if (lineCount % 2 == 0 && (lineCount * lineWidth < shelfHeigth)) {
                    canvas.drawLine(0, lineCount * lineWidth, shelfWidth, lineCount * lineWidth, mPaint);
                }
            }
            message.delete(0, message.length());
            if (count > 1) {
                message.append(count);
                message.append("x");
            }
            f.setDecimalSeparatorAlwaysShown(false);
            message.append(f.format(cutValue));
            message.append(cuttingMeasures.getUnit());

            mPaint.setStrokeWidth(3);
            mPaint.setStyle(Style.STROKE);
            mPaint.setColor(Color.RED);

            mPaint.setTextSize(textHeight);
            float txtWidth = mPaint.measureText(message.toString());

            canvas.drawLine(finalX, from, finalX, to, mPaint);
            canvas.drawLine(initialX, from, finalX, from, mPaint);
            canvas.drawLine(initialX, to, finalX, to, mPaint);
            if ((to - from) > textHeight) {

                if (txtWidth < textWidth) {
                    txtWidth = textWidth;
                }
                mPaint.setStyle(Style.FILL);

                textRectangle.top = from + (to - from) / 2 - textHeight / 2;
                textRectangle.bottom = textRectangle.top + 1.2f * textHeight;
                textRectangle.left = finalX + 2 * markingLine - (int)txtWidth;
                textRectangle.right = finalX + 2 * markingLine;
                canvas.drawRoundRect(textRectangle, roundingRadius, roundingRadius, mPaint);

                mPaint.setTextSize(textHeight);
                mPaint.setTextAlign(Align.CENTER);
                mPaint.setColor(Color.WHITE);
                int x = (int)(textRectangle.left + (textRectangle.right - textRectangle.left) / 2);
                mPaint.getTextBounds(message.toString(), 0, message.length(), boundingTextRectangle);
                int y = (int)(textRectangle.bottom - (textRectangle.height() - boundingTextRectangle.height()) / 2);
                canvas.drawText(message.toString(), x, y, mPaint);
            } else {
                if ((to - from) > wasteTextHeight) {
                    mPaint.setColor(Color.RED);
                    mPaint.setTextAlign(Align.LEFT);
                    mPaint.setStyle(Style.FILL_AND_STROKE);
                    mPaint.setStrokeCap(Cap.BUTT);
                    mPaint.setStrokeJoin(Join.ROUND);
                    mPaint.setAntiAlias(true);
                    mPaint.setTextSize(wasteTextHeight);
                    mPaint.setStrokeWidth(1);
                    canvas.drawText(message.toString(), finalX + 3, from + (to - from) / 2 + wasteTextHeight / 2,
                            mPaint);
                }
            }
        }

        private void DrawNotCut(Canvas canvas) {
            mPaint.setStrokeWidth(5);
            mPaint.setColor(Color.RED);
            mPaint.setStrokeCap(Cap.BUTT);
            canvas.drawLine(2, from, 2, to, mPaint);
            canvas.drawLine(shelfWidth - 10, from, shelfWidth - 10, to, mPaint);
            canvas.drawLine(shelfWidth, from, shelfWidth, to, mPaint);
            mPaint.setStrokeWidth(lineWidth);
            while (lineCount * lineWidth < to) {
                lineCount++;
                if (lineCount % 2 == 0 && (lineCount * lineWidth < shelfHeigth)) {
                    canvas.drawLine(0, lineCount * lineWidth, shelfWidth, lineCount * lineWidth, mPaint);
                }
            }
            canvas.drawLine(0, from, shelfWidth, from, mPaint);
        }

        private void DrawWaste(Canvas canvas) {
            mPaint.setStrokeWidth(5);
            mPaint.setColor(Color.LTGRAY);
            mPaint.setStrokeCap(Cap.BUTT);
            canvas.drawLine(2, 0, 2, to, mPaint);
            canvas.drawLine(shelfWidth - 10, 0, shelfWidth - 10, to, mPaint);
            canvas.drawLine(shelfWidth, 0, shelfWidth, to, mPaint);
            mPaint.setStrokeWidth(lineWidth);
            while (lineCount * lineWidth < to) {
                lineCount++;
                if (lineCount % 2 == 0 && (lineCount * lineWidth < shelfHeigth)) {
                    canvas.drawLine(0, lineCount * lineWidth, shelfWidth, lineCount * lineWidth, mPaint);
                }
            }

            mPaint.setColor(Color.BLACK);
            mPaint.setTextAlign(Align.LEFT);
            mPaint.setStyle(Style.FILL_AND_STROKE);
            mPaint.setStrokeCap(Cap.BUTT);
            mPaint.setStrokeJoin(Join.ROUND);
            mPaint.setAntiAlias(true);
            mPaint.setTextSize(wasteTextHeight);
            mPaint.setStrokeWidth(1);
            message.delete(0, message.length());

            f.setDecimalSeparatorAlwaysShown(false);
            message.append(f.format(cutValue));
            message.append(cuttingMeasures.getUnit());
            message.append(" ");
            String waste = context.getResources().getString(R.string.waste);
            message.append(waste);

            float twaste = mPaint.measureText(message.toString());
            if (twaste < width - finalX - 3) {
                canvas.drawText(message.toString(), finalX + 3, (to - from) / 2 + wasteTextHeight / 2, mPaint);
            } else {
                message.delete(message.length() - waste.length(), message.length());
                canvas.drawText(message.toString(), finalX + 3, (to - from) / 2 + wasteTextHeight / 2, mPaint);
                canvas.drawText(waste, finalX + 3, (to - from) / 2 + 3 * wasteTextHeight / 2, mPaint);

            }

            mPaint.setStrokeWidth(3);
            mPaint.setColor(Color.LTGRAY);
            mPaint.setStyle(Style.STROKE);
            mPaint.setStrokeCap(Cap.BUTT);
            canvas.drawLine(initialX, 0, finalX, 0, mPaint);
            canvas.drawLine(finalX, 0, finalX, to, mPaint);
            canvas.drawLine(initialX, to, finalX, to, mPaint);
        }

    }

}
