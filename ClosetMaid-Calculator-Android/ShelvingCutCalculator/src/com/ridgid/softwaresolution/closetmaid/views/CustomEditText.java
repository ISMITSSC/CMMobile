
package com.ridgid.softwaresolution.closetmaid.views;

import com.ridgid.softwaresolution.closetmaid.shelvingcutcalculator.MainActivity;

import android.content.Context;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

public class CustomEditText extends EditText {

    EditText edtAFriendInNeed = null;

    public boolean dataHasErrors = false;

    public CustomEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        // TODO Auto-generated constructor stub
    }

    public void setAFriendInNeed(EditText edtText) {
        this.edtAFriendInNeed = edtText;
    }

    @Override
    public boolean dispatchKeyEventPreIme(KeyEvent event) {
        return super.dispatchKeyEventPreIme(event);
    }

    @Override
    public void onEditorAction(int actionCode) {
        if (actionCode == EditorInfo.IME_ACTION_DONE) {
            ((MainActivity)getContext()).getInputManager().hideSoftInputFromWindow(this.getWindowToken(),
                    InputMethodManager.HIDE_NOT_ALWAYS);
        } else {
            super.onEditorAction(actionCode);
        }
    }

    @Override
    public boolean onKeyPreIme(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_UP) {
            ((MainActivity)getContext()).getInputManager().hideSoftInputFromWindow(this.getWindowToken(),
                    InputMethodManager.HIDE_NOT_ALWAYS);
        }
        return super.dispatchKeyEvent(event);

    }

    public boolean virtualFocusClear() {
        this.onFocusChanged(false, FOCUS_DOWN, null);
        return dataHasErrors;
    }
}
