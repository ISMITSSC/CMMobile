package com.tss.utils;

//<enum name="none" value="0"/>
//<enum name="byWidth" value="1"/>
//<enum name="byHeight" value="2"/>
//<enum name="byParentWidth" value="3"/>
//<enum name="byParentHeight" value="4"/>
//<enum name="byXY" value="5"/>

public enum ScaleMode{
	none(0),
	byWidth(1),
	byHeight(2),
	byParentWidth(3),
	byParentHeight(4),
	byXY(5);
	
	private int index;
	private ScaleMode(int index){
		this.index=index;
	}
	
	public static ScaleMode getScaleMode(int index){
		switch(index){
			case 0: return ScaleMode.none;
			case 1: return ScaleMode.byWidth;
			case 2: return ScaleMode.byHeight;
			case 3: return ScaleMode.byParentWidth;
			case 4: return ScaleMode.byParentHeight;
			case 5: return ScaleMode.byXY;
			default: return ScaleMode.none;
		}
	}
	
}
